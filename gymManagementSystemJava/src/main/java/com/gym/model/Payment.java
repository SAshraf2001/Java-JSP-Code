package com.gym.model;

import java.sql.Timestamp;

public class Payment {
    private int paymentID;
    private int subID;
    private double amount;
    private Timestamp paymentDate;
    private String paymentMethod;
    
    // Transient fields for display
    private String planName;

    public Payment() {}

    public int getPaymentID() { return paymentID; }
    public void setPaymentID(int paymentID) { this.paymentID = paymentID; }
    public int getSubID() { return subID; }
    public void setSubID(int subID) { this.subID = subID; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
}
