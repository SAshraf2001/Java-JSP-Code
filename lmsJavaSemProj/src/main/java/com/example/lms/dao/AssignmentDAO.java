package com.example.lms.dao;

import com.example.lms.model.Assignment;
import com.example.lms.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAO {

    public void create(Assignment assignment) throws SQLException {
        String sql = "INSERT INTO assignments (course_id, title, description, due_date, max_score) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, assignment.getCourseId());
            stmt.setString(2, assignment.getTitle());
            stmt.setString(3, assignment.getDescription());
            if (assignment.getDueDate() != null) {
                stmt.setDate(4, Date.valueOf(assignment.getDueDate()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }
            stmt.setInt(5, assignment.getMaxScore());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    assignment.setAssignmentId(rs.getInt(1));
                }
            }
        }
    }

    public List<Assignment> findByCourseId(int courseId) throws SQLException {
        String sql = "SELECT * FROM assignments WHERE course_id = ? ORDER BY due_date ASC";
        List<Assignment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Assignment a = new Assignment();
                    a.setAssignmentId(rs.getInt("assignment_id"));
                    a.setCourseId(rs.getInt("course_id"));
                    a.setTitle(rs.getString("title"));
                    a.setDescription(rs.getString("description"));
                    Date d = rs.getDate("due_date");
                    if (d != null) {
                        a.setDueDate(d.toLocalDate());
                    }
                    a.setMaxScore(rs.getInt("max_score"));
                    list.add(a);
                }
            }
        }
        return list;
    }
}
