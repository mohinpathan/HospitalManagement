package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AdminController Tests")
class AdminControllerTest {

    private MockMvc mockMvc;
    private MockHttpSession session;

    @Mock private UserService         userService;
    @Mock private AppointmentService  apptService;
    @Mock private DepartmentService   deptService;
    @Mock private BillService         billService;
    @Mock private NotificationService notifService;
    @Mock private ReviewService       reviewService;

    @InjectMocks private AdminController adminController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(adminController).build();
        session = new MockHttpSession();
        session.setAttribute("role",    "admin");
        session.setAttribute("adminId", 1);
        session.setAttribute("adminName", "Admin User");
    }

    // ── Dashboard ─────────────────────────────────────────────

    @Test
    @DisplayName("Admin dashboard should forward to adminDashboard.jsp")
    void dashboard_ForwardsToJsp() throws Exception {
        when(userService.getAllDoctors()).thenReturn(List.of());
        when(userService.getAllPatients()).thenReturn(List.of());
        when(apptService.countAll()).thenReturn(0);
        when(deptService.countAll()).thenReturn(0);
        when(apptService.countToday()).thenReturn(0);
        when(billService.getTotalRevenue()).thenReturn(0.0);
        when(billService.countPending()).thenReturn(0);
        when(apptService.getPending()).thenReturn(List.of());
        when(deptService.getAll()).thenReturn(List.of());
        when(userService.getRecentPatients(5)).thenReturn(List.of());
        when(userService.getRecentDoctors(5)).thenReturn(List.of());
        when(reviewService.getTopDoctors(3)).thenReturn(List.of());
        when(billService.countUnreadFeedback()).thenReturn(0);

        mockMvc.perform(get("/admin/dashboard").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/adminDashboard.jsp"));
    }

    @Test
    @DisplayName("Admin dashboard without session should redirect to login")
    void dashboard_NoSession_RedirectsToLogin() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── Manage Doctors ────────────────────────────────────────

    @Test
    @DisplayName("Manage doctors should forward to managedoctor.jsp")
    void manageDoctors_ForwardsToJsp() throws Exception {
        when(userService.getAllDoctors()).thenReturn(List.of());
        when(deptService.getAll()).thenReturn(List.of());

        mockMvc.perform(get("/admin/doctors").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/managedoctor.jsp"));
    }

    @Test
    @DisplayName("Add doctor form should forward to adddoctor.jsp")
    void addDoctorForm_ForwardsToJsp() throws Exception {
        when(deptService.getAll()).thenReturn(List.of());

        mockMvc.perform(get("/admin/doctors/add").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/adddoctor.jsp"));
    }

    @Test
    @DisplayName("POST add doctor should redirect to doctors list")
    void addDoctor_Redirects() throws Exception {
        doNothing().when(userService).registerDoctor(any(Doctor.class));

        mockMvc.perform(post("/admin/doctors/add")
                .session(session)
                .param("fullName",       "Dr. New Doctor")
                .param("email",          "newdoc@hms.com")
                .param("phone",          "+91-9000000099")
                .param("gender",         "Male")
                .param("qualification",  "MBBS")
                .param("specialization", "General")
                .param("departmentId",   "1")
                .param("experienceYrs",  "5")
                .param("consultationFee","500")
                .param("address",        "Test Address")
                .param("password",       "doc123"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/doctors"));
    }

    @Test
    @DisplayName("Delete doctor should redirect to doctors list")
    void deleteDoctor_Redirects() throws Exception {
        doNothing().when(userService).deleteDoctor(1);

        mockMvc.perform(get("/admin/doctors/delete")
                .session(session)
                .param("id", "1"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/doctors"));

        verify(userService, times(1)).deleteDoctor(1);
    }

    // ── Manage Patients ───────────────────────────────────────

    @Test
    @DisplayName("Manage patients should forward to managepatients.jsp")
    void managePatients_ForwardsToJsp() throws Exception {
        when(userService.getAllPatients()).thenReturn(List.of());

        mockMvc.perform(get("/admin/patients").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/managepatients.jsp"));
    }

    @Test
    @DisplayName("Delete patient should redirect to patients list")
    void deletePatient_Redirects() throws Exception {
        doNothing().when(userService).deletePatient(1);

        mockMvc.perform(get("/admin/patients/delete")
                .session(session)
                .param("id", "1"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/patients"));

        verify(userService, times(1)).deletePatient(1);
    }

    // ── Manage Appointments ───────────────────────────────────

    @Test
    @DisplayName("Manage appointments should forward to manageappointment.jsp")
    void manageAppointments_ForwardsToJsp() throws Exception {
        when(apptService.getAll()).thenReturn(List.of());

        mockMvc.perform(get("/admin/appointments").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/manageappointment.jsp"));
    }

    @Test
    @DisplayName("Approve appointment should redirect to appointments")
    void approveAppointment_Redirects() throws Exception {
        doNothing().when(apptService).updateStatus(1, "approved");

        mockMvc.perform(post("/admin/appointments/status")
                .session(session)
                .param("id",     "1")
                .param("status", "approved"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/appointments"));

        verify(apptService, times(1)).updateStatus(1, "approved");
    }

    @Test
    @DisplayName("Reject appointment should redirect to appointments")
    void rejectAppointment_Redirects() throws Exception {
        doNothing().when(apptService).updateStatus(1, "rejected");

        mockMvc.perform(post("/admin/appointments/status")
                .session(session)
                .param("id",     "1")
                .param("status", "rejected"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/appointments"));
    }

    @Test
    @DisplayName("Delete appointment should redirect to appointments")
    void deleteAppointment_Redirects() throws Exception {
        doNothing().when(apptService).delete(1);

        mockMvc.perform(get("/admin/appointments/delete")
                .session(session)
                .param("id", "1"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/appointments"));
    }

    // ── Departments ───────────────────────────────────────────

    @Test
    @DisplayName("Add department should redirect to departments")
    void addDepartment_Redirects() throws Exception {
        doNothing().when(deptService).add(anyString(), anyString());

        mockMvc.perform(post("/admin/departments/add")
                .session(session)
                .param("name",        "Dermatology")
                .param("description", "Skin care"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/departments"));

        verify(deptService, times(1)).add("Dermatology", "Skin care");
    }

    @Test
    @DisplayName("Delete department should redirect to departments")
    void deleteDepartment_Redirects() throws Exception {
        doNothing().when(deptService).delete(1);

        mockMvc.perform(get("/admin/departments/delete")
                .session(session)
                .param("id", "1"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/departments"));
    }

    // ── Bills ─────────────────────────────────────────────────

    @Test
    @DisplayName("Manage bills should forward to managebills.jsp")
    void manageBills_ForwardsToJsp() throws Exception {
        when(billService.getAllBills()).thenReturn(List.of());

        mockMvc.perform(get("/admin/bills").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/managebills.jsp"));
    }
}
