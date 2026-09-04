<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="java.util.List" %>

<%
    // Session check
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"Dentist".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Sunrise Dental</title>

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

        .page-header {
            background: white;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .card-main {
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            background: white;
        }

        .table thead th {
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            color: white;
            font-weight: 600;
            border: none;
            padding: 14px 12px;
            white-space: nowrap;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 12px;
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
        }

        .btn-sm {
            padding: 0.35rem 0.85rem;
            font-size: 0.85rem;
        }

        .badge {
            font-weight: 500;
            padding: 6px 12px;
        }

        .welcome-text {
            font-size: 0.95rem;
            color: #6c757d;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-1 fw-bold">
                <i class="bi bi-calendar2-check me-2 text-primary"></i>Today's Appointments
            </h2>
            <div class="welcome-text">
                Welcome, <strong class="text-dark"><%= username %></strong>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger d-flex align-items-center mb-4">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <%= error %>
    </div>
    <% } %>

    <!-- Appointments Card -->
    <div class="card card-main">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-list-ul me-2"></i>Paid Appointments for Today
            </h5>
            <small class="text-muted">
                Status is automatically marked as <strong>Missed</strong> if the patient does not arrive on time.
            </small>
        </div>
        <div class="card-body p-0">
            <% if (appointments == null || appointments.isEmpty()) { %>
            <div class="text-center text-muted py-5">
                <i class="bi bi-calendar-x fs-3 d-block mb-2"></i>
                No paid appointments scheduled for today.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Token</th>
                        <th>Patient Name</th>
                        <th>Phone</th>
                        <th>Treatment</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Appointment a : appointments) {
                        String status = a.getStatus() != null ? a.getStatus().toLowerCase() : "pending";
                        String badgeClass = "bg-secondary";
                        if ("pending".equals(status)) badgeClass = "bg-warning text-dark";
                        else if ("process".equals(status)) badgeClass = "bg-info text-dark";
                        else if ("finished".equals(status)) badgeClass = "bg-success";
                        else if ("missed".equals(status)) badgeClass = "bg-danger";
                    %>
                    <tr>
                        <td><strong>#<%= a.getTokenNumber() %></strong></td>
                        <td class="fw-semibold"><%= a.getPatientName() %></td>
                        <td><%= a.getPatientPhone() != null ? a.getPatientPhone() : "—" %></td>
                        <td><%= a.getTreatmentName() != null ? a.getTreatmentName() : "—" %></td>
                        <td><%= a.getAppointmentTime() %></td>
                        <td>
                            <span class="badge <%= badgeClass %>">
                                <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                            </span>
                        </td>
                        <td class="text-center">
                            <% if ("pending".equals(status)) { %>
                            <form action="<%= request.getContextPath() %>/dentist/appointments" method="post" class="d-inline">
                                <input type="hidden" name="appointment_id" value="<%= a.getAppointmentId() %>">
                                <input type="hidden" name="status" value="process">
                                <button type="submit" class="btn btn-sm btn-info text-white">
                                    <i class="bi bi-play-fill me-1"></i> Start
                                </button>
                            </form>
                            <% } else if ("process".equals(status)) { %>
                            <form action="<%= request.getContextPath() %>/dentist/appointments" method="post" class="d-inline">
                                <input type="hidden" name="appointment_id" value="<%= a.getAppointmentId() %>">
                                <input type="hidden" name="status" value="finished">
                                <button type="submit" class="btn btn-sm btn-success">
                                    <i class="bi bi-check-lg me-1"></i> Finish
                                </button>
                            </form>
                            <% } else { %>
                            <span class="text-muted">—</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>