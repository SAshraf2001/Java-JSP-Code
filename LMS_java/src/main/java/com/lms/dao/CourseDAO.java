package com.lms.dao;

import com.lms.database.DBConnection;
import com.lms.model.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Course-related database operations.
 */
public class CourseDAO {

    /**
     * Retrieves all courses a student is enrolled in.
     * Joins courses, enrollments, and users to present instructor details.
     *
     * @param studentId ID of the student
     * @return List of Course objects the student is enrolled in
     */
    public List<Course> getStudentCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.id, c.title, c.description, c.instructor_id, u.name AS instructor_name, c.created_at " +
                     "FROM courses c " +
                     "JOIN enrollments e ON c.id = e.course_id " +
                     "JOIN users u ON c.instructor_id = u.id " +
                     "WHERE e.student_id = ? " +
                     "ORDER BY c.title ASC";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getInt("instructor_id"),
                    rs.getString("instructor_name"),
                    rs.getTimestamp("created_at")
                );
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching enrolled courses for student: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rs, pstmt, conn);
        }

        return courses;
    }

    /**
     * Retrieves all courses existing in the platform database with instructor details.
     *
     * @return List of all Course objects
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.id, c.title, c.description, c.instructor_id, u.name AS instructor_name, c.created_at " +
                     "FROM courses c " +
                     "JOIN users u ON c.instructor_id = u.id " +
                     "ORDER BY c.title ASC";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getInt("instructor_id"),
                    rs.getString("instructor_name"),
                    rs.getTimestamp("created_at")
                );
                courses.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all courses: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rs, pstmt, conn);
        }

        return courses;
    }
}
