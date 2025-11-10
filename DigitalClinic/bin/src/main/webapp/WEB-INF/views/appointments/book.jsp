<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .booking-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
        }
        .step {
            text-align: center;
            flex: 1;
            padding: 1rem;
            border-radius: 10px;
            background: #f8f9fa;
            margin: 0 0.5rem;
        }
        .step.active {
            background: #007bff;
            color: white;
        }
        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #6c757d;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.5rem;
        }
        .step.active .step-number {
            background: white;
            color: #007bff;
        }
        .doctor-card, .pod-card {
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
        }
        .doctor-card:hover, .pod-card:hover {
            border-color: #007bff;
            transform: translateY(-2px);
        }
        .doctor-card.selected, .pod-card.selected {
            border-color: #007bff;
            background-color: #f0f8ff;
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
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-calendar-plus me-2"></i>Book New Appointment
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <!-- Booking Steps -->
                        <div class="booking-steps">
                            <div class="step active" id="step1">
                                <div class="step-number">1</div>
                                <div class="step-title">Choose Type</div>
                            </div>
                            <div class="step" id="step2">
                                <div class="step-number">2</div>
                                <div class="step-title">Select Doctor/Pod</div>
                            </div>
                            <div class="step" id="step3">
                                <div class="step-number">3</div>
                                <div class="step-title">Date & Time</div>
                            </div>
                            <div class="step" id="step4">
                                <div class="step-number">4</div>
                                <div class="step-title">Confirm</div>
                            </div>
                        </div>

                        <form action="/appointments/book" method="post" id="appointmentForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="patientId" value="${patient.id}">
                            
                            <!-- Step 1: Appointment Type -->
                            <div class="step-content" id="step1-content">
                                <h5 class="mb-4">Choose Appointment Type</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="card doctor-card h-100 text-center" 
                                             onclick="selectType('VIDEO', this)">
                                            <div class="card-body">
                                                <i class="fas fa-video fa-3x text-primary mb-3"></i>
                                                <h5>Video Consultation</h5>
                                                <p class="text-muted">Consult with doctors online from your home</p>
                                                <ul class="list-unstyled text-start">
                                                    <li><i class="fas fa-check text-success me-2"></i>No travel required</li>
                                                    <li><i class="fas fa-check text-success me-2"></i>Flexible timing</li>
                                                    <li><i class="fas fa-check text-success me-2"></i>Specialist access</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="card pod-card h-100 text-center" 
                                             onclick="selectType('IN_PERSON', this)">
                                            <div class="card-body">
                                                <i class="fas fa-clinic-medical fa-3x text-success mb-3"></i>
                                                <h5>Health Pod Visit</h5>
                                                <p class="text-muted">Visit our local health pod for in-person checkup</p>
                                                <ul class="list-unstyled text-start">
                                                    <li><i class="fas fa-check text-success me-2"></i>Basic tests available</li>
                                                    <li><i class="fas fa-check text-success me-2"></i>Personal care</li>
                                                    <li><i class="fas fa-check text-success me-2"></i>Medicine dispensing</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" name="type" id="appointmentType">
                                <div class="text-end mt-4">
                                    <button type="button" class="btn btn-primary" onclick="nextStep(2)" disabled id="step1-next">
                                        Next <i class="fas fa-arrow-right ms-1"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Step 2: Doctor/Pod Selection -->
                            <div class="step-content" id="step2-content" style="display: none;">
                                <h5 class="mb-4">Select Healthcare Provider</h5>
                                
                                <!-- Doctor Selection (for Video consultations) -->
                                <div id="doctorSelection" style="display: none;">
                                    <h6 class="mb-3">Available Doctors</h6>
                                    <div class="row">
                                        <c:forEach var="doctor" items="${doctors}">
                                            <div class="col-md-6 mb-3">
                                                <div class="card doctor-card h-100" 
                                                     onclick="selectDoctor(${doctor.id}, this)">
                                                    <div class="card-body">
                                                        <div class="d-flex align-items-center">
                                                            <div class="flex-shrink-0">
                                                                <i class="fas fa-user-md fa-2x text-primary"></i>
                                                            </div>
                                                            <div class="flex-grow-1 ms-3">
                                                                <h6 class="mb-1">Dr. ${doctor.user.fullName}</h6>
                                                                <p class="mb-1 small text-muted">${doctor.specialization}</p>
                                                                <p class="mb-1 small">
                                                                    <i class="fas fa-graduation-cap me-1"></i>${doctor.qualification}
                                                                </p>
                                                                <p class="mb-0 small text-success">
                                                                    <i class="fas fa-rupee-sign me-1"></i>${doctor.consultationFee}
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <input type="hidden" name="doctorId" id="selectedDoctorId">
                                </div>
                                
                                <!-- Health Pod Selection (for In-person visits) -->
                                <div id="podSelection" style="display: none;">
                                    <h6 class="mb-3">Available Health Pods</h6>
                                    <div class="row">
                                        <c:forEach var="pod" items="${healthPods}">
                                            <div class="col-md-6 mb-3">
                                                <div class="card pod-card h-100" 
                                                     onclick="selectPod(${pod.id}, this)">
                                                    <div class="card-body">
                                                        <h6 class="card-title">${pod.name}</h6>
                                                        <p class="card-text small text-muted">
                                                            <i class="fas fa-map-marker-alt me-1 text-danger"></i>
                                                            ${pod.city}, ${pod.state}
                                                        </p>
                                                        <div class="mb-2">
                                                            <c:forEach var="facility" items="${pod.facilities}" begin="0" end="2">
                                                                <span class="badge bg-light text-dark small me-1">${facility}</span>
                                                            </c:forEach>
                                                        </div>
                                                        <p class="small mb-1">
                                                            <i class="fas fa-clock me-1 text-success"></i>${pod.operatingHours}
                                                        </p>
                                                        <p class="small mb-0">
                                                            <i class="fas fa-user me-1 text-info"></i>${pod.inchargeName}
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <input type="hidden" name="podId" id="selectedPodId">
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary" onclick="prevStep(1)">
                                        <i class="fas fa-arrow-left me-1"></i>Back
                                    </button>
                                    <button type="button" class="btn btn-primary" onclick="nextStep(3)" disabled id="step2-next">
                                        Next <i class="fas fa-arrow-right ms-1"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Step 3: Date & Time -->
                            <div class="step-content" id="step3-content" style="display: none;">
                                <h5 class="mb-4">Select Date & Time</h5>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="appointmentDate" class="form-label">Appointment Date</label>
                                        <input type="date" class="form-control" id="appointmentDate" 
                                               name="appointmentDate" min="" required> <!-- FIXED: Changed name to appointmentDate -->
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="appointmentTime" class="form-label">Appointment Time</label>
                                        <select class="form-select" id="appointmentTime" name="appointmentTime" required> <!-- FIXED: Added name attribute -->
                                            <option value="">Select Time</option>
                                            <option value="09:00">09:00 AM</option>
                                            <option value="10:00">10:00 AM</option>
                                            <option value="11:00">11:00 AM</option>
                                            <option value="14:00">02:00 PM</option>
                                            <option value="15:00">03:00 PM</option>
                                            <option value="16:00">04:00 PM</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="symptoms" class="form-label">Symptoms / Reason for Visit</label>
                                    <textarea class="form-control" id="symptoms" name="symptoms" 
                                              rows="3" placeholder="Describe your symptoms or reason for appointment"></textarea>
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary" onclick="prevStep(2)">
                                        <i class="fas fa-arrow-left me-1"></i>Back
                                    </button>
                                    <button type="button" class="btn btn-primary" onclick="nextStep(4)">
                                        Next <i class="fas fa-arrow-right ms-1"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Step 4: Confirmation -->
                            <div class="step-content" id="step4-content" style="display: none;">
                                <h5 class="mb-4">Confirm Appointment Details</h5>
                                
                                <div class="card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h6>Appointment Type</h6>
                                                <p id="confirm-type" class="text-muted"></p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>Healthcare Provider</h6>
                                                <p id="confirm-provider" class="text-muted"></p>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-md-6">
                                                <h6>Date & Time</h6>
                                                <p id="confirm-datetime" class="text-muted"></p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>Consultation Fee</h6>
                                                <p id="confirm-fee" class="text-muted"></p>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <h6>Symptoms / Reason</h6>
                                                <p id="confirm-symptoms" class="text-muted"></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-check mt-3">
                                    <input class="form-check-input" type="checkbox" id="termsAgreement" required>
                                    <label class="form-check-label" for="termsAgreement">
                                        I agree to the <a href="/terms" target="_blank">Terms of Service</a> and 
                                        <a href="/privacy" target="_blank">Privacy Policy</a>
                                    </label>
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary" onclick="prevStep(3)">
                                        <i class="fas fa-arrow-left me-1"></i>Back
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-calendar-check me-1"></i>Confirm Booking
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set minimum date to today
        document.getElementById('appointmentDate').min = new Date().toISOString().split('T')[0];
        
        let currentStep = 1;
        let selectedType = '';
        let selectedDoctor = null;
        let selectedPod = null;
        
        function selectType(type, element) {
            selectedType = type;
            document.getElementById('appointmentType').value = type;
            
            // Update UI
            document.querySelectorAll('.doctor-card, .pod-card').forEach(card => {
                card.classList.remove('selected');
            });
            element.classList.add('selected');
            
            // Enable next button
            document.getElementById('step1-next').disabled = false;
            
            // Show appropriate selection in next step
            if (type === 'VIDEO') {
                document.getElementById('doctorSelection').style.display = 'block';
                document.getElementById('podSelection').style.display = 'none';
            } else {
                document.getElementById('doctorSelection').style.display = 'none';
                document.getElementById('podSelection').style.display = 'block';
            }
        }
        
        function selectDoctor(doctorId, element) {
            selectedDoctor = doctorId;
            document.getElementById('selectedDoctorId').value = doctorId;
            
            // Update UI
            document.querySelectorAll('.doctor-card').forEach(card => {
                card.classList.remove('selected');
            });
            element.classList.add('selected');
            
            // Enable next button
            document.getElementById('step2-next').disabled = false;
        }
        
        function selectPod(podId, element) {
            selectedPod = podId;
            document.getElementById('selectedPodId').value = podId;
            
            // Update UI
            document.querySelectorAll('.pod-card').forEach(card => {
                card.classList.remove('selected');
            });
            element.classList.add('selected');
            
            // Enable next button
            document.getElementById('step2-next').disabled = false;
        }
        
        function nextStep(step) {
            // Hide current step
            document.getElementById(`step\${currentStep}-content`).style.display = 'none';
            document.getElementById(`step\${currentStep}`).classList.remove('active');
            
            // Show next step
            document.getElementById(`step\${step}-content`).style.display = 'block';
            document.getElementById(`step\${step}`).classList.add('active');
            
            currentStep = step;
            
            // Update confirmation details
            if (step === 4) {
                updateConfirmationDetails();
            }
        }
        
        function prevStep(step) {
            // Hide current step
            document.getElementById(`step\${currentStep}-content`).style.display = 'none';
            document.getElementById(`step\${currentStep}`).classList.remove('active');
            
            // Show previous step
            document.getElementById(`step\${step}-content`).style.display = 'block';
            document.getElementById(`step\${step}`).classList.add('active');
            
            currentStep = step;
        }
        
        function updateConfirmationDetails() {
            // Type
            document.getElementById('confirm-type').textContent = 
                selectedType === 'VIDEO' ? 'Video Consultation' : 'Health Pod Visit';
            
            // Provider
            if (selectedType === 'VIDEO' && selectedDoctor) {
                // In real app, fetch doctor details
                document.getElementById('confirm-provider').textContent = 'Selected Doctor';
            } else if (selectedType === 'IN_PERSON' && selectedPod) {
                // In real app, fetch pod details
                document.getElementById('confirm-provider').textContent = 'Selected Health Pod';
            }
            
            // Date & Time
            const date = document.getElementById('appointmentDate').value;
            const time = document.getElementById('appointmentTime').value;
            if (date && time) {
                document.getElementById('confirm-datetime').textContent = 
                    `${date} at ${time}`;
            }
            
            // Fee
            document.getElementById('confirm-fee').textContent = 
                selectedType === 'VIDEO' ? '₹300 (Standard Video Consultation)' : '₹200 (Health Pod Visit)';
            
            // Symptoms
            document.getElementById('confirm-symptoms').textContent = 
                document.getElementById('symptoms').value || 'Not specified';
        }
        
        // Auto-fill if parameters provided
        window.addEventListener('load', function() {
            <c:if test="${not empty selectedDoctor}">
            selectType('VIDEO', document.querySelector('.doctor-card'));
            // In real app, select the specific doctor card
            </c:if>
            <c:if test="${not empty selectedPod}">
            selectType('IN_PERSON', document.querySelector('.pod-card'));
            // In real app, select the specific pod card
            </c:if>
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>