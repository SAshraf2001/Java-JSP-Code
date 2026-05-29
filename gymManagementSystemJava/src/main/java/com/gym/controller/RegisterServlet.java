package com.gym.controller;

import com.gym.dao.UserDAO;
import com.gym.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contactNo = request.getParameter("contactNo");

        User user = new User(0, name, email, password, "Member", contactNo);
        UserDAO userDAO = new UserDAO();

        if (userDAO.register(user)) {
            response.sendRedirect("index.jsp?msg=Registration Successful. Please Login.");
        } else {
            response.sendRedirect("index.jsp?error=Registration Failed. Email might be in use.");
        }
    }
}
