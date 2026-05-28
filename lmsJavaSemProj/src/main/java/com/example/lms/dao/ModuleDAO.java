package com.example.lms.dao;

import com.example.lms.model.Module;
import com.example.lms.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ModuleDAO {

    public void create(Module module) throws SQLException {
        String sql = "INSERT INTO modules (course_id, title, sequence_order) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, module.getCourseId());
            stmt.setString(2, module.getTitle());
            stmt.setInt(3, module.getSequenceOrder());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    module.setModuleId(rs.getInt(1));
                }
            }
        }
    }

    public List<Module> findByCourseId(int courseId) throws SQLException {
        String sql = "SELECT * FROM modules WHERE course_id = ? ORDER BY sequence_order ASC";
        List<Module> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Module m = new Module();
                    m.setModuleId(rs.getInt("module_id"));
                    m.setCourseId(rs.getInt("course_id"));
                    m.setTitle(rs.getString("title"));
                    m.setSequenceOrder(rs.getInt("sequence_order"));
                    list.add(m);
                }
            }
        }
        return list;
    }
}
