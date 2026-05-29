package com.gym.controller;

import com.gym.dao.UserDAO;
import com.gym.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null && "Member".equals(user.getRole())) {
            String name = request.getParameter("name");
            String contactNo = request.getParameter("contactNo");
            
            user.setName(name);
            user.setContactNo(contactNo);
            
            UserDAO dao = new UserDAO();
            dao.updateUser(user);
            session.setAttribute("user", user); // Update session
        }
        response.sendRedirect("MemberDashboard");
    }
}
