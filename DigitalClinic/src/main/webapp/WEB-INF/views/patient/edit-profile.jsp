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
            <a class="navbar-brand" href="/patient/dashboard">
                <i class="fas fa-clinic-medical"></i> Digital Clinic
            </a>
            <a href="/patient/profile" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Back to Profile
            </a>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-user-edit me-2"></i>Edit Patient Profile
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="/patient/profile/update" method="post">
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

                            <!-- Health Information -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h5 class="border-bottom pb-2 mb-3">
                                        <i class="fas fa-heartbeat me-2 text-danger"></i>Health Information
                                    </h5>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                           value="${patient.dateOfBirth}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="age" class="form-label">Age</label>
                                    <input type="number" class="form-control" id="age" name="age"
                                           value="${patient.age}" min="0" max="120">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="">Select Gender</option>
                                        <option value="MALE" ${patient.gender == 'MALE' ? 'selected' : ''}>Male</option>
                                        <option value="FEMALE" ${patient.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                        <option value="OTHER" ${patient.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="bloodGroup" class="form-label">Blood Group</label>
                                    <select class="form-select" id="bloodGroup" name="bloodGroup">
                                        <option value="">Select Blood Group</option>
                                        <option value="A+" ${patient.bloodGroup == 'A+' ? 'selected' : ''}>A+</option>
                                        <option value="A-" ${patient.bloodGroup == 'A-' ? 'selected' : ''}>A-</option>
                                        <option value="B+" ${patient.bloodGroup == 'B+' ? 'selected' : ''}>B+</option>
                                        <option value="B-" ${patient.bloodGroup == 'B-' ? 'selected' : ''}>B-</option>
                                        <option value="AB+" ${patient.bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
                                        <option value="AB-" ${patient.bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
                                        <option value="O+" ${patient.bloodGroup == 'O+' ? 'selected' : ''}>O+</option>
                                        <option value="O-" ${patient.bloodGroup == 'O-' ? 'selected' : ''}>O-</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="height" class="form-label">Height (cm)</label>
                                    <input type="number" class="form-control" id="height" name="height"
                                           value="${patient.height}" step="0.1" min="0">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="weight" class="form-label">Weight (kg)</label>
                                    <input type="number" class="form-control" id="weight" name="weight"
                                           value="${patient.weight}" step="0.1" min="0">
                                </div>
                            </div>

                            <!-- Medical History -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h5 class="border-bottom pb-2 mb-3">
                                        <i class="fas fa-file-medical me-2 text-info"></i>Medical History
                                    </h5>
                                </div>
                                <div class="col-12 mb-3">
                                    <label for="medicalHistory" class="form-label">Medical History</label>
                                    <textarea class="form-control" id="medicalHistory" name="medicalHistory" 
                                              rows="4" placeholder="List any past medical conditions, surgeries, or chronic illnesses">${patient.medicalHistory}</textarea>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="allergies" class="form-label">Allergies</label>
                                    <textarea class="form-control" id="allergies" name="allergies" 
                                              rows="3" placeholder="List any known allergies">${patient.allergies}</textarea>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="currentMedications" class="form-label">Current Medications</label>
                                    <textarea class="form-control" id="currentMedications" name="currentMedications" 
                                              rows="3" placeholder="List current medications and dosages">${patient.currentMedications}</textarea>
                                </div>
                            </div>

                            <!-- Emergency Contact -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h5 class="border-bottom pb-2 mb-3">
                                        <i class="fas fa-phone-emergency me-2 text-warning"></i>Emergency Contact
                                    </h5>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="emergencyContactName" class="form-label">Emergency Contact Name</label>
                                    <input type="text" class="form-control" id="emergencyContactName" 
                                           name="emergencyContactName" value="${patient.emergencyContactName}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="emergencyContactPhone" class="form-label">Emergency Contact Phone</label>
                                    <input type="tel" class="form-control" id="emergencyContactPhone" 
                                           name="emergencyContactPhone" value="${patient.emergencyContactPhone}">
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="d-flex justify-content-between">
                                        <a href="/patient/profile" class="btn btn-secondary">
                                            <i class="fas fa-times me-1"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>Update Profile
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>