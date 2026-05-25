package com.lms.controller;

import com.lms.dao.UserDAO;
import com.lms.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller to handle user authentication requests.
 * Intercepts POST requests, queries UserDAO, and routes by role.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    /**
     * Handles GET request by redirecting to the login presentation view.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    /**
     * Handles POST request containing login credentials.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Input validation
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Authenticate via DAO
        User user = userDAO.authenticateUser(email.trim(), password);

        if (user != null) {
            // Setup Session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);

            // Role-based routing
            if ("INSTRUCTOR".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("instructorDashboard.jsp");
            } else if ("STUDENT".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("studentDashboard.jsp");
            } else {
                // Unknown role fallback
                session.invalidate();
                request.setAttribute("errorMessage", "Unauthorized role configuration.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
