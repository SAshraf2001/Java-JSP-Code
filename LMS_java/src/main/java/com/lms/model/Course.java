package com.lms.model;

import java.sql.Timestamp;

/**
 * Plain Old Java Object (POJO) model mapping the Course schema.
 */
public class Course {
    private int id;
    private String title;
    private String description;
    private int instructorId;
    private String instructorName; // Derived field for convenience in UI layouts
    private Timestamp createdAt;

    // Default Constructor
    public Course() {}

    // Parameterized Constructor without ID, InstructorName, and Timestamp (useful for creation)
    public Course(String title, String description, int instructorId) {
        this.title = title;
        this.description = description;
        this.instructorId = instructorId;
    }

    // Constructor with full fields including instructorName
    public Course(int id, String title, String description, int instructorId, String instructorName, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.instructorId = instructorId;
        this.instructorName = instructorName;
        this.createdAt = createdAt;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", instructorId=" + instructorId +
                ", instructorName='" + instructorName + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
