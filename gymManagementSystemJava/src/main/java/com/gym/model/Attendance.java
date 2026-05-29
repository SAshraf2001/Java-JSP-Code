package com.gym.model;

import java.sql.Timestamp;

public class Attendance {
    private int attendanceID;
    private int userID;
    private Timestamp checkInTime;

    // Transient
    private String userName;

    public Attendance() {}

    public int getAttendanceID() { return attendanceID; }
    public void setAttendanceID(int attendanceID) { this.attendanceID = attendanceID; }
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    public Timestamp getCheckInTime() { return checkInTime; }
    public void setCheckInTime(Timestamp checkInTime) { this.checkInTime = checkInTime; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
