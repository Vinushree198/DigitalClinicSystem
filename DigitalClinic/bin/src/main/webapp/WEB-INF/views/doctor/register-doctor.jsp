<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-clinic-medical"></i> Digital Clinic
            </a>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-user-md"></i> Doctor Registration
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/register/doctor" method="post">
                            <!-- CSRF Token -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <h5 class="mb-3">Personal Information</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                            </div>
                            
                            <h5 class="mb-3">Professional Information</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="specialization" class="form-label">Specialization</label>
                                    <select class="form-control" id="specialization" name="specialization" required>
                                        <option value="">Select Specialization</option>
                                        <option value="CARDIOLOGY">Cardiology</option>
                                        <option value="DERMATOLOGY">Dermatology</option>
                                        <option value="NEUROLOGY">Neurology</option>
                                        <option value="PEDIATRICS">Pediatrics</option>
                                        <option value="ORTHOPEDICS">Orthopedics</option>
                                        <option value="GYNECOLOGY">Gynecology</option>
                                        <option value="PSYCHIATRY">Psychiatry</option>
                                        <option value="DENTISTRY">Dentistry</option>
                                        <option value="GENERAL_PRACTICE">General Practice</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="qualification" class="form-label">Qualification</label>
                                    <input type="text" class="form-control" id="qualification" name="qualification" 
                                           placeholder="MBBS, MD, MS, etc." required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="licenseNumber" class="form-label">Medical License Number</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="experienceYears" class="form-label">Years of Experience</label>
                                    <input type="number" class="form-control" id="experienceYears" name="experienceYears" 
                                           min="0" max="50" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="hospitalAffiliation" class="form-label">Hospital Affiliation</label>
                                <input type="text" class="form-control" id="hospitalAffiliation" name="hospitalAffiliation">
                            </div>
                            
                            <div class="mb-3">
                                <label for="bio" class="form-label">Professional Bio</label>
                                <textarea class="form-control" id="bio" name="bio" rows="3" 
                                          placeholder="Brief about your professional background..."></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="consultationFee" class="form-label">Consultation Fee (₹)</label>
                                <input type="number" class="form-control" id="consultationFee" name="consultationFee" 
                                       min="0" step="0.01" required>
                            </div>
                            
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="terms" required>
                                <label class="form-check-label" for="terms">
                                    I agree that my information will be verified before approval
                                </label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-info btn-lg">Submit for Verification</button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
                            <p>Are you a patient? <a href="${pageContext.request.contextPath}/register/patient">Register as Patient</a></p>
                        </div>
                        
                        <div class="alert alert-warning mt-3">
                            <small>
                                <strong>Note:</strong> Doctor accounts require verification before they can be activated. 
                                You will be notified via email once your account is verified.
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>