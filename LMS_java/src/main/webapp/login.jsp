<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-950">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Online LMS Portal</title>
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
<body class="h-full flex flex-col justify-between text-slate-200 antialiased relative overflow-hidden">

    <!-- Gradient Ambient Background Orbs -->
    <div class="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-indigo-600/10 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[500px] h-[500px] bg-violet-600/10 rounded-full blur-[120px] pointer-events-none"></div>

    <!-- Main Section -->
    <main class="flex-grow flex items-center justify-center px-4 sm:px-6 lg:px-8 relative z-10 py-12">
        <div class="max-w-md w-full space-y-8">
            <!-- Brand Logotype Header -->
            <div class="text-center">
                <div class="mx-auto h-12 w-12 rounded-2xl bg-gradient-to-tr from-indigo-500 to-violet-500 flex items-center justify-center shadow-lg shadow-indigo-500/20">
                    <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                    </svg>
                </div>
                <h2 class="mt-6 text-3xl font-extrabold tracking-tight text-white sm:text-4xl">
                    Online Learning Management
                </h2>
                <p class="mt-2 text-sm text-slate-400">
                    Sign in to your learning dashboard portal
                </p>
            </div>

            <!-- Login Card Container -->
            <div class="bg-slate-900/60 backdrop-blur-xl border border-slate-800/80 rounded-2xl p-8 shadow-2xl shadow-slate-950/50">
                
                <!-- Dynamic Error Notification System -->
                <%
                    String error = (String) request.getAttribute("errorMessage");
                    if (error != null) {
                %>
                    <div class="flex items-center gap-3 bg-rose-500/10 border border-rose-500/25 text-rose-300 p-4 rounded-xl text-sm mb-6 animate-pulse">
                        <svg class="h-5 w-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                        </svg>
                        <span><%= error %></span>
                    </div>
                <%
                    }
                %>

                <form class="space-y-6" action="login" method="POST">
                    <div>
                        <label for="email" class="block text-xs font-semibold uppercase tracking-wider text-slate-400">Email Address</label>
                        <div class="mt-1 relative">
                            <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500">
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.206"></path>
                                </svg>
                            </span>
                            <input id="email" name="email" type="email" autocomplete="email" required 
                                class="block w-full pl-11 pr-4 py-3 bg-slate-950/60 border border-slate-800 rounded-xl text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 focus:border-indigo-500/80 transition-all text-sm" 
                                placeholder="name@example.com">
                        </div>
                    </div>

                    <div>
                        <label for="password" class="block text-xs font-semibold uppercase tracking-wider text-slate-400">Password</label>
                        <div class="mt-1 relative">
                            <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500">
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                                </svg>
                            </span>
                            <input id="password" name="password" type="password" autocomplete="current-password" required 
                                class="block w-full pl-11 pr-4 py-3 bg-slate-950/60 border border-slate-800 rounded-xl text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 focus:border-indigo-500/80 transition-all text-sm" 
                                placeholder="••••••••">
                        </div>
                    </div>

                    <div class="flex items-center justify-between">
                        <div class="flex items-center">
                            <input id="remember-me" name="remember-me" type="checkbox" 
                                class="h-4 w-4 text-indigo-600 focus:ring-indigo-500/40 border-slate-800 rounded bg-slate-950">
                            <label for="remember-me" class="ml-2 block text-xs text-slate-400">
                                Remember my device
                            </label>
                        </div>
                        <div class="text-xs">
                            <a href="#" class="font-medium text-indigo-400 hover:text-indigo-300 transition-colors">Forgot password?</a>
                        </div>
                    </div>

                    <div>
                        <button type="submit" 
                            class="group relative w-full flex justify-center py-3.5 px-4 border border-transparent text-sm font-semibold rounded-xl text-white bg-gradient-to-r from-indigo-500 to-violet-500 hover:from-indigo-600 hover:to-violet-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500/60 transition-all shadow-md shadow-indigo-500/10 active:scale-[0.98]">
                            Sign In to Portal
                        </button>
                    </div>
                </form>

                <!-- Seed info cards for local development testing -->
                <div class="mt-8 pt-6 border-t border-slate-800/80">
                    <p class="text-[10px] text-slate-500 text-center font-mono uppercase tracking-wider mb-3">Dev Test Accounts</p>
                    <div class="grid grid-cols-2 gap-3 text-xs">
                        <div class="p-2.5 bg-slate-950/40 rounded-lg border border-slate-800/50 text-slate-400">
                            <span class="block font-bold text-indigo-400 mb-0.5">Instructor Portal</span>
                            <span class="block font-mono text-[10px]">instructor@lms.com</span>
                            <span class="block font-mono text-[10px]">pass: password123</span>
                        </div>
                        <div class="p-2.5 bg-slate-950/40 rounded-lg border border-slate-800/50 text-slate-400">
                            <span class="block font-bold text-emerald-400 mb-0.5">Student Portal</span>
                            <span class="block font-mono text-[10px]">student@lms.com</span>
                            <span class="block font-mono text-[10px]">pass: password123</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <!-- Simple Footer -->
    <footer class="py-4 border-t border-slate-900/60 relative z-10 text-center text-xs text-slate-600">
        &copy; 2026 Online LMS Portal. All rights reserved. Powered by Java MVC (Servlets, JDBC, JSP) &amp; Tailwind.
    </footer>

</body>
</html>
