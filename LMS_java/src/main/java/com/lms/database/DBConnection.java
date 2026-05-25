package com.lms.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Thread-safe utility class for database connections.
 * Uses native JDBC DriverManager to manage connection mapping with proper resources cleanup.
 */
public class DBConnection {

    // Database configurations (customize username and password as per environment)
    private static final String URL = "jdbc:mysql://localhost:3306/lms_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "pma";
    private static final String PASSWORD = "root";
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // Static block to load the JDBC driver safely exactly once
    static {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found in classpath. Make sure mysql-connector-java is added.");
            e.printStackTrace();
        }
    }

    // Private constructor to prevent direct instantiation
    private DBConnection() {}

    /**
     * Obtains a thread-safe connection to the LMS database.
     * Each thread calling this will receive its own Connection instance, which must be closed after use.
     *
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Helper to close standard Connection, Statement, and ResultSet objects to prevent connection leaks.
     * Highly critical in Servlet environments.
     */
    public static void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing Statement: " + e.getMessage());
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing Connection: " + e.getMessage());
            }
        }
    }
}
