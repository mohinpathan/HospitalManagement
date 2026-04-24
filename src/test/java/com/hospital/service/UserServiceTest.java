package com.hospital.service;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserService Tests")
class UserServiceTest {

    @Mock  private JdbcTemplate jdbc;
    @InjectMocks private UserService userService;

    // ── findPatientByEmail ────────────────────────────────────

    @Test
    @DisplayName("findPatientByEmail returns null when patient not found")
    void findPatientByEmail_NotFound() {
        when(jdbc.query(anyString(), any(RowMapper.class), anyString()))
            .thenReturn(List.of());

        Patient result = userService.findPatientByEmail("notfound@test.com");
        assertNull(result);
    }

    @Test
    @DisplayName("findPatientByEmail returns patient when found")
    void findPatientByEmail_Found() {
        Patient mock = new Patient();
        mock.setId(1);
        mock.setFullName("John Smith");
        mock.setEmail("john@hms.com");

        when(jdbc.query(anyString(), any(RowMapper.class), anyString()))
            .thenReturn(List.of(mock));

        Patient result = userService.findPatientByEmail("john@hms.com");
        assertNotNull(result);
        assertEquals("John Smith", result.getFullName());
        assertEquals("john@hms.com", result.getEmail());
    }

    // ── findDoctorByEmail ─────────────────────────────────────

    @Test
    @DisplayName("findDoctorByEmail returns null when doctor not found")
    void findDoctorByEmail_NotFound() {
        when(jdbc.query(anyString(), any(RowMapper.class), anyString()))
            .thenReturn(List.of());

        Doctor result = userService.findDoctorByEmail("notfound@test.com");
        assertNull(result);
    }

    @Test
    @DisplayName("findDoctorByEmail returns doctor when found")
    void findDoctorByEmail_Found() {
        Doctor mock = new Doctor();
        mock.setId(1);
        mock.setFullName("Dr. Sarah Johnson");
        mock.setEmail("sarah@hms.com");
        mock.setDepartmentName("Cardiology");

        when(jdbc.query(anyString(), any(RowMapper.class), anyString()))
            .thenReturn(List.of(mock));

        Doctor result = userService.findDoctorByEmail("sarah@hms.com");
        assertNotNull(result);
        assertEquals("Dr. Sarah Johnson", result.getFullName());
    }

    // ── findAdminByEmail ──────────────────────────────────────

    @Test
    @DisplayName("findAdminByEmail returns null when admin not found")
    void findAdminByEmail_NotFound() {
        when(jdbc.query(anyString(), any(RowMapper.class), anyString()))
            .thenReturn(List.of());

        Admin result = userService.findAdminByEmail("notfound@test.com");
        assertNull(result);
    }

    // ── registerPatient ───────────────────────────────────────

    @Test
    @DisplayName("registerPatient should call jdbc.update exactly once")
    void registerPatient_CallsDB() {
        Patient p = new Patient();
        p.setFullName("Test User"); p.setEmail("test@test.com");
        p.setPhone("1234567890"); p.setPassword("hashed");
        p.setGender("Male"); p.setAge(25);
        p.setBloodGroup("O+"); p.setAddress("Test Address");

        userService.registerPatient(p);

        verify(jdbc, times(1)).update(anyString(),
            anyString(), anyString(), anyString(), anyString(),
            anyString(), anyInt(), anyString(), anyString());
    }

    // ── emailExists ───────────────────────────────────────────

    @Test
    @DisplayName("emailExists returns true when count > 0")
    void emailExists_True() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class), anyString()))
            .thenReturn(1);

        assertTrue(userService.emailExists("john@hms.com", "patient"));
    }

    @Test
    @DisplayName("emailExists returns false when count is 0")
    void emailExists_False() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class), anyString()))
            .thenReturn(0);

        assertFalse(userService.emailExists("nobody@test.com", "patient"));
    }

    // ── tableFor (via emailExists) ────────────────────────────

    @Test
    @DisplayName("Unknown role should throw IllegalArgumentException")
    void unknownRole_ThrowsException() {
        assertThrows(IllegalArgumentException.class, () ->
            userService.emailExists("test@test.com", "unknown_role"));
    }

    // ── updatePassword ────────────────────────────────────────

    @Test
    @DisplayName("updatePassword should call jdbc.update once")
    void updatePassword_CallsDB() {
        userService.updatePassword("john@hms.com", "patient", "newhashedpass");
        verify(jdbc, times(1)).update(anyString(), anyString(), anyString());
    }
}
