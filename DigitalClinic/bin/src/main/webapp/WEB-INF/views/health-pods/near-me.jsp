<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .location-card {
            border-left: 4px solid #28a745;
        }
        .distance-badge {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
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
                <a class="nav-link" href="/health-pods">
                    <i class="fas fa-list me-1"></i>All Pods
                </a>
                <a class="nav-link" href="/health-pods/map">
                    <i class="fas fa-map me-1"></i>Map View
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-12 text-center">
                <h1 class="display-5 fw-bold">
                    <i class="fas fa-location-arrow me-2 text-success"></i>Health Pods Near You
                </h1>
                <p class="lead text-muted">
                    Find the closest health pods to your current location
                </p>
            </div>
        </div>

        <!-- Location Access -->
        <div class="row mb-4">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-map-marker-alt fa-3x text-primary mb-3"></i>
                        <h4>Find Pods Near Your Location</h4>
                        <p class="text-muted">
                            Allow location access to find health pods closest to you, or browse all available pods.
                        </p>
                        <div class="d-flex justify-content-center gap-3">
                            <button class="btn btn-primary" onclick="getLocation()">
                                <i class="fas fa-crosshairs me-1"></i>Use My Location
                            </button>
                            <a href="/health-pods" class="btn btn-outline-primary">
                                <i class="fas fa-list me-1"></i>Browse All Pods
                            </a>
                        </div>
                        <div id="locationStatus" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Nearby Pods -->
        <div class="row">
            <div class="col-12">
                <h3 class="mb-4">
                    <i class="fas fa-clinic-medical me-2 text-primary"></i>
                    Available Health Pods in Your Area
                </h3>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty healthPods && healthPods.size() > 0}">
                <div class="row">
                    <c:forEach var="pod" items="${healthPods}" varStatus="status">
                        <div class="col-lg-6 mb-4">
                            <div class="card location-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title">${pod.name}</h5>
                                        <span class="distance-badge badge">
                                            <i class="fas fa-road me-1"></i>
                                            <!-- Simulated distance - in real app, calculate based on user location -->
                                            ${status.index + 2}.${status.index + 5} km
                                        </span>
                                    </div>
                                    
                                    <p class="card-text text-muted">
                                        <i class="fas fa-map-marker-alt me-1 text-danger"></i>
                                        ${pod.address}, ${pod.city}
                                    </p>
                                    
                                    <div class="mb-3">
                                        <strong class="small">Quick Services:</strong>
                                        <div class="mt-1">
                                            <c:forEach var="facility" items="${pod.facilities}" begin="0" end="3">
                                                <span class="badge bg-light text-dark small">${facility}</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>${pod.operatingHours}
                                            </small>
                                        </div>
                                        <div class="col-6 text-end">
                                            <c:if test="${pod.hasPharmacy}">
                                                <span class="badge bg-success me-1">
                                                    <i class="fas fa-pills"></i>
                                                </span>
                                            </c:if>
                                            <c:if test="${pod.hasLab}">
                                                <span class="badge bg-info">
                                                    <i class="fas fa-flask"></i>
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-user-md me-1"></i>${pod.inchargeName}
                                        </small>
                                        <div>
                                            <a href="/health-pods/${pod.id}" class="btn btn-primary btn-sm me-1">
                                                Details
                                            </a>
                                            <c:if test="${not empty user && user.role == 'PATIENT'}">
                                                <a href="/appointments/book?podId=${pod.id}" class="btn btn-success btn-sm">
                                                    Book Visit
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-12">
                        <div class="text-center py-5">
                            <i class="fas fa-map-marker-alt fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No Health Pods in Your Area</h4>
                            <p class="text-muted">We're expanding our network to serve more rural areas.</p>
                            <a href="/health-pods" class="btn btn-primary">
                                <i class="fas fa-clinic-medical me-1"></i>View All Available Pods
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Expansion Info -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card bg-light">
                    <div class="card-body text-center">
                        <h5 class="card-title">
                            <i class="fas fa-expand-arrows-alt me-2 text-primary"></i>We're Expanding!
                        </h5>
                        <p class="card-text">
                            Digital Clinic is continuously working to establish health pods in more rural areas. 
                            If your village doesn't have a health pod yet, 
                            <a href="/contact" class="text-primary">contact us</a> to request one.
                        </p>
                        <div class="row text-center mt-3">
                            <div class="col-md-4">
                                <i class="fas fa-village fa-2x text-success mb-2"></i>
                                <h5>50+ Villages</h5>
                                <p class="small text-muted">Targeted for coverage</p>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-heartbeat fa-2x text-primary mb-2"></i>
                                <h5>24/7 Support</h5>
                                <p class="small text-muted">Telemedicine available</p>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-rupee-sign fa-2x text-warning mb-2"></i>
                                <h5>Affordable</h5>
                                <p class="small text-muted">Family packages available</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Location Script -->
    <script>
        function getLocation() {
            const statusDiv = document.getElementById('locationStatus');
            
            if (navigator.geolocation) {
                statusDiv.innerHTML = `
                    <div class="alert alert-info">
                        <i class="fas fa-sync fa-spin me-2"></i>Detecting your location...
                    </div>
                `;
                
                navigator.geolocation.getCurrentPosition(
                    function(position) {
                        const lat = position.coords.latitude;
                        const lng = position.coords.longitude;
                        
                        statusDiv.innerHTML = `
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle me-2"></i>
                                Location detected! Showing health pods near you.
                                <br><small class="text-muted">Lat: \${lat.toFixed(4)}, Lng: \${lng.toFixed(4)}</small>
                            </div>
                        `;
                        
                        // In real implementation, send coordinates to server and get nearby pods
                        alert('Location detected! In full implementation, this would filter pods based on your location.');
                    },
                    function(error) {
                        let message = "Unable to detect your location. ";
                        switch(error.code) {
                            case error.PERMISSION_DENIED:
                                message += "Please allow location access to find nearby health pods.";
                                break;
                            case error.POSITION_UNAVAILABLE:
                                message += "Location information is unavailable.";
                                break;
                            case error.TIMEOUT:
                                message += "Location request timed out.";
                                break;
                            default:
                                message += "An unknown error occurred.";
                        }
                        
                        statusDiv.innerHTML = `
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                \${message}
                            </div>
                        `;
                    }
                );
            } else {
                statusDiv.innerHTML = `
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Geolocation is not supported by this browser. Please browse all pods instead.
                    </div>
                `;
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>