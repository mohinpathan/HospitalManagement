package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.service.AppointmentService;
import com.hospital.service.BillService;
import com.hospital.service.NotificationService;
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

    @Autowired private UserService         userService;
    @Autowired private AppointmentService  apptService;
    @Autowired private BillService         billService;
    @Autowired private NotificationService notifService;
    @Autowired private EmailService        emailService;
    @Autowired private JdbcTemplate        jdbc;

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
        req.setAttribute("patients", apptService.getPatientsByDoctor(did));
        return "forward:/doctorpatients.jsp";
    }

    @GetMapping("/patients/view/{patientId}")
    public String viewPatient(@PathVariable("patientId") int patientId,
            HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("patient",      userService.getPatientById(patientId));
        req.setAttribute("appointments", apptService.getByPatientAndDoctor(patientId, did));
        req.setAttribute("bills",        billService.getBillsByPatient(patientId));
        req.setAttribute("reports",      getReports(patientId, did));
        req.setAttribute("notes",        getNotes(patientId, did));
        return "forward:/doctorviewpatient.jsp";
    }

    // ── Add Note ──────────────────────────────────────────────
    @PostMapping("/patients/addNote")
    public String addNote(
            @RequestParam("patientId") int patientId,
            @RequestParam("note")      String note,
            HttpSession session, RedirectAttributes ra) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        jdbc.update("INSERT INTO doctor_notes (doctor_id, patient_id, note) VALUES (?,?,?)", did, patientId, note);
        ra.addFlashAttribute("success", "Note added.");
        return "redirect:/doctor/patients/view/" + patientId;
    }

    // ── Upload Report / X-Ray ─────────────────────────────────
    @PostMapping("/patients/uploadReport")
    public String uploadReport(
            @RequestParam("patientId")      int patientId,
            @RequestParam("appointmentId")  int appointmentId,
            @RequestParam("reportType")     String reportType,
            @RequestParam("description")    String description,
            @RequestParam("sendEmail")      boolean sendEmail,
            @RequestParam("reportFile")     MultipartFile file,
            HttpSession session, RedirectAttributes ra) throws Exception {

        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");

        if (file.isEmpty()) {
            ra.addFlashAttribute("error", "Please select a file.");
            return "redirect:/doctor/patients/view/" + patientId;
        }

        if (file.getSize() > 20 * 1024 * 1024) {
            ra.addFlashAttribute("error", "File size must be under 20 MB.");
            return "redirect:/doctor/patients/view/" + patientId;
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
            "INSERT INTO patient_reports (patient_id, doctor_id, appointment_id, report_type, file_name, file_path, description, send_email) VALUES (?,?,?,?,?,?,?,?)",
            patientId, did, appointmentId > 0 ? appointmentId : null,
            reportType, file.getOriginalFilename(), filePath, description, sendEmail ? 1 : 0);

        // Send email to patient if requested
        if (sendEmail) {
            com.hospital.model.Patient pat = userService.getPatientById(patientId);
            Doctor doc = userService.getDoctorById(did);
            if (pat != null && pat.getEmail() != null) {
                emailService.sendReportNotification(
                    pat.getEmail(), pat.getFullName(),
                    doc.getFullName(), reportType, description);
            }
        }

        // Notify patient in-app
        notifService.create(patientId, "patient",
            "New Report Uploaded 📋",
            "Dr. " + session.getAttribute("doctorName") + " uploaded a " + reportType + " report for you.",
            "info");

        ra.addFlashAttribute("success", "Report uploaded successfully.");
        return "redirect:/doctor/patients/view/" + patientId;
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
    private List<Map<String, Object>> getReports(int patientId, int doctorId) {
        return jdbc.queryForList(
            "SELECT * FROM patient_reports WHERE patient_id=? AND doctor_id=? ORDER BY created_at DESC",
            patientId, doctorId);
    }

    private List<Map<String, Object>> getNotes(int patientId, int doctorId) {
        return jdbc.queryForList(
            "SELECT * FROM doctor_notes WHERE patient_id=? AND doctor_id=? ORDER BY created_at DESC",
            patientId, doctorId);
    }

    private String getExt(String filename) {
        if (filename == null || !filename.contains(".")) return "bin";
        return filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    }
}
