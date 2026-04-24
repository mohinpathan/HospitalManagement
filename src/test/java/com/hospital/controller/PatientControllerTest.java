package com.hospital.controller;

import com.hospital.model.Appointment;
import com.hospital.model.Patient;
import com.hospital.service.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PatientController Tests")
class PatientControllerTest {

    private MockMvc mockMvc;
    private MockHttpSession session;

    @Mock private UserService        userService;
    @Mock private AppointmentService apptService;
    @Mock private DepartmentService  deptService;
    @Mock private BillService        billService;

    @InjectMocks private PatientController patientController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(patientController).build();
        session = new MockHttpSession();
        session.setAttribute("role",      "patient");
        session.setAttribute("patientId", 1);
        session.setAttribute("patientName", "John Smith");
        session.setAttribute("patientEmail", "john@hms.com");
    }

    // ── Dashboard ─────────────────────────────────────────────

    @Test
    @DisplayName("Dashboard should forward to patientDashboard.jsp")
    void dashboard_ForwardsToJsp() throws Exception {
        when(apptService.countByPatient(1)).thenReturn(3);
        when(apptService.countByPatientAndStatus(1, "approved")).thenReturn(1);
        when(apptService.countByPatientAndStatus(1, "completed")).thenReturn(2);
        when(apptService.getByPatient(1)).thenReturn(List.of());
        when(billService.getBillsByPatient(1)).thenReturn(List.of());
        when(apptService.getNextApproved(1)).thenReturn(null);
        when(userService.getPatientById(1)).thenReturn(new Patient());

        mockMvc.perform(get("/patient/dashboard").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/patientDashboard.jsp"));
    }

    @Test
    @DisplayName("Dashboard without session should redirect to login")
    void dashboard_NoSession_RedirectsToLogin() throws Exception {
        mockMvc.perform(get("/patient/dashboard"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/login.jsp"));
    }

    // ── Appointments ──────────────────────────────────────────

    @Test
    @DisplayName("Appointments page should forward to patientAppointments.jsp")
    void appointments_ForwardsToJsp() throws Exception {
        when(apptService.getByPatient(1)).thenReturn(List.of());

        mockMvc.perform(get("/patient/appointments").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/patientAppointments.jsp"));
    }

    // ── Book Appointment ──────────────────────────────────────

    @Test
    @DisplayName("Book appointment form should forward to bookAppointment.jsp")
    void bookForm_ForwardsToJsp() throws Exception {
        when(deptService.getAll()).thenReturn(List.of());
        when(userService.getAllDoctors()).thenReturn(List.of());

        mockMvc.perform(get("/patient/bookAppointment").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/bookAppointment.jsp"));
    }

    @Test
    @DisplayName("POST bookAppointment should redirect to appointments")
    void bookSubmit_RedirectsToAppointments() throws Exception {
        doNothing().when(apptService).book(any(Appointment.class));

        mockMvc.perform(post("/patient/bookAppointment")
                .session(session)
                .param("doctorId",     "1")
                .param("departmentId", "1")
                .param("date",         "2026-06-01")
                .param("time",         "10:00")
                .param("reason",       "Regular checkup"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/patient/appointments"));

        verify(apptService, times(1)).book(any(Appointment.class));
    }

    // ── Cancel Appointment ────────────────────────────────────

    @Test
    @DisplayName("Cancel appointment should redirect to appointments")
    void cancelAppointment_Redirects() throws Exception {
        doNothing().when(apptService).updateStatus(1, "cancelled");

        mockMvc.perform(get("/patient/cancelAppointment")
                .session(session)
                .param("id", "1"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/patient/appointments"));

        verify(apptService, times(1)).updateStatus(1, "cancelled");
    }

    // ── Find Doctors ──────────────────────────────────────────

    @Test
    @DisplayName("Find doctors should forward to findDoctors.jsp")
    void findDoctors_ForwardsToJsp() throws Exception {
        when(deptService.getAll()).thenReturn(List.of());
        when(userService.searchDoctors(anyInt(), anyString(), anyDouble(), anyString()))
            .thenReturn(List.of());

        mockMvc.perform(get("/patient/findDoctors").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/findDoctors.jsp"));
    }

    // ── Profile ───────────────────────────────────────────────

    @Test
    @DisplayName("Profile page should forward to patientProfile.jsp")
    void profile_ForwardsToJsp() throws Exception {
        when(userService.getPatientById(1)).thenReturn(new Patient());

        mockMvc.perform(get("/patient/profile").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/patientProfile.jsp"));
    }

    @Test
    @DisplayName("Update profile should redirect to profile page")
    void updateProfile_Redirects() throws Exception {
        doNothing().when(userService).updatePatientFull(anyInt(), anyString(), anyString(), anyString(), anyString(), anyInt());

        mockMvc.perform(post("/patient/updateProfile")
                .session(session)
                .param("name",       "John Updated")
                .param("phone",      "+91-9876543210")
                .param("bloodGroup", "O+")
                .param("address",    "New Address")
                .param("age",        "31"))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/patient/profile"));
    }

    // ── Medical Records ───────────────────────────────────────

    @Test
    @DisplayName("Medical records should forward to medicalRecords.jsp")
    void medicalRecords_ForwardsToJsp() throws Exception {
        when(billService.getBillsByPatient(1)).thenReturn(List.of());

        mockMvc.perform(get("/patient/medicalRecords").session(session))
               .andExpect(status().isOk())
               .andExpect(forwardedUrl("/medicalRecords.jsp"));
    }
}
