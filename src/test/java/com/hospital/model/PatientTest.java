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
        patient.setPassword("hashedpassword");
        patient.setGender("Male");
        patient.setAge(30);
        patient.setBloodGroup("O+");
        patient.setAddress("123 Main St, Rajkot");
        patient.setStatus("active");
        patient.setPhoto("/uploads/photo.jpg");
    }

    @Test @DisplayName("ID getter/setter")
    void testId() { assertEquals(1, patient.getId()); }

    @Test @DisplayName("Full name getter/setter")
    void testFullName() { assertEquals("John Smith", patient.getFullName()); }

    @Test @DisplayName("Email getter/setter")
    void testEmail() { assertEquals("john@hms.com", patient.getEmail()); }

    @Test @DisplayName("Phone getter/setter")
    void testPhone() { assertEquals("+91-9876543210", patient.getPhone()); }

    @Test @DisplayName("Password getter/setter")
    void testPassword() { assertEquals("hashedpassword", patient.getPassword()); }

    @Test @DisplayName("Gender getter/setter")
    void testGender() { assertEquals("Male", patient.getGender()); }

    @Test @DisplayName("Age getter/setter")
    void testAge() { assertEquals(30, patient.getAge()); }

    @Test @DisplayName("Blood group getter/setter")
    void testBloodGroup() { assertEquals("O+", patient.getBloodGroup()); }

    @Test @DisplayName("Address getter/setter")
    void testAddress() { assertEquals("123 Main St, Rajkot", patient.getAddress()); }

    @Test @DisplayName("Status getter/setter")
    void testStatus() { assertEquals("active", patient.getStatus()); }

    @Test @DisplayName("Photo getter/setter")
    void testPhoto() { assertEquals("/uploads/photo.jpg", patient.getPhoto()); }

    @Test @DisplayName("Age should be positive")
    void testAgePositive() { assertTrue(patient.getAge() > 0); }

    @Test @DisplayName("Status should be active or inactive")
    void testStatusValid() {
        String s = patient.getStatus();
        assertTrue("active".equals(s) || "inactive".equals(s));
    }

    @Test @DisplayName("Gender should be Male, Female or Other")
    void testGenderValid() {
        String g = patient.getGender();
        assertTrue("Male".equals(g) || "Female".equals(g) || "Other".equals(g));
    }

    @Test @DisplayName("All fields should be set correctly")
    void testAllFields() {
        assertAll("Patient fields",
            () -> assertEquals(1,              patient.getId()),
            () -> assertEquals("John Smith",   patient.getFullName()),
            () -> assertEquals("john@hms.com", patient.getEmail()),
            () -> assertEquals(30,             patient.getAge()),
            () -> assertEquals("O+",           patient.getBloodGroup()),
            () -> assertEquals("active",       patient.getStatus())
        );
    }

    @Test @DisplayName("Default patient has null photo")
    void testDefaultPhoto() {
        Patient p = new Patient();
        assertNull(p.getPhoto());
    }

    @Test @DisplayName("Default patient has zero age")
    void testDefaultAge() {
        Patient p = new Patient();
        assertEquals(0, p.getAge());
    }
}
