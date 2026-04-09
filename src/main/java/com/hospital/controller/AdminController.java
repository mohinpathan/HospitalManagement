package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.AppointmentService;
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

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService        userService;
    @Autowired private AppointmentService apptService;
    @Autowired private DepartmentService  deptService;
    @Autowired private BillService        billService;

    private boolean isAdmin(HttpSession s) { return "admin".equals(s.getAttribute("role")); }

    // ── Dashboard ────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, HttpServletRequest req) {
        if (!isAdmin(session)) return "redirect:/login.jsp";
        req.setAttribute("totalDoctors",      userService.getAllDoctors().size());
        req.setAttribute("totalPatients",     userService.getAllPatients().size());
        req.setAttribute("totalAppointments", apptService.countAll());
        req.setAttribute("totalDepts",        deptService.countAll());
        req.setAttribute("pendingAppts",      apptService.getPending());
        req.setAttribute("departments",       deptService.getAll());
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
}
