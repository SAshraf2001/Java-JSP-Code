<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="container main-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Admin Dashboard - User Management</h2>
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.name}</td>
                            <td>${user.email}</td>
                            <td>
                                <!-- Form to change role -->
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="changeRole">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <select name="newRole" class="form-select form-select-sm d-inline-block w-auto" onchange="this.form.submit()" ${user.userId == sessionScope.user.userId ? 'disabled' : ''}>
                                        <option value="Student" ${user.role == 'Student' ? 'selected' : ''}>Student</option>
                                        <option value="Instructor" ${user.role == 'Instructor' ? 'selected' : ''}>Instructor</option>
                                        <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <span class="badge ${user.active ? 'bg-success' : 'bg-danger'}">
                                    ${user.active ? 'Active' : 'Disabled'}
                                </span>
                            </td>
                            <td>
                                <!-- Form to toggle status -->
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <input type="hidden" name="currentStatus" value="${user.active}">
                                    <button type="submit" class="btn btn-sm ${user.active ? 'btn-outline-danger' : 'btn-outline-success'}" ${user.userId == sessionScope.user.userId ? 'disabled' : ''}>
                                        ${user.active ? 'Disable' : 'Enable'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
