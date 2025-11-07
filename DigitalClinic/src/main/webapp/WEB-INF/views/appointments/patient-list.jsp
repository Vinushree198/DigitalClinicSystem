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
        .upcoming {
            border-left-color: #28a745;
        }
        .completed {
            border-left-color: #6c757d;
        }
        .cancelled {
            border-left-color: #dc3545;
        }
        .nav-pills .nav-link.active {
            background-color: #007bff;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/patient/dashboard">
                <i class="fas fa-clinic-medical"></i> Digital Clinic - Patient
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/appointments/book" class="btn btn-light btn-sm">
                    <i class="fas fa-calendar-plus me-1"></i>Book New
                </a>
                <a class="nav-link" href="/patient/dashboard">
                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
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
                            <i class="fas fa-calendar-alt me-2 text-primary"></i>My Appointments
                        </h1>
                        <p class="text-muted mb-0">Manage your healthcare appointments</p>
                    </div>
                    <a href="/appointments/book" class="btn btn-primary">
                        <i class="fas fa-calendar-plus me-1"></i>Book New Appointment
                    </a>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">${appointments.stream().filter(a -> a.upcoming).count()}</h4>
                        <small>Upcoming</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">${appointments.stream().filter(a -> a.completed).count()}</h4>
                        <small>Completed</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">${appointments.size()}</h4>
                        <small>Total</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h4 class="mb-0">${appointments.stream().filter(a -> a.type == 'VIDEO').count()}</h4>
                        <small>Video Consults</small>
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

        <!-- Appointments List -->
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
                        <div class="list-group list-group-flush">
                            <c:forEach var="appointment" items="${appointments}">
                                <div class="list-group-item p-0 border-0 mb-3">
                                    <div class="card appointment-card 
                                         ${appointment.upcoming ? 'upcoming' : ''} 
                                         ${appointment.completed ? 'completed' : ''} 
                                         ${appointment.status == 'CANCELLED' ? 'cancelled' : ''}">
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
                                                                    ${appointment.symptoms}
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
                                                            ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}
                                                            ${appointment.status == 'CANCELLED' ? 'bg-danger' : ''}">
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
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No Appointments Found</h4>
                            <p class="text-muted">You haven't booked any appointments yet.</p>
                            <a href="/appointments/book" class="btn btn-primary">
                                <i class="fas fa-calendar-plus me-1"></i>Book Your First Appointment
                            </a>
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
                        <i class="fas fa-video fa-2x text-primary mb-3"></i>
                        <h5>Video Consultation</h5>
                        <p class="text-muted small">Consult with doctors online from your home</p>
                        <a href="/appointments/book?type=VIDEO" class="btn btn-outline-primary btn-sm">
                            Book Video Consult
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-clinic-medical fa-2x text-success mb-3"></i>
                        <h5>Health Pod Visit</h5>
                        <p class="text-muted small">Visit our local health pod for checkups</p>
                        <a href="/appointments/book?type=IN_PERSON" class="btn btn-outline-success btn-sm">
                            Book Pod Visit
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="fas fa-question-circle fa-2x text-info mb-3"></i>
                        <h5>Need Help?</h5>
                        <p class="text-muted small">Get assistance with appointments</p>
                        <a href="/support" class="btn btn-outline-info btn-sm">
                            Contact Support
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>