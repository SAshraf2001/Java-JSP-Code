package com.example.lms.model;

public class Lesson {
    private int lessonId;
    private int moduleId;
    private String title;
    private String content;
    private ContentType contentType;
    private int sequenceOrder;

    public Lesson() {}

    public Lesson(int lessonId, int moduleId, String title, String content, ContentType contentType, int sequenceOrder) {
        this.lessonId = lessonId;
        this.moduleId = moduleId;
        this.title = title;
        this.content = content;
        this.contentType = contentType;
        this.sequenceOrder = sequenceOrder;
    }

    // Getters and Setters
    public int getLessonId() { return lessonId; }
    public void setLessonId(int lessonId) { this.lessonId = lessonId; }
    public int getModuleId() { return moduleId; }
    public void setModuleId(int moduleId) { this.moduleId = moduleId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public ContentType getContentType() { return contentType; }
    public void setContentType(ContentType contentType) { this.contentType = contentType; }
    public int getSequenceOrder() { return sequenceOrder; }
    public void setSequenceOrder(int sequenceOrder) { this.sequenceOrder = sequenceOrder; }
}
