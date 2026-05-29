package com.gym.dao;

import com.gym.model.Subscription;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubscriptionDAO {

    public List<Subscription> getAllSubscriptions() {
        List<Subscription> subs = new ArrayList<>();
        String query = "SELECT s.*, u.name as userName, p.planName as planName, p.price as price FROM Subscription s " +
                       "JOIN User u ON s.userID = u.userID " +
                       "JOIN MembershipPlan p ON s.planID = p.planID";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subscription sub = new Subscription();
                sub.setSubID(rs.getInt("subID"));
                sub.setUserID(rs.getInt("userID"));
                sub.setPlanID(rs.getInt("planID"));
                sub.setStartDate(rs.getDate("startDate"));
                sub.setEndDate(rs.getDate("endDate"));
                sub.setStatus(rs.getString("status"));
                sub.setUserName(rs.getString("userName"));
                sub.setPlanName(rs.getString("planName"));
                sub.setPrice(rs.getDouble("price"));
                subs.add(sub);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return subs;
    }

    public Subscription getSubscriptionByUserId(int userId) {
        Subscription sub = null;
        String query = "SELECT s.*, p.planName, p.price FROM Subscription s " +
                       "JOIN MembershipPlan p ON s.planID = p.planID " +
                       "WHERE s.userID=? ORDER BY s.endDate DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    sub = new Subscription();
                    sub.setSubID(rs.getInt("subID"));
                    sub.setUserID(rs.getInt("userID"));
                    sub.setPlanID(rs.getInt("planID"));
                    sub.setStartDate(rs.getDate("startDate"));
                    sub.setEndDate(rs.getDate("endDate"));
                    sub.setStatus(rs.getString("status"));
                    sub.setPlanName(rs.getString("planName"));
                    sub.setPrice(rs.getDouble("price"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return sub;
    }

    public boolean approveSubscription(int subId) {
        String query = "UPDATE Subscription SET status='Active' WHERE subID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, subId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int createSubscription(Subscription sub) {
        String query = "INSERT INTO Subscription (userID, planID, startDate, endDate, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sub.getUserID());
            ps.setInt(2, sub.getPlanID());
            ps.setDate(3, sub.getStartDate());
            ps.setDate(4, sub.getEndDate());
            ps.setString(5, sub.getStatus());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }
}
