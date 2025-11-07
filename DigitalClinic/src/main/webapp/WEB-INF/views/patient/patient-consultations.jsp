<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title} - DigitalClinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <!-- Simple Header -->
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-video me-2"></i>My Video Consultations</h2>
                <p class="text-muted">Manage your video consultations with doctors</p>
            </div>
        </div>

        <!-- Debug Info -->
        <div class="alert alert-info">
            <h6>Debug Information:</h6>
            <p>User: ${user.fullName}</p>
            <p>Patient: ${patient.firstName} ${patient.lastName}</p>
            <p>Consultations Count: ${consultations.size()}</p>
        </div>

        <!-- Check if consultations exist -->
        <c:choose>
            <c:when test="${empty consultations}">
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-video-slash fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No Video Consultations</h4>
                                <p class="text-muted">You don't have any video consultations scheduled yet.</p>
                                <a href="/appointments" class="btn btn-primary">
                                    <i class="fas fa-calendar-plus me-2"></i>Book an Appointment
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row mt-4">
                    <c:forEach var="consultation" items="${consultations}">
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <strong>Room: ${consultation.roomId}</strong>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title">
                                        Consultation #${consultation.id}
                                    </h6>
                                    <p class="card-text">
                                        Status: <span class="badge bg-info">${consultation.status}</span>
                                    </p>
                                    <p class="card-text">
                                        Scheduled: ${consultation.scheduledStartTime}
                                    </p>
                                </div>
                                <div class="card-footer">
                                    <a href="/video-call/patient/${consultation.roomId}" class="btn btn-primary btn-sm">
                                        Join Consultation
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>