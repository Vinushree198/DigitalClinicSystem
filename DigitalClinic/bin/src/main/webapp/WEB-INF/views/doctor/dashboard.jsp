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
            background-color: #28a745;
            color: white;
        }
        .stats-card {
            border-radius: 10px;
            transition: transform 0.3s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .verification-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand" href="/doctor/dashboard">
                <i class="fas fa-user-md"></i> Digital Clinic - Doctor
            </a>
            <div class="navbar-nav ms-auto d-flex flex-row">
                <span class="navbar-text text-white me-3">
                    Welcome, Dr. ${user.fullName}
                </span>
                <a class="nav-link text-white" href="/doctor/profile">
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
                    <h5 class="text-center">Doctor Panel</h5>
                </div>
                <nav class="nav flex-column p-3">
                    <a class="nav-link active" href="/doctor/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="/doctor/profile">
                        <i class="fas fa-user me-2"></i> My Profile
                    </a>
                    <a class="nav-link" href="/doctor/appointments">
                        <i class="fas fa-calendar-check me-2"></i> Appointments
                    </a>
                    <a class="nav-link" href="/doctor/patients">
                        <i class="fas fa-users me-2"></i> My Patients
                    </a>
                    <a class="nav-link" href="/doctor/consultations">
                        <i class="fas fa-video me-2"></i> Video Consultations
                    </a>
                    <a class="nav-link" href="/doctor/prescriptions">
                        <i class="fas fa-file-prescription me-2"></i> Prescriptions
                    </a>
                    <a class="nav-link" href="/doctor/schedule">
                        <i class="fas fa-clock me-2"></i> Schedule
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
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h3 class="card-title">
                                            <i class="fas fa-user-md text-success me-2"></i>
                                            Welcome, Dr. ${user.fullName}
                                        </h3>
                                        <p class="card-text mb-0">
                                            Provide quality healthcare to rural communities through our platform.
                                        </p>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${doctor.verified}">
                                                <span class="badge bg-success verification-badge">
                                                    <i class="fas fa-check-circle me-1"></i>Verified Doctor
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning verification-badge">
                                                    <i class="fas fa-clock me-1"></i>Verification Pending
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Doctor Stats -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>0</h4>
                                        <p class="mb-0">Today's Appointments</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-calendar-day fa-2x"></i>
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
                                        <h4>0</h4>
                                        <p class="mb-0">Total Patients</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x"></i>
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
                                        <h4>0</h4>
                                        <p class="mb-0">Pending Consultations</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-video fa-2x"></i>
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
                                        <h4>₹0</h4>
                                        <p class="mb-0">Monthly Earnings</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-rupee-sign fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Doctor Information & Quick Actions -->
                <div class="row">
                    <!-- Doctor Information -->
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-info-circle me-2"></i>Professional Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty doctor.specialization}">
                                        <div class="mb-3">
                                            <strong>Specialization:</strong><br>
                                            <span class="badge bg-primary">${doctor.specialization}</span>
                                        </div>
                                        <div class="mb-3">
                                            <strong>Qualification:</strong><br>
                                            ${doctor.qualification}
                                        </div>
                                        <div class="mb-3">
                                            <strong>Experience:</strong><br>
                                            <c:choose>
                                                <c:when test="${not empty doctor.experienceYears}">
                                                    ${doctor.experienceYears} years
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not specified</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="mb-3">
                                            <strong>Consultation Fee:</strong><br>
                                            <c:choose>
                                                <c:when test="${not empty doctor.consultationFee}">
                                                    ₹${doctor.consultationFee}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not set</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="mb-3">
                                            <strong>License Number:</strong><br>
                                            <code>${doctor.licenseNumber}</code>
                                        </div>
                                        <c:if test="${not empty doctor.hospitalAffiliation}">
                                            <div class="mb-3">
                                                <strong>Hospital Affiliation:</strong><br>
                                                ${doctor.hospitalAffiliation}
                                            </div>
                                        </c:if>
                                        <a href="/doctor/profile/edit" class="btn btn-outline-success btn-sm">
                                            <i class="fas fa-edit me-1"></i>Update Information
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-3">
                                            <i class="fas fa-stethoscope fa-3x text-muted mb-3"></i>
                                            <h6 class="text-muted">Complete Your Professional Profile</h6>
                                            <p class="text-muted small">Add your specialization, qualification, and experience to start receiving patients.</p>
                                            <a href="/doctor/profile/edit" class="btn btn-success">
                                                <i class="fas fa-user-plus me-1"></i>Complete Profile
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-rocket me-2"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="/doctor/appointments" class="btn btn-outline-primary btn-lg text-start">
                                        <i class="fas fa-calendar-check me-2"></i>View Appointments
                                    </a>
                                    <a href="/doctor/schedule" class="btn btn-outline-success btn-lg text-start">
                                        <i class="fas fa-clock me-2"></i>Manage Schedule
                                    </a>
                                    <a href="/doctor/consultations" class="btn btn-outline-info btn-lg text-start">
                                        <i class="fas fa-video me-2"></i>Video Consultations
                                    </a>
                                    <a href="/doctor/patients" class="btn btn-outline-warning btn-lg text-start">
                                        <i class="fas fa-users me-2"></i>My Patients
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Verification Status -->
                        <c:if test="${not doctor.verified}">
                            <div class="card mt-4 border-warning">
                                <div class="card-header bg-warning text-dark">
                                    <h6 class="card-title mb-0">
                                        <i class="fas fa-exclamation-triangle me-2"></i>Verification Required
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <p class="small mb-2">Your account is pending verification. You'll be able to:</p>
                                    <ul class="small mb-3">
                                        <li>Receive patient appointments</li>
                                        <li>Conduct video consultations</li>
                                        <li>Access all platform features</li>
                                    </ul>
                                    <p class="small text-muted mb-0">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Our team will verify your credentials within 24-48 hours.
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Upcoming Appointments (Placeholder) -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>Today's Appointments
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center py-4">
                                    <i class="fas fa-calendar-times fa-2x text-muted mb-3"></i>
                                    <h6 class="text-muted">No appointments scheduled for today</h6>
                                    <p class="text-muted small">Appointments will appear here once patients book consultations with you.</p>
                                </div>
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