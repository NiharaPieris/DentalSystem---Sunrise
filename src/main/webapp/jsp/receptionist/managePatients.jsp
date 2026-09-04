<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sunrise.dental.model.Patient" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Patient patient = (Patient) request.getAttribute("patient");
    List<Map<String, Object>> appointments = (List<Map<String, Object>>) request.getAttribute("appointments");
    String error = (String) request.getAttribute("error");

    String searchName  = (String) request.getAttribute("searchName");
    String searchPhone = (String) request.getAttribute("searchPhone");
    String searchEmail = (String) request.getAttribute("searchEmail");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management - Sunrise Dental</title>

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

        .form-control, .form-select {
            border-radius: 10px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            height: 100%;
        }

        .info-card .label {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 2px;
        }

        .info-card .value {
            font-size: 1.05rem;
            font-weight: 600;
            color: #212529;
        }

        .badge {
            font-weight: 500;
            padding: 5px 10px;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">
                <i class="bi bi-person-vcard me-2 text-primary"></i>Patient Management
            </h2>
            <small class="text-muted">Search patients and view their appointment history</small>
        </div>
        <a href="<%= request.getContextPath() %>/jsp/receptionist/dashboard.jsp" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger d-flex align-items-center mb-4">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <%= error %>
    </div>
    <% } %>

    <!-- ===================== SEARCH CARD ===================== -->
    <div class="card card-main mb-4">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-search me-2"></i>Search Patient
            </h5>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/receptionist/patients" method="post">
                <input type="hidden" name="action" value="search">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Name</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= searchName != null ? searchName : "" %>"
                               placeholder="Patient name">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Phone</label>
                        <input type="text" name="phone" class="form-control"
                               value="<%= searchPhone != null ? searchPhone : "" %>"
                               placeholder="Phone number">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="text" name="email" class="form-control"
                               value="<%= searchEmail != null ? searchEmail : "" %>"
                               placeholder="Email address">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search me-1"></i> Search
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- ===================== SEARCH RESULTS ===================== -->
    <% if (patients != null) { %>
    <div class="card card-main mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-people me-2"></i>Search Results
            </h5>
            <span class="badge bg-primary"><%= patients.size() %> found</span>
        </div>
        <div class="card-body p-0">
            <% if (patients.isEmpty()) { %>
            <div class="text-center text-muted py-5">
                <i class="bi bi-person-x fs-3 d-block mb-2"></i>
                No patients found matching your criteria.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th class="text-center">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Patient p : patients) { %>
                    <tr>
                        <td><strong>#<%= p.getPatientId() %></strong></td>
                        <td class="fw-semibold"><%= p.getName() %></td>
                        <td><%= p.getPhone() != null ? p.getPhone() : "—" %></td>
                        <td><%= p.getEmail() != null ? p.getEmail() : "—" %></td>
                        <td><%= p.getAddress() != null ? p.getAddress() : "—" %></td>
                        <td class="text-center">
                            <form action="<%= request.getContextPath() %>/receptionist/patients" method="post" class="d-inline">
                                <input type="hidden" name="action" value="view">
                                <input type="hidden" name="patient_id" value="<%= p.getPatientId() %>">
                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye me-1"></i> View
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- ===================== PATIENT DETAILS ===================== -->
    <% if (patient != null) { %>
    <div class="card card-main mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-person-circle me-2"></i>Patient Details
            </h5>
            <a href="<%= request.getContextPath() %>/receptionist/patients" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Back to Search
            </a>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Patient ID</div>
                        <div class="value">#<%= patient.getPatientId() %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Full Name</div>
                        <div class="value"><%= patient.getName() %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Phone</div>
                        <div class="value"><%= patient.getPhone() != null ? patient.getPhone() : "—" %></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-card">
                        <div class="label">Email</div>
                        <div class="value"><%= patient.getEmail() != null ? patient.getEmail() : "—" %></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-card">
                        <div class="label">Address</div>
                        <div class="value"><%= patient.getAddress() != null ? patient.getAddress() : "—" %></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===================== APPOINTMENT HISTORY ===================== -->
    <div class="card card-main">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-calendar2-check me-2"></i>Appointment History
            </h5>
        </div>
        <div class="card-body p-0">
            <% if (appointments == null || appointments.isEmpty()) { %>
            <div class="text-center text-muted py-5">
                <i class="bi bi-calendar-x fs-3 d-block mb-2"></i>
                This patient has no appointments yet.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Treatment</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Token</th>
                        <th>Payment</th>
                        <th>Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, Object> row : appointments) {
                        Appointment a = (Appointment) row.get("appointment");
                        Payment pay = (Payment) row.get("payment");
                    %>
                    <tr>
                        <td><strong>#<%= a.getAppointmentId() %></strong></td>
                        <td><%= a.getTreatmentName() != null ? a.getTreatmentName() : "—" %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= a.getAppointmentTime() %></td>
                        <td>#<%= a.getTokenNumber() %></td>
                        <td>
                            <% if (pay != null && pay.isPaid()) { %>
                            <span class="badge bg-success">Paid</span>
                            <% } else { %>
                            <span class="badge bg-danger">Unpaid</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (pay != null && pay.isPaid()) { %>
                            <strong>Rs. <%= String.format("%.2f", pay.getTotalAmount()) %></strong>
                            <% } else { %>
                            —
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
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>