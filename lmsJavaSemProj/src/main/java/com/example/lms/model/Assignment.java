package com.example.lms.model;

import java.time.LocalDate;

public class Assignment {
    private int assignmentId;
    private int courseId;
    private String title;
    private String instructions;
    private LocalDate dueDate;
    private int maxPoints;

    public Assignment() {}

    public Assignment(int assignmentId, int courseId, String title, String instructions, LocalDate dueDate, int maxPoints) {
        this.assignmentId = assignmentId;
        this.courseId = courseId;
        this.title = title;
        this.instructions = instructions;
        this.dueDate = dueDate;
        this.maxPoints = maxPoints;
    }

    // Getters and Setters
    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
    public int getMaxPoints() { return maxPoints; }
    public void setMaxPoints(int maxPoints) { this.maxPoints = maxPoints; }
}
