package com.hospital.service;

import com.hospital.model.Appointment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AppointmentService {

    @Autowired private JdbcTemplate jdbc;

    private static final String BASE_SELECT =
        "SELECT a.*, p.full_name AS patient_name, d.full_name AS doctor_name, dep.name AS dept_name " +
        "FROM appointments a " +
        "JOIN patients p    ON a.patient_id    = p.id " +
        "JOIN doctors d     ON a.doctor_id     = d.id " +
        "LEFT JOIN departments dep ON a.department_id = dep.id ";

    public void book(Appointment a) {
        jdbc.update(
            "INSERT INTO appointments (patient_id,doctor_id,department_id,appointment_date,appointment_time,reason) VALUES (?,?,?,?,?,?)",
            a.getPatientId(), a.getDoctorId(), a.getDepartmentId(),
            a.getAppointmentDate(), a.getAppointmentTime(), a.getReason());
    }

    public List<Appointment> getByPatient(int patientId) {
        return jdbc.query(BASE_SELECT + "WHERE a.patient_id=? ORDER BY a.appointment_date DESC", mapper(), patientId);
    }

    public List<Appointment> getByDoctor(int doctorId) {
        return jdbc.query(BASE_SELECT + "WHERE a.doctor_id=? ORDER BY a.appointment_date DESC", mapper(), doctorId);
    }

    public List<Appointment> getAll() {
        return jdbc.query(BASE_SELECT + "ORDER BY a.appointment_date DESC", mapper());
    }

    public List<Appointment> getPending() {
        return jdbc.query(BASE_SELECT + "WHERE a.status='pending' ORDER BY a.appointment_date", mapper());
    }

    public void updateStatus(int id, String status) {
        jdbc.update("UPDATE appointments SET status=? WHERE id=?", status, id);
    }

    public void delete(int id) {
        jdbc.update("DELETE FROM appointments WHERE id=?", id);
    }

    // counts
    public int countByPatient(int patientId) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM appointments WHERE patient_id=?", Integer.class, patientId);
    }
    public int countByPatientAndStatus(int patientId, String status) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM appointments WHERE patient_id=? AND status=?", Integer.class, patientId, status);
    }
    public int countByDoctor(int doctorId) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM appointments WHERE doctor_id=?", Integer.class, doctorId);
    }
    public int countByDoctorAndStatus(int doctorId, String status) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND status=?", Integer.class, doctorId, status);
    }
    public int countByDoctorToday(int doctorId) {
        return jdbc.queryForObject(
            "SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND appointment_date=CURDATE()", Integer.class, doctorId);
    }
    public int countAll() {
        return jdbc.queryForObject("SELECT COUNT(*) FROM appointments", Integer.class);
    }

    private RowMapper<Appointment> mapper() {
        return (rs, i) -> {
            Appointment a = new Appointment();
            a.setId(rs.getInt("id"));
            a.setPatientId(rs.getInt("patient_id"));
            a.setDoctorId(rs.getInt("doctor_id"));
            a.setDepartmentId(rs.getInt("department_id"));
            a.setAppointmentDate(rs.getDate("appointment_date"));
            a.setAppointmentTime(rs.getTime("appointment_time"));
            a.setReason(rs.getString("reason"));
            a.setStatus(rs.getString("status"));
            a.setNotes(rs.getString("notes"));
            a.setPatientName(rs.getString("patient_name"));
            a.setDoctorName(rs.getString("doctor_name"));
            a.setDepartmentName(rs.getString("dept_name"));
            return a;
        };
    }
}
