package com.gym.controller;

import com.gym.dao.ClassDAO;
import com.gym.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/BookClassServlet")
public class BookClassServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null && "Member".equals(user.getRole())) {
            int classId = Integer.parseInt(request.getParameter("classID"));
            ClassDAO dao = new ClassDAO();
            dao.bookClass(user.getUserID(), classId);
        }
        response.sendRedirect("MemberDashboard");
    }
}
