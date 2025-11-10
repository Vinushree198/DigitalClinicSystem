<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        #map {
            height: 600px;
            width: 100%;
            border-radius: 15px;
        }
        .map-container {
            position: relative;
        }
        .map-sidebar {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 1000;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 300px;
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
                    <i class="fas fa-list me-1"></i>List View
                </a>
                <a class="nav-link" href="/health-pods/near-me">
                    <i class="fas fa-location-arrow me-1"></i>Near Me
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="display-5 fw-bold text-center">
                    <i class="fas fa-map-marked-alt me-2 text-primary"></i>Health Pods Map
                </h1>
                <p class="text-center text-muted lead">
                    Find health pods near your location. Click on markers for details.
                </p>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="map-container">
                    <!-- Map Sidebar -->
                    <div class="map-sidebar">
                        <h5>
                            <i class="fas fa-filter me-2"></i>Health Pods
                        </h5>
                        <p class="small text-muted">${healthPods.size()} pods available</p>
                        
                        <div class="list-group" style="max-height: 500px; overflow-y: auto;">
                            <c:forEach var="pod" items="${healthPods}">
                                <a href="javascript:void(0)" class="list-group-item list-group-item-action pod-item" 
                                   data-lat="${pod.latitude}" data-lng="${pod.longitude}" data-name="${pod.name}">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-1">${pod.name}</h6>
                                    </div>
                                    <p class="mb-1 small text-muted">
                                        <i class="fas fa-map-marker-alt me-1"></i>${pod.city}
                                    </p>
                                    <small>
                                        <c:if test="${pod.hasPharmacy}">
                                            <span class="badge bg-success me-1">Pharmacy</span>
                                        </c:if>
                                        <c:if test="${pod.hasLab}">
                                            <span class="badge bg-info">Lab</span>
                                        </c:if>
                                    </small>
                                </a>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Map -->
                    <div id="map"></div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row mt-5">
            <div class="col-md-3 col-6 text-center">
                <div class="card border-0 bg-light">
                    <div class="card-body">
                        <i class="fas fa-clinic-medical fa-2x text-primary mb-2"></i>
                        <h3>${healthPods.size()}</h3>
                        <p class="text-muted mb-0">Health Pods</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6 text-center">
                <div class="card border-0 bg-light">
                    <div class="card-body">
                        <i class="fas fa-pills fa-2x text-success mb-2"></i>
                        <h3>
                            <c:set var="pharmacyCount" value="0" />
                            <c:forEach var="pod" items="${healthPods}">
                                <c:if test="${pod.hasPharmacy}">
                                    <c:set var="pharmacyCount" value="${pharmacyCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${pharmacyCount}
                        </h3>
                        <p class="text-muted mb-0">With Pharmacy</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6 text-center">
                <div class="card border-0 bg-light">
                    <div class="card-body">
                        <i class="fas fa-flask fa-2x text-info mb-2"></i>
                        <h3>
                            <c:set var="labCount" value="0" />
                            <c:forEach var="pod" items="${healthPods}">
                                <c:if test="${pod.hasLab}">
                                    <c:set var="labCount" value="${labCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${labCount}
                        </h3>
                        <p class="text-muted mb-0">With Lab</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6 text-center">
                <div class="card border-0 bg-light">
                    <div class="card-body">
                        <i class="fas fa-users fa-2x text-warning mb-2"></i>
                        <h3>
                            <c:set var="totalStaff" value="0" />
                            <c:forEach var="pod" items="${healthPods}">
                                <c:if test="${not empty pod.staffCount}">
                                    <c:set var="totalStaff" value="${totalStaff + pod.staffCount}" />
                                </c:if>
                            </c:forEach>
                            ${totalStaff}+
                        </h3>
                        <p class="text-muted mb-0">Trained Staff</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Map -->
    <script>
        // Simple map implementation (in real app, use Google Maps or Leaflet)
        function initMap() {
            const mapElement = document.getElementById('map');
            
            // Create a simple grid map for demonstration
            mapElement.innerHTML = `
                <div style="width:100%; height:100%; background: linear-gradient(45deg, #e3f2fd, #bbdefb); 
                     display:flex; align-items:center; justify-content:center; border-radius:15px;">
                    <div class="text-center">
                        <i class="fas fa-map-marked-alt fa-5x text-primary mb-3"></i>
                        <h4 class="text-primary">Interactive Health Pods Map</h4>
                        <p class="text-muted">In a full implementation, this would show actual locations<br>using Google Maps or similar service.</p>
                        <div class="mt-3">
                            <c:forEach var="pod" items="${healthPods}">
                                <div class="badge bg-primary me-2 mb-2 p-2">
                                    <i class="fas fa-map-marker-alt me-1"></i>${pod.name}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            `;
            
            // Add click handlers for pod items
            document.querySelectorAll('.pod-item').forEach(item => {
                item.addEventListener('click', function() {
                    const podName = this.getAttribute('data-name');
                    alert(`Showing details for: \${podName}\n\nIn full implementation, this would:\n- Center map on location\n- Show popup with pod details\n- Provide navigation options`);
                });
            });
        }
        
        // Initialize map when page loads
        document.addEventListener('DOMContentLoaded', initMap);
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>