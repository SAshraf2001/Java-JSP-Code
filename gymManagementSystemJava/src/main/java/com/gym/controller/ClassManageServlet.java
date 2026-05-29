package com.gym.controller;

import com.gym.dao.ClassDAO;
import com.gym.model.GymClass;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/ClassManageServlet")
public class ClassManageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String className = request.getParameter("className");
        String trainerName = request.getParameter("trainerName");
        String scheduleTimeStr = request.getParameter("scheduleTime"); // Format: yyyy-MM-dd'T'HH:mm
        int capacity = Integer.parseInt(request.getParameter("capacity"));

        GymClass gc = new GymClass();
        gc.setClassName(className);
        gc.setTrainerName(trainerName);
        if (scheduleTimeStr != null && !scheduleTimeStr.isEmpty()) {
            gc.setScheduleTime(Timestamp.valueOf(scheduleTimeStr.replace("T", " ") + ":00"));
        }
        gc.setCapacity(capacity);

        ClassDAO classDAO = new ClassDAO();
        classDAO.addClass(gc);

        response.sendRedirect("AdminDashboard");
    }
}
