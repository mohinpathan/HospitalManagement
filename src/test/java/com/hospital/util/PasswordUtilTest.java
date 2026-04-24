package com.hospital.util;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PasswordUtil Tests")
class PasswordUtilTest {

    @Test
    @DisplayName("Hash should not equal plain text")
    void hashShouldNotEqualPlainText() {
        String plain  = "admin123";
        String hashed = PasswordUtil.hash(plain);
        assertNotEquals(plain, hashed);
    }

    @Test
    @DisplayName("Hash should not be null or empty")
    void hashShouldNotBeNullOrEmpty() {
        String hashed = PasswordUtil.hash("testpass");
        assertNotNull(hashed);
        assertFalse(hashed.isEmpty());
    }

    @Test
    @DisplayName("Correct password should verify successfully")
    void correctPasswordShouldVerify() {
        String plain  = "admin123";
        String hashed = PasswordUtil.hash(plain);
        assertTrue(PasswordUtil.verify(plain, hashed));
    }

    @Test
    @DisplayName("Wrong password should fail verification")
    void wrongPasswordShouldFail() {
        String hashed = PasswordUtil.hash("admin123");
        assertFalse(PasswordUtil.verify("wrongpass", hashed));
    }

    @Test
    @DisplayName("Empty password should fail verification against real hash")
    void emptyPasswordShouldFail() {
        String hashed = PasswordUtil.hash("admin123");
        assertFalse(PasswordUtil.verify("", hashed));
    }

    @Test
    @DisplayName("Two hashes of same password should be different (salt)")
    void twoHashesShouldBeDifferent() {
        String h1 = PasswordUtil.hash("admin123");
        String h2 = PasswordUtil.hash("admin123");
        assertNotEquals(h1, h2, "BCrypt should produce different salts each time");
    }

    @Test
    @DisplayName("Hash should start with BCrypt prefix")
    void hashShouldStartWithBcryptPrefix() {
        String hashed = PasswordUtil.hash("admin123");
        assertTrue(hashed.startsWith("$2a$") || hashed.startsWith("$2b$"));
    }
}
