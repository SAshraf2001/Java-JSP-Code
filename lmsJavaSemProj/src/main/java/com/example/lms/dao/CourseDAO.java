package com.example.lms.dao;

import com.example.lms.model.Course;
import com.example.lms.model.CourseStatus;
import com.example.lms.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    private static final String INSERT_COURSE = "INSERT INTO courses (instructor_id, title, description, enrollment_key, status) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_BY_INSTRUCTOR = "SELECT * FROM courses WHERE instructor_id = ?";
    private static final String SELECT_PUBLISHED = "SELECT * FROM courses WHERE status = 'Published'";
    private static final String SELECT_BY_ID = "SELECT * FROM courses WHERE course_id = ?";
    private static final String UPDATE_STATUS = "UPDATE courses SET status = ? WHERE course_id = ?";

    public void create(Course course) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_COURSE, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, course.getInstructorId());
            stmt.setString(2, course.getTitle());
            stmt.setString(3, course.getDescription());
            stmt.setString(4, course.getEnrollmentKey());
            stmt.setString(5, course.getStatus().name());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    course.setCourseId(rs.getInt(1));
                }
            }
        }
    }

    public List<Course> findAllByInstructorId(int instructorId) throws SQLException {
        List<Course> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_INSTRUCTOR)) {
            stmt.setInt(1, instructorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<Course> findAllPublished() throws SQLException {
        List<Course> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_PUBLISHED);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Course findById(int courseId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)) {
            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public void updateStatus(int courseId, CourseStatus status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_STATUS)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, courseId);
            stmt.executeUpdate();
        }
    }

    private Course mapRow(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setInstructorId(rs.getInt("instructor_id"));
        course.setTitle(rs.getString("title"));
        course.setDescription(rs.getString("description"));
        course.setEnrollmentKey(rs.getString("enrollment_key"));
        course.setStatus(CourseStatus.valueOf(rs.getString("status")));
        return course;
    }
}
