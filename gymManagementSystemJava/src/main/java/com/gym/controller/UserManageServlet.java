package com.gym.controller;

import com.gym.dao.UserDAO;
import com.gym.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UserManageServlet")
public class UserManageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("edit".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userID"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String contactNo = request.getParameter("contactNo");

            User user = new User();
            user.setUserID(userId);
            user.setName(name);
            user.setEmail(email);
            user.setContactNo(contactNo);

            userDAO.updateUser(user);
        } else if ("add".equals(action)) {
            User user = new User();
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPassword(request.getParameter("password"));
            user.setRole(request.getParameter("role"));
            user.setContactNo(request.getParameter("contactNo"));
            
            // Re-use register but we need a custom insert for arbitrary roles
            // Let's create an addUser method in UserDAO if it doesn't exist, or just use raw SQL here.
            // Actually, we can use userDAO.addUser(user) if we add it, but for simplicity we will add it to UserDAO next.
            userDAO.addUser(user);
        }
        response.sendRedirect("AdminDashboard");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("disable".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();
            userDAO.disableUser(userId);
        }
        response.sendRedirect("AdminDashboard");
    }
}
