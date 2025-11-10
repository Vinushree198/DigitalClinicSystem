<%-- video-call/doctor-interface.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${title}</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        .video-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .video-wrapper {
            flex: 1;
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 10px;
        }
        video {
            width: 100%;
            max-width: 500px;
            height: auto;
            border-radius: 4px;
        }
        .controls {
            margin: 20px 0;
            text-align: center;
        }
        .chat-container {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            max-height: 300px;
            overflow-y: auto;
        }
        .message {
            margin: 10px 0;
            padding: 8px;
            border-radius: 4px;
        }
        .message.system {
            background-color: #f0f0f0;
            font-style: italic;
        }
        .message.doctor {
            background-color: #d4edda;
            text-align: right;
        }
        .message.patient {
            background-color: #e2e3e5;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Video Consultation - Dr. ${doctor.firstName} ${doctor.lastName}</h2>
        
        <!-- Patient Information -->
        <div class="patient-info card mb-4">
            <div class="card-body">
                <h5 class="card-title">Patient: ${patient.firstName} ${patient.lastName}</h5>
                <p class="card-text">
                    <strong>Email:</strong> ${patient.user.email}<br>
                    <strong>Phone:</strong> ${patient.phoneNumber}<br>
                    <strong>Appointment Time:</strong> ${consultation.scheduledStartTime}
                </p>
            </div>
        </div>

        <!-- Video Container -->
        <div class="video-container">
            <div class="video-wrapper">
                <h5>Your Video</h5>
                <video id="localVideo" autoplay muted></video>
                <div class="mt-2">
                    <small id="localVideoStatus" class="text-success">● Live</small>
                </div>
            </div>
            <div class="video-wrapper">
                <h5>Patient Video</h5>
                <video id="remoteVideo" autoplay></video>
                <div class="mt-2">
                    <small id="remoteVideoStatus" class="text-muted">Waiting for patient...</small>
                </div>
            </div>
        </div>

        <!-- Controls -->
        <div class="controls">
            <button id="toggleVideo" class="btn btn-outline-primary">
                <i class="fas fa-video"></i> Video On
            </button>
            <button id="toggleAudio" class="btn btn-outline-primary">
                <i class="fas fa-microphone"></i> Audio On
            </button>
            <button id="startConsultation" class="btn btn-success">
                <i class="fas fa-play"></i> Start Consultation
            </button>
            <button id="endConsultation" class="btn btn-danger">
                <i class="fas fa-stop"></i> End Consultation
            </button>
        </div>

        <!-- Status -->
        <div class="status alert alert-info">
            <strong>Status:</strong> <span id="consultationStatus">${consultation.status}</span>
            <strong>Participants:</strong> <span id="participantCount">1</span>
        </div>

        <!-- Chat Container -->
        <div class="row">
            <div class="col-md-8">
                <div class="chat-container">
                    <h5>Consultation Chat</h5>
                    <div id="chatMessages"></div>
                </div>
                <div class="input-group mt-2">
                    <input type="text" id="messageInput" class="form-control" placeholder="Type your message...">
                    <button class="btn btn-primary" onclick="sendMessage()">Send</button>
                </div>
            </div>
            <div class="col-md-4">
                <!-- Quick Prescription Templates -->
                <div class="card">
                    <div class="card-header">
                        <h6>Quick Actions</h6>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-outline-secondary btn-sm mb-2" onclick="sendQuickMessage('Please describe your symptoms in detail.')">
                            Ask about symptoms
                        </button>
                        <button class="btn btn-outline-secondary btn-sm mb-2" onclick="sendQuickMessage('Any allergies to medications?')">
                            Ask about allergies
                        </button>
                        <button class="btn btn-outline-secondary btn-sm mb-2" onclick="sendQuickMessage('I am prescribing medication for your condition.')">
                            Prescription info
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Consultation Notes Form -->
        <div class="card mt-4">
            <div class="card-header">
                <h6>Consultation Notes</h6>
            </div>
            <div class="card-body">
                <form id="consultationForm" action="/video-call/${consultation.id}/complete" method="post">
                    <div class="mb-3">
                        <label for="prescription" class="form-label">Prescription</label>
                        <textarea class="form-control" id="prescription" name="prescription" rows="3" 
                                  placeholder="Enter prescription details..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="notes" class="form-label">Clinical Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3" 
                                  placeholder="Enter clinical notes..."></textarea>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // WebSocket Configuration
        const roomId = '${consultation.roomId}';
        const userId = '${user.id}';
        const userName = 'Dr. ${doctor.firstName} ${doctor.lastName}';
        const userType = 'DOCTOR';
        
        let stompClient = null;
        let localStream = null;
        let peerConnection = null;
        let isVideoEnabled = true;
        let isAudioEnabled = true;

        function connect() {
            const socket = new SockJS('/ws-video-consultation');
            stompClient = Stomp.over(socket);
            
            stompClient.connect({}, function(frame) {
                console.log('Connected to consultation: ' + roomId);
                
                // Join consultation room
                stompClient.send("/app/consultation.join", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        userType: userType,
                        userName: userName
                    }));
                
                // Subscribe to consultation topics
                subscribeToTopics();
                
                // Initialize WebRTC
                initializeWebRTC();
            }, function(error) {
                console.error('WebSocket connection error:', error);
                setTimeout(connect, 5000); // Reconnect after 5 seconds
            });
        }

        function subscribeToTopics() {
            // Participants updates
            stompClient.subscribe('/topic/consultation.' + roomId + '.participants', 
                function(message) {
                    handleParticipantsUpdate(JSON.parse(message.body));
                });
            
            // WebRTC signaling
            stompClient.subscribe('/user/queue/webrtc.offer', 
                function(message) {
                    handleWebRTCOffer(JSON.parse(message.body));
                });
            
            stompClient.subscribe('/user/queue/webrtc.answer', 
                function(message) {
                    handleWebRTCAnswer(JSON.parse(message.body));
                });
            
            stompClient.subscribe('/user/queue/webrtc.ice-candidate', 
                function(message) {
                    handleICECandidate(JSON.parse(message.body));
                });
            
            // Chat messages
            stompClient.subscribe('/topic/consultation.' + roomId + '.chat', 
                function(message) {
                    handleChatMessage(JSON.parse(message.body));
                });
            
            // Media controls
            stompClient.subscribe('/topic/consultation.' + roomId + '.media', 
                function(message) {
                    handleMediaUpdate(JSON.parse(message.body));
                });
            
            // Consultation status
            stompClient.subscribe('/topic/consultation.' + roomId + '.status', 
                function(message) {
                    handleStatusUpdate(JSON.parse(message.body));
                });
            
            // Consultation end
            stompClient.subscribe('/topic/consultation.' + roomId + '.end', 
                function(message) {
                    handleConsultationEnd(JSON.parse(message.body));
                });
            
            // Errors
            stompClient.subscribe('/user/queue/errors', 
                function(message) {
                    handleError(JSON.parse(message.body));
                });
        }

        // WebRTC Functions
        async function initializeWebRTC() {
            try {
                localStream = await navigator.mediaDevices.getUserMedia({ 
                    video: true, 
                    audio: true 
                });
                document.getElementById('localVideo').srcObject = localStream;
                createPeerConnection();
            } catch (error) {
                console.error('Error accessing media devices:', error);
                alert('Unable to access camera/microphone. Please check permissions.');
            }
        }

        function createPeerConnection() {
            const configuration = {
                iceServers: [
                    { urls: 'stun:stun.l.google.com:19302' },
                    { urls: 'stun:stun1.l.google.com:19302' }
                ]
            };
            
            peerConnection = new RTCPeerConnection(configuration);
            
            // Add local stream tracks
            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });
            
            // Handle incoming stream
            peerConnection.ontrack = (event) => {
                const remoteVideo = document.getElementById('remoteVideo');
                remoteVideo.srcObject = event.streams[0];
                document.getElementById('remoteVideoStatus').textContent = '● Live';
                document.getElementById('remoteVideoStatus').className = 'text-success';
            };
            
            // Handle ICE candidates
            peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    stompClient.send("/app/consultation.webrtc.ice-candidate", {}, 
                        JSON.stringify({
                            roomId: roomId,
                            targetUserId: getPatientUserId(),
                            candidate: event.candidate
                        }));
                }
            };
            
            // Send offer to patient when connection is established
            setTimeout(() => {
                if (peerConnection.signalingState === 'stable') {
                    createAndSendOffer();
                }
            }, 2000);
        }

        async function createAndSendOffer() {
            try {
                const offer = await peerConnection.createOffer();
                await peerConnection.setLocalDescription(offer);
                
                stompClient.send("/app/consultation.webrtc.offer", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        targetUserId: getPatientUserId(),
                        offer: offer
                    }));
            } catch (error) {
                console.error('Error creating offer:', error);
            }
        }

        // WebRTC Signaling Handlers
        async function handleWebRTCOffer(data) {
            // Doctor typically doesn't receive offers, but handle if needed
        }

        async function handleWebRTCAnswer(data) {
            try {
                await peerConnection.setRemoteDescription(data.answer);
            } catch (error) {
                console.error('Error setting remote description:', error);
            }
        }

        function handleICECandidate(data) {
            peerConnection.addIceCandidate(new RTCIceCandidate(data.candidate))
                .catch(error => console.error('Error adding ICE candidate:', error));
        }

        // Media Controls
        document.getElementById('toggleVideo').addEventListener('click', function() {
            const videoTrack = localStream.getVideoTracks()[0];
            if (videoTrack) {
                videoTrack.enabled = !videoTrack.enabled;
                isVideoEnabled = videoTrack.enabled;
                
                this.innerHTML = isVideoEnabled ? 
                    '<i class="fas fa-video"></i> Video On' : 
                    '<i class="fas fa-video-slash"></i> Video Off';
                this.classList.toggle('btn-outline-danger', !isVideoEnabled);
                
                // Notify other participants
                stompClient.send("/app/consultation.media.toggle", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        mediaType: 'video',
                        enabled: isVideoEnabled
                    }));
            }
        });

        document.getElementById('toggleAudio').addEventListener('click', function() {
            const audioTrack = localStream.getAudioTracks()[0];
            if (audioTrack) {
                audioTrack.enabled = !audioTrack.enabled;
                isAudioEnabled = audioTrack.enabled;
                
                this.innerHTML = isAudioEnabled ? 
                    '<i class="fas fa-microphone"></i> Audio On' : 
                    '<i class="fas fa-microphone-slash"></i> Audio Off';
                this.classList.toggle('btn-outline-danger', !isAudioEnabled);
                
                // Notify other participants
                stompClient.send("/app/consultation.media.toggle", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        mediaType: 'audio',
                        enabled: isAudioEnabled
                    }));
            }
        });

        // Consultation Controls
        document.getElementById('startConsultation').addEventListener('click', function() {
            stompClient.send("/app/consultation.status.update", {}, 
                JSON.stringify({
                    roomId: roomId,
                    status: 'IN_PROGRESS'
                }));
            
            // Update local UI
            document.getElementById('consultationStatus').textContent = 'IN_PROGRESS';
            sendSystemMessage('Doctor started the consultation');
        });

        document.getElementById('endConsultation').addEventListener('click', function() {
            if (confirm('Are you sure you want to end this consultation?')) {
                stompClient.send("/app/consultation.end", {}, 
                    JSON.stringify({
                        roomId: roomId
                    }));
            }
        });

        // Chat Functions
        function sendMessage() {
            const messageInput = document.getElementById('messageInput');
            const content = messageInput.value.trim();
            
            if (content && stompClient) {
                stompClient.send("/app/consultation.chat", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        content: content
                    }));
                
                messageInput.value = '';
            }
        }

        function sendQuickMessage(content) {
            if (stompClient) {
                stompClient.send("/app/consultation.chat", {}, 
                    JSON.stringify({
                        roomId: roomId,
                        content: content
                    }));
            }
        }

        // Message Handlers
        function handleParticipantsUpdate(data) {
            const participantCount = Object.keys(data.participants || {}).length;
            document.getElementById('participantCount').textContent = participantCount;
            
            if (data.type === 'USER_JOINED') {
                addSystemMessage(data.userName + ' joined the consultation');
            } else if (data.type === 'USER_LEFT') {
                addSystemMessage(data.userName + ' left the consultation');
            }
        }

        function handleChatMessage(message) {
            addChatMessage(message);
        }

        function handleMediaUpdate(data) {
            // Update UI to show other participant's media status
            if (data.userId !== userId) {
                const statusElement = data.mediaType === 'video' ? 
                    document.getElementById('remoteVideoStatus') : 
                    document.getElementById('localVideoStatus');
                
                if (statusElement) {
                    statusElement.textContent = data.enabled ? '● Live' : '❌ Off';
                    statusElement.className = data.enabled ? 'text-success' : 'text-danger';
                }
            }
        }

        function handleStatusUpdate(data) {
            document.getElementById('consultationStatus').textContent = data.status;
        }

        function handleConsultationEnd(data) {
            alert(`Consultation ended by ${data.endedByUser}`);
            
            // Stop all media tracks
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
            }
            
            // Submit the consultation form
            document.getElementById('consultationForm').submit();
        }

        function handleError(error) {
            console.error('WebSocket error:', error);
            alert('Error: ' + error.error);
        }

        // UI Helper Functions
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
                <small class="text-muted float-end">${timestamp}</small>
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

        function getPatientUserId() {
            // This should be implemented to get the patient's user ID
            // You might need to pass it from the controller or fetch it
            return '${patient.user.id}';
        }

        // Initialize when page loads
        window.onload = function() {
            connect();
            
            // Handle Enter key in message input
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });
        };

        // Cleanup on page unload
        window.onbeforeunload = function() {`
            if (stompClient) {
                stompClient.send("/app/consultation.leave", {}, 
                    JSON.stringify({
                        roomId: roomId
                    }));
            }
            
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
            }
        };
    </script>
</body>
</html>