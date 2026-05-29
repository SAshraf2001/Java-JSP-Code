// script.js - Frontend Validations and Interactions

// --- Authentication Page Methods ---
function validateLogin() {
    let email = document.getElementById("loginEmail").value.trim();
    let password = document.getElementById("loginPassword").value.trim();
    let isValid = true;

    if (email === "" || !email.includes("@")) {
        document.getElementById("loginEmailError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("loginEmailError").classList.add("d-none");
    }

    if (password === "") {
        document.getElementById("loginPasswordError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("loginPasswordError").classList.add("d-none");
    }

    return isValid;
}

function validateRegister() {
    let name = document.getElementById("regName").value.trim();
    let email = document.getElementById("regEmail").value.trim();
    let password = document.getElementById("regPassword").value.trim();
    let isValid = true;

    if (name === "") {
        document.getElementById("regNameError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("regNameError").classList.add("d-none");
    }

    if (email === "" || !email.includes("@")) {
        document.getElementById("regEmailError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("regEmailError").classList.add("d-none");
    }

    if (password.length < 6) {
        document.getElementById("regPasswordError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("regPasswordError").classList.add("d-none");
    }

    return isValid;
}

// --- Admin Dashboard Methods ---
function openEditUserModal(userID, name, email, contactNo) {
    document.getElementById("editUserID").value = userID;
    document.getElementById("editName").value = name;
    document.getElementById("editEmail").value = email;
    document.getElementById("editContact").value = contactNo;
    
    let modal = new bootstrap.Modal(document.getElementById('editUserModal'));
    modal.show();
}

function confirmAction(message, url) {
    if (confirm(message)) {
        window.location.href = url;
    }
}

function openCreatePlanModal() {
    let modal = new bootstrap.Modal(document.getElementById('createPlanModal'));
    modal.show();
}

function validatePlanForm() {
    let duration = document.getElementById("planDuration").value;
    let price = document.getElementById("planPrice").value;
    let isValid = true;

    if (duration <= 0) {
        document.getElementById("durationError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("durationError").classList.add("d-none");
    }

    if (price <= 0) {
        document.getElementById("priceError").classList.remove("d-none");
        isValid = false;
    } else {
        document.getElementById("priceError").classList.add("d-none");
    }

    return isValid;
}

function approveSubscription(subID) {
    window.location.href = "SubscriptionApproveServlet?id=" + subID;
}

// --- Member Dashboard Methods ---
function populatePaymentModal(planID, planName, price) {
    document.getElementById("payPlanID").value = planID;
    document.getElementById("payPlanName").innerText = planName;
    document.getElementById("payPrice").innerText = "$" + parseFloat(price).toFixed(2);
    
    let modal = new bootstrap.Modal(document.getElementById('paymentModal'));
    modal.show();
}

function simulatePaymentProcessing(button) {
    // Disable button and show processing text
    button.disabled = true;
    let originalText = button.innerHTML;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Processing...';
    
    // Simulate network delay of 1.5 seconds before submission
    setTimeout(() => {
        document.getElementById("paymentForm").submit();
    }, 1500);
}
