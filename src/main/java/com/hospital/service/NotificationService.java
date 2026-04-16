package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class NotificationService {

    @Autowired private JdbcTemplate jdbc;

    public void create(int userId, String role, String title, String message, String type) {
        jdbc.update(
            "INSERT INTO notifications (user_id, user_role, title, message, type) VALUES (?,?,?,?,?)",
            userId, role, title, message, type);
    }

    public List<Map<String, Object>> getUnread(int userId, String role) {
        return jdbc.queryForList(
            "SELECT * FROM notifications WHERE user_id=? AND user_role=? AND is_read=0 ORDER BY created_at DESC",
            userId, role);
    }

    public List<Map<String, Object>> getAll(int userId, String role) {
        return jdbc.queryForList(
            "SELECT * FROM notifications WHERE user_id=? AND user_role=? ORDER BY created_at DESC LIMIT 20",
            userId, role);
    }

    public int countUnread(int userId, String role) {
        Integer c = jdbc.queryForObject(
            "SELECT COUNT(*) FROM notifications WHERE user_id=? AND user_role=? AND is_read=0",
            Integer.class, userId, role);
        return c != null ? c : 0;
    }

    public void markAllRead(int userId, String role) {
        jdbc.update("UPDATE notifications SET is_read=1 WHERE user_id=? AND user_role=?", userId, role);
    }

    public void markRead(int id) {
        jdbc.update("UPDATE notifications SET is_read=1 WHERE id=?", id);
    }
}
