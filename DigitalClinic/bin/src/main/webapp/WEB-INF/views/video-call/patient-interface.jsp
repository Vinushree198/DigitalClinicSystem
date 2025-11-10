<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title} - DigitalClinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        .video-container {
            background: #1a1a1a;
            min-height: 100vh;
            color: white;
        }
        .video-main {
            height: 70vh;
            background: #2d2d2d;
            border-radius: 10px;
            position: relative;
        }
        .video-remote {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }
        .video-local {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 200px;
            height: 150px;
            border: 2px solid #007bff;
            border-radius: 8px;
            background: #000;
        }
        .controls-container {
            background: rgba(45, 45, 45, 0.9);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }
        .control-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: none;
            margin: 0 10px;
            font-size: 1.2rem;
            transition: all 0.3s;
        }
        .control-btn:hover {
            transform: scale(1.1);
        }
        .btn-mute {
            background: #6c757d;
            color: white;
        }
        .btn-mute.active {
            background: #dc3545;
        }
        .btn-video {
            background: #6c757d;
            color: white;
        }
        .btn-video.active {
            background: #dc3545;
        }
        .btn-call {
            background: #dc3545;
            color: white;
        }
        .btn-call.active {
            background: #28a745;
        }
        .patient-info {
            background: rgba(0, 123, 255, 0.1);
            border-radius: 10px;
            padding: 1rem;
        }
        .consultation-timer {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .chat-container {
            background: #2d2d2d;
            border-radius: 10px;
            height: 400px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
        }
        .chat-input {
            border-top: 1px solid #444;
            padding: 1rem;
        }
        .message {
            margin: 10px 0;
            padding: 8px 12px;
            border-radius: 8px;
            max-width: 80%;
        }
        .message.system {
            background-color: #e9ecef;
            color: #333;
            font-style: italic;
            margin: 5px auto;
            text-align: center;
            max-width: 100%;
        }
        .message.doctor {
            background-color: #007bff;
            color: white;
            margin-left: auto;
        }
        .message.patient {
            background-color: #28a745;
            color: white;
            margin-right: auto;
        }
        .connection-status {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1000;
        }
    </style>
</head>
<body class="video-container">
    <div class="container-fluid py-4">
        <div class="row">
            <!-- Main Video Area -->
            <div class="col-lg-9">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="mb-0">
                            <i class="fas fa-video me-2 text-primary"></i>
                            Video Consultation with 
                            <c:if test="${not empty consultation.appointment.doctor}">
                                Dr. ${consultation.appointment.doctor.user.fullName}
                            </c:if>
                        </h4>
                        <p class="text-muted mb-0">
                            ${consultation.appointment.doctor.specialization}
                        </p>
                    </div>
                    <div class="consultation-timer" id="consultationTimer">
                        00:00
                    </div>
                </div>

                <!-- Video Streams -->
                <div class="video-main mb-3">
                    <!-- Remote Video (Doctor) -->
                    <video class="video-remote" id="remoteVideo" autoplay></video>

                    <!-- Local Video (Patient) -->
                    <video class="video-local" id="localVideo" autoplay muted></video>

                    <!-- Connection Status -->
                    <div class="connection-status">
                        <span class="badge bg-success" id="connectionStatus">
                            <i class="fas fa-wifi me-1"></i>Connecting...
                        </span>
                    </div>

                    <!-- Waiting Message -->
                    <div id="waitingMessage" class="h-100 d-flex align-items-center justify-content-center">
                        <div class="text-center">
                            <i class="fas fa-user-md fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">Waiting for doctor to join...</h5>
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Controls -->
                <div class="controls-container">
                    <div class="d-flex justify-content-center align-items-center">
                        <button class="control-btn btn-mute" id="muteBtn" onclick="toggleMute()">
                            <i class="fas fa-microphone"></i>
                        </button>
                        
                        <button class="control-btn btn-video" id="videoBtn" onclick="toggleVideo()">
                            <i class="fas fa-video"></i>
                        </button>
                        
                        <button class="control-btn btn-call" id="callBtn" onclick="endCall()">
                            <i class="fas fa-phone-slash"></i>
                        </button>
                        
                        <button class="control-btn btn-info" onclick="showPatientInfo()" 
                                style="background: #17a2b8; color: white;">
                            <i class="fas fa-info"></i>
                        </button>
                        
                        <button class="control-btn btn-chat" onclick="toggleChat()" 
                                style="background: #ffc107; color: black;">
                            <i class="fas fa-comments"></i>
                        </button>
                    </div>
                </div>

                <!-- Consultation Info -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="patient-info">
                            <h6><i class="fas fa-user me-2"></i>Your Information</h6>
                            <p class="mb-1"><strong>Name:</strong> ${patient.user.fullName}</p>
                            <p class="mb-1"><strong>Age:</strong> ${patient.age} years</p>
                            <p class="mb-0"><strong>Symptoms:</strong> ${consultation.appointment.symptoms}</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="patient-info">
                            <h6><i class="fas fa-stethoscope me-2"></i>Consultation Details</h6>
                            <p class="mb-1"><strong>Started:</strong> <span id="startTime">Just now</span></p>
                            <p class="mb-1"><strong>Duration:</strong> <span id="duration">00:00</span></p>
                            <p class="mb-0"><strong>Type:</strong> Video Consultation</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-3">
                <!-- Chat Panel -->
                <div class="chat-container mb-4">
                    <div class="chat-header bg-primary text-white p-3 rounded-top">
                        <h6 class="mb-0">
                            <i class="fas fa-comments me-2"></i>Chat
                        </h6>
                    </div>
                    <div class="chat-messages" id="chatMessages">
                        <div class="message system">
                            <small>Consultation started. You can now chat with the doctor.</small>
                        </div>
                    </div>
                    <div class="chat-input">
                        <div class="input-group">
                            <input type="text" class="form-control" id="chatInput" 
                                   placeholder="Type a message..." onkeypress="handleChatInput(event)">
                            <button class="btn btn-primary" onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Tools & Resources -->
                <div class="card bg-dark border-0 mb-3">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-tools me-2"></i>Quick Tools
                        </h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-info btn-sm" onclick="shareScreen()">
                                <i class="fas fa-desktop me-1"></i>Share Screen
                            </button>
                            <button class="btn btn-outline-warning btn-sm" onclick="takeSnapshot()">
                                <i class="fas fa-camera me-1"></i>Take Snapshot
                            </button>
                            <button class="btn btn-outline-success btn-sm" onclick="showPrescription()">
                                <i class="fas fa-file-prescription me-1"></i>View Prescription
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Emergency Help -->
                <div class="card bg-danger bg-opacity-25 border-0">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-first-aid me-2"></i>Emergency Help
                        </h6>
                        <p class="small mb-2">If you need immediate medical assistance:</p>
                        <div class="d-grid">
                            <button class="btn btn-outline-danger btn-sm" onclick="emergencyHelp()">
                                <i class="fas fa-ambulance me-1"></i>Emergency Support
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Info Modal -->
    <div class="modal fade" id="patientInfoModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user me-2"></i>Patient Information
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <strong>Personal Details:</strong>
                        <p class="mb-1">Name: ${patient.user.fullName}</p>
                        <p class="mb-1">Age: ${patient.age} years</p>
                        <p class="mb-1">Gender: ${patient.gender}</p>
                        <p class="mb-0">Blood Group: ${patient.bloodGroup}</p>
                    </div>
                    <div class="mb-3">
                        <strong>Current Symptoms:</strong>
                        <p class="mb-0">${consultation.appointment.symptoms}</p>
                    </div>
                    <c:if test="${not empty patient.medicalHistory}">
                        <div>
                            <strong>Medical History:</strong>
                            <p class="mb-0 small">${patient.medicalHistory}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Prescription Modal -->
    <div class="modal fade" id="prescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-file-prescription me-2"></i>Prescription
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="prescriptionContent">
                        <c:if test="${not empty consultation.appointment.prescription}">
                            <div class="prescription-box bg-dark border rounded p-3">
                                ${consultation.appointment.prescription}
                            </div>
                        </c:if>
                        <c:if test="${empty consultation.appointment.prescription}">
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-file-medical fa-3x mb-3"></i>
                                <p>No prescription has been provided yet.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="printPrescription()">
                        <i class="fas fa-print me-1"></i>Print
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // WebSocket Configuration
        const roomId = '${consultation.roomId}';
        const userId = '${user.id}';
        const userName = '${patient.user.fullName}';
        const userType = 'PATIENT';
        const doctorUserId = '${consultation.appointment.doctor.user.id}';
        
        let stompClient = null;
        let localStream = null;
        let peerConnection = null;
        let isMuted = false;
        let isVideoOn = true;
        let consultationStartTime = new Date();
        let timerInterval = null;

        // WebSocket Connection
        function connect() {
            const socket = new SockJS('/ws-video-consultation');
            stompClient = Stomp.over(socket);
            
            stompClient.connect({}, function(frame) {
                console.log('Connected to consultation: ' + roomId);
                updateConnectionStatus(true);
                
                // Join consultation room
                stompClient.send("/app/consultation.join", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        userType: userType,
                        userName: userName
                    }));
                
                // Subscribe to topics
                subscribeToTopics();
                
                // Initialize WebRTC
                initializeWebRTC();
                
                // Start timer
                startTimer();
                
            }, function(error) {
                console.error('WebSocket connection error:', error);
                updateConnectionStatus(false);
                setTimeout(connect, 5000);
            });
        }

        function subscribeToTopics() {
            // Participants updates
            stompClient.subscribe('/topic/consultation.' + roomId + '.participants', 
                handleParticipantsUpdate);
            
            // WebRTC signaling
            stompClient.subscribe('/user/queue/webrtc.offer', handleWebRTCOffer);
            stompClient.subscribe('/user/queue/webrtc.answer', handleWebRTCAnswer);
            stompClient.subscribe('/user/queue/webrtc.ice-candidate', handleICECandidate);
            
            // Chat and media
            stompClient.subscribe('/topic/consultation.' + roomId + '.chat', handleChatMessage);
            stompClient.subscribe('/topic/consultation.' + roomId + '.media', handleMediaUpdate);
            stompClient.subscribe('/topic/consultation.' + roomId + '.status', handleStatusUpdate);
            stompClient.subscribe('/topic/consultation.' + roomId + '.end', handleConsultationEnd);
            stompClient.subscribe('/user/queue/errors', handleError);
        }

        // WebRTC Functions
        async function initializeWebRTC() {
            try {
                localStream = await navigator.mediaDevices.getUserMedia({ 
                    video: true, 
                    audio: true 
                });
                
                const localVideo = document.getElementById('localVideo');
                localVideo.srcObject = localStream;
                
                createPeerConnection();
                
            } catch (error) {
                console.error('Error accessing media devices:', error);
                showError('Unable to access camera/microphone. Please check permissions.');
            }
        }

        function createPeerConnection() {
            const configuration = {
                iceServers: [
                    { urls: 'stun:stun.l.google.com:19302' }
                ]
            };
            
            peerConnection = new RTCPeerConnection(configuration);
            
            // Add local stream
            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });
            
            // Handle incoming stream
            peerConnection.ontrack = (event) => {
                const remoteVideo = document.getElementById('remoteVideo');
                const waitingMessage = document.getElementById('waitingMessage');
                
                remoteVideo.srcObject = event.streams[0];
                waitingMessage.style.display = 'none';
                remoteVideo.style.display = 'block';
                
                addSystemMessage('Doctor joined the consultation');
            };
            
            // Handle ICE candidates
            peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    stompClient.send("/app/consultation.webrtc.ice-candidate", {}, 
                        JSON.stringify({
                            roomId: roomId,
                            targetUserId: doctorUserId,
                            candidate: event.candidate
                        }));
                }
            };
        }

        // WebRTC Signaling Handlers
        async function handleWebRTCOffer(message) {
            const data = JSON.parse(message.body);
            try {
                await peerConnection.setRemoteDescription(data.offer);
                const answer = await peerConnection.createAnswer();
                await peerConnection.setLocalDescription(answer);
                
                stompClient.send("/app/consultation.webrtc.answer", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        targetUserId: data.fromUserId,
                        answer: answer
                    }));
            } catch (error) {
                console.error('Error handling WebRTC offer:', error);
            }
        }

        async function handleWebRTCAnswer(message) {
            const data = JSON.parse(message.body);
            try {
                await peerConnection.setRemoteDescription(data.answer);
            } catch (error) {
                console.error('Error handling WebRTC answer:', error);
            }
        }

        function handleICECandidate(message) {
            const data = JSON.parse(message.body);
            peerConnection.addIceCandidate(new RTCIceCandidate(data.candidate))
                .catch(error => console.error('Error adding ICE candidate:', error));
        }

        // Event Handlers
        function handleParticipantsUpdate(message) {
            const data = JSON.parse(message.body);
            if (data.type === 'USER_JOINED' && data.userType === 'DOCTOR') {
                addSystemMessage('Dr. ' + data.userName + ' joined the consultation');
            }
        }

        function handleChatMessage(message) {
            const data = JSON.parse(message.body);
            addChatMessage(data);
        }

        function handleMediaUpdate(message) {
            const data = JSON.parse(message.body);
            // Handle media toggle updates from doctor
        }

        function handleStatusUpdate(message) {
            const data = JSON.parse(message.body);
            // Update consultation status
        }

        function handleConsultationEnd(message) {
            const data = JSON.parse(message.body);
            alert(`Consultation ended by doctor`);
            cleanupAndRedirect();
        }

        function handleError(message) {
            const data = JSON.parse(message.body);
            showError(data.error);
        }

        // Control functions
        function toggleMute() {
            const audioTrack = localStream.getAudioTracks()[0];
            if (audioTrack) {
                audioTrack.enabled = !audioTrack.enabled;
                isMuted = !audioTrack.enabled;
                
                const btn = document.getElementById('muteBtn');
                btn.classList.toggle('active', isMuted);
                btn.innerHTML = isMuted ? '<i class="fas fa-microphone-slash"></i>' : '<i class="fas fa-microphone"></i>';
                
                // Notify other participants
                if (stompClient) {
                    stompClient.send("/app/consultation.media.toggle", {}, 
                        JSON.stringify({
                            roomId: roomId,
                            mediaType: 'audio',
                            enabled: !isMuted
                        }));
                }
            }
        }

        function toggleVideo() {
            const videoTrack = localStream.getVideoTracks()[0];
            if (videoTrack) {
                videoTrack.enabled = !videoTrack.enabled;
                isVideoOn = videoTrack.enabled;
                
                const btn = document.getElementById('videoBtn');
                btn.classList.toggle('active', !isVideoOn);
                btn.innerHTML = isVideoOn ? '<i class="fas fa-video"></i>' : '<i class="fas fa-video-slash"></i>';
                
                // Notify other participants
                if (stompClient) {
                    stompClient.send("/app/consultation.media.toggle", {}, 
                        JSON.stringify({
                            roomId: roomId,
                            mediaType: 'video',
                            enabled: isVideoOn
                        }));
                }
            }
        }

        function endCall() {
            if (confirm('Are you sure you want to end the consultation?')) {
                if (stompClient) {
                    stompClient.send("/app/consultation.leave", {}, 
                        JSON.stringify({
                            roomId: roomId
                        }));
                }
                cleanupAndRedirect();
            }
        }

        // Chat Functions
        function sendMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            
            if (message && stompClient) {
                stompClient.send("/app/consultation.chat", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        content: message
                    }));
                
                input.value = '';
            }
        }

        function handleChatInput(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }

        // Utility Functions
        function addChatMessage(message) {
            const chatMessages = document.getElementById('chatMessages');
            
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${message.senderType.toLowerCase()}`;
            if (message.messageType === 'SYSTEM') {
                messageDiv.className += ' system';
            }
            
            const timestamp = new Date(message.timestamp).toLocaleTimeString();
            messageDiv.innerHTML = `
                <strong>${message.senderName}:</strong> ${message.content}
                <small class="float-end" style="opacity: 0.7;">${timestamp}</small>
            `;
            
            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function addSystemMessage(content) {
            addChatMessage({
                senderType: 'SYSTEM',
                senderName: 'System',
                content: content,
                timestamp: new Date(),
                messageType: 'SYSTEM'
            });
        }

        function updateConnectionStatus(connected) {
            const statusElement = document.getElementById('connectionStatus');
            if (connected) {
                statusElement.className = 'badge bg-success';
                statusElement.innerHTML = '<i class="fas fa-wifi me-1"></i>Connected';
            } else {
                statusElement.className = 'badge bg-danger';
                statusElement.innerHTML = '<i class="fas fa-wifi-slash me-1"></i>Disconnected';
            }
        }

        function startTimer() {
            consultationStartTime = new Date();
            timerInterval = setInterval(updateTimer, 1000);
        }

        function updateTimer() {
            const now = new Date();
            const diff = Math.floor((now - consultationStartTime) / 1000);
            const minutes = Math.floor(diff / 60);
            const seconds = diff % 60;
            
            document.getElementById('consultationTimer').textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            document.getElementById('duration').textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }

        function cleanupAndRedirect() {
            // Stop media tracks
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
            }
            
            // Clear interval
            if (timerInterval) {
                clearInterval(timerInterval);
            }
            
            // Disconnect WebSocket
            if (stompClient) {
                stompClient.disconnect();
            }
            
            // Redirect to appointments page
            setTimeout(() => {
                window.location.href = '/appointments/${consultation.appointment.id}';
            }, 1000);
        }

        function showError(message) {
            alert('Error: ' + message);
        }

        // UI Functions (unchanged from your original)
        function showPatientInfo() {
            const modal = new bootstrap.Modal(document.getElementById('patientInfoModal'));
            modal.show();
        }

        function toggleChat() {
            const chatContainer = document.querySelector('.chat-container');
            chatContainer.style.display = chatContainer.style.display === 'none' ? 'flex' : 'none';
        }

        function shareScreen() {
            alert('Screen sharing feature will be implemented in future version.');
        }

        function takeSnapshot() {
            alert('Snapshot feature will be implemented in future version.');
        }

        function showPrescription() {
            const modal = new bootstrap.Modal(document.getElementById('prescriptionModal'));
            modal.show();
        }

        function emergencyHelp() {
            if (confirm('Are you experiencing a medical emergency? This will alert emergency services.')) {
                window.location.href = '/emergency';
            }
        }

        function printPrescription() {
            window.print();
        }

        // Initialize when page loads
        window.onload = function() {
            connect();
            document.getElementById('startTime').textContent = new Date().toLocaleTimeString();
        };

        // Cleanup on page unload
        window.addEventListener('beforeunload', function() {
            if (stompClient) {
                stompClient.send("/app/consultation.leave", {}, 
                    JSON.stringify({
                        roomId: roomId
                    }));
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>