<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="container main-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Instructor Dashboard</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createCourseModal">
            <i class="bi bi-plus-circle"></i> Create New Course
        </button>
    </div>

    <div class="row">
        <c:forEach var="course" items="${courses}">
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title">${course.title}</h5>
                        <p class="card-text text-muted">${course.description}</p>
                        <hr>
                        <p class="mb-1"><strong>Status:</strong> 
                            <span class="badge ${course.status == 'Published' ? 'bg-success' : 'bg-warning'}">
                                ${course.status}
                            </span>
                        </p>
                        <p class="mb-3"><strong>Key:</strong> <code>${course.enrollmentKey}</code></p>
                        
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/instructor/course?id=${course.courseId}" class="btn btn-outline-primary btn-sm">Manage Modules</a>
                            
                            <c:if test="${course.status == 'Draft'}">
                                <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post">
                                    <input type="hidden" name="action" value="publishCourse">
                                    <input type="hidden" name="courseId" value="${course.courseId}">
                                    <button type="submit" class="btn btn-success btn-sm w-100">Publish Course</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty courses}">
            <div class="col-12 text-center mt-5">
                <h4 class="text-muted">You haven't created any courses yet.</h4>
            </div>
        </c:if>
    </div>
</div>

<!-- Create Course Modal -->
<div class="modal fade" id="createCourseModal" tabindex="-1" aria-labelledby="createCourseModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="createCourseModalLabel">Create New Course</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post" id="createCourseForm">
            <input type="hidden" name="action" value="createCourse">
            <div class="mb-3">
                <label class="form-label">Course Title</label>
                <input type="text" class="form-control" name="title" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="description" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Enrollment Key (Password for students)</label>
                <input type="text" class="form-control" name="enrollmentKey" required>
            </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" form="createCourseForm" class="btn btn-primary">Create Course</button>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
