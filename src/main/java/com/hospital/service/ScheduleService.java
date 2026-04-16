package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ScheduleService {

    @Autowired private JdbcTemplate jdbc;

    public List<Map<String, Object>> getByDoctor(int doctorId) {
        return jdbc.queryForList(
            "SELECT * FROM doctor_schedules WHERE doctor_id=? ORDER BY FIELD(day_of_week," +
            "'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')", doctorId);
    }

    public void save(int doctorId, String dayOfWeek, String startTime, String endTime) {
        jdbc.update(
            "INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time) VALUES (?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE start_time=VALUES(start_time), end_time=VALUES(end_time)",
            doctorId, dayOfWeek, startTime, endTime);
    }

    public void delete(int id, int doctorId) {
        jdbc.update("DELETE FROM doctor_schedules WHERE id=? AND doctor_id=?", id, doctorId);
    }

    public void deleteAll(int doctorId) {
        jdbc.update("DELETE FROM doctor_schedules WHERE doctor_id=?", doctorId);
    }

    /** Returns available time slots for a doctor on a given date */
    public List<Map<String, Object>> getAvailableSlots(int doctorId, String date) {
        // Get day of week from date
        return jdbc.queryForList(
            "SELECT ds.start_time, ds.end_time FROM doctor_schedules ds " +
            "WHERE ds.doctor_id=? AND ds.day_of_week = DAYNAME(?)", doctorId, date);
    }

    /** Check if doctor works on a given day */
    public boolean isAvailable(int doctorId, String date) {
        Integer c = jdbc.queryForObject(
            "SELECT COUNT(*) FROM doctor_schedules WHERE doctor_id=? AND day_of_week=DAYNAME(?)",
            Integer.class, doctorId, date);
        return c != null && c > 0;
    }
}
