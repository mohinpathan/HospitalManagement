package com.hospital;

import org.junit.platform.suite.api.*;

/**
 * Master test suite — runs all tests in the project.
 * Right-click this class → Run As → JUnit Test
 */
@Suite
@SelectPackages({
    "com.hospital.util",
    "com.hospital.model",
    "com.hospital.service",
    "com.hospital.controller"
})
@DisplayName("Hospital Management System — Full Test Suite")
public class HospitalManagementTestSuite {
    // This class is intentionally empty.
    // It serves as the entry point for the full test suite.
}
