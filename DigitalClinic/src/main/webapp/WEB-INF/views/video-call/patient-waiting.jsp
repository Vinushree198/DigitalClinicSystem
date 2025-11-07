<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .waiting-room {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .doctor-avatar {
            width: 120px;
            height: 120px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            border: 4px solid rgba(255,255,255,0.3);
        }
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .connection-status {
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 10px 20px;
            margin: 1rem 0;
        }
    </style>
</head>
<body class="waiting-room">
    <div class="container-fluid">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-lg-6 col-md-8 text-center">
                <!-- Header -->
                <div class="mb-5">
                    <h1 class="display-4 fw-bold mb-3">
                        <i class="fas fa-video me-2"></i>Waiting Room
                    </h1>
                    <p class="lead">Your video consultation will start shortly</p>
                </div>

                <!-- Doctor Information -->
                <div class="doctor-avatar pulse-animation">
                    <i class="fas fa-user-md fa-3x"></i>
                </div>
                
                <h3 class="mb-3">
                    <c:if test="${not empty consultation.appointment.doctor}">
                        Dr. ${consultation.appointment.doctor.user.fullName}
                    </c:if>
                    <c:if test="${empty consultation.appointment.doctor}">
                        Your Doctor
                    </c:if>
                </h3>
                
                <p class="mb-4">
                    <c:if test="${not empty consultation.appointment.doctor}">
                        ${consultation.appointment.doctor.specialization}
                    </c:if>
                </p>

                <!-- Consultation Details -->
                <div class="card bg-dark bg-opacity-25 border-0 mb-4">
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-6 mb-3">
                                <i class="fas fa-calendar-alt fa-2x mb-2"></i>
                                <h5>Appointment Time</h5>
                                <p class="mb-0">${consultation.scheduledStartTime}</p>
                            </div>
                            <div class="col-md-6 mb-3">
                                <i class="fas fa-clock fa-2x mb-2"></i>
                                <h5>Current Status</h5>
                                <p class="mb-0">
                                    <span class="badge bg-warning">Waiting for Doctor</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Connection Status -->
                <div class="connection-status d-inline-block">
                    <i class="fas fa-wifi me-2"></i>
                    <span id="connectionStatus">Checking connection...</span>
                </div>

                <!-- Action Buttons -->
                <div class="mt-5">
                    <a href="/video-call/${consultation.roomId}" 
                       class="btn btn-light btn-lg me-3 px-4 pulse-animation">
                        <i class="fas fa-play me-2"></i>Join Consultation
                    </a>
                    
                    <button type="button" class="btn btn-outline-light btn-lg px-4" 
                            onclick="testAudioVideo()">
                        <i class="fas fa-cog me-2"></i>Test Setup
                    </button>
                </div>

                <!-- Help Section -->
                <div class="mt-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card bg-dark bg-opacity-50 border-0">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-info-circle me-2"></i>Before You Join
                                    </h5>
                                    <ul class="list-unstyled text-start">
                                        <li class="mb-2">
                                            <i class="fas fa-check-circle text-success me-2"></i>
                                            Ensure good internet connection
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas fa-check-circle text-success me-2"></i>
                                            Test your microphone and camera
                                        </li>
                                        <li class="mb-2">
                                            <i class="fas fa-check-circle text-success me-2"></i>
                                            Find a quiet, well-lit space
                                        </li>
                                        <li class="mb-0">
                                            <i class="fas fa-check-circle text-success me-2"></i>
                                            Have your medical reports ready if any
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Emergency Contact -->
                <div class="mt-4">
                    <p class="small">
                        Need immediate help? 
                        <a href="/emergency" class="text-warning text-decoration-none">
                            Contact Emergency Support
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Test Modal -->
    <div class="modal fade" id="testModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Test Your Audio & Video</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Camera Test</h6>
                            <video id="testVideo" width="100%" height="200" autoplay muted 
                                   class="border rounded bg-dark"></video>
                            <div class="mt-2">
                                <select id="cameraSelect" class="form-select form-select-sm">
                                    <option value="">Select Camera</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Microphone Test</h6>
                            <div class="border rounded p-3 bg-light text-center">
                                <i class="fas fa-microphone fa-3x text-muted mb-3"></i>
                                <p class="small text-muted">Speak to test microphone</p>
                                <div class="audio-level bg-primary rounded" 
                                     style="height: 10px; width: 0%; transition: width 0.1s;"></div>
                            </div>
                            <div class="mt-2">
                                <select id="microphoneSelect" class="form-select form-select-sm">
                                    <option value="">Select Microphone</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button type="button" class="btn btn-success w-100" onclick="startTest()">
                            <i class="fas fa-play me-1"></i>Start Test
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Simulate connection check
        setTimeout(() => {
            document.getElementById('connectionStatus').innerHTML = 
                '<i class="fas fa-check-circle text-success me-2"></i>Connection Ready';
        }, 2000);

        function testAudioVideo() {
            const testModal = new bootstrap.Modal(document.getElementById('testModal'));
            testModal.show();
        }

        function startTest() {
            // In real implementation, this would access user media and test devices
            alert('In full implementation, this would test your camera and microphone.');
        }

        // Auto-redirect to main call after 30 seconds if doctor joins
        setTimeout(() => {
            // In real app, check if doctor has joined via WebSocket or polling
            console.log('Checking if doctor has joined...');
        }, 30000);
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>