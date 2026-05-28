package com.example.lms.controller;

import com.example.lms.dao.UserDAO;
import com.example.lms.model.User;
import com.example.lms.model.UserRole;
import com.example.lms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.findByEmail(email);
            
            if (user != null && user.isActive() && PasswordUtil.verify(password, user.getPasswordHash())) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole().name());

                // Redirect based on role
                switch (user.getRole()) {
                    case Admin:
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                        break;
                    case Instructor:
                        response.sendRedirect(request.getContextPath() + "/instructor/dashboard");
                        break;
                    case Student:
                        response.sendRedirect(request.getContextPath() + "/student/dashboard");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid credentials or account disabled.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during login", e);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");

        try {
            if (userDAO.findByEmail(email) != null) {
                request.setAttribute("error", "Email already exists.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPasswordHash(PasswordUtil.hash(password));
            user.setRole(UserRole.valueOf(roleStr));
            user.setActive(true);

            userDAO.create(user);
            
            // Auto login after registration
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole().name());

            if (user.getRole() == UserRole.Student) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            } else if (user.getRole() == UserRole.Instructor) {
                response.sendRedirect(request.getContextPath() + "/instructor/dashboard");
            } else if (user.getRole() == UserRole.Admin) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during registration", e);
        }
    }
}
