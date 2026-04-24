package com.hospital.util;

import org.junit.jupiter.api.*;

import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("OtpUtil Tests")
class OtpUtilTest {

    @Test
    @DisplayName("OTP should not be null")
    void otp_NotNull() {
        assertNotNull(OtpUtil.generate());
    }

    @Test
    @DisplayName("OTP should be exactly 6 characters")
    void otp_SixChars() {
        assertEquals(6, OtpUtil.generate().length());
    }

    @Test
    @DisplayName("OTP should contain only digits")
    void otp_OnlyDigits() {
        String otp = OtpUtil.generate();
        assertTrue(otp.matches("\\d{6}"), "OTP should be 6 numeric digits, got: " + otp);
    }

    @Test
    @DisplayName("OTP should be in range 100000 to 999999")
    void otp_InRange() {
        String otp = OtpUtil.generate();
        int value = Integer.parseInt(otp);
        assertTrue(value >= 100000 && value <= 999999,
            "OTP out of range: " + value);
    }

    @Test
    @DisplayName("OTP should be parseable as integer")
    void otp_ParseableAsInt() {
        assertDoesNotThrow(() -> Integer.parseInt(OtpUtil.generate()));
    }

    @Test
    @DisplayName("Multiple OTPs should not all be identical (randomness check)")
    void otp_IsRandom() {
        Set<String> otps = new HashSet<>();
        for (int i = 0; i < 20; i++) {
            otps.add(OtpUtil.generate());
        }
        assertTrue(otps.size() > 1, "OTPs should be random, not all identical");
    }

    @Test
    @DisplayName("OTP should never start with 0 (always 6 digits)")
    void otp_NeverStartsWithZero() {
        for (int i = 0; i < 10; i++) {
            String otp = OtpUtil.generate();
            assertNotEquals('0', otp.charAt(0),
                "OTP should not start with 0: " + otp);
        }
    }
}
