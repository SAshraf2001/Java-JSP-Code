<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Online LMS</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <c:choose>
              <c:when test="${sessionScope.role == 'Admin'}">
                  <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
              </c:when>
              <c:when test="${sessionScope.role == 'Instructor'}">
                  <a class="nav-link" href="${pageContext.request.contextPath}/instructor/dashboard">Dashboard</a>
              </c:when>
              <c:when test="${sessionScope.role == 'Student'}">
                  <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a>
              </c:when>
          </c:choose>
        </li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <i class="bi bi-person-circle"></i> ${sessionScope.user.name} (${sessionScope.role})
          </a>
          <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Logout</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
