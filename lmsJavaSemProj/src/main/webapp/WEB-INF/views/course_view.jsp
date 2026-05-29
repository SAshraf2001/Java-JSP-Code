<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="container main-container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">${course.title}</li>
        </ol>
    </nav>

    <div class="row mb-4">
        <div class="col-12">
            <h2>${course.title}</h2>
            <p class="text-muted lead">${course.description}</p>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <c:if test="${empty modules}">
                <div class="alert alert-info">Your instructor hasn't added any content to this course yet!</div>
            </c:if>

            <div class="accordion" id="courseAccordion">
                <c:forEach var="module" items="${modules}" varStatus="status">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading${module.moduleId}">
                            <button class="accordion-button ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${module.moduleId}" aria-expanded="${status.first ? 'true' : 'false'}" aria-controls="collapse${module.moduleId}">
                                Module ${module.sequenceOrder}: ${module.title}
                            </button>
                        </h2>
                        <div id="collapse${module.moduleId}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" aria-labelledby="heading${module.moduleId}" data-bs-parent="#courseAccordion">
                            <div class="accordion-body p-0">
                                <ul class="list-group list-group-flush">
                                    <c:set var="lessons" value="${lessonsMap[module.moduleId]}" />
                                    <c:forEach var="lesson" items="${lessons}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                                            <div>
                                                <i class="bi bi-file-earmark-text text-primary me-2"></i>
                                                <strong>Lesson ${lesson.sequenceOrder}:</strong> ${lesson.title}
                                            </div>
                                            <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#lessonModal${lesson.lessonId}">
                                                View Content
                                            </button>
                                        </li>

                                        <!-- Lesson Modal -->
                                        <div class="modal fade" id="lessonModal${lesson.lessonId}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">${lesson.title} <span class="badge bg-secondary ms-2">${lesson.contentType}</span></h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body p-4">
                                                        <c:choose>
                                                            <c:when test="${lesson.contentType == 'Video'}">
                                                                <div class="ratio ratio-16x9 bg-dark mb-3">
                                                                    <!-- Assuming content is a YouTube embed URL -->
                                                                    <iframe src="${lesson.content}" allowfullscreen></iframe>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="lesson-text-content">
                                                                    ${lesson.content}
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Mark as Complete</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty lessons}">
                                        <li class="list-group-item text-muted p-3">No lessons in this module.</li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- ASSIGNMENTS SECTION -->
            <h4 class="mt-5 mb-3">Assignments</h4>
            <c:if test="${empty assignments}">
                <div class="alert alert-secondary">No assignments posted for this course yet.</div>
            </c:if>
            <div class="list-group mb-5">
                <c:forEach var="assignment" items="${assignments}">
                    <c:set var="submission" value="${mySubmissions[assignment.assignmentId]}" />
                    
                    <div class="list-group-item p-4">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="me-auto">
                                <h5 class="fw-bold text-primary mb-1">${assignment.title}</h5>
                                <p class="mb-2">${assignment.description}</p>
                                <p class="mb-1 text-danger small"><i class="bi bi-calendar-event"></i> Due: ${assignment.dueDate != null ? assignment.dueDate : 'No due date'} | Max Score: ${assignment.maxScore}</p>
                                
                                <c:choose>
                                    <c:when test="${not empty submission}">
                                        <hr>
                                        <div class="bg-light p-3 rounded">
                                            <p class="mb-1"><strong>Your Submission:</strong> <a href="${submission.filePath}" target="_blank">${submission.filePath}</a></p>
                                            <p class="mb-1"><strong>Status:</strong> 
                                                <c:choose>
                                                    <c:when test="${submission.score != null}">
                                                        <span class="badge bg-success">Graded</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">Submitted, Pending Grade</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <c:if test="${submission.score != null}">
                                                <p class="mb-1"><strong>Score:</strong> ${submission.score} / ${assignment.maxScore}</p>
                                            </c:if>
                                            <c:if test="${not empty submission.feedback}">
                                                <p class="mb-0"><strong>Feedback:</strong> <em>${submission.feedback}</em></p>
                                            </c:if>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>
                            
                            <c:if test="${empty submission or submission.score == null}">
                                <button class="btn btn-warning ms-3" data-bs-toggle="modal" data-bs-target="#submitAssignmentModal${assignment.assignmentId}">
                                    ${empty submission ? 'Submit Assignment' : 'Update Submission'}
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <!-- Submit Assignment Modal -->
                    <div class="modal fade" id="submitAssignmentModal${assignment.assignmentId}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Submit: ${assignment.title}</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <form action="${pageContext.request.contextPath}/student/dashboard" method="post" id="formSubmit${assignment.assignmentId}">
                                        <input type="hidden" name="action" value="submitAssignment">
                                        <input type="hidden" name="courseId" value="${course.courseId}">
                                        <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
                                        
                                        <div class="alert alert-info small">
                                            Please provide a link to your completed work (e.g., Google Drive link, GitHub repository, or YouTube video). Make sure the link is public or shared with your instructor.
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Submission Link (URL)</label>
                                            <input type="url" class="form-control" name="submissionLink" value="${not empty submission ? submission.filePath : ''}" placeholder="https://..." required>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" form="formSubmit${assignment.assignmentId}" class="btn btn-primary">Submit Work</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
