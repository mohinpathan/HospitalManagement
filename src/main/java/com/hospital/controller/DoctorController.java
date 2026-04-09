package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.service.AppointmentService;
import com.hospital.service.BillService;
import com.hospital.service.UserService;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    @Autowired private UserService        userService;
    @Autowired private AppointmentService apptService;
    @Autowired private BillService        billService;

    private boolean isDoctor(HttpSession s) { return "doctor".equals(s.getAttribute("role")); }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("totalAppts",     apptService.countByDoctor(did));
        req.setAttribute("todayAppts",     apptService.countByDoctorToday(did));
        req.setAttribute("pendingAppts",   apptService.countByDoctorAndStatus(did, "pending"));
        req.setAttribute("completedAppts", apptService.countByDoctorAndStatus(did, "completed"));
        req.setAttribute("appointments",   apptService.getByDoctor(did));
        return "forward:/doctorDashboard.jsp";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        req.setAttribute("appointments", apptService.getByDoctor((int) session.getAttribute("doctorId")));
        return "forward:/doctorAppointments.jsp";
    }

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

    @GetMapping("/profile")
    public String profile(HttpSession session, HttpServletRequest req) {
        if (!isDoctor(session)) return "redirect:/login.jsp";
        req.setAttribute("doctor", userService.getDoctorById((int) session.getAttribute("doctorId")));
        return "forward:/doctorProfile.jsp";
    }

    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam("name")  String name,
            @RequestParam("phone") String phone,
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
}
