<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'Admin'}">
    <c:redirect url="index.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - GymSystem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dashboard-bg">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark glass-nav">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">GymSystem Admin</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Welcome, ${user.name}</span>
            <a href="LogoutServlet" class="btn btn-outline-light btn-sm rounded-pill px-3">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
        <!-- Analytics Cards -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="glass-card p-4 rounded-4 text-center">
                    <h5 class="text-muted mb-2">Active Members</h5>
                    <h2 class="text-white fw-bold">${activeMembers}</h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 rounded-4 text-center">
                    <h5 class="text-muted mb-2">Monthly Revenue</h5>
                    <h2 class="text-success fw-bold">$${monthlyRevenue}</h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 rounded-4 text-center">
                    <h5 class="text-muted mb-2">Total Classes</h5>
                    <h2 class="text-info fw-bold">${totalClasses}</h2>
                </div>
            </div>
        </div>

        <ul class="nav nav-pills mb-4" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active rounded-pill px-4" data-bs-toggle="pill" data-bs-target="#users">Users</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4 mx-2" data-bs-toggle="pill" data-bs-target="#plans">Plans</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4" data-bs-toggle="pill" data-bs-target="#subscriptions">Subscriptions</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4 mx-2" data-bs-toggle="pill" data-bs-target="#classes">Classes</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4" data-bs-toggle="pill" data-bs-target="#attendance">Attendance</button>
            </li>
        </ul>

    <div class="tab-content" id="adminTabsContent">
        <!-- Users Tab -->
        <div class="tab-pane fade show active glass-card p-4 rounded-3" id="users">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-white">User Management</h4>
                <button class="btn btn-success rounded-pill fw-bold px-4 btn-animate" data-bs-toggle="modal" data-bs-target="#addUserModal">+ Add User</button>
            </div>
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle custom-table">
                    <thead>
                        <tr>
                            <th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Contact</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.userID}</td>
                                <td>${u.name}</td>
                                <td>${u.email}</td>
                                <td><span class="badge bg-info">${u.role}</span></td>
                                <td>${u.contactNo}</td>
                                <td>
                                    <button class="btn btn-sm btn-primary rounded-pill px-3 me-2 btn-animate" 
                                            onclick="openEditUserModal(${u.userID}, '${u.name}', '${u.email}', '${u.contactNo}')">Edit</button>
                                    <c:if test="${u.role ne 'Admin'}">
                                        <button class="btn btn-sm btn-danger rounded-pill px-3 btn-animate" 
                                                onclick="confirmAction('Are you sure you want to disable this user?', 'UserManageServlet?action=disable&id=${u.userID}')">Disable</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Plans Tab -->
        <div class="tab-pane fade glass-card p-4 rounded-3" id="plans">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-white">Membership Plans</h4>
                <button class="btn btn-success rounded-pill fw-bold px-4 btn-animate" onclick="openCreatePlanModal()">+ Create Plan</button>
            </div>
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle custom-table">
                    <thead>
                        <tr>
                            <th>ID</th><th>Plan Name</th><th>Duration (Months)</th><th>Price ($)</th><th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${plans}">
                            <tr>
                                <td>${p.planID}</td>
                                <td><span class="fw-bold text-warning">${p.planName}</span></td>
                                <td>${p.durationMonths}</td>
                                <td>$${p.price}</td>
                                <td>${p.description}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Subscriptions Tab -->
        <div class="tab-pane fade glass-card p-4 rounded-3" id="subscriptions">
            <h4 class="text-white mb-3">All Subscriptions</h4>
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle custom-table">
                    <thead>
                        <tr>
                            <th>Sub ID</th><th>User</th><th>Plan</th><th>Start Date</th><th>End Date</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${subscriptions}">
                            <tr>
                                <td>${s.subID}</td>
                                <td>${s.userName}</td>
                                <td>${s.planName}</td>
                                <td>${s.startDate}</td>
                                <td>${s.endDate}</td>
                                <td>
                                    <span class="badge bg-${s.status == 'Active' ? 'success' : (s.status == 'Pending' ? 'warning' : 'danger')}">${s.status}</span>
                                </td>
                                <td>
                                    <c:if test="${s.status == 'Pending'}">
                                        <button class="btn btn-sm btn-success rounded-pill px-3 btn-animate" onclick="approveSubscription(${s.subID})">Approve</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
            
        <!-- Classes Tab -->
        <div class="tab-pane fade" id="classes" role="tabpanel">
                <div class="glass-card p-4 rounded-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="text-white fw-bold mb-0">Manage Classes</h4>
                        <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addClassModal">+ Add Class</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-dark table-hover custom-table">
                            <thead>
                                <tr><th>ID</th><th>Class Name</th><th>Trainer</th><th>Schedule</th><th>Booked / Capacity</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${gymClasses}">
                                    <tr>
                                        <td>${c.classID}</td>
                                        <td class="text-warning fw-bold">${c.className}</td>
                                        <td>${c.trainerName}</td>
                                        <td>${c.scheduleTime}</td>
                                        <td>${c.bookedCount} / ${c.capacity}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <h5 class="text-white mt-5 fw-bold mb-3">Recent Bookings</h5>
                    <div class="table-responsive">
                        <table class="table table-dark table-hover custom-table">
                            <thead>
                                <tr><th>Booking ID</th><th>Member</th><th>Class Name</th><th>Schedule Time</th><th>Booking Time</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${recentBookings}">
                                    <tr>
                                        <td>${b.bookingID}</td>
                                        <td class="text-info">${b.userName}</td>
                                        <td>${b.className}</td>
                                        <td>${b.classTime}</td>
                                        <td>${b.bookingTime}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Attendance Tab -->
            <div class="tab-pane fade" id="attendance" role="tabpanel">
                <div class="glass-card p-4 rounded-4">
                    <h4 class="text-white mb-4 fw-bold">Today's Check-ins</h4>
                    <div class="table-responsive">
                        <table class="table table-dark table-hover custom-table">
                            <thead>
                                <tr><th>Log ID</th><th>Member Name</th><th>Check-in Time</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${todayAttendance}">
                                    <tr>
                                        <td>${a.attendanceID}</td>
                                        <td class="text-info">${a.userName}</td>
                                        <td>${a.checkInTime}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Class Modal -->
