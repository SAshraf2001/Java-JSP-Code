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

public class EnrollmentDAO {

    public void enrollStudent(int studentId, int courseId) throws SQLException {
        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            stmt.executeUpdate();
        }
    }

    public List<Course> findEnrolledCourses(int studentId) throws SQLException {
        String sql = "SELECT c.* FROM courses c JOIN enrollments e ON c.course_id = e.course_id WHERE e.student_id = ?";
        List<Course> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseId(rs.getInt("course_id"));
                    course.setInstructorId(rs.getInt("instructor_id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setEnrollmentKey(rs.getString("enrollment_key"));
                    course.setStatus(CourseStatus.valueOf(rs.getString("status")));
                    list.add(course);
                }
            }
        }
        return list;
    }
}
