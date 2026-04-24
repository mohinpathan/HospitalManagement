package com.hospital.model;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Patient Model Tests")
class PatientTest {

    private Patient patient;

    @BeforeEach
    void setUp() {
        patient = new Patient();
        patient.setId(1);
        patient.setFullName("John Smith");
        patient.setEmail("john@hms.com");
        patient.setPhone("+91-9876543210");
        patient.setGender("Male");
        patient.setAge(30);
        patient.setBloodGroup("O+");
        patient.setAddress("123 Main St, Rajkot");
        patient.setStatus("active");
    }

    @Test
    @DisplayName("Patient ID should be set correctly")
    void testId() { assertEquals(1, patient.getId()); }

    @Test
    @DisplayName("Patient full name should be set correctly")
    void testFullName() { assertEquals("John Smith", patient.getFullName()); }

    @Test
    @DisplayName("Patient email should be set correctly")
    void testEmail() { assertEquals("john@hms.com", patient.getEmail()); }

    @Test
    @DisplayName("Patient age should be positive")
    void testAge() { assertTrue(patient.getAge() > 0); }

    @Test
    @DisplayName("Patient blood group should not be null")
    void testBloodGroup() { assertNotNull(patient.getBloodGroup()); }

    @Test
    @DisplayName("Patient status should be active")
    void testStatus() { assertEquals("active", patient.getStatus()); }

    @Test
    @DisplayName("Patient gender should be Male or Female or Other")
    void testGender() {
        String g = patient.getGender();
        assertTrue("Male".equals(g) || "Female".equals(g) || "Other".equals(g));
    }

    @Test
    @DisplayName("All fields should be set correctly together")
    void testAllFields() {
        assertAll("Patient fields",
            () -> assertEquals(1,            patient.getId()),
            () -> assertEquals("John Smith", patient.getFullName()),
            () -> assertEquals("john@hms.com", patient.getEmail()),
            () -> assertEquals(30,           patient.getAge()),
            () -> assertEquals("O+",         patient.getBloodGroup()),
            () -> assertEquals("active",     patient.getStatus())
        );
    }
}
