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
    <nav class="navbar navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="/doctor/dashboard">
                <i class="fas fa-user-md"></i> Digital Clinic
            </a>
            <a href="/doctor/profile" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Back to Profile
            </a>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-user-edit me-2"></i>Edit Doctor Profile
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="/doctor/profile/update" method="post">
                            <!-- Personal Information -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h5 class="border-bottom pb-2 mb-3">
                                        <i class="fas fa-user me-2 text-primary"></i>Personal Information
                                    </h5>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           value="${user.fullName}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${user.phone}" required>
                                </div>
                                <div class="col-12 mb-3">
                                    <label for="address" class="form-label">Address *</label>
                                    <textarea class="form-control" id="address" name="address" 
                                              rows="3" required>${user.address}</textarea>
                                </div>
                            </div>

                            <!-- Professional Information -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h5 class="border-bottom pb-2 mb-3">
                                        <i class="fas fa-stethoscope me-2 text-success"></i>Professional Information
                                    </h5>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="specialization" class="form-label">Specialization *</label>
                                    <select class="form-select" id="specialization" name="specialization" required>
                                        <option value="">Select Specialization</option>
                                        <option value="General Physician" ${doctor.specialization == 'General Physician' ? 'selected' : ''}>General Physician</option>
                                        <option value="Cardiologist" ${doctor.specialization == 'Cardiologist' ? 'selected' : ''}>Cardiologist</option>
                                        <option value="Dermatologist" ${doctor.specialization == 'Dermatologist' ? 'selected' : ''}>Dermatologist</option>
                                        <option value="Pediatrician" ${doctor.specialization == 'Pediatrician' ? 'selected' : ''}>Pediatrician</option>
                                        <option value="Gynecologist" ${doctor.specialization == 'Gynecologist' ? 'selected' : ''}>Gynecologist</option>
                                        <option value="Orthopedic" ${doctor.specialization == 'Orthopedic' ? 'selected' : ''}>Orthopedic</option>
                                        <option value="Psychiatrist" ${doctor.specialization == 'Psychiatrist' ? 'selected' : ''}>Psychiatrist</option>
                                        <option value="Dentist" ${doctor.specialization == 'Dentist' ? 'selected' : ''}>Dentist</option>
                                        <option value="ENT Specialist" ${doctor.specialization == 'ENT Specialist' ? 'selected' : ''}>ENT Specialist</option>
                                        <option value="Other" ${doctor.specialization == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="qualification" class="form-label">Qualification *</label>
                                    <input type="text" class="form-control" id="qualification" name="qualification"
                                           value="${doctor.qualification}" required 
                                           placeholder="MBBS, MD, MS, etc.">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="licenseNumber" class="form-label">Medical License Number *</label>
                                    <input type="text" class="form-control" id="licenseNumber" name="licenseNumber"
                                           value="${doctor.licenseNumber}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="experienceYears" class="form-label">Years of Experience</label>
                                    <input type="number" class="form-control" id="experienceYears" name="experienceYears"
                                           value="${doctor.experienceYears}" min="0" max="50">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="consultationFee" class="form-label">Consultation Fee (₹)</label>
                                    <input type="number" class="form-control" id="consultationFee" name="consultationFee"
                                           value="${doctor.consultationFee}" min="0" step="50">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="hospitalAffiliation" class="form-label">Hospital Affiliation</label>
                                    <input type="text" class="form-control" id="hospitalAffiliation" name="hospitalAffiliation"
                                           value="${doctor.hospitalAffiliation}" 
                                           placeholder="Current hospital or clinic">
                                </div>
                                <div class="col-12 mb-3">
                                    <label for="bio" class="form-label">Professional Bio</label>
                                    <textarea class="form-control" id="bio" name="bio" rows="4"
                                              placeholder="Brief about your professional experience, expertise, and approach to patient care">${doctor.bio}</textarea>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="d-flex justify-content-between">
                                        <a href="/doctor/profile" class="btn btn-secondary">
                                            <i class="fas fa-times me-1"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-save me-1"></i>Update Profile
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Verification Notice -->
                <c:if test="${not doctor.verified}">
                    <div class="alert alert-info mt-4">
                        <h6 class="alert-heading">
                            <i class="fas fa-info-circle me-2"></i>Verification Process
                        </h6>
                        <p class="mb-2">Your profile information will be verified by our team. Please ensure all details are accurate.</p>
                        <p class="mb-0 small">
                            <strong>Note:</strong> You'll receive notification once your verification is complete. 
                            This usually takes 24-48 hours.
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>