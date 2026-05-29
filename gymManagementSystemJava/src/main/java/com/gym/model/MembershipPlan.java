package com.gym.model;

public class MembershipPlan {
    private int planID;
    private String planName;
    private int durationMonths;
    private double price;
    private String description;

    public MembershipPlan() {}

    public MembershipPlan(int planID, String planName, int durationMonths, double price, String description) {
        this.planID = planID;
        this.planName = planName;
        this.durationMonths = durationMonths;
        this.price = price;
        this.description = description;
    }

    // Getters and Setters
    public int getPlanID() { return planID; }
    public void setPlanID(int planID) { this.planID = planID; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public int getDurationMonths() { return durationMonths; }
    public void setDurationMonths(int durationMonths) { this.durationMonths = durationMonths; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
