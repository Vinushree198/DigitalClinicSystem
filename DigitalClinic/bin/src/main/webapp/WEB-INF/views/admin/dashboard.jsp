<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            border-radius: 10px;
            transition: transform 0.3s;
            border: none;
            color: white;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .stats-icon {
            font-size: 2.5rem;
            opacity: 0.8;
        }
        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }
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
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-dark bg-danger">
        <div class="container-fluid">
            <a class="navbar-brand" href="/admin/dashboard">
                <i class="fas fa-cogs"></i> Digital Clinic - Admin
            </a>
            <div class="navbar-nav ms-auto d-flex flex-row">
                <span class="navbar-text text-white me-3">
                    Welcome, ${user.fullName}
                </span>
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
                    <h5 class="text-center">Admin Panel</h5>
                </div>
                <nav class="nav flex-column p-3">
                    <a class="nav-link active" href="/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="/admin/patients">
                        <i class="fas fa-users me-2"></i> Patients
                    </a>
                    <a class="nav-link" href="/admin/doctors">
                        <i class="fas fa-user-md me-2"></i> Doctors
                    </a>
                    <a class="nav-link" href="/admin/health-pods">
                        <i class="fas fa-clinic-medical me-2"></i> Health Pods
                    </a>
                    <a class="nav-link" href="/admin/appointments">
                        <i class="fas fa-calendar-check me-2"></i> Appointments
                    </a>
                    <a class="nav-link" href="/admin/analytics">
                        <i class="fas fa-chart-bar me-2"></i> Analytics
                    </a>
                    <a class="nav-link" href="/admin/settings">
                        <i class="fas fa-cog me-2"></i> Settings
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
                                    <i class="fas fa-tachometer-alt text-danger me-2"></i>
                                    Admin Dashboard
                                </h3>
                                <p class="card-text">
                                    Manage the Digital Clinic platform, monitor system health, and oversee operations.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalPatients}</h4>
                                        <p class="mb-0">Total Patients</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalDoctors}</h4>
                                        <p class="mb-0">Total Doctors</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-user-md stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-warning">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalAppointments}</h4>
                                        <p class="mb-0">Total Appointments</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-calendar-check stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalPods}</h4>
                                        <p class="mb-0">Health Pods</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-clinic-medical stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Second Row Stats -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-secondary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${verifiedDoctors}</h4>
                                        <p class="mb-0">Verified Doctors</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-check-circle stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-dark">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${completedAppointments}</h4>
                                        <p class="mb-0">Completed</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-check stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-danger">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalConsultations}</h4>
                                        <p class="mb-0">Video Consults</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-video stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card bg-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${activeConsultations}</h4>
                                        <p class="mb-0">Active Now</p>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-play stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pending Actions & Recent Activity -->
                <div class="row">
                    <!-- Pending Verifications -->
                    <div class="col-lg-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-warning text-dark">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-clock me-2"></i>Pending Doctor Verifications
                                    <span class="badge bg-dark ms-2">${pendingVerifications.size()}</span>
                                </h5>
                            </div>
                            <div class="card-body recent-activity">
                                <c:choose>
                                    <c:when test="${not empty pendingVerifications && pendingVerifications.size() > 0}">
                                        <c:forEach var="doctor" items="${pendingVerifications}">
                                            <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-2">
                                                <div>
                                                    <h6 class="mb-1">Dr. ${doctor.user.fullName}</h6>
                                                    <p class="mb-1 small text-muted">${doctor.specialization}</p>
                                                    <p class="mb-0 small">
                                                        <i class="fas fa-graduation-cap me-1"></i>${doctor.qualification}
                                                    </p>
                                                </div>
                                                <div class="btn-group btn-group-sm">
                                                    <form action="/admin/doctors/${doctor.id}/verify" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-success btn-sm">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </form>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#rejectModal${doctor.id}">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Reject Modal -->
                                            <div class="modal fade" id="rejectModal${doctor.id}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Reject Doctor Application</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="/admin/doctors/${doctor.id}/reject" method="post">
                                                            <div class="modal-body">
                                                                <p>Reject application for Dr. ${doctor.user.fullName}?</p>
                                                                <div class="mb-3">
                                                                    <label for="reason${doctor.id}" class="form-label">Reason for rejection</label>
                                                                    <textarea class="form-control" id="reason${doctor.id}" 
                                                                              name="reason" rows="3" required></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-danger">Reject Application</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                            <p class="text-muted">No pending verifications</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="col-lg-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-history me-2"></i>Recent Appointments
                                </h5>
                            </div>
                            <div class="card-body recent-activity">
                                <c:choose>
                                    <c:when test="${not empty recentAppointments && recentAppointments.size() > 0}">
                                        <c:forEach var="appointment" items="${recentAppointments}">
                                            <div class="border-bottom pb-2 mb-2">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <h6 class="mb-1">${appointment.patient.user.fullName}</h6>
                                                        <p class="mb-1 small text-muted">
                                                            <c:if test="${not empty appointment.doctor}">
                                                                with Dr. ${appointment.doctor.user.fullName}
                                                            </c:if>
                                                            <c:if test="${empty appointment.doctor}">
                                                                Health Pod Visit
                                                            </c:if>
                                                        </p>
                                                        <p class="mb-0 small">
                                                            <i class="fas fa-calendar me-1"></i>${appointment.formattedDateTime}
                                                        </p>
                                                    </div>
                                                    <span class="badge 
                                                        ${appointment.status == 'COMPLETED' ? 'bg-success' : ''}
                                                        ${appointment.status == 'SCHEDULED' ? 'bg-warning' : ''}
                                                        ${appointment.status == 'CANCELLED' ? 'bg-danger' : ''}">
                                                        ${appointment.status}
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No recent appointments</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-bolt me-2"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 col-6 text-center mb-3">
                                        <a href="/admin/health-pods/add" class="btn btn-outline-primary w-100">
                                            <i class="fas fa-plus-circle fa-2x mb-2"></i><br>
                                            Add Health Pod
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6 text-center mb-3">
                                        <a href="/admin/doctors" class="btn btn-outline-success w-100">
                                            <i class="fas fa-user-md fa-2x mb-2"></i><br>
                                            Manage Doctors
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6 text-center mb-3">
                                        <a href="/admin/analytics" class="btn btn-outline-info w-100">
                                            <i class="fas fa-chart-bar fa-2x mb-2"></i><br>
                                            View Analytics
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6 text-center mb-3">
                                        <a href="/admin/settings" class="btn btn-outline-warning w-100">
                                            <i class="fas fa-cog fa-2x mb-2"></i><br>
                                            System Settings
                                        </a>
                                    </div>
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