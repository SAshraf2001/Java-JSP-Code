package com.example.lms.dao;

import com.example.lms.model.Lesson;
import com.example.lms.model.ContentType;
import com.example.lms.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LessonDAO {

    public void create(Lesson lesson) throws SQLException {
        String sql = "INSERT INTO lessons (module_id, title, content, content_type, sequence_order) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, lesson.getModuleId());
            stmt.setString(2, lesson.getTitle());
            stmt.setString(3, lesson.getContent());
            stmt.setString(4, lesson.getContentType().name());
            stmt.setInt(5, lesson.getSequenceOrder());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    lesson.setLessonId(rs.getInt(1));
                }
            }
        }
    }

    public List<Lesson> findByModuleId(int moduleId) throws SQLException {
        String sql = "SELECT * FROM lessons WHERE module_id = ? ORDER BY sequence_order ASC";
        List<Lesson> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, moduleId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Lesson l = new Lesson();
                    l.setLessonId(rs.getInt("lesson_id"));
                    l.setModuleId(rs.getInt("module_id"));
                    l.setTitle(rs.getString("title"));
                    l.setContent(rs.getString("content"));
                    l.setContentType(ContentType.valueOf(rs.getString("content_type")));
                    l.setSequenceOrder(rs.getInt("sequence_order"));
                    list.add(l);
                }
            }
        }
        return list;
    }
}
