package com.gym.dao;

import com.gym.model.Attendance;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {
    
    public boolean checkIn(int userId) {
        String query = "INSERT INTO Attendance (userID) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Attendance> getTodayAttendance() {
        List<Attendance> list = new ArrayList<>();
        String query = "SELECT a.*, u.name as userName FROM Attendance a JOIN User u ON a.userID = u.userID " +
                       "WHERE DATE(a.checkInTime) = CURRENT_DATE ORDER BY a.checkInTime DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAttendanceID(rs.getInt("attendanceID"));
                a.setUserID(rs.getInt("userID"));
                a.setCheckInTime(rs.getTimestamp("checkInTime"));
                a.setUserName(rs.getString("userName"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
