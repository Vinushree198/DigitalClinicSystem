<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .facility-list {
            list-style: none;
            padding: 0;
        }
        .facility-list li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .facility-list li:last-child {
            border-bottom: none;
        }
        .facility-list li i {
            color: #28a745;
            margin-right: 10px;
        }
        .info-card {
            border-left: 4px solid #007bff;
            padding-left: 15px;
        }
        .operating-hours {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border-radius: 10px;
            padding: 1.5rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-clinic-medical"></i> Digital Clinic
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/health-pods">
                    <i class="fas fa-arrow-left me-1"></i>Back to Pods
                </a>
                <c:if test="${not empty user}">
                    <a class="nav-link" href="/${user.role.toLowerCase()}/dashboard">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </c:if>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 fw-bold">
                        <i class="fas fa-clinic-medical me-2"></i>${healthPod.name}
                    </h1>
                    <p class="lead mb-0">
                        <i class="fas fa-map-marker-alt me-1"></i>${healthPod.fullAddress}
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="operating-hours">
                        <h5 class="mb-1">
                            <i class="fas fa-clock me-1"></i>Operating Hours
                        </h5>
                        <p class="mb-0 fs-5">${healthPod.operatingHours}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Description -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-info-circle me-2 text-primary"></i>About This Health Pod
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">${healthPod.description}</p>
                        
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="info-card">
                                    <h6>
                                        <i class="fas fa-user-md me-2 text-success"></i>Incharge
                                    </h6>
                                    <p class="mb-0">${healthPod.inchargeName}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-card">
                                    <h6>
                                        <i class="fas fa-users me-2 text-info"></i>Staff
                                    </h6>
                                    <p class="mb-0">${healthPod.staffCount} trained professionals</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Facilities -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list-alt me-2 text-success"></i>Available Facilities
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <ul class="facility-list">
                                    <c:forEach var="facility" items="${healthPod.facilities}" begin="0" end="${healthPod.facilities.size() / 2}">
                                        <li>
                                            <i class="fas fa-check-circle"></i>${facility}
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <ul class="facility-list">
                                    <c:forEach var="facility" items="${healthPod.facilities}" begin="${(healthPod.facilities.size() / 2) + 1}">
                                        <li>
                                            <i class="fas fa-check-circle"></i>${facility}
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Equipment -->
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-tools me-2 text-warning"></i>Medical Equipment
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <c:forEach var="equipment" items="${healthPod.equipment}">
                                <div class="col-md-4 mb-2">
                                    <span class="badge bg-light text-dark p-2 w-100">
                                        <i class="fas fa-check me-1 text-success"></i>${equipment}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Contact Information -->
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-address-card me-2"></i>Contact Information
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <strong><i class="fas fa-phone me-2 text-success"></i>Phone</strong>
                            <p class="mb-0">${healthPod.phone}</p>
                        </div>
                        <c:if test="${not empty healthPod.email}">
                            <div class="mb-3">
                                <strong><i class="fas fa-envelope me-2 text-info"></i>Email</strong>
                                <p class="mb-0">${healthPod.email}</p>
                            </div>
                        </c:if>
                        <div>
                            <strong><i class="fas fa-map-marker-alt me-2 text-danger"></i>Address</strong>
                            <p class="mb-0">${healthPod.fullAddress}</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <c:if test="${not empty user && user.role == 'PATIENT'}">
                                <a href="/appointments/book?podId=${healthPod.id}" class="btn btn-primary">
                                    <i class="fas fa-calendar-plus me-1"></i>Book Appointment
                                </a>
                                <a href="/consultations/video" class="btn btn-info">
                                    <i class="fas fa-video me-1"></i>Video Consultation
                                </a>
                            </c:if>
                            <c:if test="${empty user}">
                                <a href="/login" class="btn btn-primary">
                                    <i class="fas fa-sign-in-alt me-1"></i>Login to Book Appointment
                                </a>
                                <a href="/register/patient" class="btn btn-success">
                                    <i class="fas fa-user-plus me-1"></i>Register as Patient
                                </a>
                            </c:if>
                            <a href="/health-pods/map" class="btn btn-outline-primary">
                                <i class="fas fa-map me-1"></i>View on Map
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Additional Features -->
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-star me-2"></i>Special Features
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span>Pharmacy</span>
                            <c:choose>
                                <c:when test="${healthPod.hasPharmacy}">
                                    <span class="badge bg-success">
                                        <i class="fas fa-check me-1"></i>Available
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">
                                        <i class="fas fa-times me-1"></i>Not Available
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span>Lab Facility</span>
                            <c:choose>
                                <c:when test="${healthPod.hasLab}">
                                    <span class="badge bg-success">
                                        <i class="fas fa-check me-1"></i>Available
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">
                                        <i class="fas fa-times me-1"></i>Not Available
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>