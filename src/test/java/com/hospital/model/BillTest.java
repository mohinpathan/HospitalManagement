package com.hospital.model;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Bill Model Tests")
class BillTest {

    private Bill bill;

    @BeforeEach
    void setUp() {
        bill = new Bill();
        bill.setId(1);
        bill.setAppointmentId(1);
        bill.setPatientId(1);
        bill.setDoctorId(1);
        bill.setConsultationFee(500.00);
        bill.setMedicineCharge(150.00);
        bill.setOtherCharge(50.00);
        bill.setTotalAmount(700.00);
        bill.setPaymentStatus("pending");
        bill.setPaymentMethod("cash");
        bill.setReceiptSent(false);
        bill.setPatientName("John Smith");
        bill.setDoctorName("Dr. Sarah Johnson");
        bill.setDiagnosis("Viral fever");
        bill.setMedicines("Paracetamol 500mg");
    }

    @Test
    @DisplayName("Total amount should equal sum of all charges")
    void testTotalAmount() {
        double expected = bill.getConsultationFee() + bill.getMedicineCharge() + bill.getOtherCharge();
        assertEquals(expected, bill.getTotalAmount(), 0.001);
    }

    @Test
    @DisplayName("All fees should be non-negative")
    void testFeesNonNegative() {
        assertAll("Fees",
            () -> assertTrue(bill.getConsultationFee() >= 0),
            () -> assertTrue(bill.getMedicineCharge()  >= 0),
            () -> assertTrue(bill.getOtherCharge()     >= 0),
            () -> assertTrue(bill.getTotalAmount()     >= 0)
        );
    }

    @Test
    @DisplayName("Payment status should be valid")
    void testPaymentStatus() {
        String s = bill.getPaymentStatus();
        assertTrue(
            "pending".equals(s) || "confirmed".equals(s) ||
            "paid".equals(s)    || "cancelled".equals(s),
            "Invalid payment status: " + s
        );
    }

    @Test
    @DisplayName("Receipt sent should default to false")
    void testReceiptSentDefault() { assertFalse(bill.isReceiptSent()); }

    @Test
    @DisplayName("Diagnosis and medicines should not be null")
    void testPrescriptionFields() {
        assertNotNull(bill.getDiagnosis());
        assertNotNull(bill.getMedicines());
    }

    @Test
    @DisplayName("Patient and doctor names should be set")
    void testNames() {
        assertAll("Names",
            () -> assertEquals("John Smith",        bill.getPatientName()),
            () -> assertEquals("Dr. Sarah Johnson", bill.getDoctorName())
        );
    }
}
