package com.hospital.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DepartmentService {

    @Autowired private JdbcTemplate jdbc;

    public List<Map<String, Object>> getAll() {
        return jdbc.queryForList(
            "SELECT d.*, COUNT(doc.id) AS doctor_count " +
            "FROM departments d LEFT JOIN doctors doc ON doc.department_id = d.id " +
            "GROUP BY d.id ORDER BY d.name");
    }

    public int countAll() {
        return jdbc.queryForObject("SELECT COUNT(*) FROM departments", Integer.class);
    }

    public void add(String name, String description) {
        jdbc.update("INSERT INTO departments (name, description) VALUES (?,?)", name, description);
    }

    public void delete(int id) {
        jdbc.update("DELETE FROM departments WHERE id=?", id);
    }
}
