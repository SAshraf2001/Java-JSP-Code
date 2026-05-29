package com.gym.controller;

import com.gym.dao.SubscriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/SubscriptionApproveServlet")
public class SubscriptionApproveServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subId = Integer.parseInt(request.getParameter("id"));
        SubscriptionDAO subDAO = new SubscriptionDAO();
        subDAO.approveSubscription(subId);
        response.sendRedirect("AdminDashboard");
    }
}
