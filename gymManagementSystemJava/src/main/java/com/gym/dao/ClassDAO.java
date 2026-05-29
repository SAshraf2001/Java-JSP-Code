package com.gym.dao;

import com.gym.model.ClassBooking;
import com.gym.model.GymClass;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassDAO {

    public List<GymClass> getAllClasses() {
        List<GymClass> classes = new ArrayList<>();
        String query = "SELECT c.*, (SELECT COUNT(*) FROM ClassBooking b WHERE b.classID = c.classID) as bookedCount " +
                       "FROM GymClass c ORDER BY c.scheduleTime ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                GymClass gc = new GymClass();
                gc.setClassID(rs.getInt("classID"));
                gc.setClassName(rs.getString("className"));
                gc.setTrainerName(rs.getString("trainerName"));
                gc.setScheduleTime(rs.getTimestamp("scheduleTime"));
                gc.setCapacity(rs.getInt("capacity"));
                gc.setBookedCount(rs.getInt("bookedCount"));
                classes.add(gc);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return classes;
    }

    public boolean addClass(GymClass gc) {
        String query = "INSERT INTO GymClass (className, trainerName, scheduleTime, capacity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, gc.getClassName());
            ps.setString(2, gc.getTrainerName());
            ps.setTimestamp(3, gc.getScheduleTime());
            ps.setInt(4, gc.getCapacity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean bookClass(int userId, int classId) {
        String checkQuery = "SELECT capacity, (SELECT COUNT(*) FROM ClassBooking WHERE classID = ?) as bookedCount FROM GymClass WHERE classID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {
            checkPs.setInt(1, classId);
            checkPs.setInt(2, classId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    int cap = rs.getInt("capacity");
                    int booked = rs.getInt("bookedCount");
                    if (booked >= cap) return false; // Full
                }
            }
            
            // Check if already booked
            String checkBooked = "SELECT * FROM ClassBooking WHERE userID = ? AND classID = ?";
            try (PreparedStatement cbPs = conn.prepareStatement(checkBooked)) {
                cbPs.setInt(1, userId);
                cbPs.setInt(2, classId);
                try (ResultSet rs = cbPs.executeQuery()) {
                    if (rs.next()) return false; // Already booked
                }
            }

            String insertQuery = "INSERT INTO ClassBooking (userID, classID) VALUES (?, ?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
                insertPs.setInt(1, userId);
                insertPs.setInt(2, classId);
                return insertPs.executeUpdate() > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<ClassBooking> getRecentBookings() {
        List<ClassBooking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.name as userName, c.className, c.scheduleTime FROM ClassBooking b " +
                       "JOIN User u ON b.userID = u.userID " +
                       "JOIN GymClass c ON b.classID = c.classID " +
                       "ORDER BY b.bookingTime DESC LIMIT 20";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ClassBooking cb = new ClassBooking();
                cb.setBookingID(rs.getInt("bookingID"));
                cb.setUserID(rs.getInt("userID"));
                cb.setClassID(rs.getInt("classID"));
                cb.setBookingTime(rs.getTimestamp("bookingTime"));
                cb.setUserName(rs.getString("userName"));
                cb.setClassName(rs.getString("className"));
                cb.setClassTime(rs.getTimestamp("scheduleTime"));
                bookings.add(cb);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bookings;
    }
}
