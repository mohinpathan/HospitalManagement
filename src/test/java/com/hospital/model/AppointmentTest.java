package com.hospital.model;

import org.junit.jupiter.api.*;
import java.sql.Date;
import java.sql.Time;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Appointment Model Tests")
class AppointmentTest {

    private Appointment appointment;

    @BeforeEach
    void setUp() {
        appointment = new Appointment();
        appointment.setId(1);
        appointment.setPatientId(1);
        appointment.setDoctorId(1);
        appointment.setDepartmentId(1);
        appointment.setAppointmentDate(Date.valueOf("2026-05-01"));
        appointment.setAppointmentTime(Time.valueOf("10:00:00"));
        appointment.setReason("Regular checkup");
        appointment.setStatus("pending");
        appointment.setPatientName("John Smith");
        appointment.setDoctorName("Dr. Sarah Johnson");
        appointment.setDepartmentName("Cardiology");
    }

    @Test
    @DisplayName("Appointment ID should be set correctly")
    void testId() { assertEquals(1, appointment.getId()); }

    @Test
    @DisplayName("Status should be one of valid values")
    void testValidStatus() {
        String s = appointment.getStatus();
        assertTrue(
            "pending".equals(s) || "approved".equals(s) ||
            "completed".equals(s) || "cancelled".equals(s) || "rejected".equals(s),
            "Invalid status: " + s
        );
    }

    @Test
    @DisplayName("Appointment date should not be null")
    void testDateNotNull() { assertNotNull(appointment.getAppointmentDate()); }

    @Test
    @DisplayName("Appointment time should not be null")
    void testTimeNotNull() { assertNotNull(appointment.getAppointmentTime()); }

    @Test
    @DisplayName("Reason should not be empty")
    void testReasonNotEmpty() {
        assertNotNull(appointment.getReason());
        assertFalse(appointment.getReason().isEmpty());
    }

    @Test
    @DisplayName("Patient and doctor IDs should be positive")
    void testPositiveIds() {
        assertTrue(appointment.getPatientId() > 0);
        assertTrue(appointment.getDoctorId() > 0);
    }

    @Test
    @DisplayName("Joined fields should be populated")
    void testJoinedFields() {
        assertAll("Joined fields",
            () -> assertEquals("John Smith",        appointment.getPatientName()),
            () -> assertEquals("Dr. Sarah Johnson", appointment.getDoctorName()),
            () -> assertEquals("Cardiology",        appointment.getDepartmentName())
        );
    }
}
