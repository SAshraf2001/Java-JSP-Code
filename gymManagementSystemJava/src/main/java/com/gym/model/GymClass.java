package com.gym.model;

import java.sql.Timestamp;

public class GymClass {
    private int classID;
    private String className;
    private String trainerName;
    private Timestamp scheduleTime;
    private int capacity;

    // Transient for UI
    private int bookedCount;

    public GymClass() {}

    public int getClassID() { return classID; }
    public void setClassID(int classID) { this.classID = classID; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getTrainerName() { return trainerName; }
    public void setTrainerName(String trainerName) { this.trainerName = trainerName; }
    public Timestamp getScheduleTime() { return scheduleTime; }
    public void setScheduleTime(Timestamp scheduleTime) { this.scheduleTime = scheduleTime; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    
    public int getBookedCount() { return bookedCount; }
    public void setBookedCount(int bookedCount) { this.bookedCount = bookedCount; }
}
