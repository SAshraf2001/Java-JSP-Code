package com.gym.controller;

import com.gym.dao.PlanDAO;
import com.gym.dao.SubscriptionDAO;
import com.gym.dao.PaymentDAO;
import com.gym.dao.ClassDAO;
import com.gym.model.GymClass;
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
import java.util.List;

@WebServlet("/MemberDashboard")
public class MemberDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"Member".equals(user.getRole())) {
            response.sendRedirect("index.jsp?error=Unauthorized Access");
            return;
        }

        PlanDAO planDAO = new PlanDAO();
        SubscriptionDAO subDAO = new SubscriptionDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        ClassDAO classDAO = new ClassDAO();

        List<MembershipPlan> plans = planDAO.getAllPlans();
        Subscription currentSub = subDAO.getSubscriptionByUserId(user.getUserID());
        List<Payment> payments = paymentDAO.getPaymentsByUserId(user.getUserID());
        List<GymClass> classes = classDAO.getAllClasses();

        request.setAttribute("plans", plans);
        request.setAttribute("currentSub", currentSub);
        request.setAttribute("payments", payments);
        request.setAttribute("classes", classes);

        request.getRequestDispatcher("Member.jsp").forward(request, response);
    }
}
