package com.example.lms.dao;

import com.example.lms.model.AssignmentSubmission;
import com.example.lms.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AssignmentSubmissionDAO {

    public void submit(AssignmentSubmission submission) throws SQLException {
        // We use ON DUPLICATE KEY UPDATE so students can resubmit if they want, up to the instructor to enforce due dates.
        String sql = "INSERT INTO assignment_submissions (assignment_id, student_id, file_path) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE file_path = VALUES(file_path), submitted_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, submission.getAssignmentId());
            stmt.setInt(2, submission.getStudentId());
            stmt.setString(3, submission.getFilePath()); // This is just the URL/text link
            stmt.executeUpdate();
        }
    }

    public void gradeSubmission(int submissionId, int score, String feedback) throws SQLException {
        String sql = "UPDATE assignment_submissions SET score = ?, feedback = ? WHERE submission_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, score);
            stmt.setString(2, feedback);
            stmt.setInt(3, submissionId);
            stmt.executeUpdate();
        }
    }

    public List<AssignmentSubmission> findByAssignmentId(int assignmentId) throws SQLException {
        String sql = "SELECT * FROM assignment_submissions WHERE assignment_id = ?";
        List<AssignmentSubmission> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AssignmentSubmission sub = new AssignmentSubmission();
                    sub.setSubmissionId(rs.getInt("submission_id"));
                    sub.setAssignmentId(rs.getInt("assignment_id"));
                    sub.setStudentId(rs.getInt("student_id"));
                    sub.setFilePath(rs.getString("file_path"));
                    if (rs.getObject("score") != null) {
                        sub.setScore(rs.getInt("score"));
                    }
                    sub.setFeedback(rs.getString("feedback"));
                    list.add(sub);
                }
            }
        }
        return list;
    }

    public AssignmentSubmission findByAssignmentAndStudent(int assignmentId, int studentId) throws SQLException {
        String sql = "SELECT * FROM assignment_submissions WHERE assignment_id = ? AND student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    AssignmentSubmission sub = new AssignmentSubmission();
                    sub.setSubmissionId(rs.getInt("submission_id"));
                    sub.setAssignmentId(rs.getInt("assignment_id"));
                    sub.setStudentId(rs.getInt("student_id"));
                    sub.setFilePath(rs.getString("file_path"));
                    if (rs.getObject("score") != null) {
                        sub.setScore(rs.getInt("score"));
                    }
                    sub.setFeedback(rs.getString("feedback"));
                    return sub;
                }
            }
        }
        return null;
    }
}
