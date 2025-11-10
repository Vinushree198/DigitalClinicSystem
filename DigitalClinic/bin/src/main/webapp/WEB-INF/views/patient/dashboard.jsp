<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            background-color: #f8f9fa;
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        .sidebar .nav-link {
            color: #333;
            padding: 12px 20px;
            border-radius: 5px;
            margin: 5px 0;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #007bff;
            color: white;
        }
        .stats-card {
            border-radius: 10px;
            transition: transform 0.3s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .appointment-card {
            border-left: 4px solid #007bff;
            transition: all 0.3s;
        }
        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .video-consult {
            border-left-color: #17a2b8;
        }
        .pod-visit {
            border-left-color: #28a745;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/dashboard">
                <i class="fas fa-clinic-medical"></i> Digital Clinic - Patient
            </a>
            <div class="navbar-nav ms-auto d-flex flex-row">
                <span class="navbar-text text-white me-3">
                    Welcome, ${user.fullName}
                </span>
                <a class="nav-link text-white" href="/patient/profile">
                    <i class="fas fa-user"></i> Profile
                </a>
                <a class="nav-link text-white" href="/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-0">
                <div class="p-3">
                    <h5 class="text-center">Patient Panel</h5>
                </div>
                <nav class="nav flex-column p-3">
                    <a class="nav-link active" href="/patient/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="/patient/profile">
                        <i class="fas fa-user me-2"></i> My Profile
                    </a>
                    <a class="nav-link" href="/appointments">
                        <i class="fas fa-calendar-check me-2"></i> Appointments
                    </a>
                    <a class="nav-link" href="/health-pods">
                        <i class="fas fa-map-marker-alt me-2"></i> Health Pods
                    </a>
                    <a class="nav-link" href="/video-call/patient/consultations">
                        <i class="fas fa-video me-2"></i> Video Consultations
                    </a>
                    <a class="nav-link" href="/prescriptions">
                        <i class="fas fa-file-prescription me-2"></i> Prescriptions
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ms-sm-auto px-4 py-4">
                <!-- Welcome Section -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h3 class="card-title">
                                    <i class="fas fa-heartbeat text-primary me-2"></i>
                                    Welcome back, ${user.fullName}!
                                </h3>
                                <p class="card-text">
                                    Access quality healthcare from the comfort of your village. 
                                    Book appointments, consult doctors online, and visit our health pods.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>
                                            <c:if test="${not empty appointments}">
                                                ${appointments.stream().filter(a -> a.upcoming).count()}
                                            </c:if>
                                            <c:if test="${empty appointments}">0</c:if>
                                        </h4>
                                        <p class="mb-0">Upcoming Appointments</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-calendar fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card text-white bg-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>
                                            <c:if test="${not empty appointments}">
                                                ${appointments.stream().filter(a -> a.completed).count()}
                                            </c:if>
                                            <c:if test="${empty appointments}">0</c:if>
                                        </h4>
                                        <p class="mb-0">Completed Consultations</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-video fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card text-white bg-warning">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>
                                            <c:if test="${not empty appointments}">
                                                ${appointments.stream().filter(a -> a.type == 'IN_PERSON' && a.completed).count()}
                                            </c:if>
                                            <c:if test="${empty appointments}">0</c:if>
                                        </h4>
                                        <p class="mb-0">Health Pod Visits</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-map-marker-alt fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card text-white bg-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>
                                            <c:if test="${not empty appointments}">
                                                ${appointments.stream().filter(a -> a.completed && a.prescription != null).count()}
                                            </c:if>
                                            <c:if test="${empty appointments}">0</c:if>
                                        </h4>
                                        <p class="mb-0">Active Prescriptions</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-file-prescription fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments Section -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>Upcoming Appointments
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:set var="upcomingAppointments" value="${appointments.stream().filter(a -> a.upcoming).toList()}" />
                                <c:choose>
                                    <c:when test="${not empty upcomingAppointments && upcomingAppointments.size() > 0}">
                                        <div class="list-group">
                                            <c:forEach var="appointment" items="${upcomingAppointments}">
                                                <div class="list-group-item p-0 border-0 mb-3">
                                                    <div class="card appointment-card ${appointment.type == 'VIDEO' ? 'video-consult' : 'pod-visit'}">
                                                        <div class="card-body">
                                                            <div class="row align-items-center">
                                                                <div class="col-md-8">
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="flex-shrink-0">
                                                                            <c:choose>
                                                                                <c:when test="${appointment.type == 'VIDEO'}">
                                                                                    <i class="fas fa-video fa-2x text-info me-3"></i>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <i class="fas fa-clinic-medical fa-2x text-success me-3"></i>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <div class="flex-grow-1">
                                                                            <h6 class="card-title mb-1">
                                                                                <c:choose>
                                                                                    <c:when test="${appointment.type == 'VIDEO'}">
                                                                                        Video Consultation
                                                                                        <c:if test="${not empty appointment.doctor}">
                                                                                            with Dr. ${appointment.doctor.user.fullName}
                                                                                        </c:if>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        Health Pod Visit
                                                                                        <c:if test="${not empty appointment.healthPod}">
                                                                                            at ${appointment.healthPod.name}
                                                                                        </c:if>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </h6>
                                                                            <p class="card-text text-muted small mb-1">
                                                                                <i class="fas fa-calendar me-1"></i>
                                                                                ${appointment.formattedDateTime}
                                                                            </p>
                                                                            <c:if test="${not empty appointment.symptoms}">
                                                                                <p class="card-text small text-muted mb-0">
                                                                                    <i class="fas fa-stethoscope me-1"></i>
                                                                                    ${appointment.symptoms.length() > 50 ? 
                                                                                        appointment.symptoms.substring(0, 50) + '...' : 
                                                                                        appointment.symptoms}
                                                                                </p>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-4 text-md-end">
                                                                    <div class="mb-2">
                                                                        <span class="badge 
                                                                            ${appointment.status == 'SCHEDULED' ? 'bg-warning' : ''}
                                                                            ${appointment.status == 'CONFIRMED' ? 'bg-info' : ''}">
                                                                            ${appointment.status}
                                                                        </span>
                                                                    </div>
                                                                    <div class="btn-group btn-group-sm">
                                                                        <a href="/appointments/${appointment.id}" 
                                                                           class="btn btn-outline-primary">
                                                                            <i class="fas fa-eye me-1"></i>View
                                                                        </a>
                                                                        <c:if test="${appointment.canBeCancelled}">
                                                                            <button type="button" class="btn btn-outline-danger" 
                                                                                    data-bs-toggle="modal" 
                                                                                    data-bs-target="#cancelModal${appointment.id}">
                                                                                <i class="fas fa-times me-1"></i>Cancel
                                                                            </button>
                                                                        </c:if>
                                                                        <c:if test="${appointment.type == 'VIDEO' && appointment.status == 'CONFIRMED'}">
                                                                            <a href="/video-call/patient/${appointment.videoConsultation.roomId}" 
                                                                               class="btn btn-outline-success">
                                                                                <i class="fas fa-video me-1"></i>Join
                                                                            </a>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Cancel Modal -->
                                                    <div class="modal fade" id="cancelModal${appointment.id}" tabindex="-1">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Cancel Appointment</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <form action="/appointments/${appointment.id}/cancel" method="post">
                                                                    <div class="modal-body">
                                                                        <p>Are you sure you want to cancel this appointment?</p>
                                                                        <div class="mb-3">
                                                                            <label for="reason${appointment.id}" class="form-label">Reason for cancellation</label>
                                                                            <textarea class="form-control" id="reason${appointment.id}" 
                                                                                      name="reason" rows="3" required></textarea>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                                        <button type="submit" class="btn btn-danger">Cancel Appointment</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-calendar-plus fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">No Upcoming Appointments</h5>
                                            <p class="text-muted">You don't have any upcoming appointments scheduled.</p>
                                            <div class="mt-3">
                                                <a href="/appointments/book" class="btn btn-primary me-2">
                                                    <i class="fas fa-calendar-plus me-1"></i>Book Appointment
                                                </a>
                                                <a href="/health-pods" class="btn btn-outline-primary">
                                                    <i class="fas fa-map-marker-alt me-1"></i>Find Health Pod
                                                </a>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-rocket me-2"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="/appointments/book" class="btn btn-outline-primary btn-lg">
                                        <i class="fas fa-calendar-plus me-2"></i>Book Appointment
                                    </a>
                                    <a href="/health-pods" class="btn btn-outline-success btn-lg">
                                        <i class="fas fa-map-marker-alt me-2"></i>Find Health Pod
                                    </a>
                                    <a href="/appointments/book?type=VIDEO" class="btn btn-outline-info btn-lg">
                                        <i class="fas fa-video me-2"></i>Video Consultation
                                    </a>
                                    <a href="/patient/profile/edit" class="btn btn-outline-warning btn-lg">
                                        <i class="fas fa-user-edit me-2"></i>Update Profile
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-info-circle me-2"></i>Health Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty patient}">
                                        <div class="row">
                                            <div class="col-6">
                                                <strong>Age:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty patient.age}">${patient.age} years</c:when>
                                                    <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                                </c:choose>
                                                <br>
                                                <strong>Gender:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty patient.gender}">${patient.gender}</c:when>
                                                    <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                                </c:choose>
                                                <br>
                                                <strong>Blood Group:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty patient.bloodGroup}">${patient.bloodGroup}</c:when>
                                                    <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="col-6">
                                                <strong>Height:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty patient.height}">${patient.height} cm</c:when>
                                                    <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                                </c:choose>
                                                <br>
                                                <strong>Weight:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty patient.weight}">${patient.weight} kg</c:when>
                                                    <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="mt-3">
                                            <a href="/patient/profile/edit" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit me-1"></i>Update Health Info
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-3">
                                            <i class="fas fa-user-injured fa-3x text-muted mb-3"></i>
                                            <h6 class="text-muted">Health Profile Not Complete</h6>
                                            <p class="text-muted small">Complete your health profile to get personalized healthcare services.</p>
                                            <a href="/patient/profile/edit" class="btn btn-primary">
                                                <i class="fas fa-user-plus me-1"></i>Complete Health Profile
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header bg-warning text-dark">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-history me-2"></i>Recent Activity
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:set var="recentAppointments" value="${appointments.stream()
                                    .filter(a -> !a.upcoming)
                                    .sorted((a1, a2) -> a2.appointmentDateTime.compareTo(a1.appointmentDateTime))
                                    .limit(3)
                                    .toList()}" />
                                
                                <c:choose>
                                    <c:when test="${not empty recentAppointments && recentAppointments.size() > 0}">
                                        <div class="list-group list-group-flush">
                                            <c:forEach var="appointment" items="${recentAppointments}">
                                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${appointment.type == 'VIDEO'}">
                                                                <i class="fas fa-video text-info me-2"></i>
                                                                Video Consultation
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-clinic-medical text-success me-2"></i>
                                                                Health Pod Visit
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <small class="text-muted ms-2">- ${appointment.formattedDateTime}</small>
                                                    </div>
                                                    <span class="badge 
                                                        ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}
                                                        ${appointment.status == 'CANCELLED' ? 'bg-danger' : ''}">
                                                        ${appointment.status}
                                                    </span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="text-center mt-3">
                                            <a href="/appointments" class="btn btn-outline-primary btn-sm">
                                                View All Appointments
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-3">
                                            <i class="fas fa-calendar-check fa-2x text-muted mb-2"></i>
                                            <p class="text-muted mb-0">No recent activity</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>