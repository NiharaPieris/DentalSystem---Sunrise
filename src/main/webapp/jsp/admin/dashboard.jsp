<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"Admin".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Sunrise Dental</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d6efd;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
        }

        .welcome-card {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            border-radius: 20px;
            padding: 2rem 2.5rem;
            box-shadow: 0 8px 30px rgba(13, 110, 253, 0.3);
            margin-bottom: 2.5rem;
        }

        .dashboard-card {
            background: white;
            border: none;
            border-radius: 18px;
            box-shadow: var(--card-shadow);
            transition: all 0.25s ease;
            text-decoration: none;
            color: inherit;
            height: 100%;
            overflow: hidden;
        }

        .dashboard-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
            color: inherit;
        }

        .card-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 1rem;
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 0.35rem;
        }

        .card-desc {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .users-icon      { background: #e3f2fd; color: #1976d2; }
        .treatments-icon { background: #f3e5f5; color: #7b1fa2; }
        .patients-icon   { background: #e8f5e9; color: #388e3c; }
        .appointments-icon { background: #fff3e0; color: #f57c00; }
        .reports-icon    { background: #e0f7fa; color: #0097a7; }
        .logout-icon     { background: #ffebee; color: #d32f2f; }
    </style>
</head>
<body>

<div class="container py-5">

    <!-- Welcome Banner -->
    <div class="welcome-card d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-1 fw-bold">Welcome back, <%= username %>!</h2>
            <p class="mb-0 opacity-75">Admin Dashboard · Sunrise Dental System</p>
        </div>
        <div class="d-none d-md-block">
            <i class="bi bi-hospital" style="font-size: 3.5rem; opacity: 0.3;"></i>
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="row g-4">

        <!-- Manage Users -->
        <div class="col-md-4 col-sm-6">
            <a href="<%= request.getContextPath() %>/jsp/admin/manageUsers.jsp" class="dashboard-card d-block p-4">
                <div class="card-icon users-icon">
                    <i class="bi bi-people"></i>
                </div>
                <div class="card-title">Manage Users</div>
                <div class="card-desc">Add, edit & manage Receptionists and Dentists</div>
            </a>
        </div>

        <!-- Manage Treatments -->
        <div class="col-md-4 col-sm-6">
            <a href="<%= request.getContextPath() %>/jsp/admin/manageTreatments.jsp" class="dashboard-card d-block p-4">
                <div class="card-icon treatments-icon">
                    <i class="bi bi-heart-pulse"></i>
                </div>
                <div class="card-title">Manage Treatments</div>
                <div class="card-desc">Create and update available dental treatments</div>
            </a>
        </div>

        <!-- View Patients -->
        <div class="col-md-4 col-sm-6">
            <a href="<%= request.getContextPath() %>/admin/patients" class="dashboard-card d-block p-4">
                <div class="card-icon patients-icon">
                    <i class="bi bi-person-vcard"></i>
                </div>
                <div class="card-title">View Patients</div>
                <div class="card-desc">Search patients and view appointment history</div>
            </a>
        </div>

        <!-- Reports -->
        <div class="col-md-4 col-sm-6">
            <a href="<%= request.getContextPath() %>/admin/reports" class="dashboard-card d-block p-4">
                <div class="card-icon reports-icon">
                    <i class="bi bi-bar-chart-line"></i>
                </div>
                <div class="card-title">Reports</div>
                <div class="card-desc">Daily, weekly & monthly income reports</div>
            </a>
        </div>

        <!-- Logout -->
        <div class="col-md-4 col-sm-6">
            <a href="<%= request.getContextPath() %>/logout" class="dashboard-card d-block p-4">
                <div class="card-icon logout-icon">
                    <i class="bi bi-box-arrow-right"></i>
                </div>
                <div class="card-title text-danger">Logout</div>
                <div class="card-desc">Sign out from the system</div>
            </a>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>