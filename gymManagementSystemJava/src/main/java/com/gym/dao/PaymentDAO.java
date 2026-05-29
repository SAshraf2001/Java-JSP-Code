package com.gym.dao;

import com.gym.model.Payment;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean addPayment(Payment payment) {
        String query = "INSERT INTO Payment (subID, amount, paymentMethod) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, payment.getSubID());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Payment> getPaymentsByUserId(int userId) {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT p.*, mp.planName FROM Payment p " +
                       "JOIN Subscription s ON p.subID = s.subID " +
                       "JOIN MembershipPlan mp ON s.planID = mp.planID " +
                       "WHERE s.userID = ? ORDER BY p.paymentDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentID(rs.getInt("paymentID"));
                    payment.setSubID(rs.getInt("subID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentDate(rs.getTimestamp("paymentDate"));
                    payment.setPaymentMethod(rs.getString("paymentMethod"));
                    payment.setPlanName(rs.getString("planName"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return payments;
    }
}
