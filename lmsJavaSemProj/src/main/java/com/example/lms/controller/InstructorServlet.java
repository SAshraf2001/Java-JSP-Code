package com.example.lms.controller;

import com.example.lms.dao.CourseDAO;
import com.example.lms.model.Course;
import com.example.lms.model.CourseStatus;
import com.example.lms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class InstructorServlet extends HttpServlet {
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if ("/dashboard".equals(path) || path == null || path.equals("/")) {
            try {
                List<Course> courses = courseDAO.findAllByInstructorId(user.getUserId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/WEB-INF/views/instructor_dashboard.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("DB Error", e);
            }
        } else if ("/course".equals(path)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("id"));
                Course course = courseDAO.findById(courseId);
                
                com.example.lms.dao.ModuleDAO moduleDAO = new com.example.lms.dao.ModuleDAO();
                com.example.lms.dao.LessonDAO lessonDAO = new com.example.lms.dao.LessonDAO();
                
                List<com.example.lms.model.Module> modules = moduleDAO.findByCourseId(courseId);
                java.util.Map<Integer, List<com.example.lms.model.Lesson>> lessonsMap = new java.util.HashMap<>();
                for (com.example.lms.model.Module m : modules) {
                    lessonsMap.put(m.getModuleId(), lessonDAO.findByModuleId(m.getModuleId()));
                }
                
                com.example.lms.dao.AssignmentDAO assignmentDAO = new com.example.lms.dao.AssignmentDAO();
                com.example.lms.dao.AssignmentSubmissionDAO submissionDAO = new com.example.lms.dao.AssignmentSubmissionDAO();
                
                List<com.example.lms.model.Assignment> assignments = assignmentDAO.findByCourseId(courseId);
                java.util.Map<Integer, List<com.example.lms.model.AssignmentSubmission>> submissionsMap = new java.util.HashMap<>();
                for (com.example.lms.model.Assignment a : assignments) {
                    submissionsMap.put(a.getAssignmentId(), submissionDAO.findByAssignmentId(a.getAssignmentId()));
                }
                
                request.setAttribute("course", course);
                request.setAttribute("modules", modules);
                request.setAttribute("lessonsMap", lessonsMap);
                request.setAttribute("assignments", assignments);
                request.setAttribute("submissionsMap", submissionsMap);
                request.getRequestDispatcher("/WEB-INF/views/course_manage.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("DB Error", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            if ("createCourse".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String enrollmentKey = request.getParameter("enrollmentKey");

                Course course = new Course();
                course.setInstructorId(user.getUserId());
                course.setTitle(title);
                course.setDescription(description);
                course.setEnrollmentKey(enrollmentKey);
                course.setStatus(CourseStatus.Draft);

                courseDAO.create(course);
                response.sendRedirect(request.getContextPath() + "/instructor/dashboard");
            } else if ("publishCourse".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseDAO.updateStatus(courseId, CourseStatus.Published);
                response.sendRedirect(request.getContextPath() + "/instructor/dashboard");
            } else if ("addModule".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                com.example.lms.model.Module module = new com.example.lms.model.Module();
                module.setCourseId(courseId);
                module.setTitle(request.getParameter("title"));
                module.setSequenceOrder(Integer.parseInt(request.getParameter("sequenceOrder")));
                new com.example.lms.dao.ModuleDAO().create(module);
                response.sendRedirect(request.getContextPath() + "/instructor/course?id=" + courseId);
            } else if ("addLesson".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                com.example.lms.model.Lesson lesson = new com.example.lms.model.Lesson();
                lesson.setModuleId(Integer.parseInt(request.getParameter("moduleId")));
                lesson.setTitle(request.getParameter("title"));
                lesson.setContent(request.getParameter("content"));
                lesson.setContentType(com.example.lms.model.ContentType.valueOf(request.getParameter("contentType")));
                lesson.setSequenceOrder(Integer.parseInt(request.getParameter("sequenceOrder")));
                new com.example.lms.dao.LessonDAO().create(lesson);
                response.sendRedirect(request.getContextPath() + "/instructor/course?id=" + courseId);
            } else if ("addAssignment".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                com.example.lms.model.Assignment assignment = new com.example.lms.model.Assignment();
                assignment.setCourseId(courseId);
                assignment.setTitle(request.getParameter("title"));
                assignment.setDescription(request.getParameter("description"));
                String dueDateStr = request.getParameter("dueDate");
                if (dueDateStr != null && !dueDateStr.isEmpty()) {
                    assignment.setDueDate(java.time.LocalDate.parse(dueDateStr));
                }
                assignment.setMaxScore(Integer.parseInt(request.getParameter("maxScore")));
                new com.example.lms.dao.AssignmentDAO().create(assignment);
                response.sendRedirect(request.getContextPath() + "/instructor/course?id=" + courseId);
            } else if ("gradeSubmission".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                int submissionId = Integer.parseInt(request.getParameter("submissionId"));
                int score = Integer.parseInt(request.getParameter("score"));
                String feedback = request.getParameter("feedback");
                new com.example.lms.dao.AssignmentSubmissionDAO().gradeSubmission(submissionId, score, feedback);
                response.sendRedirect(request.getContextPath() + "/instructor/course?id=" + courseId);
            }
        } catch (SQLException e) {
            throw new ServletException("Error managing course", e);
        }
    }
}
