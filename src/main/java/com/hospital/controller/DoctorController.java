package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.service.AppointmentService;
import com.hospital.service.BillService;
import com.hospital.service.UserService;
import com.hospital.util.EmailService;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    @Autowired private UserService        userService;
    @Autowired private AppointmentService apptService;
    @Autowired private BillService        billService;
    @Autowired private EmailService       emailService;
    @Autowired private JdbcTemplate       jdbc;

    private static final String UPLOAD_DIR = System.getProperty("user.home") + "/hms_uploads/";

    private boolean isDoctor(HttpSession s) { return "doctor".equals(s.getAttribute("role")); }

    // ── Dashboard ─────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("totalAppts",      apptService.countByDoctor(did));
        req.setAttribute("todayAppts",      apptService.countByDoctorToday(did));
        req.setAttribute("pendingAppts",    apptService.countByDoctorAndStatus(did, "pending"));
        req.setAttribute("completedAppts",  apptService.countByDoctorAndStatus(did, "completed"));
        req.setAttribute("todayList",       apptService.getTodayByDoctor(did));
        req.setAttribute("appointments",    apptService.getByDoctor(did));
        req.setAttribute("monthlyEarnings", billService.getEarningsByDoctor(did));
        req.setAttribute("uniquePatients",  apptService.countUniquePatients(did));
        req.setAttribute("doctor",          userService.getDoctorById(did));
        return "forward:/doctorDashboard.jsp";
    }

    // ── Appointments ──────────────────────────────────────────
    @GetMapping("/appointments")
    public String appointments(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        req.setAttribute("appointments", apptService.getByDoctor((int) session.getAttribute("doctorId")));
        return "forward:/doctorAppointments.jsp";
    }

    // ── My Patients ───────────────────────────────────────────
    @GetMapping("/patients")
    public String myPatients(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        List<Map<String,Object>> patients = jdbc.queryForList(
            "SELECT DISTINCT p.id, p.full_name, p.email, p.phone, p.gender, p.age, p.blood_group, p.photo, " +
            "COUNT(a.id) AS visit_count, MAX(a.appointment_date) AS last_visit " +
            "FROM appointments a JOIN patients p ON a.patient_id=p.id " +
            "WHERE a.doctor_id=? GROUP BY p.id ORDER BY last_visit DESC", did);
        req.setAttribute("patients", patients);
        return "forward:/doctorpatients.jsp";
    }

    // ── View single patient (doctor view) ─────────────────────
    @GetMapping("/patient/{patientId}")
    public String viewPatient(@PathVariable("patientId") int patientId,
            HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("patient",      userService.getPatientById(patientId));
        req.setAttribute("appointments", apptService.getByPatient(patientId));
        req.setAttribute("bills",        billService.getBillsByPatient(patientId));
        req.setAttribute("reports",      getPatientReports(patientId, did));
        req.setAttribute("notes",        getPatientNotes(patientId, did));
        return "forward:/doctorviewpatient.jsp";
    }

    // ── Add note for patient ──────────────────────────────────
    @PostMapping("/patient/note")
    public String addNote(@RequestParam("patientId") int patientId,
                          @RequestParam("note")      String note,
                          HttpSession session, RedirectAttributes ra) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        jdbc.update("INSERT INTO doctor_patient_notes (doctor_id, patient_id, note) VALUES (?,?,?)",
                    did, patientId, note);
        ra.addFlashAttribute("success", "Note added.");
        return "redirect:/doctor/patient/" + patientId;
    }

    // ── Upload report / X-Ray for patient ─────────────────────
    @PostMapping("/patient/uploadReport")
    public String uploadReport(
            @RequestParam("patientId")      int patientId,
            @RequestParam("appointmentId")  int appointmentId,
            @RequestParam("reportType")     String reportType,
            @RequestParam("description")    String description,
            @RequestParam("reportFile")     MultipartFile file,
            @RequestParam(value="sendEmail", required=false) String sendEmail,
            HttpSession session, RedirectAttributes ra) throws Exception {

        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");

        if (file.isEmpty()) {
            ra.addFlashAttribute("error", "Please select a file to upload.");
            return "redirect:/doctor/patient/" + patientId;
        }

        // Save file
        File dir = new File(UPLOAD_DIR + "reports/");
        if (!dir.exists()) dir.mkdirs();

        String ext      = getExt(file.getOriginalFilename());
        String filename = UUID.randomUUID() + "." + ext;
        Path   dest     = Paths.get(UPLOAD_DIR + "reports/" + filename);
        Files.write(dest, file.getBytes());

        String filePath = "/hms_uploads/reports/" + filename;

        // Save to DB
        jdbc.update(
            "INSERT INTO patient_reports (patient_id, doctor_id, appointment_id, report_type, file_name, file_path, description) VALUES (?,?,?,?,?,?,?)",
            patientId, did, appointmentId > 0 ? appointmentId : null,
            reportType, file.getOriginalFilename(), filePath, description);

        // Send email to patient if requested
        if ("on".equals(sendEmail)) {
            String patientEmail = jdbc.queryForObject(
                "SELECT email FROM patients WHERE id=?", String.class, patientId);
            String patientName = jdbc.queryForObject(
                "SELECT full_name FROM patients WHERE id=?", String.class, patientId);
            String doctorName = (String) session.getAttribute("doctorName");
            emailService.sendReportNotification(patientEmail, patientName, doctorName, reportType, description);
            jdbc.update("UPDATE patient_reports SET email_sent=1 WHERE file_path=?", filePath);
        }

        ra.addFlashAttribute("success", "Report uploaded successfully.");
        return "redirect:/doctor/patient/" + patientId;
    }

    // ── Prescription form ─────────────────────────────────────
    @GetMapping("/prescription/{appointmentId}")
    public String prescriptionForm(@PathVariable("appointmentId") int appointmentId,
            HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("appointment", apptService.getByDoctor(did)
            .stream().filter(a -> a.getId() == appointmentId).findFirst().orElse(null));
        req.setAttribute("doctor", userService.getDoctorById(did));
        return "forward:/writePrescription.jsp";
    }

    // ── Profile ───────────────────────────────────────────────
    @GetMapping("/profile")
    public String profile(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        req.setAttribute("doctor", userService.getDoctorById((int) session.getAttribute("doctorId")));
        return "forward:/doctorProfile.jsp";
    }

    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam("name")    String name,
            @RequestParam("phone")   String phone,
            @RequestParam("address") String address,
            HttpSession session, RedirectAttributes ra) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        userService.updateDoctor(did, name, phone, address);
        session.setAttribute("doctorName", name);
        ra.addFlashAttribute("success", "Profile updated successfully.");
        return "redirect:/doctor/profile";
    }

    @PostMapping("/changePassword")
    public String changePassword(
            @RequestParam("currentPass") String currentPass,
            @RequestParam("newPass")     String newPass,
            @RequestParam("confirmPass") String confirmPass,
            HttpSession session, RedirectAttributes ra) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        Doctor d = userService.getDoctorById(did);
        if (!PasswordUtil.verify(currentPass, d.getPassword())) {
            ra.addFlashAttribute("pwError", "Current password is incorrect.");
            return "redirect:/doctor/profile";
        }
        if (!newPass.equals(confirmPass)) {
            ra.addFlashAttribute("pwError", "Passwords do not match.");
            return "redirect:/doctor/profile";
        }
        userService.updatePassword(d.getEmail(), "doctor", PasswordUtil.hash(newPass));
        ra.addFlashAttribute("success", "Password changed successfully.");
        return "redirect:/doctor/profile";
    }

    // ── Helpers ───────────────────────────────────────────────
    private List<Map<String,Object>> getPatientReports(int patientId, int doctorId) {
        try {
            return jdbc.queryForList(
                "SELECT * FROM patient_reports WHERE patient_id=? AND doctor_id=? ORDER BY created_at DESC",
                patientId, doctorId);
        } catch (Exception e) { return java.util.Collections.emptyList(); }
    }

    private List<Map<String,Object>> getPatientNotes(int patientId, int doctorId) {
        try {
            return jdbc.queryForList(
                "SELECT * FROM doctor_patient_notes WHERE patient_id=? AND doctor_id=? ORDER BY created_at DESC",
                patientId, doctorId);
        } catch (Exception e) { return java.util.Collections.emptyList(); }
    }

    private String getExt(String filename) {
        if (filename == null || !filename.contains(".")) return "pdf";
        return filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    }
}
