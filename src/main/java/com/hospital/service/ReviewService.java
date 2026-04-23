package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ReviewService {

    @Autowired private JdbcTemplate jdbc;

    public void addReview(int patientId, int doctorId, int appointmentId, int rating, String comment) {
        try {
            jdbc.update(
                "INSERT INTO reviews (patient_id, doctor_id, appointment_id, rating, comment) VALUES (?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE rating=VALUES(rating), comment=VALUES(comment)",
                patientId, doctorId, appointmentId, rating, comment);
        } catch (Exception e) { /* reviews table may not exist yet */ }
    }

    public List<Map<String, Object>> getByDoctor(int doctorId) {
        try {
            return jdbc.queryForList(
                "SELECT r.*, p.full_name AS patient_name FROM reviews r " +
                "JOIN patients p ON r.patient_id=p.id WHERE r.doctor_id=? ORDER BY r.created_at DESC",
                doctorId);
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public double getAvgRating(int doctorId) {
        try {
            Double avg = jdbc.queryForObject(
                "SELECT AVG(rating) FROM reviews WHERE doctor_id=?", Double.class, doctorId);
            return avg != null ? Math.round(avg * 10.0) / 10.0 : 0.0;
        } catch (Exception e) { return 0.0; }
    }

    public int getReviewCount(int doctorId) {
        try {
            Integer c = jdbc.queryForObject(
                "SELECT COUNT(*) FROM reviews WHERE doctor_id=?", Integer.class, doctorId);
            return c != null ? c : 0;
        } catch (Exception e) { return 0; }
    }

    public boolean hasReviewed(int patientId, int appointmentId) {
        try {
            Integer c = jdbc.queryForObject(
                "SELECT COUNT(*) FROM reviews WHERE patient_id=? AND appointment_id=?",
                Integer.class, patientId, appointmentId);
            return c != null && c > 0;
        } catch (Exception e) { return false; }
    }

    public List<Map<String, Object>> getTopDoctors(int limit) {
        try {
            return jdbc.queryForList(
                "SELECT d.id, d.full_name, d.specialization, dep.name AS dept_name, " +
                "AVG(r.rating) AS avg_rating, COUNT(r.id) AS review_count " +
                "FROM doctors d LEFT JOIN reviews r ON d.id=r.doctor_id " +
                "LEFT JOIN departments dep ON d.department_id=dep.id " +
                "WHERE d.status='active' GROUP BY d.id ORDER BY avg_rating DESC LIMIT ?", limit);
        } catch (Exception e) { return new ArrayList<>(); }
    }
}
