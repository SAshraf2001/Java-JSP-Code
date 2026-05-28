<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="container main-container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/instructor/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">Manage ${course.title}</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2>Manage: ${course.title}</h2>
            <span class="badge ${course.status == 'Published' ? 'bg-success' : 'bg-warning'}">${course.status}</span>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
            <i class="bi bi-plus-circle"></i> Add Module
        </button>
    </div>

    <div class="row">
        <div class="col-12">
            <c:if test="${empty modules}">
                <div class="alert alert-warning text-center p-5">
                    <h5>No modules found for this course!</h5>
                    <p class="mb-0">Start by creating your first module using the button above.</p>
                </div>
            </c:if>

            <c:forEach var="module" items="${modules}">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Module ${module.sequenceOrder}: ${module.title}</h5>
                        <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#addLessonModal${module.moduleId}">
                            <i class="bi bi-plus"></i> Add Lesson
                        </button>
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:set var="lessons" value="${lessonsMap[module.moduleId]}" />
                        <c:forEach var="lesson" items="${lessons}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="bi bi-grip-vertical text-muted me-2"></i>
                                    <strong>Lesson ${lesson.sequenceOrder}:</strong> ${lesson.title}
                                    <span class="badge bg-secondary ms-2">${lesson.contentType}</span>
                                </div>
                            </li>
                        </c:forEach>
                        <c:if test="${empty lessons}">
                            <li class="list-group-item text-muted fst-italic">No lessons added to this module yet.</li>
                        </c:if>
                    </ul>
                </div>

                <!-- Add Lesson Modal for this Module -->
                <div class="modal fade" id="addLessonModal${module.moduleId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Add Lesson to Module ${module.sequenceOrder}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <form action="${pageContext.request.contextPath}/instructor/course" method="post" id="formLesson${module.moduleId}">
                                    <input type="hidden" name="action" value="addLesson">
                                    <input type="hidden" name="courseId" value="${course.courseId}">
                                    <input type="hidden" name="moduleId" value="${module.moduleId}">
                                    <div class="mb-3">
                                        <label class="form-label">Lesson Title</label>
                                        <input type="text" class="form-control" name="title" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Content Type</label>
                                        <select class="form-select" name="contentType" required>
                                            <option value="Text">Text</option>
                                            <option value="Video">Video Embed (YouTube URL)</option>
                                            <option value="Document">Document Link</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Sequence Order</label>
                                        <input type="number" class="form-control" name="sequenceOrder" value="1" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Lesson Content</label>
                                        <textarea class="form-control" name="content" rows="4" placeholder="Enter text, YouTube embed URL, or document link..." required></textarea>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" form="formLesson${module.moduleId}" class="btn btn-success">Save Lesson</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Add Module Modal -->
<div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Module</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/instructor/course" method="post" id="formModule">
                    <input type="hidden" name="action" value="addModule">
                    <input type="hidden" name="courseId" value="${course.courseId}">
                    <div class="mb-3">
                        <label class="form-label">Module Title</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Sequence Order (e.g. 1, 2, 3)</label>
                        <input type="number" class="form-control" name="sequenceOrder" value="1" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" form="formModule" class="btn btn-primary">Save Module</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
