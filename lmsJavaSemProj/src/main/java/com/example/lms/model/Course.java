package com.example.lms.model;

public class Course {
    private int courseId;
    private int instructorId;
    private String title;
    private String description;
    private String enrollmentKey;
    private CourseStatus status;

    public Course() {}

    public Course(int courseId, int instructorId, String title, String description, String enrollmentKey, CourseStatus status) {
        this.courseId = courseId;
        this.instructorId = instructorId;
        this.title = title;
        this.description = description;
        this.enrollmentKey = enrollmentKey;
        this.status = status;
    }

    // Getters and Setters
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public int getInstructorId() { return instructorId; }
    public void setInstructorId(int instructorId) { this.instructorId = instructorId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getEnrollmentKey() { return enrollmentKey; }
    public void setEnrollmentKey(String enrollmentKey) { this.enrollmentKey = enrollmentKey; }
    public CourseStatus getStatus() { return status; }
    public void setStatus(CourseStatus status) { this.status = status; }
}
