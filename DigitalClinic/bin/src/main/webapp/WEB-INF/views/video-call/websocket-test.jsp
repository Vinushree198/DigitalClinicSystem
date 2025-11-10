<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Test - DigitalClinic</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
    <h2>WebSocket Connection Test</h2>
    
    <div>
        <button onclick="connectWebSocket()">Test WebSocket Connection</button>
        <button onclick="testVideoConsultation()">Test Video Consultation</button>
    </div>
    
    <div id="status" style="margin-top: 20px; padding: 10px; border: 1px solid #ccc;"></div>
    
    <script>
        let stompClient = null;
        
        function connectWebSocket() {
            const socket = new SockJS('/ws-video-consultation');
            stompClient = Stomp.over(socket);
            
            const statusDiv = document.getElementById('status');
            statusDiv.innerHTML = 'Connecting to WebSocket...';
            
            stompClient.connect({}, function(frame) {
                statusDiv.innerHTML = '✅ <strong>SUCCESS:</strong> WebSocket connected!<br>' +
                                    'Frame: ' + frame + '<br><br>' +
                                    '✅ WebSocket is working properly!';
                console.log('Connected: ' + frame);
                
                // Test subscription
                const subscription = stompClient.subscribe('/topic/test', function(message) {
                    console.log('Received: ' + message.body);
                });
                
                // Test sending a message
                stompClient.send("/app/test", {}, JSON.stringify({message: 'Hello WebSocket!'}));
                
            }, function(error) {
                statusDiv.innerHTML = '❌ <strong>FAILED:</strong> ' + error + '<br><br>' +
                                    'Check if WebSocket configuration is correct.';
                console.error('Error: ', error);
            });
        }
        
        function testVideoConsultation() {
            const statusDiv = document.getElementById('status');
            statusDiv.innerHTML = 'Testing video consultation setup...';
            
            // Check if browser supports WebRTC
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                statusDiv.innerHTML += '<br>❌ WebRTC not supported in this browser';
                return;
            }
            
            // Test camera access
            navigator.mediaDevices.getUserMedia({ video: true, audio: true })
                .then(function(stream) {
                    statusDiv.innerHTML += '<br>✅ Camera and microphone access granted';
                    
                    // Test WebSocket again with consultation data
                    if (stompClient && stompClient.connected) {
                        stompClient.send("/app/consultation.join", {}, 
                            JSON.stringify({
                                roomId: 'test_room_123',
                                userType: 'PATIENT',
                                userName: 'Test Patient'
                            }));
                        statusDiv.innerHTML += '<br>✅ Successfully sent consultation join message';
                    }
                    
                    // Stop the stream
                    stream.getTracks().forEach(track => track.stop());
                })
                .catch(function(error) {
                    statusDiv.innerHTML += '<br>❌ Camera/microphone access denied: ' + error.message;
                });
        }
    </script>
</body>
</html>