<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.dao.CourseDAO" %>
<%@ page import="java.util.List" %>
<%
    // Security check: Verify session state and STUDENT role permission
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"STUDENT".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve Student's enrolled courses
    CourseDAO courseDAO = new CourseDAO();
    List<Course> enrolledCourses = courseDAO.getStudentCourses(currentUser.getId());
%>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950 text-slate-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Online LMS</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Font (Outfit) -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Outfit', sans-serif;
        }
    </style>
</head>
<body class="min-h-full flex flex-col justify-between relative overflow-x-hidden">

    <!-- Gradient Ambient Background Orbs -->
    <div class="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-indigo-600/5 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[500px] h-[500px] bg-violet-600/5 rounded-full blur-[120px] pointer-events-none"></div>

    <!-- Header Navigation -->
    <header class="border-b border-slate-900 bg-slate-950/80 backdrop-blur-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <!-- Branding -->
                <div class="flex items-center gap-3">
                    <div class="h-9 w-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-violet-500 flex items-center justify-center shadow-md">
                        <svg class="h-5 w-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                        </svg>
                    </div>
                    <span class="text-lg font-bold tracking-tight bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent">LMS Platform</span>
                </div>

                <!-- User profile & Logout -->
                <div class="flex items-center gap-4">
                    <div class="hidden sm:flex flex-col text-right">
                        <span class="text-sm font-medium text-slate-200"><%= currentUser.getName() %></span>
                        <span class="text-xs text-slate-500 font-mono tracking-wider uppercase"><%= currentUser.getRole() %></span>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center font-bold text-indigo-400 text-sm">
                        <%= currentUser.getName().substring(0, 1).toUpperCase() %>
                    </div>
                    <a href="logout" 
                        class="px-4 py-2 bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white transition-all text-xs font-semibold rounded-lg text-slate-300">
                        Sign Out
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 flex-grow relative z-10">
        
        <!-- Welcome Jumbotron -->
        <section class="mb-10 bg-gradient-to-r from-slate-900/60 to-indigo-950/20 backdrop-blur-xl border border-slate-800/60 p-8 rounded-2xl flex flex-col md:flex-row md:items-center md:justify-between gap-6 shadow-xl">
            <div>
                <span class="text-xs font-mono uppercase tracking-wider text-indigo-400 font-bold">Dashboard Hub</span>
                <h1 class="text-3xl font-extrabold tracking-tight text-white mt-1">Welcome back, <%= currentUser.getName() %>!</h1>
                <p class="text-slate-400 mt-2 text-sm max-w-xl">
                    Ready to make progress? Access your virtual classrooms, module lessons, and assignments from the grid panel below.
                </p>
            </div>
            
            <!-- Quick Stat Mini Card Grid -->
            <div class="grid grid-cols-2 gap-4 shrink-0 w-full md:w-auto">
                <div class="bg-slate-950/40 border border-slate-800/40 p-4 rounded-xl text-center md:w-36">
                    <span class="block text-2xl font-bold text-white"><%= enrolledCourses.size() %></span>
                    <span class="text-[10px] uppercase font-bold text-slate-500 tracking-widest block mt-1">Enrolled</span>
                </div>
                <div class="bg-slate-950/40 border border-slate-800/40 p-4 rounded-xl text-center md:w-36">
                    <span class="block text-2xl font-bold text-emerald-400">100%</span>
                    <span class="text-[10px] uppercase font-bold text-slate-500 tracking-widest block mt-1">Attendance</span>
                </div>
            </div>
        </section>

        <!-- Course Listings Section -->
        <section class="space-y-6">
            <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-white tracking-tight flex items-center gap-2">
                    <span class="h-2 w-2 rounded-full bg-indigo-500"></span>
                    My Enrolled Courses
                </h2>
                <span class="text-xs font-mono text-slate-400">Total Enrolled: <%= enrolledCourses.size() %></span>
            </div>

            <!-- Course Card Grid -->
            <% if (enrolledCourses.isEmpty()) { %>
                <div class="text-center py-16 bg-slate-900/30 border border-dashed border-slate-800 rounded-2xl">
                    <svg class="mx-auto h-12 w-12 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                    </svg>
                    <h3 class="mt-4 text-sm font-semibold text-slate-300">No active course enrollments</h3>
                    <p class="mt-2 text-xs text-slate-500">Please contact the admin system to enroll in course topics.</p>
                </div>
            <% } else { %>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% for (Course course : enrolledCourses) { %>
                        <article class="group bg-slate-900/40 hover:bg-slate-900/80 transition-all border border-slate-800/80 hover:border-indigo-500/50 rounded-2xl p-6 flex flex-col justify-between shadow-lg relative overflow-hidden hover:shadow-indigo-500/5">
                            
                            <!-- Card Backdrop Glow -->
                            <div class="absolute top-0 right-0 w-24 h-24 bg-gradient-to-bl from-indigo-500/10 to-transparent blur-md rounded-bl-full pointer-events-none group-hover:from-indigo-500/20 transition-all"></div>

                            <div>
                                <div class="flex items-start justify-between mb-4">
                                    <!-- Course tag -->
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                                        Java MVC Series
                                    </span>
                                </div>
                                
                                <h3 class="text-lg font-bold text-white group-hover:text-indigo-400 transition-colors mb-2">
                                    <%= course.getTitle() %>
                                </h3>
                                
                                <p class="text-sm text-slate-400 line-clamp-3 mb-6">
                                    <%= course.getDescription() %>
                                </p>
                            </div>

                            <div class="space-y-4 pt-4 border-t border-slate-800/60">
                                <!-- Instructor tag -->
                                <div class="flex items-center gap-2 text-xs text-slate-400">
                                    <span class="font-semibold text-slate-500">Instructor:</span>
                                    <span class="text-slate-300 font-medium"><%= course.getInstructorName() %></span>
                                </div>

                                <!-- Progress bar element -->
                                <div>
                                    <div class="flex justify-between text-[10px] text-slate-500 font-bold mb-1 font-mono uppercase tracking-wider">
                                        <span>Course Completion</span>
                                        <span>40%</span>
                                    </div>
                                    <div class="w-full bg-slate-950 rounded-full h-1.5 overflow-hidden border border-slate-800">
                                        <div class="bg-gradient-to-r from-indigo-500 to-violet-500 h-1.5 rounded-full" style="width: 40%"></div>
                                    </div>
                                </div>

                                <!-- Action button -->
                                <button class="w-full mt-2 py-2.5 px-4 rounded-xl text-xs font-bold text-white bg-indigo-600/20 hover:bg-indigo-600 border border-indigo-500/30 hover:border-indigo-500 transition-all text-center">
                                    Enter Course Classroom
                                </button>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>

    </main>

    <!-- Footer -->
    <footer class="py-6 border-t border-slate-900 bg-slate-950 relative z-10 text-center text-xs text-slate-600">
        &copy; 2026 Online LMS Portal. Secured student console session.
    </footer>

</body>
</html>
