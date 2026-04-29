package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.AppointmentService;
import com.hospital.service.NotificationService;
import com.hospital.service.ReviewService;
import com.hospital.service.BillService;
import com.hospital.service.DepartmentService;
import com.hospital.service.UserService;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hospital.service.ScheduleService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService        userService;
    @Autowired private AppointmentService apptService;
    @Autowired private DepartmentService  deptService;
    @Autowired private BillService        billService;
    @Autowired private NotificationService notifService;
    @Autowired private ReviewService      reviewService;
    @Autowired private ScheduleService    scheduleService;

    private boolean isAdmin(HttpSession s) { return "admin".equals(s.getAttribute("role")); }

    // ── Dashboard ────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";

        // Core stats
        req.setAttribute("totalDoctors",      userService.getAllDoctors().size());
        req.setAttribute("totalPatients",     userService.getAllPatients().size());
        req.setAttribute("totalAppointments", apptService.countAll());
        req.setAttribute("totalDepts",        deptService.countAll());

        // New stats
        req.setAttribute("todayAppts",        apptService.countToday());
        req.setAttribute("totalRevenue",      billService.getTotalRevenue());
        req.setAttribute("pendingBills",      billService.countPending());

        // Panels
        req.setAttribute("pendingAppts",      apptService.getPending());
        req.setAttribute("departments",       deptService.getAll());
        req.setAttribute("recentPatients",    userService.getRecentPatients(5));
        req.setAttribute("recentDoctors",     userService.getRecentDoctors(5));
        req.setAttribute("topDoctors",        reviewService.getTopDoctors(3));
        req.setAttribute("unreadFeedback",    billService.countUnreadFeedback());

        return "forward:/adminDashboard.jsp";
    }

    // ── DOCTORS CRUD ─────────────────────────────────────────
    @GetMapping("/doctors")
    public String manageDoctors(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("doctors",     userService.getAllDoctors());
        req.setAttribute("departments", deptService.getAll());
        return "forward:/managedoctor.jsp";
    }

    @GetMapping("/doctors/add")
    public String addDoctorForm(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("departments", deptService.getAll());
        return "forward:/adddoctor.jsp";
    }

    @PostMapping("/doctors/add")
    public String addDoctor(
            @RequestParam("fullName")       String fullName,
            @RequestParam("email")          String email,
            @RequestParam("phone")          String phone,
            @RequestParam("gender")         String gender,
            @RequestParam("qualification")  String qualification,
            @RequestParam("specialization") String specialization,
            @RequestParam("departmentId")   int departmentId,
            @RequestParam("experienceYrs")  int experienceYrs,
            @RequestParam("consultationFee") double consultationFee,
            @RequestParam("address")        String address,
            @RequestParam("password")       String password,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        Doctor d = new Doctor();
        d.setFullName(fullName); d.setEmail(email); d.setPhone(phone);
        d.setGender(gender); d.setQualification(qualification);
        d.setSpecialization(specialization); d.setDepartmentId(departmentId);
        d.setExperienceYrs(experienceYrs); d.setConsultationFee(consultationFee);
        d.setAddress(address); d.setPassword(PasswordUtil.hash(password));
        try {
            userService.registerDoctor(d);
            ra.addFlashAttribute("success", "Doctor added successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Email already exists.");
        }
        return "redirect:/admin/doctors";
    }

    @GetMapping("/doctors/edit")
    public String editDoctorForm(@RequestParam("id") int id, HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("doctor",      userService.getDoctorById(id));
        req.setAttribute("departments", deptService.getAll());
        return "forward:/editdoctor.jsp";
    }

    @PostMapping("/doctors/edit")
    public String editDoctor(
            @RequestParam("id")             int id,
            @RequestParam("fullName")       String fullName,
            @RequestParam("phone")          String phone,
            @RequestParam("gender")         String gender,
            @RequestParam("qualification")  String qualification,
            @RequestParam("specialization") String specialization,
            @RequestParam("departmentId")   int departmentId,
            @RequestParam("experienceYrs")  int experienceYrs,
            @RequestParam("consultationFee") double consultationFee,
            @RequestParam("address")        String address,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        userService.updateDoctorFull(id, fullName, phone, gender, qualification,
                specialization, departmentId, experienceYrs, consultationFee, address);
        ra.addFlashAttribute("success", "Doctor updated successfully.");
        return "redirect:/admin/doctors";
    }

    @GetMapping("/doctors/delete")
    public String deleteDoctor(@RequestParam("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        userService.deleteDoctor(id);
        ra.addFlashAttribute("success", "Doctor removed.");
        return "redirect:/admin/doctors";
    }

    // ── PATIENTS CRUD ────────────────────────────────────────
    @GetMapping("/patients")
    public String managePatients(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("patients", userService.getAllPatients());
        return "forward:/managepatients.jsp";
    }

    @GetMapping("/patients/view")
    public String viewPatient(@RequestParam("id") int id, HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("patient",      userService.getPatientById(id));
        req.setAttribute("appointments", apptService.getByPatient(id));
        req.setAttribute("bills",        billService.getBillsByPatient(id));
        return "forward:/viewpatient.jsp";
    }

    @GetMapping("/patients/delete")
    public String deletePatient(@RequestParam("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        userService.deletePatient(id);
        ra.addFlashAttribute("success", "Patient removed.");
        return "redirect:/admin/patients";
    }

    // ── APPOINTMENTS ─────────────────────────────────────────
    @GetMapping("/appointments")
    public String manageAppointments(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("appointments", apptService.getAll());
        return "forward:/manageappointment.jsp";
    }

    @PostMapping("/appointments/status")
    public String updateApptStatus(
            @RequestParam("id")     int id,
            @RequestParam("status") String status,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        apptService.updateStatus(id, status);

        // Notify patient
        try {
            java.util.List<java.util.Map<String,Object>> rows = new org.springframework.jdbc.core.JdbcTemplate(
                    ((org.springframework.jdbc.datasource.DriverManagerDataSource)
                    apptService.getClass().getDeclaredField("jdbc").get(apptService))).queryForList(
                    "SELECT patient_id FROM appointments WHERE id=?", id);
        } catch (Exception ignored) {}

        ra.addFlashAttribute("success", "Appointment " + status + ".");
        return "redirect:/admin/appointments";
    }

    @GetMapping("/appointments/delete")
    public String deleteAppointment(@RequestParam("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        apptService.delete(id);
        ra.addFlashAttribute("success", "Appointment deleted.");
        return "redirect:/admin/appointments";
    }

    // ── DEPARTMENTS ──────────────────────────────────────────
    @GetMapping("/departments")
    public String manageDepts(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("departments", deptService.getAll());
        return "forward:/managedepartment.jsp";
    }

    @PostMapping("/departments/add")
    public String addDept(
            @RequestParam("name")        String name,
            @RequestParam("description") String description,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        deptService.add(name, description);
        ra.addFlashAttribute("success", "Department added.");
        return "redirect:/admin/departments";
    }

    @GetMapping("/departments/delete")
    public String deleteDept(@RequestParam("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        deptService.delete(id);
        ra.addFlashAttribute("success", "Department deleted.");
        return "redirect:/admin/departments";
    }

    // ── BILLS ────────────────────────────────────────────────
    @GetMapping("/bills")
    public String manageBills(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("bills", billService.getAllBills());
        return "forward:/managebills.jsp";
    }

    // ── DOCTOR SCHEDULES (Admin view) ────────────────────────
    @GetMapping("/schedules")
    public String viewSchedules(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("doctors",   userService.getAllDoctors());
        req.setAttribute("schedules", scheduleService.getAllSchedules());
        return "forward:/adminschedules.jsp";
    }

    @GetMapping("/schedules/doctor/{doctorId}")
    public String doctorSchedule(@PathVariable("doctorId") int doctorId,
            @RequestParam(value = "date", required = false) String date,
            HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        if (date == null || date.isEmpty()) {
            date = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        }
        req.setAttribute("doctor",    userService.getDoctorById(doctorId));
        req.setAttribute("schedules", scheduleService.getByDoctor(doctorId));
        req.setAttribute("slots",     scheduleService.generateSlots(doctorId, date, -1));
        req.setAttribute("date",      date);
        return "forward:/admindoctorschedule.jsp";
    }

    // ── PATIENT FULL HISTORY ──────────────────────────────────
    @GetMapping("/patients/history/{patientId}")
    public String patientHistory(@PathVariable("patientId") int patientId,
            HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("patient",      userService.getPatientById(patientId));
        req.setAttribute("appointments", apptService.getByPatient(patientId));
        req.setAttribute("bills",        billService.getBillsByPatient(patientId));
        req.setAttribute("reports",      getPatientReports(patientId));
        return "forward:/adminpatienthistory.jsp";
    }

    // ── REPORTS ──────────────────────────────────────────────
    @GetMapping("/reports")
    public String reports(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("topDoctors",    reviewService.getTopDoctors(5));
        req.setAttribute("monthlyRevenue", billService.getMonthlyRevenue());
        req.setAttribute("apptTrend",      apptService.getMonthlyTrend());
        req.setAttribute("deptStats",      apptService.getDeptStats());
        return "forward:/adminreports.jsp";
    }

    // ── ADMIN PROFILE ────────────────────────────────────────
    @GetMapping("/profile")
    public String profile(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        int aid = (int) session.getAttribute("adminId");
        req.setAttribute("admin", userService.getAdminById(aid));
        return "forward:/adminprofile.jsp";
    }

    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam("fullName") String fullName,
            @RequestParam("phone")    String phone,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        int aid = (int) session.getAttribute("adminId");
        userService.updateAdmin(aid, fullName, phone);
        session.setAttribute("adminName", fullName);
        ra.addFlashAttribute("success", "Profile updated.");
        return "redirect:/admin/profile";
    }

    @PostMapping("/changePassword")
    public String changePassword(
            @RequestParam("currentPassword") String currentPass,
            @RequestParam("newPassword")     String newPass,
            @RequestParam("confirmPassword") String confirmPass,
            HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        int aid = (int) session.getAttribute("adminId");
        com.hospital.model.Admin a = userService.getAdminById(aid);
        if (!PasswordUtil.verify(currentPass, a.getPassword())) {
            ra.addFlashAttribute("pwError", "Current password is incorrect.");
            return "redirect:/admin/profile";
        }
        if (!newPass.equals(confirmPass)) {
            ra.addFlashAttribute("pwError", "Passwords do not match.");
            return "redirect:/admin/profile";
        }
        userService.updatePassword(a.getEmail(), "admin", PasswordUtil.hash(newPass));
        ra.addFlashAttribute("success", "Password changed.");
        return "redirect:/admin/profile";
    }

    // ── Private helpers ───────────────────────────────────────
    private java.util.List<java.util.Map<String,Object>> getPatientReports(int patientId) {
        try {
            return new org.springframework.jdbc.core.JdbcTemplate(
                ((org.springframework.jdbc.datasource.DriverManagerDataSource)
                 apptService.getClass().getDeclaredField("jdbc").get(apptService))
            ).queryForList(
                "SELECT pr.*, d.full_name AS doctor_name FROM patient_reports pr " +
                "JOIN doctors d ON pr.doctor_id=d.id WHERE pr.patient_id=? ORDER BY pr.created_at DESC",
                patientId);
        } catch (Exception e) { return new java.util.ArrayList<>(); }
    }
}
