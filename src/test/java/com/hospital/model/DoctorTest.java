package com.hospital.model;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Doctor Model Tests")
class DoctorTest {

    private Doctor doctor;

    @BeforeEach
    void setUp() {
        doctor = new Doctor();
        doctor.setId(1);
        doctor.setFullName("Dr. Sarah Johnson");
        doctor.setEmail("sarah@hms.com");
        doctor.setPhone("+91-9000000001");
        doctor.setGender("Female");
        doctor.setQualification("MD, FACC");
        doctor.setSpecialization("Cardiologist");
        doctor.setDepartmentId(1);
        doctor.setDepartmentName("Cardiology");
        doctor.setExperienceYrs(15);
        doctor.setConsultationFee(800.00);
        doctor.setStatus("active");
    }

    @Test
    @DisplayName("Doctor ID should be set correctly")
    void testId() { assertEquals(1, doctor.getId()); }

    @Test
    @DisplayName("Doctor name should start with Dr.")
    void testNamePrefix() {
        assertTrue(doctor.getFullName().startsWith("Dr."));
    }

    @Test
    @DisplayName("Consultation fee should be positive")
    void testConsultationFee() {
        assertTrue(doctor.getConsultationFee() > 0);
    }

    @Test
    @DisplayName("Experience years should be non-negative")
    void testExperience() {
        assertTrue(doctor.getExperienceYrs() >= 0);
    }

    @Test
    @DisplayName("Department name should match department ID")
    void testDepartment() {
        assertEquals(1, doctor.getDepartmentId());
        assertEquals("Cardiology", doctor.getDepartmentName());
    }

    @Test
    @DisplayName("Doctor status should be active or inactive")
    void testStatus() {
        String s = doctor.getStatus();
        assertTrue("active".equals(s) || "inactive".equals(s));
    }

    @Test
    @DisplayName("All doctor fields should be set correctly")
    void testAllFields() {
        assertAll("Doctor fields",
            () -> assertEquals("Dr. Sarah Johnson", doctor.getFullName()),
            () -> assertEquals("sarah@hms.com",     doctor.getEmail()),
            () -> assertEquals("MD, FACC",          doctor.getQualification()),
            () -> assertEquals("Cardiologist",      doctor.getSpecialization()),
            () -> assertEquals(15,                  doctor.getExperienceYrs()),
            () -> assertEquals(800.00,              doctor.getConsultationFee())
        );
    }
}
