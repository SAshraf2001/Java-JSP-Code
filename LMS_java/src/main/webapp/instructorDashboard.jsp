<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.dao.CourseDAO" %>
<%@ page import="java.util.List" %>
<%
    // Security check: Verify session state and INSTRUCTOR role permission
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"INSTRUCTOR".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve all platform courses
    CourseDAO courseDAO = new CourseDAO();
    List<Course> allCourses = courseDAO.getAllCourses();
%>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950 text-slate-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Admin Console - Online LMS</title>
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
    <div class="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-violet-600/5 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[500px] h-[500px] bg-indigo-600/5 rounded-full blur-[120px] pointer-events-none"></div>

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
                    <span class="text-lg font-bold tracking-tight bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent">LMS Administration</span>
                </div>

                <!-- User profile & Logout -->
                <div class="flex items-center gap-4">
                    <div class="hidden sm:flex flex-col text-right">
                        <span class="text-sm font-medium text-slate-200"><%= currentUser.getName() %></span>
                        <span class="text-xs text-rose-400 font-mono tracking-wider uppercase"><%= currentUser.getRole() %></span>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center font-bold text-rose-400 text-sm">
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
        <section class="mb-10 bg-gradient-to-r from-slate-900/60 to-rose-950/10 backdrop-blur-xl border border-slate-800/60 p-8 rounded-2xl flex flex-col md:flex-row md:items-center md:justify-between gap-6 shadow-xl">
            <div>
                <span class="text-xs font-mono uppercase tracking-wider text-rose-400 font-bold">Admin Dashboard Panel</span>
                <h1 class="text-3xl font-extrabold tracking-tight text-white mt-1">Instructor Console: <%= currentUser.getName() %></h1>
                <p class="text-slate-400 mt-2 text-sm max-w-xl">
                    Review general platform metrics, course catalogs, and administrative options inside this central command dashboard.
                </p>
            </div>
            
            <div class="flex gap-4 shrink-0 w-full md:w-auto">
                <button class="flex-grow md:flex-none px-5 py-3 rounded-xl bg-gradient-to-tr from-rose-500 to-amber-500 hover:from-rose-600 hover:to-amber-600 font-semibold text-xs text-white shadow-lg shadow-rose-500/10 transition-all active:scale-95">
                    + Add New Course
                </button>
            </div>
        </section>

        <!-- Stats Counter Panel -->
        <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
            <!-- Stat 1 -->
            <div class="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                <span class="text-xs uppercase font-mono tracking-widest text-slate-500 font-bold">Total Courses</span>
                <span class="block text-3xl font-extrabold text-white mt-2"><%= allCourses.size() %></span>
                <span class="text-[10px] text-emerald-400 flex items-center gap-1 mt-2">
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M5 10l7-7 7 7M12 3v18"></path></svg>
                    +12% vs last month
                </span>
            </div>
            <!-- Stat 2 -->
            <div class="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                <span class="text-xs uppercase font-mono tracking-widest text-slate-500 font-bold">Total Registrations</span>
                <span class="block text-3xl font-extrabold text-white mt-2">1,248</span>
                <span class="text-[10px] text-emerald-400 flex items-center gap-1 mt-2">
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M5 10l7-7 7 7M12 3v18"></path></svg>
                    +24% vs last month
                </span>
            </div>
            <!-- Stat 3 -->
            <div class="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                <span class="text-xs uppercase font-mono tracking-widest text-slate-500 font-bold">Active Submissions</span>
                <span class="block text-3xl font-extrabold text-white mt-2">42</span>
                <span class="text-[10px] text-amber-400 flex items-center gap-1 mt-2">
                    <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    15 pending review
                </span>
            </div>
            <!-- Stat 4 -->
            <div class="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                <span class="text-xs uppercase font-mono tracking-widest text-slate-500 font-bold">Platform Status</span>
                <span class="block text-3xl font-extrabold text-emerald-400 mt-2">Healthy</span>
                <span class="text-[10px] text-slate-500 flex items-center gap-1 mt-2 font-mono uppercase">
                    Tomcat 9.0 Active
                </span>
            </div>
        </section>

        <!-- Courses Management Data Table -->
        <section class="space-y-6">
            <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-white tracking-tight flex items-center gap-2">
                    <span class="h-2 w-2 rounded-full bg-rose-500"></span>
                    Manage Course Catalog
                </h2>
                <span class="text-xs font-mono text-slate-400">Records Loaded: <%= allCourses.size() %></span>
            </div>

            <!-- Table Card -->
            <div class="bg-slate-900/40 border border-slate-800/80 rounded-2xl shadow-xl overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="border-b border-slate-800 bg-slate-950/60 text-slate-400 text-xs font-mono uppercase tracking-wider">
                                <th class="py-4 px-6 font-semibold">Course Title</th>
                                <th class="py-4 px-6 font-semibold hidden md:table-cell">Description</th>
                                <th class="py-4 px-6 font-semibold">Instructor</th>
                                <th class="py-4 px-6 font-semibold text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800/60 text-sm text-slate-300">
                            <% if (allCourses.isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="text-center py-12 text-slate-500 font-mono text-xs">
                                        No courses defined in system catalog database.
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (Course course : allCourses) { %>
                                    <tr class="hover:bg-slate-900/30 transition-colors">
                                        <!-- Title -->
                                        <td class="py-4 px-6 font-semibold text-white">
                                            <div class="flex flex-col">
                                                <span><%= course.getTitle() %></span>
                                                <span class="text-[10px] text-slate-500 font-mono mt-0.5">ID: <%= course.getId() %></span>
                                            </div>
                                        </td>
                                        <!-- Description -->
                                        <td class="py-4 px-6 hidden md:table-cell max-w-xs truncate text-slate-400">
                                            <%= course.getDescription() %>
                                        </td>
                                        <!-- Instructor -->
                                        <td class="py-4 px-6 font-medium">
                                            <span class="inline-flex items-center px-2 py-1 rounded bg-slate-950 border border-slate-800 text-xs font-mono text-slate-400">
                                                <%= course.getInstructorName() %>
                                            </span>
                                        </td>
                                        <!-- Actions -->
                                        <td class="py-4 px-6 text-right">
                                            <div class="inline-flex gap-2">
                                                <button class="p-2 bg-slate-950 hover:bg-indigo-600 hover:text-white border border-slate-800 hover:border-indigo-500 rounded-lg text-slate-400 transition-all text-xs font-bold font-mono">
                                                    Modules
                                                </button>
                                                <button class="p-2 bg-slate-950 hover:bg-rose-600 hover:text-white border border-slate-800 hover:border-rose-500 rounded-lg text-slate-400 transition-all text-xs font-bold font-mono">
                                                    Edit
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

    </main>

    <!-- Footer -->
    <footer class="py-6 border-t border-slate-900 bg-slate-950 relative z-10 text-center text-xs text-slate-600">
        &copy; 2026 Online LMS Portal. Secured admin administrator console session.
    </footer>

</body>
</html>
