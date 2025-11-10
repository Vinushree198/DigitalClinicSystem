<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="card-title mb-0 text-center">
                            <i class="fas fa-sign-in-alt"></i> Login to Digital Clinic
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger">Invalid email or password!</div>
                        </c:if>
                        <c:if test="${not empty param.logout}">
                            <div class="alert alert-success">You have been logged out successfully!</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <!-- ADD THIS CSRF TOKEN LINE -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <p>Don't have an account? 
                                <a href="${pageContext.request.contextPath}/register/patient">Register as Patient</a> or 
                                <a href="${pageContext.request.contextPath}/register/doctor">Register as Doctor</a> or
                                <a href="${pageContext.request.contextPath}/register/admin">Register as Admin</a>
                            </p>
                        </div>

                        <!-- Test Credentials -->
                        <div class="card mt-3">
                            <div class="card-body">
                                <h6>Test Credentials:</h6>
                                <small class="text-muted">
                                    <strong>Admin:</strong> admin@digitalclinic.com / admin123<br>
                                    <strong>Patient:</strong> patient@test.com / password123<br>
                                    <strong>Doctor:</strong> doctor@test.com / password123
                                </small>
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