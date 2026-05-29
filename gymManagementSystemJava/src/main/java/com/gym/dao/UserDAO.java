package com.gym.dao;

import com.gym.model.User;
import com.gym.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User login(String email, String password) {
        User user = null;
        String query = "SELECT * FROM User WHERE email=? AND password=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User(rs.getInt("userID"), rs.getString("name"), rs.getString("email"), 
                                    rs.getString("password"), rs.getString("role"), rs.getString("contactNo"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    public boolean register(User user) {
        String query = "INSERT INTO User (name, email, password, role, contactNo) VALUES (?, ?, ?, 'Member', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getContactNo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM User";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(new User(rs.getInt("userID"), rs.getString("name"), rs.getString("email"),
                                   rs.getString("password"), rs.getString("role"), rs.getString("contactNo")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return users;
    }

    public boolean updateUser(User user) {
        String query = "UPDATE User SET name=?, email=?, contactNo=? WHERE userID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getContactNo());
            ps.setInt(4, user.getUserID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean disableUser(int userId) {
        // Here disable might mean deleting or changing a status flag. We will just delete for simplicity
        // based on the schema or we could add a status column. Since schema doesn't have status for User, we delete.
        String query = "DELETE FROM User WHERE userID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean addUser(User user) {
        String query = "INSERT INTO User (name, email, password, role, contactNo) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getContactNo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
