package com.gym.model;

import java.sql.Timestamp;

public class ClassBooking {
    private int bookingID;
    private int userID;
    private int classID;
    private Timestamp bookingTime;

    // Transient
    private String userName;
    private String className;
    private Timestamp classTime;

    public ClassBooking() {}

    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    public int getClassID() { return classID; }
    public void setClassID(int classID) { this.classID = classID; }
    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public Timestamp getClassTime() { return classTime; }
    public void setClassTime(Timestamp classTime) { this.classTime = classTime; }
}
