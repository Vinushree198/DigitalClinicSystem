<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .appointment-card {
            border-left: 4px solid #007bff;
            transition: transform 0.2s;
        }
        .appointment-card:hover {
            transform: translateY(-2px);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 6px 12px;
        }
        .today {
            border-left-color: #28a745;
            background-color: #f8fff9;
        }
        .upcoming {
            border-left-color: #ffc107;
        }
        .completed {
            border-left-color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="/doctor/dashboard">
                <i class="fas fa-user-md"></i> Digital Clinic - Doctor
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/doctor/dashboard">
                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                </a>
                <a class="nav-link" href="/doctor/schedule">
                    <i class="fas fa-clock me-1"></i>My Schedule
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3">
                            <i class="fas fa-calendar-check me-2 text-success"></i>My Appointments
                        </h1>
                        <p class="text-muted mb-0">Manage your patient appointments and consultations</p>
                    </div>
                    <div class="btn-group">
                        <a href="/doctor/schedule" class="btn btn-outline-success">
                            <i class="fas fa-clock me-1"></i>Manage Schedule
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">
                            ${appointments.stream()
                                .filter(a -> a.appointmentDateTime.toLocalDate().equals(java.time.LocalDate.now()))
                                .count()}
                        </h4>
                        <small>Today's</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">
                            ${appointments.stream().filter(a -> a.upcoming).count()}
                        </h4>
                        <small>Upcoming</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">
                            ${appointments.stream().filter(a -> a.completed).count()}
                        </h4>
                        <small>Completed</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">${appointments.size()}</h4>
                        <small>Total</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Today's Appointments -->
        <div class="card mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="card-title mb-0">
                    <i class="fas fa-calendar-day me-2"></i>Today's Appointments
                </h5>
            </div>
            <div class="card-body">
                <c:set var="todayAppointments" value="${appointments.stream()
                    .filter(a -> a.appointmentDateTime.toLocalDate().equals(java.time.LocalDate.now()))
                    .toList()}" />
                
                <c:choose>
                    <c:when test="${not empty todayAppointments && todayAppointments.size() > 0}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="appointment" items="${todayAppointments}">
                                <div class="list-group-item p-0 border-0 mb-3">
                                    <div class="card appointment-card today">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-shrink-0">
                                                            <c:choose>
                                                                <c:when test="${appointment.type == 'VIDEO'}">
                                                                    <i class="fas fa-video fa-2x text-primary me-3"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-clinic-medical fa-2x text-success me-3"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-1">
                                                                ${appointment.patient.user.fullName}
                                                                <small class="text-muted">(${appointment.patient.age} years)</small>
                                                            </h6>
                                                            <p class="card-text text-muted small mb-1">
                                                                <i class="fas fa-clock me-1"></i>
                                                                ${appointment.appointmentDateTime.toLocalTime()}
                                                            </p>
                                                            <c:if test="${not empty appointment.symptoms}">
                                                                <p class="card-text small text-muted mb-0">
                                                                    <i class="fas fa-stethoscope me-1"></i>
                                                                    ${appointment.symptoms.length() > 100 ? 
                                                                        appointment.symptoms.substring(0, 100) + '...' : 
                                                                        appointment.symptoms}
                                                                </p>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-md-end">
                                                    <div class="mb-2">
                                                        <span class="status-badge badge 
                                                            ${appointment.status == 'SCHEDULED' ? 'bg-warning' : ''}
                                                            ${appointment.status == 'CONFIRMED' ? 'bg-info' : ''}
                                                            ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}">
                                                            ${appointment.status}
                                                        </span>
                                                    </div>
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="/appointments/${appointment.id}" 
                                                           class="btn btn-outline-primary">
                                                            <i class="fas fa-eye me-1"></i>View
                                                        </a>
                                                        <c:if test="${appointment.upcoming}">
                                                            <a href="/appointments/${appointment.id}?action=start" 
                                                               class="btn btn-outline-success">
                                                                <i class="fas fa-play me-1"></i>Start
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="fas fa-calendar-check fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No Appointments Today</h5>
                            <p class="text-muted">You don't have any appointments scheduled for today.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- All Appointments -->
        <div class="card">
            <div class="card-header">
                <ul class="nav nav-pills card-header-pills">
                    <li class="nav-item">
                        <a class="nav-link active" href="?filter=all">All Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="?filter=upcoming">Upcoming</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="?filter=completed">Completed</a>
                    </li>
                </ul>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty appointments && appointments.size() > 0}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Date & Time</th>
                                        <th>Type</th>
                                        <th>Symptoms</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td>
                                                <strong>${appointment.patient.user.fullName}</strong>
                                                <br>
                                                <small class="text-muted">
                                                    ${appointment.patient.age} years, ${appointment.patient.gender}
                                                </small>
                                            </td>
                                            <td>
                                                <small>${appointment.formattedDateTime}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.type == 'VIDEO'}">
                                                        <span class="badge bg-primary">Video</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success">In-Person</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${not empty appointment.symptoms}">
                                                    <small>${appointment.symptoms.length() > 50 ? 
                                                        appointment.symptoms.substring(0, 50) + '...' : 
                                                        appointment.symptoms}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    ${appointment.status == 'SCHEDULED' ? 'bg-warning' : ''}
                                                    ${appointment.status == 'CONFIRMED' ? 'bg-info' : ''}
                                                    ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}
                                                    ${appointment.status == 'CANCELLED' ? 'bg-danger' : ''}">
                                                    ${appointment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <a href="/appointments/${appointment.id}" 
                                                       class="btn btn-outline-primary">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <c:if test="${appointment.upcoming}">
                                                        <a href="/appointments/${appointment.id}?action=confirm" 
                                                           class="btn btn-outline-success">
                                                            <i class="fas fa-check"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No Appointments Found</h4>
                            <p class="text-muted">You don't have any appointments scheduled yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-md-4 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-clock fa-2x text-warning mb-3"></i>
                        <h5>Manage Schedule</h5>
                        <p class="text-muted small">Set your availability and working hours</p>
                        <a href="/doctor/schedule" class="btn btn-outline-warning btn-sm">
                            Set Availability
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-chart-line fa-2x text-info mb-3"></i>
                        <h5>View Analytics</h5>
                        <p class="text-muted small">Check your appointment statistics</p>
                        <a href="/doctor/analytics" class="btn btn-outline-info btn-sm">
                            View Reports
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-user-edit fa-2x text-primary mb-3"></i>
                        <h5>Update Profile</h5>
                        <p class="text-muted small">Keep your professional information updated</p>
                        <a href="/doctor/profile/edit" class="btn btn-outline-primary btn-sm">
                            Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>