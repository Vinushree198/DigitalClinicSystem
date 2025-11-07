<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Registration - Digital Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                    <div class="card-header bg-danger text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-user-shield"></i> Admin Registration
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
                        
                        <form action="${pageContext.request.contextPath}/register/admin" method="post">
                            <!-- CSRF Token -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <h5 class="mb-3">Administrator Information</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           placeholder="Enter full name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="Enter official email" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Create strong password" required>
                                    <div class="form-text">Password must be at least 8 characters</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Confirm password" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           placeholder="Enter contact number" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="employeeId" class="form-label">Employee ID</label>
                                    <input type="text" class="form-control" id="employeeId" name="employeeId" 
                                           placeholder="Enter employee ID" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" 
                                          placeholder="Enter complete address" required></textarea>
                            </div>
                            
                            <h5 class="mb-3">Administrative Details</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="department" class="form-label">Department</label>
                                    <select class="form-control" id="department" name="department" required>
                                        <option value="">Select Department</option>
                                        <option value="SYSTEM_ADMINISTRATION">System Administration</option>
                                        <option value="HUMAN_RESOURCES">Human Resources</option>
                                        <option value="FINANCE">Finance & Billing</option>
                                        <option value="MEDICAL_RECORDS">Medical Records</option>
                                        <option value="FACILITY_MANAGEMENT">Facility Management</option>
                                        <option value="IT_SUPPORT">IT Support</option>
                                        <option value="PATIENT_SERVICES">Patient Services</option>
                                        <option value="DOCTOR_MANAGEMENT">Doctor Management</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="designation" class="form-label">Designation</label>
                                    <select class="form-control" id="designation" name="designation" required>
                                        <option value="">Select Designation</option>
                                        <option value="SYSTEM_ADMIN">System Administrator</option>
                                        <option value="HR_MANAGER">HR Manager</option>
                                        <option value="FINANCE_MANAGER">Finance Manager</option>
                                        <option value="RECORDS_MANAGER">Records Manager</option>
                                        <option value="FACILITY_SUPERVISOR">Facility Supervisor</option>
                                        <option value="IT_SUPPORT">IT Support Specialist</option>
                                        <option value="PATIENT_COORDINATOR">Patient Coordinator</option>
                                        <option value="DOCTOR_COORDINATOR">Doctor Coordinator</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="adminLevel" class="form-label">Admin Level</label>
                                    <select class="form-control" id="adminLevel" name="adminLevel" required>
                                        <option value="">Select Admin Level</option>
                                        <option value="SUPER_ADMIN">Super Admin</option>
                                        <option value="ADMIN">Admin</option>
                                        <option value="MANAGER">Manager</option>
                                        <option value="SUPERVISOR">Supervisor</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="joinDate" class="form-label">Joining Date</label>
                                    <input type="date" class="form-control" id="joinDate" name="joinDate" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="permissions" class="form-label">System Permissions</label>
                                <div class="border p-3 rounded">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="userManagement" name="permissions" value="USER_MANAGEMENT">
                                                <label class="form-check-label" for="userManagement">
                                                    User Management
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="doctorManagement" name="permissions" value="DOCTOR_MANAGEMENT">
                                                <label class="form-check-label" for="doctorManagement">
                                                    Doctor Management
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="patientManagement" name="permissions" value="PATIENT_MANAGEMENT">
                                                <label class="form-check-label" for="patientManagement">
                                                    Patient Management
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="appointmentManagement" name="permissions" value="APPOINTMENT_MANAGEMENT">
                                                <label class="form-check-label" for="appointmentManagement">
                                                    Appointment Management
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="healthPodManagement" name="permissions" value="HEALTH_POD_MANAGEMENT">
                                                <label class="form-check-label" for="healthPodManagement">
                                                    Health Pod Management
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="systemAnalytics" name="permissions" value="SYSTEM_ANALYTICS">
                                                <label class="form-check-label" for="systemAnalytics">
                                                    System Analytics
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="systemSettings" name="permissions" value="SYSTEM_SETTINGS">
                                                <label class="form-check-label" for="systemSettings">
                                                    System Settings
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="reportsAccess" name="permissions" value="REPORTS_ACCESS">
                                                <label class="form-check-label" for="reportsAccess">
                                                    Reports Access
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="terms" required>
                                <label class="form-check-label" for="terms">
                                    I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms of Service</a> 
                                    and confirm that I have authorization to create an admin account
                                </label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-danger btn-lg">
                                    <i class="fas fa-user-shield"></i> Create Admin Account
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
                            <p>Are you a doctor? <a href="${pageContext.request.contextPath}/register/doctor">Register as Doctor</a></p>
                            <p>Are you a patient? <a href="${pageContext.request.contextPath}/register/patient">Register as Patient</a></p>
                        </div>
                        
                        <div class="alert alert-info mt-3">
                            <small>
                                <strong>Important:</strong> Admin accounts require special authorization. 
                                Only authorized personnel should register for admin access. 
                                All admin activities are logged and monitored.
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Terms Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Admin Account Terms of Service</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>Administrative Responsibilities</h6>
                    <ul>
                        <li>Admin accounts have elevated system privileges</li>
                        <li>All actions are logged and monitored for security</li>
                        <li>Do not share your admin credentials with anyone</li>
                        <li>Report any suspicious activity immediately</li>
                    </ul>
                    
                    <h6>Data Protection</h6>
                    <ul>
                        <li>You are responsible for protecting sensitive patient data</li>
                        <li>Follow all healthcare data protection regulations</li>
                        <li>Maintain confidentiality of all system information</li>
                    </ul>
                    
                    <h6>System Usage</h6>
                    <ul>
                        <li>Use admin privileges only for authorized tasks</li>
                        <li>Do not modify system settings without proper authorization</li>
                        <li>Follow established procedures for user management</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });

        // Set maximum date for joining date to today
        document.getElementById('joinDate').max = new Date().toISOString().split('T')[0];

        // Auto-check permissions based on admin level
        document.getElementById('adminLevel').addEventListener('change', function() {
            const level = this.value;
            const checkboxes = document.querySelectorAll('input[name="permissions"]');
            
            // Uncheck all first
            checkboxes.forEach(checkbox => checkbox.checked = false);
            
            // Auto-check based on level
            if (level === 'SUPER_ADMIN') {
                checkboxes.forEach(checkbox => checkbox.checked = true);
            } else if (level === 'ADMIN') {
                document.getElementById('userManagement').checked = true;
                document.getElementById('doctorManagement').checked = true;
                document.getElementById('patientManagement').checked = true;
                document.getElementById('appointmentManagement').checked = true;
                document.getElementById('healthPodManagement').checked = true;
            } else if (level === 'MANAGER') {
                document.getElementById('userManagement').checked = true;
                document.getElementById('doctorManagement').checked = true;
                document.getElementById('patientManagement').checked = true;
            }
        });
    </script>
</body>
</html>