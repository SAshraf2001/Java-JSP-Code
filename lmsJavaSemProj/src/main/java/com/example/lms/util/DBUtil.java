package com.example.lms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Simple utility class for obtaining JDBC connections.
 * In a real‑world project you would use a connection pool (e.g., Apache DBCP or HikariCP),
 * but for a semester project a single DriverManager based connection is sufficient.
 */
public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/lms_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root"; // adjust as needed
    private static final String PASSWORD = ""; // default empty password for XAMPP/local dev

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found.", e);
        }
    }

    private DBUtil() { }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
