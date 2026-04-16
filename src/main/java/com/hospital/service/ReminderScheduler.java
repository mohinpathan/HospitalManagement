package com.hospital.service;

import com.hospital.util.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class ReminderScheduler {

    @Autowired private JdbcTemplate  jdbc;
    @Autowired private EmailService  emailService;

    /**
     * Runs every day at 8:00 AM.
     * Sends reminder emails for appointments scheduled for tomorrow.
     */
    @Scheduled(cron = "0 0 8 * * *")
    public void sendAppointmentReminders() {
        List<Map<String, Object>> upcoming = jdbc.queryForList(
            "SELECT a.id, a.appointment_date, a.appointment_time, a.reason, " +
            "p.full_name AS patient_name, p.email AS patient_email, " +
            "d.full_name AS doctor_name, dep.name AS dept_name " +
            "FROM appointments a " +
            "JOIN patients p    ON a.patient_id    = p.id " +
            "JOIN doctors d     ON a.doctor_id     = d.id " +
            "LEFT JOIN departments dep ON a.department_id = dep.id " +
            "WHERE a.appointment_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY) " +
            "AND a.status = 'approved'");

        for (Map<String, Object> row : upcoming) {
            String to          = (String) row.get("patient_email");
            String patientName = (String) row.get("patient_name");
            String doctorName  = (String) row.get("doctor_name");
            String dept        = (String) row.get("dept_name");
            String date        = String.valueOf(row.get("appointment_date"));
            String time        = String.valueOf(row.get("appointment_time"));
            String reason      = (String) row.get("reason");

            emailService.sendAppointmentReminder(to, patientName, doctorName, dept, date, time, reason);
            System.out.println("[Reminder] Sent to: " + to + " for " + date);
        }
    }
}
