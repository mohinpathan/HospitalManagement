package com.hospital.service;

import com.hospital.model.Bill;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("BillService Tests")
class BillServiceTest {

    @Mock  private JdbcTemplate jdbc;
    @InjectMocks private BillService billService;

    private Bill buildBill(int id, String status) {
        Bill b = new Bill();
        b.setId(id);
        b.setPatientId(1); b.setDoctorId(1); b.setAppointmentId(1);
        b.setConsultationFee(500); b.setMedicineCharge(100); b.setOtherCharge(50);
        b.setTotalAmount(650);
        b.setPaymentStatus(status);
        b.setPaymentMethod("cash");
        b.setPatientName("John Smith");
        b.setPatientEmail("john@hms.com");
        b.setDoctorName("Dr. Sarah Johnson");
        b.setDiagnosis("Fever"); b.setMedicines("Paracetamol");
        return b;
    }

    // ── getAllBills ────────────────────────────────────────────

    @Test
    @DisplayName("getAllBills returns list of bills")
    void getAllBills_ReturnsList() {
        when(jdbc.query(anyString(), any(RowMapper.class)))
            .thenReturn(List.of(buildBill(1, "pending"), buildBill(2, "confirmed")));

        List<Bill> result = billService.getAllBills();
        assertEquals(2, result.size());
    }

    @Test
    @DisplayName("getAllBills returns empty list when no bills")
    void getAllBills_Empty() {
        when(jdbc.query(anyString(), any(RowMapper.class)))
            .thenReturn(List.of());

        assertTrue(billService.getAllBills().isEmpty());
    }

    // ── getBillsByPatient ─────────────────────────────────────

    @Test
    @DisplayName("getBillsByPatient returns bills for patient")
    void getBillsByPatient_WithData() {
        when(jdbc.query(anyString(), any(RowMapper.class), anyInt()))
            .thenReturn(List.of(buildBill(1, "pending")));

        List<Bill> result = billService.getBillsByPatient(1);
        assertEquals(1, result.size());
        assertEquals("pending", result.get(0).getPaymentStatus());
    }

    // ── confirmBill ───────────────────────────────────────────

    @Test
    @DisplayName("confirmBill calls update and returns bill")
    void confirmBill_UpdatesAndReturns() {
        Bill mock = buildBill(1, "confirmed");
        when(jdbc.query(anyString(), any(RowMapper.class), anyInt()))
            .thenReturn(List.of(mock));

        Bill result = billService.confirmBill(1, 1);
        assertNotNull(result);
        verify(jdbc, atLeastOnce()).update(anyString(), anyInt(), anyInt());
    }

    // ── markReceiptSent ───────────────────────────────────────

    @Test
    @DisplayName("markReceiptSent calls jdbc.update once")
    void markReceiptSent_CallsDB() {
        billService.markReceiptSent(1);
        verify(jdbc, times(1)).update(anyString(), eq(1));
    }

    // ── getTotalRevenue ───────────────────────────────────────

    @Test
    @DisplayName("getTotalRevenue returns correct value")
    void getTotalRevenue_ReturnsValue() {
        when(jdbc.queryForObject(anyString(), eq(Double.class)))
            .thenReturn(15000.0);

        assertEquals(15000.0, billService.getTotalRevenue(), 0.001);
    }

    @Test
    @DisplayName("getTotalRevenue returns 0 when null from DB")
    void getTotalRevenue_NullReturnsZero() {
        when(jdbc.queryForObject(anyString(), eq(Double.class)))
            .thenReturn(null);

        assertEquals(0.0, billService.getTotalRevenue(), 0.001);
    }

    // ── countPending ──────────────────────────────────────────

    @Test
    @DisplayName("countPending returns correct count")
    void countPending_ReturnsCount() {
        when(jdbc.queryForObject(anyString(), eq(Integer.class)))
            .thenReturn(3);

        assertEquals(3, billService.countPending());
    }

    // ── getEarningsByDoctor ───────────────────────────────────

    @Test
    @DisplayName("getEarningsByDoctor returns monthly earnings")
    void getEarningsByDoctor_ReturnsValue() {
        when(jdbc.queryForObject(anyString(), eq(Double.class), anyInt()))
            .thenReturn(8000.0);

        assertEquals(8000.0, billService.getEarningsByDoctor(1), 0.001);
    }
}
