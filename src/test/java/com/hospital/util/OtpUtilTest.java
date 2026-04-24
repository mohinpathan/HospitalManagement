package com.hospital.util;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("OtpUtil Tests")
class OtpUtilTest {

    @Test
    @DisplayName("OTP should be exactly 6 characters")
    void otpShouldBeSixChars() {
        String otp = OtpUtil.generate();
        assertEquals(6, otp.length());
    }

    @Test
    @DisplayName("OTP should contain only digits")
    void otpShouldBeNumeric() {
        String otp = OtpUtil.generate();
        assertTrue(otp.matches("\\d{6}"), "OTP should be 6 numeric digits, got: " + otp);
    }

    @Test
    @DisplayName("OTP should not be null")
    void otpShouldNotBeNull() {
        assertNotNull(OtpUtil.generate());
    }

    @Test
    @DisplayName("OTP should be in range 100000-999999")
    void otpShouldBeInRange() {
        String otp = OtpUtil.generate();
        int value = Integer.parseInt(otp);
        assertTrue(value >= 100000 && value <= 999999);
    }

    @Test
    @DisplayName("10 consecutive OTPs should not all be the same")
    void otpsShouldBeRandom() {
        Set<String> otps = new HashSet<>();
        for (int i = 0; i < 10; i++) {
            otps.add(OtpUtil.generate());
        }
        assertTrue(otps.size() > 1, "OTPs should be random, not all identical");
    }
}
