package com.example.lms.controller;

import com.example.lms.dao.UserDAO;
import com.example.lms.model.User;
import com.example.lms.model.UserRole;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if ("/dashboard".equals(path) || path == null || path.equals("/")) {
            try {
                List<User> users = userDAO.findAll();
                request.setAttribute("users", users);
                request.getRequestDispatcher("/WEB-INF/views/admin_dashboard.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("DB Error", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if ("toggleStatus".equals(action)) {
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
                userDAO.setActive(userId, !currentStatus);
            } else if ("changeRole".equals(action)) {
                String newRole = request.getParameter("newRole");
                userDAO.setRole(userId, UserRole.valueOf(newRole));
            }
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Error updating user", e);
        }
    }
}
