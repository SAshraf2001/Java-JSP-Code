package com.example.lms.controller;

import com.example.lms.dao.CourseDAO;
import com.example.lms.dao.EnrollmentDAO;
import com.example.lms.model.Course;
import com.example.lms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class StudentServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if ("/dashboard".equals(path) || path == null || path.equals("/")) {
            try {
                // Fetch courses the student is enrolled in
                List<Course> enrolledCourses = enrollmentDAO.findEnrolledCourses(user.getUserId());
                
                // Fetch all published courses to show in "Available Courses"
                List<Course> allCourses = courseDAO.findAllPublished();
                
                request.setAttribute("enrolledCourses", enrolledCourses);
                request.setAttribute("allCourses", allCourses);
                request.getRequestDispatcher("/WEB-INF/views/student_dashboard.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("DB Error", e);
            }
        } else if ("/course".equals(path)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("id"));
                Course course = courseDAO.findById(courseId);
                
                // Fetch modules and lessons
                com.example.lms.dao.ModuleDAO moduleDAO = new com.example.lms.dao.ModuleDAO();
                com.example.lms.dao.LessonDAO lessonDAO = new com.example.lms.dao.LessonDAO();
                
                List<com.example.lms.model.Module> modules = moduleDAO.findByCourseId(courseId);
                // Create a map or pass lessons directly. For simplicity, we can fetch lessons in the JSP or pass a nested structure.
                // To keep it simple without DTOs, we'll attach lessons to the request via a map.
                java.util.Map<Integer, List<com.example.lms.model.Lesson>> lessonsMap = new java.util.HashMap<>();
                for (com.example.lms.model.Module m : modules) {
                    lessonsMap.put(m.getModuleId(), lessonDAO.findByModuleId(m.getModuleId()));
                }
                
                com.example.lms.dao.AssignmentDAO assignmentDAO = new com.example.lms.dao.AssignmentDAO();
                com.example.lms.dao.AssignmentSubmissionDAO submissionDAO = new com.example.lms.dao.AssignmentSubmissionDAO();
                
                List<com.example.lms.model.Assignment> assignments = assignmentDAO.findByCourseId(courseId);
                java.util.Map<Integer, com.example.lms.model.AssignmentSubmission> mySubmissions = new java.util.HashMap<>();
                for (com.example.lms.model.Assignment a : assignments) {
                    com.example.lms.model.AssignmentSubmission sub = submissionDAO.findByAssignmentAndStudent(a.getAssignmentId(), user.getUserId());
                    if (sub != null) {
                        mySubmissions.put(a.getAssignmentId(), sub);
                    }
                }
                
                request.setAttribute("course", course);
                request.setAttribute("modules", modules);
                request.setAttribute("lessonsMap", lessonsMap);
                request.setAttribute("assignments", assignments);
                request.setAttribute("mySubmissions", mySubmissions);
                request.getRequestDispatcher("/WEB-INF/views/course_view.jsp").forward(request, response);
            } catch (Exception e) {
                throw new ServletException("Error loading course details", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            if ("enroll".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String providedKey = request.getParameter("enrollmentKey");
                
                Course course = courseDAO.findById(courseId);
                if (course != null && course.getEnrollmentKey().equals(providedKey)) {
                    enrollmentDAO.enrollStudent(user.getUserId(), courseId);
                    request.getSession().setAttribute("success", "Successfully enrolled in " + course.getTitle());
                } else {
                    request.getSession().setAttribute("error", "Invalid Enrollment Key!");
                }
            } else if ("submitAssignment".equals(action)) {
                int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                
                com.example.lms.model.AssignmentSubmission submission = new com.example.lms.model.AssignmentSubmission();
                submission.setAssignmentId(assignmentId);
                submission.setStudentId(user.getUserId());
                submission.setFilePath(request.getParameter("submissionLink"));
                
                new com.example.lms.dao.AssignmentSubmissionDAO().submit(submission);
                request.getSession().setAttribute("success", "Assignment submitted successfully!");
                response.sendRedirect(request.getContextPath() + "/student/course?id=" + courseId);
                return; // exit to avoid the redirect below
            }
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        } catch (SQLException e) {
            // Usually means already enrolled (UNIQUE constraint violation)
            request.getSession().setAttribute("error", "You are already enrolled in this course.");
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}
