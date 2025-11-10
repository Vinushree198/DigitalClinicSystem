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
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/dashboard">
                <i class="fas fa-clinic-medical"></i> Digital Clinic
            </a>
            <div class="navbar-nav ms-auto d-flex flex-row">
                <a class="nav-link text-white me-3" href="/patient/dashboard">
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
            <div class="col-md-8 mx-auto">
                <div class="card shadow">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h4 class="card-title mb-0">
                            <i class="fas fa-user-circle me-2"></i>My Profile
                        </h4>
                        <a href="/patient/profile/edit" class="btn btn-light btn-sm">
                            <i class="fas fa-edit me-1"></i>Edit Profile
                        </a>
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
                                <p><strong>Full Name:</strong> ${user.fullName}</p>
                                <p><strong>Email:</strong> ${user.email}</p>
                                <p><strong>Phone:</strong> ${user.phone}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Address:</strong> ${user.address}</p>
                                <p><strong>Member Since:</strong> ${user.createdAt}</p>
                            </div>
                        </div>

                        <!-- Health Information -->
                        <div class="row">
                            <div class="col-12">
                                <h5 class="border-bottom pb-2">
                                    <i class="fas fa-heartbeat me-2 text-danger"></i>Health Information
                                </h5>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty patient && (not empty patient.age || not empty patient.gender)}">
                                    <div class="col-md-6">
                                        <p><strong>Age:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty patient.age}">${patient.age} years</c:when>
                                                <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><strong>Gender:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty patient.gender}">${patient.gender}</c:when>
                                                <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><strong>Blood Group:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty patient.bloodGroup}">${patient.bloodGroup}</c:when>
                                                <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Height:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty patient.height}">${patient.height} cm</c:when>
                                                <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><strong>Weight:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty patient.weight}">${patient.weight} kg</c:when>
                                                <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    
                                    <!-- Medical Details -->
                                    <div class="col-12 mt-3">
                                        <p><strong>Medical History:</strong></p>
                                        <div class="border rounded p-3 bg-light">
                                            <c:choose>
                                                <c:when test="${not empty patient.medicalHistory}">
                                                    ${patient.medicalHistory}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No medical history recorded</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 mt-3">
                                        <p><strong>Allergies:</strong></p>
                                        <div class="border rounded p-3 bg-light">
                                            <c:choose>
                                                <c:when test="${not empty patient.allergies}">
                                                    ${patient.allergies}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No allergies recorded</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 mt-3">
                                        <p><strong>Current Medications:</strong></p>
                                        <div class="border rounded p-3 bg-light">
                                            <c:choose>
                                                <c:when test="${not empty patient.currentMedications}">
                                                    ${patient.currentMedications}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No current medications</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- Emergency Contact -->
                                    <div class="col-12 mt-3">
                                        <h6 class="border-bottom pb-1">Emergency Contact</h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p><strong>Name:</strong> 
                                                    <c:choose>
                                                        <c:when test="${not empty patient.emergencyContactName}">
                                                            ${patient.emergencyContactName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Not set</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Phone:</strong> 
                                                    <c:choose>
                                                        <c:when test="${not empty patient.emergencyContactPhone}">
                                                            ${patient.emergencyContactPhone}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Not set</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12 text-center py-4">
                                        <i class="fas fa-user-injured fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Health Profile Not Complete</h5>
                                        <p class="text-muted">Complete your health profile to get personalized healthcare services.</p>
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
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>