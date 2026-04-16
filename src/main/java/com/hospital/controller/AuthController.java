package com.hospital.controller;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.UserService;
import com.hospital.util.EmailService;
import com.hospital.util.OtpUtil;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    @Autowired private UserService  userService;
    @Autowired private EmailService emailService;

    // ── Cookie constants ──────────────────────────────────────
    private static final String COOKIE_EMAIL = "hms_email";
    private static final String COOKIE_ROLE  = "hms_role";
    private static final int    COOKIE_AGE   = 60 * 60 * 24 * 30; // 30 days

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

            // Send welcome email only (no login email)
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
            @RequestParam("role")       String role,
            @RequestParam("email")      String email,
            @RequestParam("password")   String password,
            @RequestParam(value = "rememberMe", required = false) String rememberMe,
            HttpSession session,
            HttpServletResponse response,
            RedirectAttributes ra) {

        boolean remember = "on".equals(rememberMe);

        switch (role) {
            case "patient" -> {
                Patient p = userService.findPatientByEmail(email);
                if (p != null && PasswordUtil.verify(password, p.getPassword())) {
                    // Set session (survives refresh)
                    session.setAttribute("role",        "patient");
                    session.setAttribute("patientId",   p.getId());
                    session.setAttribute("patientName", p.getFullName());
                    session.setAttribute("patientEmail",p.getEmail());
                    session.setMaxInactiveInterval(60 * 60 * 8); // 8 hours

                    // Remember Me cookie
                    if (remember) {
                        setRememberCookie(response, email, role);
                    }
                    // NO login email — removed
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
                    session.setMaxInactiveInterval(60 * 60 * 8);

                    if (remember) setRememberCookie(response, email, role);
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
                    session.setMaxInactiveInterval(60 * 60 * 8);

                    if (remember) setRememberCookie(response, email, role);
                    return "redirect:/admin/dashboard";
                }
            }
        }

        ra.addFlashAttribute("error", "Invalid email or password.");
        return "redirect:/login.jsp";
    }

    // ── Auto-login from Remember Me cookie ───────────────────
    @GetMapping("/autoLogin")
    public String autoLogin(HttpServletRequest request, HttpSession session) {
        // If already logged in, go to dashboard
        if (session.getAttribute("role") != null) {
            return dashboardFor((String) session.getAttribute("role"));
        }

        // Try cookie
        String email = getCookieValue(request, COOKIE_EMAIL);
        String role  = getCookieValue(request, COOKIE_ROLE);

        if (email == null || role == null) return "redirect:/login.jsp";

        switch (role) {
            case "patient" -> {
                Patient p = userService.findPatientByEmail(email);
                if (p != null) {
                    session.setAttribute("role",        "patient");
                    session.setAttribute("patientId",   p.getId());
                    session.setAttribute("patientName", p.getFullName());
                    session.setAttribute("patientEmail",p.getEmail());
                    session.setMaxInactiveInterval(60 * 60 * 8);
                    return "redirect:/patient/dashboard";
                }
            }
            case "doctor" -> {
                Doctor d = userService.findDoctorByEmail(email);
                if (d != null) {
                    session.setAttribute("role",       "doctor");
                    session.setAttribute("doctorId",   d.getId());
                    session.setAttribute("doctorName", d.getFullName());
                    session.setAttribute("doctorEmail",d.getEmail());
                    session.setAttribute("doctorDept", d.getDepartmentName());
                    session.setMaxInactiveInterval(60 * 60 * 8);
                    return "redirect:/doctor/dashboard";
                }
            }
            case "admin" -> {
                Admin a = userService.findAdminByEmail(email);
                if (a != null) {
                    session.setAttribute("role",      "admin");
                    session.setAttribute("adminId",   a.getId());
                    session.setAttribute("adminName", a.getFullName());
                    session.setAttribute("adminEmail",a.getEmail());
                    session.setMaxInactiveInterval(60 * 60 * 8);
                    return "redirect:/admin/dashboard";
                }
            }
        }
        return "redirect:/login.jsp";
    }

    // ── Logout ────────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();
        // Clear remember-me cookies
        clearCookie(response, COOKIE_EMAIL);
        clearCookie(response, COOKIE_ROLE);
        return "redirect:/login.jsp";
    }

    // ── Forgot Password — send OTP ────────────────────────────
    @PostMapping("/forgotPassword")
    public String forgotPassword(
            @RequestParam("email") String email,
            @RequestParam("role")  String role,
            HttpSession session,
            RedirectAttributes ra) {

        boolean exists = userService.emailExists(email, role);
        if (!exists) {
            ra.addFlashAttribute("error", "No account found with that email and role.");
            return "redirect:/forgetpass.jsp";
        }

        String otp = OtpUtil.generate();
        userService.saveOtp(email, role, otp);
        emailService.sendOtp(email, otp);

        // Store in session — survives redirect
        session.setAttribute("otpEmail", email);
        session.setAttribute("otpRole",  role);
        ra.addFlashAttribute("otpSent", true);
        return "redirect:/verifyOtp.jsp";
    }

    // ── Verify OTP ────────────────────────────────────────────
    @PostMapping("/verifyOtp")
    public String verifyOtp(
            @RequestParam("otp") String otp,
            HttpSession session,
            RedirectAttributes ra) {

        String email = (String) session.getAttribute("otpEmail");
        String role  = (String) session.getAttribute("otpRole");

        if (email == null || role == null) {
            ra.addFlashAttribute("error", "Session expired. Please request a new OTP.");
            return "redirect:/forgetpass.jsp";
        }

        boolean valid = userService.verifyOtp(email, role, otp);
        if (!valid) {
            ra.addFlashAttribute("error", "Invalid or expired OTP. Please try again.");
            return "redirect:/verifyOtp.jsp";
        }

        session.setAttribute("otpVerified", true);
        return "redirect:/resetPassword.jsp";
    }

    // ── Reset Password ────────────────────────────────────────
    @PostMapping("/resetPassword")
    public String resetPassword(
            @RequestParam("newPassword")     String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes ra) {

        String email    = (String)  session.getAttribute("otpEmail");
        String role     = (String)  session.getAttribute("otpRole");
        Boolean verified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || role == null || !Boolean.TRUE.equals(verified)) {
            ra.addFlashAttribute("error", "Session expired. Please start the password reset again.");
            return "redirect:/forgetpass.jsp";
        }

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Passwords do not match.");
            return "redirect:/resetPassword.jsp";
        }

        userService.updatePassword(email, role, PasswordUtil.hash(newPassword));

        // Send password reset success email
        String name = userService.getNameByEmail(email, role);
        emailService.sendPasswordResetSuccess(email, name);

        // Clean up OTP session keys
        session.removeAttribute("otpEmail");
        session.removeAttribute("otpRole");
        session.removeAttribute("otpVerified");

        ra.addFlashAttribute("success", "Password reset successfully! You can now login with your new password.");
        return "redirect:/login.jsp";
    }

    // ── Helpers ───────────────────────────────────────────────
    private void setRememberCookie(HttpServletResponse response, String email, String role) {
        Cookie emailCookie = new Cookie(COOKIE_EMAIL, email);
        emailCookie.setMaxAge(COOKIE_AGE);
        emailCookie.setPath("/");
        emailCookie.setHttpOnly(true);

        Cookie roleCookie = new Cookie(COOKIE_ROLE, role);
        roleCookie.setMaxAge(COOKIE_AGE);
        roleCookie.setPath("/");
        roleCookie.setHttpOnly(true);

        response.addCookie(emailCookie);
        response.addCookie(roleCookie);
    }

    private void clearCookie(HttpServletResponse response, String name) {
        Cookie c = new Cookie(name, "");
        c.setMaxAge(0);
        c.setPath("/");
        response.addCookie(c);
    }

    private String getCookieValue(HttpServletRequest request, String name) {
        if (request.getCookies() == null) return null;
        for (Cookie c : request.getCookies()) {
            if (name.equals(c.getName())) return c.getValue();
        }
        return null;
    }

    private String dashboardFor(String role) {
        return switch (role) {
            case "patient" -> "redirect:/patient/dashboard";
            case "doctor"  -> "redirect:/doctor/dashboard";
            case "admin"   -> "redirect:/admin/dashboard";
            default        -> "redirect:/login.jsp";
        };
    }
}
