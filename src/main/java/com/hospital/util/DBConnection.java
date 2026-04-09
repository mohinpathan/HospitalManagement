package com.hospital.util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Legacy JDBC helper kept for backward compatibility.
 * Prefer injecting JdbcTemplate via Spring in new code.
 */
public class DBConnection {

    private static final String URL  = "jdbc:mysql://localhost:3306/hospital_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            throw new RuntimeException("DB connection failed", e);
        }
    }
}
