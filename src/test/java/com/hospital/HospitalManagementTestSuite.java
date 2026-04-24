package com.hospital;

import org.junit.platform.suite.api.SelectPackages;
import org.junit.platform.suite.api.Suite;
import org.junit.platform.suite.api.SuiteDisplayName;

/**
 * Master test suite — runs all tests in the project.
 * 
 * To run in Eclipse:
 * Right-click this class → Run As → JUnit Test
 * 
 * This will execute all test classes in:
 * - com.hospital.util
 * - com.hospital.model
 * - com.hospital.service
 * - com.hospital.controller
 */
@Suite
@SelectPackages({
    "com.hospital.util",
    "com.hospital.model",
    "com.hospital.service",
    "com.hospital.controller"
})
@SuiteDisplayName("Hospital Management System — Full Test Suite")
public class HospitalManagementTestSuite {
    // This class is intentionally empty.
    // It serves as the entry point for running all tests together.
}
