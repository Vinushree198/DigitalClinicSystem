<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .pod-card {
            transition: transform 0.3s, box-shadow 0.3s;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .pod-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .pod-image {
            height: 200px;
            background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        .facility-badge {
            font-size: 0.75rem;
            margin: 2px;
        }
        .search-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 2rem;
            color: white;
            margin-bottom: 2rem;
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
                <a class="nav-link" href="/health-pods/map">
                    <i class="fas fa-map me-1"></i>View on Map
                </a>
                <a class="nav-link" href="/health-pods/near-me">
                    <i class="fas fa-location-arrow me-1"></i>Near Me
                </a>
                <c:if test="${not empty user}">
                    <a class="nav-link" href="/${user.role.toLowerCase()}/dashboard">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </c:if>
                <c:if test="${empty user}">
                    <a class="nav-link" href="/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                </c:if>
            </div>
        </div>
    </nav>

    <!-- Search Section -->
    <div class="search-box">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-4">
                    <h1 class="display-5 fw-bold">
                        <i class="fas fa-map-marker-alt me-2"></i>Find Health Pods
                    </h1>
                    <p class="lead">Access quality healthcare services at health pods near your village</p>
                </div>
            </div>
            
            <!-- Search Form -->
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <form action="/health-pods" method="get" class="row g-2">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-0">
                                    <i class="fas fa-search text-primary"></i>
                                </span>
                                <input type="text" name="search" class="form-control border-0" 
                                       placeholder="Search by name, location..." value="${searchTerm}">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select name="city" class="form-select border-0">
                                <option value="">All Cities</option>
                                <c:forEach var="city" items="${cities}">
                                    <option value="${city}" ${selectedCity == city ? 'selected' : ''}>${city}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-light w-100">
                                <i class="fas fa-filter me-1"></i>Filter
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <!-- Results Info -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h4>
                        <i class="fas fa-clinic-medical me-2 text-primary"></i>
                        Available Health Pods
                        <span class="badge bg-primary fs-6">${totalPods}</span>
                    </h4>
                    <div>
                        <a href="/health-pods/map" class="btn btn-outline-primary me-2">
                            <i class="fas fa-map me-1"></i>View Map
                        </a>
                        <a href="/health-pods/near-me" class="btn btn-primary">
                            <i class="fas fa-location-arrow me-1"></i>Pods Near Me
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Health Pods Grid -->
        <c:choose>
            <c:when test="${not empty healthPods && healthPods.size() > 0}">
                <div class="row">
                    <c:forEach var="pod" items="${healthPods}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card pod-card h-100">
                                <div class="pod-image">
                                    <i class="fas fa-clinic-medical"></i>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">${pod.name}</h5>
                                    <p class="card-text text-muted small">
                                        <i class="fas fa-map-marker-alt me-1 text-danger"></i>
                                        ${pod.city}, ${pod.state}
                                    </p>
                                    
                                    <div class="mb-3">
                                        <strong class="small">Facilities:</strong>
                                        <div class="mt-1">
                                            <c:forEach var="facility" items="${pod.facilities}" begin="0" end="2">
                                                <span class="badge bg-light text-dark facility-badge">${facility}</span>
                                            </c:forEach>
                                            <c:if test="${pod.facilities.size() > 3}">
                                                <span class="badge bg-light text-dark facility-badge">+${pod.facilities.size() - 3} more</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <strong class="small">Operating Hours:</strong>
                                        <p class="mb-1 small text-success">${pod.operatingHours}</p>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <c:if test="${pod.hasPharmacy}">
                                                <span class="badge bg-success me-1">
                                                    <i class="fas fa-pills"></i> Pharmacy
                                                </span>
                                            </c:if>
                                            <c:if test="${pod.hasLab}">
                                                <span class="badge bg-info">
                                                    <i class="fas fa-flask"></i> Lab
                                                </span>
                                            </c:if>
                                        </div>
                                        <a href="/health-pods/${pod.id}" class="btn btn-primary btn-sm">
                                            View Details <i class="fas fa-arrow-right ms-1"></i>
                                        </a>
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
                            <i class="fas fa-clinic-medical fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">No Health Pods Found</h4>
                            <p class="text-muted">We couldn't find any health pods matching your criteria.</p>
                            <a href="/health-pods" class="btn btn-primary">
                                <i class="fas fa-redo me-1"></i>View All Pods
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Quick Stats -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card bg-light">
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3">
                                <h3 class="text-primary mb-1">${totalPods}</h3>
                                <p class="small text-muted mb-0">Health Pods</p>
                            </div>
                            <div class="col-md-3">
                                <h3 class="text-success mb-1">
                                    <c:set var="pharmacyCount" value="0" />
                                    <c:forEach var="pod" items="${healthPods}">
                                        <c:if test="${pod.hasPharmacy}">
                                            <c:set var="pharmacyCount" value="${pharmacyCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${pharmacyCount}
                                </h3>
                                <p class="small text-muted mb-0">With Pharmacy</p>
                            </div>
                            <div class="col-md-3">
                                <h3 class="text-info mb-1">
                                    <c:set var="labCount" value="0" />
                                    <c:forEach var="pod" items="${healthPods}">
                                        <c:if test="${pod.hasLab}">
                                            <c:set var="labCount" value="${labCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${labCount}
                                </h3>
                                <p class="small text-muted mb-0">With Lab Facility</p>
                            </div>
                            <div class="col-md-3">
                                <h3 class="text-warning mb-1">
                                    <c:set var="totalStaff" value="0" />
                                    <c:forEach var="pod" items="${healthPods}">
                                        <c:if test="${not empty pod.staffCount}">
                                            <c:set var="totalStaff" value="${totalStaff + pod.staffCount}" />
                                        </c:if>
                                    </c:forEach>
                                    ${totalStaff}+
                                </h3>
                                <p class="small text-muted mb-0">Trained Staff</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>