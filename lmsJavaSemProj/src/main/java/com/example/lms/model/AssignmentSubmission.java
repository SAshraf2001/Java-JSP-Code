package com.example.lms.model;

public class AssignmentSubmission {
    private int submissionId;
    private int assignmentId;
    private int studentId;
    private String filePath;
    private Integer score; // nullable
    private String feedback;

    public AssignmentSubmission() {}

    public AssignmentSubmission(int submissionId, int assignmentId, int studentId, String filePath, Integer score, String feedback) {
        this.submissionId = submissionId;
        this.assignmentId = assignmentId;
        this.studentId = studentId;
        this.filePath = filePath;
        this.score = score;
        this.feedback = feedback;
    }

    // Getters and Setters
    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }
    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
}
