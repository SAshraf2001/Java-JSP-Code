<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'Member'}">
    <c:redirect url="index.jsp" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - GymSystem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dashboard-bg">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark glass-nav">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">GymSystem</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hello, ${user.name}</span>
            <button class="btn btn-outline-info btn-sm rounded-pill px-3 me-2" data-bs-toggle="modal" data-bs-target="#settingsModal">Settings</button>
            <a href="LogoutServlet" class="btn btn-outline-light btn-sm rounded-pill px-3">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    
    <!-- Profile & Status -->
    <div class="glass-card p-4 rounded-4 mb-5 shadow-lg d-flex justify-content-between align-items-center">
        <div>
            <h3 class="text-white mb-1 fw-bold">My Subscription</h3>
            <p class="text-light opacity-75 mb-0">Manage your gym access and plans</p>
        </div>
        <div class="text-end">
            <c:choose>
                <c:when test="${not empty currentSub}">
                    <h5 class="text-white mb-2">Current Plan: <span class="text-warning">${currentSub.planName}</span></h5>
                    <div class="badge ${currentSub.status == 'Active' ? 'bg-success' : 'bg-danger'} fs-6 px-3 py-2 rounded-pill mb-2">
                        Status: ${currentSub.status}
                    </div>
                    <div class="text-light small mb-3">Valid until: ${currentSub.endDate}</div>
                    <form action="CheckInServlet" method="POST">
                        <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold">Check-In Today</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="badge bg-secondary fs-6 px-3 py-2 rounded-pill">No Active Subscription</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <h3 class="text-white mb-4 fw-bold">Available Plans</h3>
    <div class="row g-4 mb-5">
        <c:forEach var="p" items="${plans}">
            <div class="col-md-4">
                <div class="card h-100 bg-dark text-white border-0 glass-card premium-card">
                    <div class="card-body p-4 d-flex flex-column">
                        <h4 class="card-title fw-bold text-warning">${p.planName}</h4>
                        <h2 class="my-3 fw-bold">$${p.price} <span class="fs-6 text-muted fw-normal">/ ${p.durationMonths} Months</span></h2>
                        <p class="card-text flex-grow-1 opacity-75">${p.description}</p>
                        <button class="btn btn-primary rounded-pill fw-bold w-100 py-2 mt-3 btn-animate" 
                                onclick="populatePaymentModal(${p.planID}, '${p.planName}', ${p.price})">Select Plan</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Classes Section -->
    <h3 class="text-white mb-4 fw-bold">Upcoming Classes</h3>
    <div class="row g-4 mb-5">
        <c:forEach var="c" items="${classes}">
            <div class="col-md-4">
                <div class="card h-100 bg-dark text-white border-0 glass-card">
                    <div class="card-body p-4 d-flex flex-column">
                        <h5 class="card-title fw-bold text-info">${c.className}</h5>
                        <p class="mb-1 text-muted">Trainer: <span class="text-light">${c.trainerName}</span></p>
                        <p class="mb-1 text-muted">Time: <span class="text-light">${c.scheduleTime}</span></p>
                        <p class="mb-3 text-muted">Spots: <span class="text-light">${c.capacity - c.bookedCount} left</span></p>
                        <form action="BookClassServlet" method="POST" class="mt-auto">
                            <input type="hidden" name="classID" value="${c.classID}">
                            <button type="submit" class="btn btn-outline-info rounded-pill fw-bold w-100 py-2" 
                                ${c.bookedCount >= c.capacity ? 'disabled' : ''}>
                                ${c.bookedCount >= c.capacity ? 'Class Full' : 'Book Spot'}
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="glass-card p-4 rounded-4 shadow-lg mb-5">
        <h4 class="text-white mb-4 fw-bold">Payment History</h4>
        <div class="table-responsive">
            <table class="table table-dark table-hover align-middle custom-table">
                <thead>
                    <tr>
                        <th>Date</th><th>Plan</th><th>Amount</th><th>Method</th><th>Receipt ID</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pay" items="${payments}">
                        <tr>
                            <td>${pay.paymentDate}</td>
                            <td>${pay.planName}</td>
                            <td>$${pay.amount}</td>
                            <td><span class="badge bg-secondary">${pay.paymentMethod}</span></td>
                            <td class="font-monospace text-muted">#RCPT-${pay.paymentID}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty payments}">
                        <tr><td colspan="5" class="text-center text-muted py-4">No payment history found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title fw-bold">Checkout</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="paymentForm" action="PaymentServlet" method="POST">
                <input type="hidden" name="planID" id="payPlanID">
                <div class="modal-body">
                    <div class="p-3 bg-secondary bg-opacity-25 rounded-3 mb-4 text-center border border-secondary border-opacity-50">
                        <h4 id="payPlanName" class="text-warning mb-1">Plan Name</h4>
                        <h2 id="payPrice" class="mb-0 fw-bold">$0.00</h2>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Payment Method</label>
                        <select class="form-select bg-secondary text-white border-0 py-2" name="paymentMethod" required>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="PayPal">PayPal</option>
                            <option value="Cash (On Site)">Cash (On Site)</option>
                        </select>
                    </div>
                    <!-- Mock Card Details -->
                    <div class="mb-3">
                        <label class="form-label text-light">Card Number (Mock)</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" placeholder="XXXX XXXX XXXX XXXX">
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary rounded-pill px-5 fw-bold btn-animate" id="payNowBtn" onclick="simulatePaymentProcessing(this)">Pay Now</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Settings Modal -->
<div class="modal fade" id="settingsModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white glass-modal">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title fw-bold">Account Settings</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="UpdateProfileServlet" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-light">Full Name</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="name" value="${user.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Contact Number</label>
                        <input type="text" class="form-control bg-secondary text-white border-0 py-2" name="contactNo" value="${user.contactNo}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-light">Email Address (Read-Only)</label>
                        <input type="email" class="form-control bg-secondary text-white border-0 py-2" value="${user.email}" readonly>
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-info rounded-pill px-4 fw-bold">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
