package com.gym.dao;

import com.gym.model.MembershipPlan;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlanDAO {

    public List<MembershipPlan> getAllPlans() {
        List<MembershipPlan> plans = new ArrayList<>();
        String query = "SELECT * FROM MembershipPlan";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                plans.add(new MembershipPlan(rs.getInt("planID"), rs.getString("planName"),
                                             rs.getInt("durationMonths"), rs.getDouble("price"),
                                             rs.getString("description")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return plans;
    }

    public MembershipPlan getPlanById(int planID) {
        MembershipPlan plan = null;
        String query = "SELECT * FROM MembershipPlan WHERE planID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, planID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    plan = new MembershipPlan(rs.getInt("planID"), rs.getString("planName"),
                                              rs.getInt("durationMonths"), rs.getDouble("price"),
                                              rs.getString("description"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return plan;
    }

    public boolean addPlan(MembershipPlan plan) {
        String query = "INSERT INTO MembershipPlan (planName, durationMonths, price, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, plan.getPlanName());
            ps.setInt(2, plan.getDurationMonths());
            ps.setDouble(3, plan.getPrice());
            ps.setString(4, plan.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
