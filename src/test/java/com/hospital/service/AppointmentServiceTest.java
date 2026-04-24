package com.hospital.service;

import com.hospital.model.Appointment;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AppointmentService Tests")
class AppointmentServiceTest {

    @Mock  private JdbcTemplate jdbc;
    @InjectMocks private AppointmentService apptService;

    private Appointment buildAppointment(int id, int patientId, int doctorId, String status) {
        Appointment a = new Appointment();
        a.setId(id);
        a.setPatientId(patientId);
        a.setDoctorId(doctorId);
        a.setAppointmentDate(Date.valueOf("2026-05-01"));
        a.setAppointmentTime(Time.valueOf("10:00:00"));
        a.setReason("Checkup");
        a.setStatus(status);
        a.setPatientName("John Smith");
        a.setDoctorName("Dr. Sarah Johnson");
        a.setDepartmentName("Cardiology");
        return a;
    }

    // ── book ──────────────────────────────────────────────────

    @Test
    @DisplayName("book() should call jdbc.update once")
    void book_CallsDB() {
        Appointment a = buildAppointment(0, 1, 1, "pending");
        apptService.book(a);
        verify(jdbc, times(1)).update(anyString(),
            anyInt(), anyInt(), anyInt(), any(), any(), anyString());
    }

    // ── getByPatient ──────────────────────────────────────────

    @Test
    @DisplayName("getByPatient returns empty list when no appointments")
    void getByPatient_Empty() {
        when(jdbc.query(anyString(), any(RowMapper.class), anyInt()))
            .thenReturn(List.of());

        List<Appointment> result = apptService.getByPatient(1);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getByPatient returns appointments for patient")
    void getByPatient_WithData() {
        List<Appointment> mock = List.of(
            buildAppointment(1, 1, 1, "approved"),
            buildAppointment(2, 1, 2, "completed")
        );
        when(jdbc.query(anyString(), any(RowMapper.class), anyInt()))
            .thenReturn(mock);

        List<Appointment> result = apptService.getByPatient(1);
        assertEquals(2, result.size());
        assertEquals("approved",  result.get(0).getStatus());
        assertEquals("completed", result.get(1).getStatus());
    }

    // ── getByDoctor ───────────────────────────────────────────

    @Test
    @DisplayName("getByDoctor returns appointments for doctor")
    void getByDoctor_WithData() {
        List<Appointment> mock = List.of(
            buildAppointment(1, 1, 1, "pending"),
            buildAppointment(2, 2, 1, "approved")
        );
        when(jdbc.query(anyString(), any(RowMapper.class), anyInt()))
            .thenReturn(mock);

        List<Appointment> result = apptService.getByDoctor(1);
        assertEquals(2, result.size());
    }

    // ── updateStatus ──────────────────────────────────────────

    @Test
    @DisplayName("updateStatus should call jdbc.update with correct args")
    void updateStatus_CallsDB() {
        apptService.updateStatus(1, "approved");
        verify(jdbc, times(1)).update(anyString(), eq("approved"), eq(1));
    }

    // ── countByPatient ────────────────────────────────────────

    @Test
    @DisplayName("countByPatient returns correct count")
    void countByPatient_ReturnsCount() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class), anyInt()))
            .thenReturn(5);

        int count = apptService.countByPatient(1);
        assertEquals(5, count);
    }

    @Test
    @DisplayName("countByPatient returns 0 when null from DB")
    void countByPatient_NullReturnsZero() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class), anyInt()))
            .thenReturn(null);

        // Should not throw NPE
        assertDoesNotThrow(() -> apptService.countByPatient(1));
    }

    // ── countAll ──────────────────────────────────────────────

    @Test
    @DisplayName("countAll returns total appointment count")
    void countAll_ReturnsCount() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class)))
            .thenReturn(42);

        assertEquals(42, apptService.countAll());
    }

    // ── delete ────────────────────────────────────────────────

    @Test
    @DisplayName("delete() should call jdbc.update once")
    void delete_CallsDB() {
        apptService.delete(1);
        verify(jdbc, times(1)).update(anyString(), eq(1));
    }
}
