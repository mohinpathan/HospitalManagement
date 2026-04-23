package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class NotificationService {

    @Autowired private JdbcTemplate jdbc;

    public void create(int userId, String role, String title, String message, String type) {
        try {
            jdbc.update(
                "INSERT INTO notifications (user_id, user_role, title, message, type) VALUES (?,?,?,?,?)",
                userId, role, title, message, type);
        } catch (Exception e) {
            // notifications table may not exist yet — silently ignore
        }
    }

    public List<Map<String, Object>> getUnread(int userId, String role) {
        try {
            return jdbc.queryForList(
                "SELECT * FROM notifications WHERE user_id=? AND user_role=? AND is_read=0 ORDER BY created_at DESC",
                userId, role);
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public List<Map<String, Object>> getAll(int userId, String role) {
        try {
            return jdbc.queryForList(
                "SELECT * FROM notifications WHERE user_id=? AND user_role=? ORDER BY created_at DESC LIMIT 20",
                userId, role);
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public int countUnread(int userId, String role) {
        try {
            Integer c = jdbc.queryForObject(
                "SELECT COUNT(*) FROM notifications WHERE user_id=? AND user_role=? AND is_read=0",
                Integer.class, userId, role);
            return c != null ? c : 0;
        } catch (Exception e) { return 0; }
    }

    public void markAllRead(int userId, String role) {
        try {
            jdbc.update("UPDATE notifications SET is_read=1 WHERE user_id=? AND user_role=?", userId, role);
        } catch (Exception e) { /* ignore */ }
    }

    public void markRead(int id) {
        try {
            jdbc.update("UPDATE notifications SET is_read=1 WHERE id=?", id);
        } catch (Exception e) { /* ignore */ }
    }
}
