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
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
