package com.gym.controller;

import com.gym.dao.ClassDAO;
import com.gym.dao.AttendanceDAO;
import com.gym.dao.PlanDAO;
import com.gym.dao.SubscriptionDAO;
import com.gym.dao.UserDAO;
import com.gym.model.ClassBooking;
import com.gym.model.GymClass;
import com.gym.model.Attendance;
import com.gym.model.MembershipPlan;
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

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) {
            response.sendRedirect("index.jsp?error=Unauthorized Access");
            return;
        }

        UserDAO userDAO = new UserDAO();
        PlanDAO planDAO = new PlanDAO();
        SubscriptionDAO subDAO = new SubscriptionDAO();
        ClassDAO classDAO = new ClassDAO();
        AttendanceDAO attendanceDAO = new AttendanceDAO();

        List<User> users = userDAO.getAllUsers();
        List<MembershipPlan> plans = planDAO.getAllPlans();
        List<Subscription> subscriptions = subDAO.getAllSubscriptions();
        List<GymClass> gymClasses = classDAO.getAllClasses();
        List<ClassBooking> recentBookings = classDAO.getRecentBookings();
        List<Attendance> todayAttendance = attendanceDAO.getTodayAttendance();

        request.setAttribute("users", users);
        request.setAttribute("plans", plans);
        request.setAttribute("subscriptions", subscriptions);
        request.setAttribute("gymClasses", gymClasses);
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("todayAttendance", todayAttendance);

        // Basic Analytics
        double monthlyRevenue = 0;
        int activeMembers = 0;
        for (Subscription sub : subscriptions) {
            if ("Active".equals(sub.getStatus())) {
                activeMembers++;
                MembershipPlan p = planDAO.getPlanById(sub.getPlanID());
                if (p != null && p.getDurationMonths() > 0) {
                    monthlyRevenue += sub.getPrice() / p.getDurationMonths();
                }
            }
        }
        request.setAttribute("activeMembers", activeMembers);
        request.setAttribute("monthlyRevenue", String.format("%.2f", monthlyRevenue));
        request.setAttribute("totalClasses", gymClasses.size());

        request.getRequestDispatcher("Admin.jsp").forward(request, response);
    }
}
