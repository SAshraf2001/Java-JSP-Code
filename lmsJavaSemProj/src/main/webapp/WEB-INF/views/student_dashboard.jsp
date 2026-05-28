<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="container main-container">
    <h2 class="mb-4">Student Dashboard</h2>

    <%-- Session Messages --%>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <div class="row">
        <!-- Enrolled Courses -->
        <div class="col-lg-8">
            <h4 class="border-bottom pb-2 mb-3">My Courses</h4>
            <div class="row">
                <c:forEach var="course" items="${enrolledCourses}">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body">
                                <h5 class="card-title text-primary">${course.title}</h5>
                                <p class="card-text text-muted">${course.description}</p>
                            </div>
                            <div class="card-footer bg-white border-0">
                                <a href="${pageContext.request.contextPath}/student/course?id=${course.courseId}" class="btn btn-outline-primary w-100">Go to Course</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty enrolledCourses}">
                    <div class="col-12 text-center mt-4">
                        <p class="text-muted">You are not enrolled in any courses yet.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Available Courses Sidebar -->
        <div class="col-lg-4">
            <div class="bg-light p-4 rounded">
                <h4 class="border-bottom pb-2 mb-3">Available Courses</h4>
                <div class="list-group list-group-flush">
                    <c:forEach var="course" items="${allCourses}">
                        <%-- Small trick to check if already enrolled (for UI purpose) --%>
                        <c:set var="isEnrolled" value="false" />
                        <c:forEach var="enrolled" items="${enrolledCourses}">
                            <c:if test="${enrolled.courseId == course.courseId}">
                                <c:set var="isEnrolled" value="true" />
                            </c:if>
                        </c:forEach>

                        <div class="list-group-item bg-transparent">
                            <h6 class="mb-1">${course.title}</h6>
                            <small class="text-muted d-block mb-2">${course.description}</small>
                            <c:choose>
                                <c:when test="${isEnrolled}">
                                    <span class="badge bg-success">Enrolled</span>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/student/dashboard" method="post" class="input-group input-group-sm">
                                        <input type="hidden" name="action" value="enroll">
                                        <input type="hidden" name="courseId" value="${course.courseId}">
                                        <input type="text" name="enrollmentKey" class="form-control" placeholder="Enter Key" required>
                                        <button type="submit" class="btn btn-primary">Enroll</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                    <c:if test="${empty allCourses}">
                        <p class="text-muted small">No courses available.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
