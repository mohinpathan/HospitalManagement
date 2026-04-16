package com.hospital.service;

import com.hospital.model.Bill;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.util.List;

@Service
public class BillService {

    @Autowired
    private JdbcTemplate jdbc;

    /**
     * Doctor saves prescription + creates bill in one transaction.
     */
    @Transactional
    public void createBillWithPrescription(int appointmentId, int patientId, int doctorId,
                                            double consultationFee, double medicineCharge,
                                            double otherCharge, String paymentMethod,
                                            String diagnosis, String medicines,
                                            String instructions, String followUpDate) {

        // 1. Save prescription
        jdbc.update(
            "INSERT INTO prescriptions (appointment_id, patient_id, doctor_id, diagnosis, medicines, instructions, follow_up_date) " +
            "VALUES (?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE diagnosis=VALUES(diagnosis), medicines=VALUES(medicines)",
            appointmentId, patientId, doctorId, diagnosis, medicines, instructions,
            followUpDate != null && !followUpDate.isEmpty() ? Date.valueOf(followUpDate) : null);

        // 2. Mark appointment completed
        jdbc.update("UPDATE appointments SET status='completed' WHERE id=?", appointmentId);

        // 3. Create bill
        jdbc.update(
            "INSERT INTO bills (appointment_id, patient_id, doctor_id, consultation_fee, medicine_charge, other_charge, payment_method) " +
            "VALUES (?,?,?,?,?,?,?)",
            appointmentId, patientId, doctorId,
            consultationFee, medicineCharge, otherCharge, paymentMethod);
    }

    /**
     * Admin confirms bill — returns enriched Bill for email.
     */
    @Transactional
    public Bill confirmBill(int billId, int adminId) {
        jdbc.update(
            "UPDATE bills SET payment_status='confirmed', confirmed_by_admin=?, confirmed_at=NOW() WHERE id=?",
            adminId, billId);
        return getBillWithDetails(billId);
    }

    public void markReceiptSent(int billId) {
        jdbc.update("UPDATE bills SET receipt_sent=1 WHERE id=?", billId);
    }

    public List<Bill> getAllBills() {
        return jdbc.query(
            "SELECT b.*, p.full_name AS patient_name, p.email AS patient_email, " +
            "d.full_name AS doctor_name, pr.diagnosis, pr.medicines " +
            "FROM bills b " +
            "JOIN patients p ON b.patient_id = p.id " +
            "JOIN doctors  d ON b.doctor_id  = d.id " +
            "LEFT JOIN prescriptions pr ON b.appointment_id = pr.appointment_id " +
            "ORDER BY b.created_at DESC",
            billMapper());
    }

    public Bill getBillWithDetails(int billId) {
        List<Bill> list = jdbc.query(
            "SELECT b.*, p.full_name AS patient_name, p.email AS patient_email, " +
            "d.full_name AS doctor_name, pr.diagnosis, pr.medicines " +
            "FROM bills b " +
            "JOIN patients p ON b.patient_id = p.id " +
            "JOIN doctors  d ON b.doctor_id  = d.id " +
            "LEFT JOIN prescriptions pr ON b.appointment_id = pr.appointment_id " +
            "WHERE b.id=?",
            billMapper(), billId);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Bill> getBillsByPatient(int patientId) {
        return jdbc.query(
            "SELECT b.*, p.full_name AS patient_name, p.email AS patient_email, " +
            "d.full_name AS doctor_name, pr.diagnosis, pr.medicines " +
            "FROM bills b " +
            "JOIN patients p ON b.patient_id = p.id " +
            "JOIN doctors  d ON b.doctor_id  = d.id " +
            "LEFT JOIN prescriptions pr ON b.appointment_id = pr.appointment_id " +
            "WHERE b.patient_id=? ORDER BY b.created_at DESC",
            billMapper(), patientId);
    }

    public List<java.util.Map<String,Object>> getMonthlyRevenue() {
        return jdbc.queryForList(
            "SELECT DATE_FORMAT(created_at,'%Y-%m') AS month, SUM(total_amount) AS revenue, COUNT(*) AS count " +
            "FROM bills WHERE payment_status IN ('confirmed','paid') " +
            "GROUP BY month ORDER BY month DESC LIMIT 12");
    }

    public double getTotalRevenue() {
        Double r = jdbc.queryForObject(
            "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE payment_status IN ('confirmed','paid')",
            Double.class);
        return r != null ? r : 0.0;
    }

    public int countPending() {
        Integer c = jdbc.queryForObject(
            "SELECT COUNT(*) FROM bills WHERE payment_status='pending'", Integer.class);
        return c != null ? c : 0;
    }

    public double getEarningsByDoctor(int doctorId) {
        Double r = jdbc.queryForObject(
            "SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE doctor_id=? AND payment_status IN ('confirmed','paid') " +
            "AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())",
            Double.class, doctorId);
        return r != null ? r : 0.0;
    }

    public int countUnreadFeedback() {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM feedback", Integer.class);
        return c != null ? c : 0;
    }

    private RowMapper<Bill> billMapper() {
        return (rs, i) -> {
            Bill b = new Bill();
            b.setId(rs.getInt("id"));
            b.setAppointmentId(rs.getInt("appointment_id"));
            b.setPatientId(rs.getInt("patient_id"));
            b.setDoctorId(rs.getInt("doctor_id"));
            b.setConsultationFee(rs.getDouble("consultation_fee"));
            b.setMedicineCharge(rs.getDouble("medicine_charge"));
            b.setOtherCharge(rs.getDouble("other_charge"));
            b.setTotalAmount(rs.getDouble("total_amount"));
            b.setPaymentStatus(rs.getString("payment_status"));
            b.setPaymentMethod(rs.getString("payment_method"));
            b.setReceiptSent(rs.getBoolean("receipt_sent"));
            b.setCreatedAt(rs.getTimestamp("created_at"));
            b.setPatientName(rs.getString("patient_name"));
            b.setPatientEmail(rs.getString("patient_email"));
            b.setDoctorName(rs.getString("doctor_name"));
            b.setDiagnosis(rs.getString("diagnosis"));
            b.setMedicines(rs.getString("medicines"));
            return b;
        };
    }
}
