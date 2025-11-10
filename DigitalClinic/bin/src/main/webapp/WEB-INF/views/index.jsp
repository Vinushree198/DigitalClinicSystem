<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), 
                       url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            text-align: center;
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
                <a class="nav-link" href="/login">Login</a>
                <a class="nav-link" href="/register/patient">Register as Patient</a>
                <a class="nav-link" href="/register/doctor">Register as Doctor</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <h1 class="display-4 fw-bold">Healthcare Access for Rural Communities</h1>
            <p class="lead">Connecting rural patients with doctors through telemedicine and local health pods</p>
            <div class="mt-4">
                <a href="/register/patient" class="btn btn-light btn-lg me-2">Get Started as Patient</a>
                <a href="/register/doctor" class="btn btn-outline-light btn-lg">Join as Doctor</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-4">
                    <div class="feature-icon bg-primary text-white rounded-circle p-3 mb-3 mx-auto" style="width: 70px; height: 70px;">
                        <i class="fas fa-map-marker-alt fa-2x"></i>
                    </div>
                    <h4>Local Health Pods</h4>
                    <p>Access basic healthcare services at health pods in your village</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon bg-success text-white rounded-circle p-3 mb-3 mx-auto" style="width: 70px; height: 70px;">
                        <i class="fas fa-video fa-2x"></i>
                    </div>
                    <h4>Video Consultations</h4>
                    <p>Connect with specialist doctors without traveling long distances</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon bg-warning text-white rounded-circle p-3 mb-3 mx-auto" style="width: 70px; height: 70px;">
                        <i class="fas fa-rupee-sign fa-2x"></i>
                    </div>
                    <h4>Affordable Care</h4>
                    <p>Family packages and subscriptions at minimal costs</p>
                </div>
            </div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>
</body>
</html>