<div class="modal fade" id="addClassModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title fw-bold">Add New Class</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="ClassManageServlet" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-light">Class Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="className" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Trainer Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="trainerName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Schedule Time</label>
                        <input type="datetime-local" class="form-control bg-secondary text-white border-0 py-2" name="scheduleTime" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Capacity</label>
                        <input type="number" class="form-control bg-secondary text-white border-0 py-2" name="capacity" required>
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Add Class</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title">Edit User</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="UserManageServlet" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="userID" id="editUserID">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0" id="editName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control bg-secondary text-white border-0" id="editEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contact No</label>
                        <input type="text" class="form-control bg-secondary text-white border-0" id="editContact" name="contactNo">
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary rounded-pill btn-animate">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Create Plan Modal -->
<div class="modal fade" id="createPlanModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title">Create New Plan</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="PlanManageServlet" method="POST" onsubmit="return validatePlanForm()">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Plan Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0" id="planName" name="planName" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Duration (Months)</label>
                            <input type="number" class="form-control bg-secondary text-white border-0" id="planDuration" name="durationMonths" required>
                            <div class="text-danger small d-none" id="durationError">Must be > 0</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Price ($)</label>
                            <input type="number" step="0.01" class="form-control bg-secondary text-white border-0" id="planPrice" name="price" required>
                            <div class="text-danger small d-none" id="priceError">Must be > 0</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control bg-secondary text-white border-0" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-success rounded-pill btn-animate">Create Plan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title fw-bold">Add New User</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="UserManageServlet" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-light">Full Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Email Address</label>
                        <input type="email" class="form-control bg-secondary text-white border-0 py-2" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Password</label>
                        <input type="password" class="form-control bg-secondary text-white border-0 py-2" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Role</label>
                        <select class="form-select bg-secondary text-white border-0 py-2" name="role" required>
                            <option value="Member">Member</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Contact No</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="contactNo">
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Add User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
