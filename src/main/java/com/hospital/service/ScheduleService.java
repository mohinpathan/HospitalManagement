package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.*;

@Service
public class ScheduleService {

    @Autowired private JdbcTemplate jdbc;

    public List<Map<String, Object>> getByDoctor(int doctorId) {
        try {
            return jdbc.queryForList(
                "SELECT * FROM doctor_schedules WHERE doctor_id=? ORDER BY FIELD(day_of_week," +
                "'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')", doctorId);
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public List<Map<String, Object>> getAllSchedules() {
        try {
            return jdbc.queryForList(
                "SELECT ds.*, d.full_name AS doctor_name, dep.name AS dept_name " +
                "FROM doctor_schedules ds " +
                "JOIN doctors d ON ds.doctor_id = d.id " +
                "LEFT JOIN departments dep ON d.department_id = dep.id " +
                "ORDER BY d.full_name, FIELD(ds.day_of_week," +
                "'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')");
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public void save(int doctorId, String dayOfWeek, String startTime, String endTime) {
        jdbc.update(
            "INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time) VALUES (?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE start_time=VALUES(start_time), end_time=VALUES(end_time)",
            doctorId, dayOfWeek, startTime, endTime);
    }

    public void update(int id, int doctorId, String dayOfWeek, String startTime, String endTime) {
        jdbc.update(
            "UPDATE doctor_schedules SET day_of_week=?, start_time=?, end_time=? WHERE id=? AND doctor_id=?",
            dayOfWeek, startTime, endTime, id, doctorId);
    }

    public void delete(int id, int doctorId) {
        jdbc.update("DELETE FROM doctor_schedules WHERE id=? AND doctor_id=?", id, doctorId);
    }

    public void deleteAll(int doctorId) {
        jdbc.update("DELETE FROM doctor_schedules WHERE doctor_id=?", doctorId);
    }

    public Map<String, Object> getById(int id) {
        try {
            List<Map<String, Object>> list = jdbc.queryForList(
                "SELECT * FROM doctor_schedules WHERE id=?", id);
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) { return null; }
    }

    /** Returns available time slots for a doctor on a given date */
    public List<Map<String, Object>> getAvailableSlots(int doctorId, String date) {
        try {
            return jdbc.queryForList(
                "SELECT ds.start_time, ds.end_time FROM doctor_schedules ds " +
                "WHERE ds.doctor_id=? AND ds.day_of_week = DAYNAME(?)", doctorId, date);
        } catch (Exception e) { return new ArrayList<>(); }
    }

    /**
     * Generate 30-minute time slots for a doctor on a date.
     * Each slot has: time, status (available/booked/other), patientName
     */
    public List<Map<String, Object>> generateSlots(int doctorId, String date, int currentPatientId) {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            // Get schedule for this day
            List<Map<String, Object>> schedules = jdbc.queryForList(
                "SELECT start_time, end_time FROM doctor_schedules WHERE doctor_id=? AND day_of_week=DAYNAME(?)",
                doctorId, date);

            if (schedules.isEmpty()) return result;

            // Get all appointments for this doctor on this date
            List<Map<String, Object>> appointments = jdbc.queryForList(
                "SELECT a.appointment_time, a.patient_id, a.status, p.full_name AS patient_name " +
                "FROM appointments a JOIN patients p ON a.patient_id=p.id " +
                "WHERE a.doctor_id=? AND a.appointment_date=? AND a.status NOT IN ('cancelled','rejected')",
                doctorId, date);

            // Build booked map: time -> appointment info
            Map<String, Map<String, Object>> bookedMap = new LinkedHashMap<>();
            for (Map<String, Object> appt : appointments) {
                String t = appt.get("appointment_time").toString().substring(0, 5); // HH:mm
                bookedMap.put(t, appt);
            }

            // Generate 30-min slots for each schedule block
            for (Map<String, Object> sched : schedules) {
                LocalTime start = LocalTime.parse(sched.get("start_time").toString().substring(0, 5));
                LocalTime end   = LocalTime.parse(sched.get("end_time").toString().substring(0, 5));

                LocalTime current = start;
                while (current.isBefore(end)) {
                    String timeStr = current.toString().substring(0, 5);
                    Map<String, Object> slot = new LinkedHashMap<>();
                    slot.put("time", timeStr);

                    if (bookedMap.containsKey(timeStr)) {
                        Map<String, Object> appt = bookedMap.get(timeStr);
                        int pid = ((Number) appt.get("patient_id")).intValue();
                        if (pid == currentPatientId) {
                            slot.put("status", "mine");       // green — booked by current patient
                        } else {
                            slot.put("status", "taken");      // red — booked by another patient
                        }
                        slot.put("patientName", appt.get("patient_name"));
                        slot.put("patientId",   pid);
                    } else {
                        slot.put("status", "available");      // white/gray — free
                        slot.put("patientName", null);
                    }

                    result.add(slot);
                    current = current.plusMinutes(30);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean isAvailable(int doctorId, String date) {
        try {
            Integer c = jdbc.queryForObject(
                "SELECT COUNT(*) FROM doctor_schedules WHERE doctor_id=? AND day_of_week=DAYNAME(?)",
                Integer.class, doctorId, date);
            return c != null && c > 0;
        } catch (Exception e) { return false; }
    }
}
