<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand" href="/doctor/dashboard">
                <i class="fas fa-user-md"></i> Digital Clinic
            </a>
            <div class="navbar-nav ms-auto d-flex flex-row">
                <a class="nav-link text-white me-3" href="/doctor/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a class="nav-link text-white" href="/logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-10 mx-auto">
                <div class="card shadow">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h4 class="card-title mb-0">
                            <i class="fas fa-user-md me-2"></i>Doctor Profile
                        </h4>
                        <div>
                            <c:choose>
                                <c:when test="${doctor.verified}">
                                    <span class="badge bg-light text-success me-2">
                                        <i class="fas fa-check-circle me-1"></i>Verified
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning me-2">
                                        <i class="fas fa-clock me-1"></i>Pending Verification
                                    </span>
                                </c:otherwise>
                            </c:choose>
                            <a href="/doctor/profile/edit" class="btn btn-light btn-sm">
                                <i class="fas fa-edit me-1"></i>Edit Profile
                            </a>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <!-- Success Message -->
                        <c:if test="${param.success != null}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>Profile updated successfully!
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Personal Information -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="border-bottom pb-2">
                                    <i class="fas fa-user me-2 text-primary"></i>Personal Information
                                </h5>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Full Name:</strong> Dr. ${user.fullName}</p>
                                <p><strong>Email:</strong> ${user.email}</p>
                                <p><strong>Phone:</strong> ${user.phone}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Address:</strong> ${user.address}</p>
                                <p><strong>Member Since:</strong> ${user.createdAt}</p>
                            </div>
                        </div>

                        <!-- Professional Information -->
                        <div class="row">
                            <div class="col-12">
                                <h5 class="border-bottom pb-2">
                                    <i class="fas fa-stethoscope me-2 text-success"></i>Professional Information
                                </h5>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty doctor.specialization}">
                                    <div class="col-md-6">
                                        <p><strong>Specialization:</strong><br>
                                            <span class="badge bg-primary fs-6">${doctor.specialization}</span>
                                        </p>
                                        <p><strong>Qualification:</strong><br>
                                            ${doctor.qualification}
                                        </p>
                                        <p><strong>License Number:</strong><br>
                                            <code class="bg-light p-1 rounded">${doctor.licenseNumber}</code>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Experience:</strong><br>
                                            <c:choose>
                                                <c:when test="${not empty doctor.experienceYears}">
                                                    ${doctor.experienceYears} years
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not specified</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><strong>Consultation Fee:</strong><br>
                                            <c:choose>
                                                <c:when test="${not empty doctor.consultationFee}">
                                                    ₹${doctor.consultationFee}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not set</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><strong>Verification Status:</strong><br>
                                            <c:choose>
                                                <c:when test="${doctor.verified}">
                                                    <span class="badge bg-success">Verified</span>
                                                </c:when>
                                                <c:when test="${doctor.verificationStatus == 'PENDING'}">
                                                    <span class="badge bg-warning">Pending Review</span>
                                                </c:when>
                                                <c:when test="${doctor.verificationStatus == 'REJECTED'}">
                                                    <span class="badge bg-danger">Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Unknown</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    
                                    <!-- Additional Information -->
                                    <div class="col-12 mt-3">
                                        <c:if test="${not empty doctor.hospitalAffiliation}">
                                            <p><strong>Hospital Affiliation:</strong><br>
                                                ${doctor.hospitalAffiliation}
                                            </p>
                                        </c:if>
                                        
                                        <c:if test="${not empty doctor.bio}">
                                            <p><strong>Professional Bio:</strong></p>
                                            <div class="border rounded p-3 bg-light">
                                                ${doctor.bio}
                                            </div>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12 text-center py-5">
                                        <i class="fas fa-stethoscope fa-4x text-muted mb-3"></i>
                                        <h5 class="text-muted">Professional Profile Not Complete</h5>
                                        <p class="text-muted">Complete your professional profile to start receiving patients and consultations.</p>
                                        <a href="/doctor/profile/edit" class="btn btn-success btn-lg">
                                            <i class="fas fa-user-plus me-1"></i>Complete Professional Profile
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Account Status -->
                        <c:if test="${not doctor.verified}">
                            <div class="row mt-4">
                                <div class="col-12">
                                    <div class="alert alert-warning">
                                        <h6 class="alert-heading">
                                            <i class="fas fa-exclamation-triangle me-2"></i>Account Verification Required
                                        </h6>
                                        <p class="mb-2">Your account is currently under verification. You'll gain full access to the platform once verified.</p>
                                        <p class="mb-0 small">
                                            <strong>What happens next?</strong><br>
                                            Our team will review your credentials and verify your medical license. This process usually takes 24-48 hours.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>