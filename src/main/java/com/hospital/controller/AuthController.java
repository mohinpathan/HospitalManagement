package com.hospital.controller;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.UserService;
import com.hospital.util.EmailService;
import com.hospital.util.OtpUtil;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    @Autowired private UserService  userService;
    @Autowired private EmailService emailService;

    // ── Home ─────────────────────────────────────────────────
    @GetMapping("/")
    public String home() { return "redirect:/home.jsp"; }

    // ── Register ─────────────────────────────────────────────
    @GetMapping("/register")
    public String registerPage() { return "redirect:/register.jsp"; }

    @PostMapping("/register")
    public String register(
            @RequestParam("role")             String role,
            @RequestParam("fullName")         String fullName,
            @RequestParam("email")            String email,
            @RequestParam("phone")            String phone,
            @RequestParam("password")         String password,
            @RequestParam(value = "gender",          required = false) String gender,
            @RequestParam(value = "age",             required = false, defaultValue = "0") int age,
            @RequestParam(value = "bloodGroup",      required = false) String bloodGroup,
            @RequestParam(value = "address",         required = false) String address,
            @RequestParam(value = "qualification",   required = false) String qualification,
            @RequestParam(value = "specialization",  required = false) String specialization,
            @RequestParam(value = "departmentId",    required = false, defaultValue = "0") int departmentId,
            @RequestParam(value = "experienceYrs",   required = false, defaultValue = "0") int experienceYrs,
            @RequestParam(value = "consultationFee", required = false, defaultValue = "0") double consultationFee,
            RedirectAttributes ra) {

        String hashed = PasswordUtil.hash(password);

        try {
            switch (role) {
                case "patient" -> {
                    Patient p = new Patient();
                    p.setFullName(fullName); p.setEmail(email); p.setPhone(phone);
                    p.setPassword(hashed);  p.setGender(gender); p.setAge(age);
                    p.setBloodGroup(bloodGroup); p.setAddress(address);
                    userService.registerPatient(p);
                }
                case "doctor" -> {
                    Doctor d = new Doctor();
                    d.setFullName(fullName); d.setEmail(email); d.setPhone(phone);
                    d.setPassword(hashed);  d.setGender(gender);
                    d.setQualification(qualification); d.setSpecialization(specialization);
                    d.setDepartmentId(departmentId); d.setExperienceYrs(experienceYrs);
                    d.setConsultationFee(consultationFee); d.setAddress(address);
                    userService.registerDoctor(d);
                }
                case "admin" -> {
                    Admin a = new Admin();
                    a.setFullName(fullName); a.setEmail(email);
                    a.setPhone(phone); a.setPassword(hashed);
                    userService.registerAdmin(a);
                }
            }

            // Send welcome email (async-safe — errors are caught inside sendHtml)
            emailService.sendWelcome(email, fullName, role);

            ra.addFlashAttribute("success", "Registration successful! A welcome email has been sent. Please login.");
            return "redirect:/login.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/register.jsp";
        }
    }

    // ── Login ─────────────────────────────────────────────────
    @PostMapping("/login")
    public String login(
            @RequestParam("role")     String role,
            @RequestParam("email")    String email,
            @RequestParam("password") String password,
            HttpSession session,
            RedirectAttributes ra) {

        switch (role) {
            case "patient" -> {
                Patient p = userService.findPatientByEmail(email);
                if (p != null && PasswordUtil.verify(password, p.getPassword())) {
                    session.setAttribute("role",        "patient");
                    session.setAttribute("patientId",   p.getId());
                    session.setAttribute("patientName", p.getFullName());
                    session.setAttribute("patientEmail",p.getEmail());
                    // Send login notification
                    emailService.sendLoginNotification(email, p.getFullName(), "patient");
                    return "redirect:/patient/dashboard";
                }
            }
            case "doctor" -> {
                Doctor d = userService.findDoctorByEmail(email);
                if (d != null && PasswordUtil.verify(password, d.getPassword())) {
                    session.setAttribute("role",       "doctor");
                    session.setAttribute("doctorId",   d.getId());
                    session.setAttribute("doctorName", d.getFullName());
                    session.setAttribute("doctorEmail",d.getEmail());
                    session.setAttribute("doctorDept", d.getDepartmentName());
                    // Send login notification
                    emailService.sendLoginNotification(email, d.getFullName(), "doctor");
                    return "redirect:/doctor/dashboard";
                }
            }
            case "admin" -> {
                Admin a = userService.findAdminByEmail(email);
                if (a != null && PasswordUtil.verify(password, a.getPassword())) {
                    session.setAttribute("role",      "admin");
                    session.setAttribute("adminId",   a.getId());
                    session.setAttribute("adminName", a.getFullName());
                    session.setAttribute("adminEmail",a.getEmail());
                    // Send login notification
                    emailService.sendLoginNotification(email, a.getFullName(), "admin");
                    return "redirect:/admin/dashboard";
                }
            }
        }

        ra.addFlashAttribute("error", "Invalid email or password.");
        return "redirect:/login.jsp";
    }

    // ── Logout ────────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login.jsp";
    }

    // ── Forgot Password — send OTP ────────────────────────────
    @PostMapping("/forgotPassword")
    public String forgotPassword(
            @RequestParam("email") String email,
            @RequestParam("role")  String role,
            RedirectAttributes ra) {

        boolean exists = userService.emailExists(email, role);
        if (!exists) {
            ra.addFlashAttribute("error", "No account found with that email and role.");
            return "redirect:/forgetpass.jsp";
        }

        String otp = OtpUtil.generate();
        userService.saveOtp(email, role, otp);
        emailService.sendOtp(email, otp);   // beautiful OTP email

        ra.addFlashAttribute("email", email);
        ra.addFlashAttribute("role",  role);
        ra.addFlashAttribute("otpSent", true);
        return "redirect:/verifyOtp.jsp";
    }

    // ── Verify OTP ────────────────────────────────────────────
    @PostMapping("/verifyOtp")
    public String verifyOtp(
            @RequestParam("email") String email,
            @RequestParam("role")  String role,
            @RequestParam("otp")   String otp,
            RedirectAttributes ra) {

        boolean valid = userService.verifyOtp(email, role, otp);
        if (!valid) {
            ra.addFlashAttribute("error", "Invalid or expired OTP. Please try again.");
            ra.addFlashAttribute("email", email);
            ra.addFlashAttribute("role",  role);
            return "redirect:/verifyOtp.jsp";
        }

        // OTP verified — pass email+role to reset page
        ra.addFlashAttribute("email",    email);
        ra.addFlashAttribute("role",     role);
        ra.addFlashAttribute("verified", true);
        return "redirect:/resetPassword.jsp";
    }

    // ── Reset Password ────────────────────────────────────────
    @PostMapping("/resetPassword")
    public String resetPassword(
            @RequestParam("email")           String email,
            @RequestParam("role")            String role,
            @RequestParam("newPassword")     String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes ra) {

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Passwords do not match.");
            ra.addFlashAttribute("email", email);
            ra.addFlashAttribute("role",  role);
            return "redirect:/resetPassword.jsp";
        }

        userService.updatePassword(email, role, PasswordUtil.hash(newPassword));

        // Send password reset success email with user's name
        String name = userService.getNameByEmail(email, role);
        emailService.sendPasswordResetSuccess(email, name);

        ra.addFlashAttribute("success", "Password reset successfully! You can now login with your new password.");
        return "redirect:/login.jsp";
    }
}
