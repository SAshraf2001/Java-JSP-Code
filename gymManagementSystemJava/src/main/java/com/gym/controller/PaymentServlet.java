package com.gym.controller;

import com.gym.dao.PaymentDAO;
import com.gym.dao.PlanDAO;
import com.gym.dao.SubscriptionDAO;
import com.gym.model.MembershipPlan;
import com.gym.model.Payment;
import com.gym.model.Subscription;
import com.gym.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"Member".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        int planId = Integer.parseInt(request.getParameter("planID"));
        String paymentMethod = request.getParameter("paymentMethod");

        PlanDAO planDAO = new PlanDAO();
        MembershipPlan plan = planDAO.getPlanById(planId);

        if (plan != null) {
            // Create Subscription
            Subscription sub = new Subscription();
            sub.setUserID(user.getUserID());
            sub.setPlanID(planId);
            
            Date startDate = new Date(System.currentTimeMillis());
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.add(Calendar.MONTH, plan.getDurationMonths());
            Date endDate = new Date(cal.getTimeInMillis());
            
            sub.setStartDate(startDate);
            sub.setEndDate(endDate);
            sub.setStatus("Active"); // Automatically active after payment

            SubscriptionDAO subDAO = new SubscriptionDAO();
            int subId = subDAO.createSubscription(sub);

            if (subId > 0) {
                // Record Payment
                Payment payment = new Payment();
                payment.setSubID(subId);
                payment.setAmount(plan.getPrice());
                payment.setPaymentMethod(paymentMethod);
                
                PaymentDAO paymentDAO = new PaymentDAO();
                paymentDAO.addPayment(payment);
            }
        }
        
        response.sendRedirect("MemberDashboard");
    }
}
