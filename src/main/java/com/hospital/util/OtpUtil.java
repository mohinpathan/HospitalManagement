package com.hospital.util;

import java.security.SecureRandom;

public class OtpUtil {

    private static final SecureRandom random = new SecureRandom();

    /** Returns a 6-digit numeric OTP string */
    public static String generate() {
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
}
