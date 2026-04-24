package com.hospital.controller;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.UserService;
import com.hospital.util.EmailService;
import com.hospital.util.PasswordUtil;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("AuthController Tests")
class AuthControllerTest {

    private MockMvc mockMvc;

    @Mock private UserService  userService;
    @Mock private EmailService emailService;

    @InjectMocks private AuthController authController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(authController).build();
    }

    // ── GET / ─────────────────────────────────────────────────

    @Test
    @DisplayName("GET / should redirect to home.jsp")
    void homeRedirect() throws Exception {
        mockMvc.perform(get("/"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/home.jsp"));
    }

    // ── POST /login — Patient ─────────────────────────────────

    @Test
    @DisplayName("Patient login with correct credentials should redirect to dashboard")
    void patientLogin_Success() throws Exception {
        Patient p = new Patient();
        p.setId(1);
        p.setFullName("John Smith");
        p.setEmail("john@hms.com");
        p.setPassword(PasswordUtil.hash("admin123"));

        when(userService.findPatientByEmail("john@hms.com")).thenReturn(p);
        // No email stub needed — login email was removed

        mockMvc.perform(post("/login")
                .param("role",     "patient")
                .param("email",    "john@hms.com")
                .param("password", "admin123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/patient/dashboard"));
    }

    @Test
    @DisplayName("Patient login with wrong password should redirect to login")
    void patientLogin_WrongPassword() throws Exception {
        Patient p = new Patient();
        p.setId(1);
        p.setEmail("john@hms.com");
        p.setPassword(PasswordUtil.hash("admin123"));

        when(userService.findPatientByEmail("john@hms.com")).thenReturn(p);

        mockMvc.perform(post("/login")
                .param("role",     "patient")
                .param("email",    "john@hms.com")
                .param("password", "wrongpass"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    @Test
    @DisplayName("Patient login with non-existent email should redirect to login")
    void patientLogin_NotFound() throws Exception {
        when(userService.findPatientByEmail(anyString())).thenReturn(null);

        mockMvc.perform(post("/login")
                .param("role",     "patient")
                .param("email",    "nobody@test.com")
                .param("password", "pass123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── POST /login — Doctor ──────────────────────────────────

    @Test
    @DisplayName("Doctor login with correct credentials should redirect to dashboard")
    void doctorLogin_Success() throws Exception {
        Doctor d = new Doctor();
        d.setId(1);
        d.setFullName("Dr. Sarah Johnson");
        d.setEmail("sarah@hms.com");
        d.setPassword(PasswordUtil.hash("admin123"));
        d.setDepartmentName("Cardiology");

        when(userService.findDoctorByEmail("sarah@hms.com")).thenReturn(d);
        // No email stub needed — login email was removed

        mockMvc.perform(post("/login")
                .param("role",     "doctor")
                .param("email",    "sarah@hms.com")
                .param("password", "admin123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/doctor/dashboard"));
    }

    @Test
    @DisplayName("Doctor login with wrong password should redirect to login")
    void doctorLogin_WrongPassword() throws Exception {
        Doctor d = new Doctor();
        d.setId(1);
        d.setEmail("sarah@hms.com");
        d.setPassword(PasswordUtil.hash("admin123"));

        when(userService.findDoctorByEmail("sarah@hms.com")).thenReturn(d);

        mockMvc.perform(post("/login")
                .param("role",     "doctor")
                .param("email",    "sarah@hms.com")
                .param("password", "wrongpass"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── POST /login — Admin ───────────────────────────────────

    @Test
    @DisplayName("Admin login with correct credentials should redirect to dashboard")
    void adminLogin_Success() throws Exception {
        Admin a = new Admin();
        a.setId(1);
        a.setFullName("Admin User");
        a.setEmail("admin@hms.com");
        a.setPassword(PasswordUtil.hash("admin123"));

        when(userService.findAdminByEmail("admin@hms.com")).thenReturn(a);
        // No email stub needed — login email was removed

        mockMvc.perform(post("/login")
                .param("role",     "admin")
                .param("email",    "admin@hms.com")
                .param("password", "admin123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/dashboard"));
    }

    @Test
    @DisplayName("Admin login with wrong password should redirect to login")
    void adminLogin_WrongPassword() throws Exception {
        Admin a = new Admin();
        a.setId(1);
        a.setEmail("admin@hms.com");
        a.setPassword(PasswordUtil.hash("admin123"));

        when(userService.findAdminByEmail("admin@hms.com")).thenReturn(a);

        mockMvc.perform(post("/login")
                .param("role",     "admin")
                .param("email",    "admin@hms.com")
                .param("password", "wrongpass"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── GET /logout ───────────────────────────────────────────

    @Test
    @DisplayName("Logout should redirect to login.jsp")
    void logout_RedirectsToLogin() throws Exception {
        mockMvc.perform(get("/logout"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── POST /forgotPassword ──────────────────────────────────

    @Test
    @DisplayName("forgotPassword with valid email should redirect to verifyOtp.jsp")
    void forgotPassword_ValidEmail() throws Exception {
        when(userService.emailExists("john@hms.com", "patient")).thenReturn(true);
        doNothing().when(userService).saveOtp(anyString(), anyString(), anyString());
        doNothing().when(emailService).sendOtp(anyString(), anyString());

        mockMvc.perform(post("/forgotPassword")
                .param("email", "john@hms.com")
                .param("role",  "patient"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/verifyOtp.jsp"));
    }

    @Test
    @DisplayName("forgotPassword with invalid email should redirect to forgetpass.jsp")
    void forgotPassword_InvalidEmail() throws Exception {
        when(userService.emailExists("nobody@test.com", "patient")).thenReturn(false);

        mockMvc.perform(post("/forgotPassword")
                .param("email", "nobody@test.com")
                .param("role",  "patient"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/forgetpass.jsp"));
    }

    // ── POST /verifyOtp ───────────────────────────────────────

    @Test
    @DisplayName("verifyOtp with valid OTP should redirect to resetPassword.jsp")
    void verifyOtp_Valid() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("otpEmail", "john@hms.com");
        session.setAttribute("otpRole",  "patient");

        when(userService.verifyOtp("john@hms.com", "patient", "123456")).thenReturn(true);

        mockMvc.perform(post("/verifyOtp")
                .session(session)
                .param("otp", "123456"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/resetPassword.jsp"));
    }

    @Test
    @DisplayName("verifyOtp with invalid OTP should redirect back to verifyOtp.jsp")
    void verifyOtp_Invalid() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("otpEmail", "john@hms.com");
        session.setAttribute("otpRole",  "patient");

        when(userService.verifyOtp("john@hms.com", "patient", "000000")).thenReturn(false);

        mockMvc.perform(post("/verifyOtp")
                .session(session)
                .param("otp", "000000"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/verifyOtp.jsp"));
    }

    @Test
    @DisplayName("verifyOtp with no session should redirect to forgetpass.jsp")
    void verifyOtp_NoSession() throws Exception {
        MockHttpSession session = new MockHttpSession();
        // No otpEmail/otpRole in session

        mockMvc.perform(post("/verifyOtp")
                .session(session)
                .param("otp", "123456"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/forgetpass.jsp"));
    }

    // ── POST /resetPassword ───────────────────────────────────

    @Test
    @DisplayName("resetPassword with matching passwords should redirect to login.jsp")
    void resetPassword_Success() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("otpEmail",    "john@hms.com");
        session.setAttribute("otpRole",     "patient");
        session.setAttribute("otpVerified", true);

        when(userService.getNameByEmail("john@hms.com", "patient")).thenReturn("John Smith");
        doNothing().when(userService).updatePassword(anyString(), anyString(), anyString());
        doNothing().when(emailService).sendPasswordResetSuccess(anyString(), anyString());

        mockMvc.perform(post("/resetPassword")
                .session(session)
                .param("newPassword",     "newpass123")
                .param("confirmPassword", "newpass123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    @Test
    @DisplayName("resetPassword with mismatched passwords should redirect back")
    void resetPassword_Mismatch() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("otpEmail",    "john@hms.com");
        session.setAttribute("otpRole",     "patient");
        session.setAttribute("otpVerified", true);

        mockMvc.perform(post("/resetPassword")
                .session(session)
                .param("newPassword",     "newpass123")
                .param("confirmPassword", "differentpass"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/resetPassword.jsp"));
    }

    @Test
    @DisplayName("resetPassword with no session should redirect to forgetpass.jsp")
    void resetPassword_NoSession() throws Exception {
        MockHttpSession session = new MockHttpSession();
        // No OTP session attributes

        mockMvc.perform(post("/resetPassword")
                .session(session)
                .param("newPassword",     "newpass123")
                .param("confirmPassword", "newpass123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/forgetpass.jsp"));
    }
}
