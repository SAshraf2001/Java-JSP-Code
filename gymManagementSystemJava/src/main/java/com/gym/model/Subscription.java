package com.gym.model;

import java.sql.Date;

public class Subscription {
    private int subID;
    private int userID;
    private int planID;
    private Date startDate;
    private Date endDate;
    private String status;

    // Transient fields for display purposes
    private String userName;
    private String planName;
    private double price;

    public Subscription() {}

    // Getters and Setters
    public int getSubID() { return subID; }
    public void setSubID(int subID) { this.subID = subID; }
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    public int getPlanID() { return planID; }
    public void setPlanID(int planID) { this.planID = planID; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
