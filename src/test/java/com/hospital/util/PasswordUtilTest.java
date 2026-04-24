package com.hospital.util;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PasswordUtil Tests")
class PasswordUtilTest {

    @Test
    @DisplayName("Hash should not equal plain text")
    void hash_NotEqualPlainText() {
        String plain  = "admin123";
        String hashed = PasswordUtil.hash(plain);
        assertNotEquals(plain, hashed);
    }

    @Test
    @DisplayName("Hash should not be null")
    void hash_NotNull() {
        assertNotNull(PasswordUtil.hash("testpass"));
    }

    @Test
    @DisplayName("Hash should not be empty")
    void hash_NotEmpty() {
        assertFalse(PasswordUtil.hash("testpass").isEmpty());
    }

    @Test
    @DisplayName("Hash should start with BCrypt prefix")
    void hash_StartsWithBcryptPrefix() {
        String h = PasswordUtil.hash("admin123");
        assertTrue(h.startsWith("$2a$") || h.startsWith("$2b$"),
            "Expected BCrypt prefix, got: " + h.substring(0, 4));
    }

    @Test
    @DisplayName("Two hashes of same password should differ due to salt")
    void hash_TwoHashesDiffer() {
        String h1 = PasswordUtil.hash("admin123");
        String h2 = PasswordUtil.hash("admin123");
        assertNotEquals(h1, h2, "BCrypt should produce different salts each time");
    }

    @Test
    @DisplayName("Correct password should verify successfully")
    void verify_CorrectPassword() {
        String plain  = "admin123";
        String hashed = PasswordUtil.hash(plain);
        assertTrue(PasswordUtil.verify(plain, hashed));
    }

    @Test
    @DisplayName("Wrong password should fail verification")
    void verify_WrongPassword() {
        String hashed = PasswordUtil.hash("admin123");
        assertFalse(PasswordUtil.verify("wrongpass", hashed));
    }

    @Test
    @DisplayName("Empty string should fail verification against real hash")
    void verify_EmptyPassword() {
        String hashed = PasswordUtil.hash("admin123");
        assertFalse(PasswordUtil.verify("", hashed));
    }

    @ParameterizedTest
    @ValueSource(strings = {"admin123", "doctor456", "patient789", "Test@123"})
    @DisplayName("Various passwords should hash and verify correctly")
    void verify_VariousPasswords(String password) {
        String hashed = PasswordUtil.hash(password);
        assertTrue(PasswordUtil.verify(password, hashed));
    }

    @ParameterizedTest
    @CsvSource({"admin123,wrongpass", "doctor456,admin123", "patient789,doctor456"})
    @DisplayName("Wrong passwords should fail verification")
    void verify_WrongPasswords(String correct, String wrong) {
        String hashed = PasswordUtil.hash(correct);
        assertFalse(PasswordUtil.verify(wrong, hashed));
    }
}
