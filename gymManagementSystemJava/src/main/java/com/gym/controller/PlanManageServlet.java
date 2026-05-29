package com.gym.controller;

import com.gym.dao.PlanDAO;
import com.gym.model.MembershipPlan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/PlanManageServlet")
public class PlanManageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String planName = request.getParameter("planName");
        int durationMonths = Integer.parseInt(request.getParameter("durationMonths"));
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");

        MembershipPlan plan = new MembershipPlan(0, planName, durationMonths, price, description);
        PlanDAO planDAO = new PlanDAO();
        planDAO.addPlan(plan);

        response.sendRedirect("AdminDashboard");
    }
}
