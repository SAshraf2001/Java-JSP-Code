<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gym Membership System - Welcome</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="css/style.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="auth-bg">

<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="glass-card auth-card p-5">
        <h2 class="text-center mb-4 text-white fw-bold">GymSystem</h2>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" role="alert">${param.error}</div>
        </c:if>
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success" role="alert">${param.msg}</div>
        </c:if>

        <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active rounded-pill px-4" id="pills-login-tab" data-bs-toggle="pill" data-bs-target="#pills-login" type="button" role="tab">Login</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4" id="pills-register-tab" data-bs-toggle="pill" data-bs-target="#pills-register" type="button" role="tab">Register</button>
            </li>
        </ul>

        <div class="tab-content" id="pills-tabContent">
            <!-- Login Form -->
            <div class="tab-pane fade show active" id="pills-login" role="tabpanel">
                <form action="LoginServlet" method="POST" onsubmit="return validateLogin()">
                    <div class="mb-3">
                        <label class="form-label text-white">Email Address</label>
                        <input type="email" class="form-control glass-input" id="loginEmail" name="email">
                        <div class="text-danger small d-none" id="loginEmailError">Please enter a valid email.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white">Password</label>
                        <input type="password" class="form-control glass-input" id="loginPassword" name="password">
                        <div class="text-danger small d-none" id="loginPasswordError">Password cannot be empty.</div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 rounded-pill mt-3 py-2 fw-bold btn-animate">Login</button>
                </form>
            </div>

            <!-- Register Form -->
            <div class="tab-pane fade" id="pills-register" role="tabpanel">
                <form action="RegisterServlet" method="POST" onsubmit="return validateRegister()">
                    <div class="mb-3">
                        <label class="form-label text-white">Full Name</label>
                        <input type="text" class="form-control glass-input" id="regName" name="name">
                        <div class="text-danger small d-none" id="regNameError">Name cannot be empty.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white">Email Address</label>
                        <input type="email" class="form-control glass-input" id="regEmail" name="email">
                        <div class="text-danger small d-none" id="regEmailError">Please enter a valid email.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white">Contact No</label>
                        <input type="text" class="form-control glass-input" id="regContact" name="contactNo">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white">Password</label>
                        <input type="password" class="form-control glass-input" id="regPassword" name="password">
                        <div class="text-danger small d-none" id="regPasswordError">Password must be at least 6 characters.</div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 rounded-pill mt-3 py-2 fw-bold btn-animate">Register</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="js/script.js"></script>
</body>
</html>
