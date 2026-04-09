package com.hospital.service;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired private JdbcTemplate jdbc;

    // ── Register ─────────────────────────────────────────────
    public void registerPatient(Patient p) {
        jdbc.update("INSERT INTO patients (full_name,email,phone,password,gender,age,blood_group,address) VALUES (?,?,?,?,?,?,?,?)",
            p.getFullName(), p.getEmail(), p.getPhone(), p.getPassword(),
            p.getGender(), p.getAge(), p.getBloodGroup(), p.getAddress());
    }

    public void registerDoctor(Doctor d) {
        jdbc.update("INSERT INTO doctors (full_name,email,phone,password,gender,qualification,specialization,department_id,experience_yrs,consultation_fee,address) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
            d.getFullName(), d.getEmail(), d.getPhone(), d.getPassword(),
            d.getGender(), d.getQualification(), d.getSpecialization(),
            d.getDepartmentId(), d.getExperienceYrs(), d.getConsultationFee(), d.getAddress());
    }

    public void registerAdmin(Admin a) {
        jdbc.update("INSERT INTO admins (full_name,email,phone,password) VALUES (?,?,?,?)",
            a.getFullName(), a.getEmail(), a.getPhone(), a.getPassword());
    }

    // ── Find by email ─────────────────────────────────────────
    public Patient findPatientByEmail(String email) {
        List<Patient> l = jdbc.query("SELECT * FROM patients WHERE email=? AND status='active'", patientMapper(), email);
        return l.isEmpty() ? null : l.get(0);
    }

    public Doctor findDoctorByEmail(String email) {
        List<Doctor> l = jdbc.query(
            "SELECT d.*, dep.name AS dept_name FROM doctors d LEFT JOIN departments dep ON d.department_id=dep.id WHERE d.email=? AND d.status='active'",
            doctorMapper(), email);
        return l.isEmpty() ? null : l.get(0);
    }

    public Admin findAdminByEmail(String email) {
        List<Admin> l = jdbc.query("SELECT * FROM admins WHERE email=?", adminMapper(), email);
        return l.isEmpty() ? null : l.get(0);
    }

    // ── Find by ID ────────────────────────────────────────────
    public Patient getPatientById(int id) {
        List<Patient> l = jdbc.query("SELECT * FROM patients WHERE id=?", patientMapper(), id);
        return l.isEmpty() ? null : l.get(0);
    }

    public Doctor getDoctorById(int id) {
        List<Doctor> l = jdbc.query(
            "SELECT d.*, dep.name AS dept_name FROM doctors d LEFT JOIN departments dep ON d.department_id=dep.id WHERE d.id=?",
            doctorMapper(), id);
        return l.isEmpty() ? null : l.get(0);
    }

    public Admin getAdminById(int id) {
        List<Admin> l = jdbc.query("SELECT * FROM admins WHERE id=?", adminMapper(), id);
        return l.isEmpty() ? null : l.get(0);
    }

    // ── All lists ─────────────────────────────────────────────
    public List<Patient> getAllPatients() {
        return jdbc.query("SELECT * FROM patients ORDER BY created_at DESC", patientMapper());
    }

    public List<Doctor> getAllDoctors() {
        return jdbc.query(
            "SELECT d.*, dep.name AS dept_name FROM doctors d LEFT JOIN departments dep ON d.department_id=dep.id WHERE d.status='active' ORDER BY d.full_name",
            doctorMapper());
    }

    public List<Doctor> getDoctorsByDept(int deptId) {
        return jdbc.query(
            "SELECT d.*, dep.name AS dept_name FROM doctors d LEFT JOIN departments dep ON d.department_id=dep.id WHERE d.department_id=? AND d.status='active'",
            doctorMapper(), deptId);
    }

    public List<Doctor> searchDoctors(int deptId, String search, double maxFee, String sort) {
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, dep.name AS dept_name FROM doctors d LEFT JOIN departments dep ON d.department_id=dep.id WHERE d.status='active'");
        List<Object> params = new java.util.ArrayList<>();
        if (deptId > 0) { sql.append(" AND d.department_id=?"); params.add(deptId); }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (d.full_name LIKE ? OR d.specialization LIKE ? OR dep.name LIKE ?)");
            String like = "%" + search.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (maxFee > 0) { sql.append(" AND d.consultation_fee <= ?"); params.add(maxFee); }
        if ("fee_asc".equals(sort))  sql.append(" ORDER BY d.consultation_fee ASC");
        else if ("fee_desc".equals(sort)) sql.append(" ORDER BY d.consultation_fee DESC");
        else if ("exp_desc".equals(sort)) sql.append(" ORDER BY d.experience_yrs DESC");
        else sql.append(" ORDER BY d.full_name ASC");
        return jdbc.query(sql.toString(), doctorMapper(), params.toArray());
    }

    // ── Update Patient ────────────────────────────────────────
    public void updatePatient(int id, String name, String phone, String bloodGroup, String address) {
        jdbc.update("UPDATE patients SET full_name=?,phone=?,blood_group=?,address=? WHERE id=?",
            name, phone, bloodGroup, address, id);
    }

    public void updatePatientFull(int id, String name, String phone, String bloodGroup, String address, int age) {
        jdbc.update("UPDATE patients SET full_name=?,phone=?,blood_group=?,address=?,age=? WHERE id=?",
            name, phone, bloodGroup, address, age, id);
    }

    public void deletePatient(int id) {
        jdbc.update("UPDATE patients SET status='inactive' WHERE id=?", id);
    }

    // ── Update Doctor ─────────────────────────────────────────
    public void updateDoctor(int id, String name, String phone, String address) {
        jdbc.update("UPDATE doctors SET full_name=?,phone=?,address=? WHERE id=?", name, phone, address, id);
    }

    public void updateDoctorFull(int id, String name, String phone, String gender,
            String qualification, String specialization, int deptId, int expYrs, double fee, String address) {
        jdbc.update("UPDATE doctors SET full_name=?,phone=?,gender=?,qualification=?,specialization=?,department_id=?,experience_yrs=?,consultation_fee=?,address=? WHERE id=?",
            name, phone, gender, qualification, specialization, deptId, expYrs, fee, address, id);
    }

    public void deleteDoctor(int id) {
        jdbc.update("UPDATE doctors SET status='inactive' WHERE id=?", id);
    }

    // ── Update Admin ──────────────────────────────────────────
    public void updateAdmin(int id, String name, String phone) {
        jdbc.update("UPDATE admins SET full_name=?,phone=? WHERE id=?", name, phone, id);
    }

    // ── OTP & Password ────────────────────────────────────────
    public boolean emailExists(String email, String role) {
        Integer c = jdbc.queryForObject("SELECT COUNT(*) FROM " + tableFor(role) + " WHERE email=?", Integer.class, email);
        return c != null && c > 0;
    }

    public void saveOtp(String email, String role, String otp) {
        jdbc.update("UPDATE " + tableFor(role) + " SET otp=?, otp_expiry=DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE email=?", otp, email);
    }

    public boolean verifyOtp(String email, String role, String otp) {
        List<String> r = jdbc.query(
            "SELECT otp FROM " + tableFor(role) + " WHERE email=? AND otp=? AND otp_expiry > NOW()",
            (rs, i) -> rs.getString("otp"), email, otp);
        return !r.isEmpty();
    }

    public void updatePassword(String email, String role, String hashed) {
        jdbc.update("UPDATE " + tableFor(role) + " SET password=?,otp=NULL,otp_expiry=NULL WHERE email=?", hashed, email);
    }

    // ── Helpers ───────────────────────────────────────────────
    private String tableFor(String role) {
        return switch (role) {
            case "patient" -> "patients";
            case "doctor"  -> "doctors";
            case "admin"   -> "admins";
            default -> throw new IllegalArgumentException("Unknown role: " + role);
        };
    }

    private RowMapper<Patient> patientMapper() {
        return (rs, i) -> {
            Patient p = new Patient();
            p.setId(rs.getInt("id")); p.setFullName(rs.getString("full_name"));
            p.setEmail(rs.getString("email")); p.setPhone(rs.getString("phone"));
            p.setPassword(rs.getString("password")); p.setGender(rs.getString("gender"));
            p.setAge(rs.getInt("age")); p.setBloodGroup(rs.getString("blood_group"));
            p.setAddress(rs.getString("address")); p.setStatus(rs.getString("status"));
            return p;
        };
    }

    private RowMapper<Doctor> doctorMapper() {
        return (rs, i) -> {
            Doctor d = new Doctor();
            d.setId(rs.getInt("id")); d.setFullName(rs.getString("full_name"));
            d.setEmail(rs.getString("email")); d.setPhone(rs.getString("phone"));
            d.setPassword(rs.getString("password")); d.setGender(rs.getString("gender"));
            d.setQualification(rs.getString("qualification")); d.setSpecialization(rs.getString("specialization"));
            d.setDepartmentId(rs.getInt("department_id")); d.setDepartmentName(rs.getString("dept_name"));
            d.setExperienceYrs(rs.getInt("experience_yrs")); d.setConsultationFee(rs.getDouble("consultation_fee"));
            d.setAddress(rs.getString("address")); d.setStatus(rs.getString("status"));
            return d;
        };
    }

    private RowMapper<Admin> adminMapper() {
        return (rs, i) -> {
            Admin a = new Admin();
            a.setId(rs.getInt("id")); a.setFullName(rs.getString("full_name"));
            a.setEmail(rs.getString("email")); a.setPhone(rs.getString("phone"));
            a.setPassword(rs.getString("password"));
            return a;
        };
    }
}
