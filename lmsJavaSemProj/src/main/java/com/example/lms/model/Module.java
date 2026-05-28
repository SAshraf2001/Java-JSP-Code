package com.example.lms.model;

public class Module {
    private int moduleId;
    private int courseId;
    private String title;
    private int sequenceOrder;

    public Module() {}

    public Module(int moduleId, int courseId, String title, int sequenceOrder) {
        this.moduleId = moduleId;
        this.courseId = courseId;
        this.title = title;
        this.sequenceOrder = sequenceOrder;
    }

    // Getters and Setters
    public int getModuleId() { return moduleId; }
    public void setModuleId(int moduleId) { this.moduleId = moduleId; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public int getSequenceOrder() { return sequenceOrder; }
    public void setSequenceOrder(int sequenceOrder) { this.sequenceOrder = sequenceOrder; }
}
