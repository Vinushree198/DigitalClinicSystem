<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .detail-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 8px 16px;
        }
        .action-buttons .btn {
            margin-right: 8px;
            margin-bottom: 8px;
        }
        .prescription-box {
            background: #f8f9fa;
            border-left: 4px solid #28a745;
            padding: 1rem;
            border-radius: 5px;
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
                <a class="nav-link" href="/appointments">
                    <i class="fas fa-arrow-left me-1"></i>Back to Appointments
                </a>
                <a class="nav-link" href="/patient/dashboard">
                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
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

        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Appointment Header -->
                <div class="card detail-card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h3 class="card-title">
                                    <c:choose>
                                        <c:when test="${appointment.type == 'VIDEO'}">
                                            <i class="fas fa-video me-2 text-primary"></i>Video Consultation
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-clinic-medical me-2 text-success"></i>Health Pod Visit
                                        </c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="text-muted mb-0">Appointment ID: #${appointment.id}</p>
                            </div>
                            <span class="status-badge badge 
                                ${appointment.status == 'SCHEDULED' ? 'bg-warning' : ''}
                                ${appointment.status == 'CONFIRMED' ? 'bg-info' : ''}
                                ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}
                                ${appointment.status == 'CANCELLED' ? 'bg-danger' : ''}">
                                ${appointment.status}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Appointment Details -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-info-circle me-2"></i>Appointment Details
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Date & Time:</strong><br>
                                    <i class="fas fa-calendar me-2 text-primary"></i>
                                    ${appointment.formattedDateTime}
                                </p>
                                <p><strong>Appointment Type:</strong><br>
                                    <c:choose>
                                        <c:when test="${appointment.type == 'VIDEO'}">
                                            <i class="fas fa-video me-2 text-primary"></i>Video Consultation
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-clinic-medical me-2 text-success"></i>Health Pod Visit
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <c:if test="${not empty appointment.consultationFee}">
                                    <p><strong>Consultation Fee:</strong><br>
                                        <i class="fas fa-rupee-sign me-2 text-success"></i>
                                        ₹${appointment.consultationFee}
                                        <c:if test="${appointment.paymentStatus}">
                                            <span class="badge bg-success ms-2">Paid</span>
                                        </c:if>
                                        <c:if test="${!appointment.paymentStatus}">
                                            <span class="badge bg-warning ms-2">Pending</span>
                                        </c:if>
                                    </p>
                                </c:if>
                            </div>
                            <div class="col-md-6">
                                <c:if test="${not empty appointment.doctor}">
                                    <p><strong>Doctor:</strong><br>
                                        <i class="fas fa-user-md me-2 text-info"></i>
                                        Dr. ${appointment.doctor.user.fullName}<br>
                                        <small class="text-muted">${appointment.doctor.specialization}</small>
                                    </p>
                                </c:if>
                                <c:if test="${not empty appointment.healthPod}">
                                    <p><strong>Health Pod:</strong><br>
                                        <i class="fas fa-map-marker-alt me-2 text-danger"></i>
                                        ${appointment.healthPod.name}<br>
                                        <small class="text-muted">${appointment.healthPod.city}</small>
                                    </p>
                                </c:if>
                                <p><strong>Booked On:</strong><br>
                                    <i class="fas fa-clock me-2 text-secondary"></i>
                                    ${appointment.createdAt}
                                </p>
                            </div>
                        </div>

                        <c:if test="${not empty appointment.symptoms}">
                            <div class="mt-3">
                                <strong>Symptoms / Reason:</strong>
                                <div class="border rounded p-3 bg-light mt-1">
                                    ${appointment.symptoms}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty appointment.notes}">
                            <div class="mt-3">
                                <strong>Additional Notes:</strong>
                                <div class="border rounded p-3 bg-light mt-1">
                                    ${appointment.notes}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Prescription -->
                <c:if test="${not empty appointment.prescription}">
                    <div class="card detail-card mb-4 border-success">
                        <div class="card-header bg-success text-white">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-file-prescription me-2"></i>Prescription
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="prescription-box">
                                ${appointment.prescription}
                            </div>
                            <c:if test="${appointment.hasLab}">
                                <div class="mt-3">
                                    <strong>Lab Tests Recommended:</strong>
                                    <div class="border rounded p-3 bg-light mt-1">
                                        <!-- Lab tests would be listed here -->
                                        Blood Test, Urine Analysis
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Feedback Section -->
                <c:if test="${appointment.completed && empty appointment.rating}">
                    <div class="card detail-card mb-4">
                        <div class="card-header bg-info text-white">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-star me-2"></i>Share Your Feedback
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="/appointments/${appointment.id}/feedback" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Rate your experience</label>
                                    <div class="rating-stars">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating1" value="1">
                                            <label class="form-check-label" for="rating1">1 ★</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating2" value="2">
                                            <label class="form-check-label" for="rating2">2 ★★</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating3" value="3">
                                            <label class="form-check-label" for="rating3">3 ★★★</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating4" value="4">
                                            <label class="form-check-label" for="rating4">4 ★★★★</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating5" value="5">
                                            <label class="form-check-label" for="rating5">5 ★★★★★</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="feedback" class="form-label">Your Feedback</label>
                                    <textarea class="form-control" id="feedback" name="feedback" rows="3" 
                                              placeholder="Share your experience with the consultation..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-1"></i>Submit Feedback
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty appointment.rating}">
                    <div class="card detail-card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-star me-2 text-warning"></i>Your Feedback
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-2">
                                <strong class="me-3">Rating:</strong>
                                <div class="text-warning">
                                    <c:forEach begin="1" end="${appointment.rating}">
                                        ★
                                    </c:forEach>
                                    <c:forEach begin="${appointment.rating + 1}" end="5">
                                        ☆
                                    </c:forEach>
                                </div>
                                <span class="ms-2">(${appointment.rating}/5)</span>
                            </div>
                            <c:if test="${not empty appointment.feedback}">
                                <div>
                                    <strong>Comments:</strong>
                                    <div class="border rounded p-3 bg-light mt-1">
                                        ${appointment.feedback}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Actions -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-cog me-2"></i>Appointment Actions
                        </h5>
                    </div>
                    <div class="card-body action-buttons">
                        <c:choose>
                            <c:when test="${appointment.upcoming}">
                                <c:if test="${appointment.canBeCancelled}">
                                    <button type="button" class="btn btn-danger w-100 mb-2" 
                                            data-bs-toggle="modal" data-bs-target="#cancelModal">
                                        <i class="fas fa-times me-1"></i>Cancel Appointment
                                    </button>
                                </c:if>
                                
                                <c:if test="${appointment.canBeCancelled}">
                                    <button type="button" class="btn btn-warning w-100 mb-2" 
                                            data-bs-toggle="modal" data-bs-target="#rescheduleModal">
                                        <i class="fas fa-calendar-alt me-1"></i>Reschedule
                                    </button>
                                </c:if>

                                <c:if test="${appointment.type == 'VIDEO' && appointment.status == 'CONFIRMED'}">
                                    <a href="/video-call/${appointment.id}" class="btn btn-success w-100 mb-2">
                                        <i class="fas fa-video me-1"></i>Join Video Call
                                    </a>
                                </c:if>

                                <c:if test="${appointment.type == 'IN_PERSON'}">
                                    <a href="/health-pods/${appointment.healthPod.id}" 
                                       class="btn btn-info w-100 mb-2">
                                        <i class="fas fa-directions me-1"></i>Get Directions
                                    </a>
                                </c:if>
                            </c:when>
                            <c:when test="${appointment.completed}">
                                <c:if test="${empty appointment.rating}">
                                    <button type="button" class="btn btn-primary w-100 mb-2" 
                                            onclick="document.getElementById('feedbackForm').scrollIntoView()">
                                        <i class="fas fa-star me-1"></i>Give Feedback
                                    </button>
                                </c:if>
                                <a href="/prescriptions/${appointment.id}" class="btn btn-success w-100 mb-2">
                                    <i class="fas fa-file-prescription me-1"></i>View Prescription
                                </a>
                                <c:if test="${!appointment.paymentStatus}">
                                    <a href="/payments/${appointment.id}" class="btn btn-warning w-100 mb-2">
                                        <i class="fas fa-rupee-sign me-1"></i>Make Payment
                                    </a>
                                </c:if>
                            </c:when>
                        </c:choose>
                        
                        <a href="/appointments/book?type=${appointment.type}" 
                           class="btn btn-outline-primary w-100 mb-2">
                            <i class="fas fa-calendar-plus me-1"></i>Book Similar
                        </a>
                        
                        <a href="/appointments" class="btn btn-outline-secondary w-100">
                            <i class="fas fa-list me-1"></i>All Appointments
                        </a>
                    </div>
                </div>

                <!-- Quick Info -->
                <div class="card detail-card">
                    <div class="card-header bg-light">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-question-circle me-2"></i>Need Help?
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group list-group-flush">
                            <a href="/support" class="list-group-item list-group-item-action">
                                <i class="fas fa-headset me-2 text-primary"></i>Contact Support
                            </a>
                            <a href="/faq" class="list-group-item list-group-item-action">
                                <i class="fas fa-question me-2 text-info"></i>FAQ
                            </a>
                            <a href="/health-pods" class="list-group-item list-group-item-action">
                                <i class="fas fa-clinic-medical me-2 text-success"></i>Find Health Pods
                            </a>
                            <a href="/doctors" class="list-group-item list-group-item-action">
                                <i class="fas fa-user-md me-2 text-warning"></i>Browse Doctors
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
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
                            <label for="reason" class="form-label">Reason for cancellation</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
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

    <!-- Reschedule Modal -->
    <div class="modal fade" id="rescheduleModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reschedule Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/appointments/${appointment.id}/reschedule" method="post">
                    <div class="modal-body">
                        <p>Select new date and time for your appointment:</p>
                        <div class="mb-3">
                            <label for="newDateTime" class="form-label">New Date & Time</label>
                            <input type="datetime-local" class="form-control" id="newDateTime" 
                                   name="newDateTime" required min="">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Reschedule</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Set minimum datetime for rescheduling (current time + 1 hour)
        const now = new Date();
        now.setHours(now.getHours() + 1);
        document.getElementById('newDateTime').min = now.toISOString().slice(0, 16);
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>