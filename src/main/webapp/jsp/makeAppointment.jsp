<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Sunrise Dental</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d6efd;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #f5f7fa 50%, #e8eaf6 100%);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
        }

        .page-header {
            background: white;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .card-main {
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            background: white;
        }

        .treatment-header {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 1.5rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .info-item i {
            width: 28px;
            color: #0d6efd;
            font-size: 1.1rem;
        }

        .form-control, .form-select {
            border-radius: 10px;
            padding: 0.65rem 1rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            padding: 0.65rem 1.5rem;
        }

        .cost-badge {
            background: rgba(255,255,255,0.2);
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Header -->
            <div class="page-header">
                <h2 class="mb-1 fw-bold">
                    <i class="bi bi-calendar2-plus me-2 text-primary"></i>Book Your Appointment
                </h2>
                <p class="text-muted mb-0">Fill in your details to schedule a visit with us</p>
            </div>

            <%
                String treatmentId = request.getParameter("treatment_id");
                String treatmentName = null;
                String description = null;
                int duration = 0;
                String cost = null;
                String activeStart = null;
                String activeEnd = null;
                String activeDays = null;
                boolean found = false;

                if (treatmentId != null && !treatmentId.trim().isEmpty()) {
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement ps = conn.prepareStatement(
                                 "SELECT * FROM treatments WHERE treatment_id = ? AND active = TRUE")) {
                        ps.setInt(1, Integer.parseInt(treatmentId));
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            found = true;
                            treatmentName = rs.getString("name");
                            description = rs.getString("description");
                            duration = rs.getInt("duration_minutes");
                            cost = rs.getBigDecimal("cost").toString();
                            activeStart = rs.getString("active_start") != null ? rs.getString("active_start").substring(0, 5) : "-";
                            activeEnd = rs.getString("active_end") != null ? rs.getString("active_end").substring(0, 5) : "-";
                            activeDays = rs.getString("active_days");
                        }
                    } catch (Exception e) {
                        found = false;
                    }
                }
            %>

            <% if (!found) { %>
            <div class="card card-main">
                <div class="card-body text-center py-5">
                    <i class="bi bi-exclamation-circle fs-1 text-warning d-block mb-3"></i>
                    <h5>No treatment selected</h5>
                    <p class="text-muted">Please go back and choose a treatment first.</p>
                </div>
            </div>
            <% } else { %>

            <!-- Treatment Details -->
            <div class="card card-main mb-4">
                <div class="treatment-header d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1 fw-bold"><%= treatmentName %></h4>
                        <small class="opacity-75">Selected Treatment</small>
                    </div>
                    <div class="cost-badge">
                        Rs. <%= cost %>
                    </div>
                </div>
                <div class="card-body">
                    <% if (description != null && !description.isBlank()) { %>
                    <p class="text-muted mb-3"><%= description %></p>
                    <% } %>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <i class="bi bi-clock"></i>
                                <div>
                                    <small class="text-muted d-block">Duration</small>
                                    <strong><%= duration %> minutes</strong>
                                </div>
                            </div>
                            <div class="info-item">
                                <i class="bi bi-calendar-week"></i>
                                <div>
                                    <small class="text-muted d-block">Available Days</small>
                                    <strong><%= activeDays != null ? activeDays : "—" %></strong>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <i class="bi bi-alarm"></i>
                                <div>
                                    <small class="text-muted d-block">Available Time</small>
                                    <strong><%= activeStart %> – <%= activeEnd %></strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Patient Form -->
            <div class="card card-main">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-semibold">
                        <i class="bi bi-person-lines-fill me-2"></i>Your Information
                    </h5>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/patient/appointments/new" method="post">
                        <input type="hidden" name="treatment_id" value="<%= treatmentId %>">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" required placeholder="Enter your full name">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone</label>
                                <input type="text" name="phone" class="form-control" placeholder="e.g. 07X XXX XXXX">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="your@email.com">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Address</label>
                                <input type="text" name="address" class="form-control" placeholder="Your address">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Appointment Date <span class="text-danger">*</span></label>
                                <input type="date" name="appointment_date" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Appointment Time <span class="text-danger">*</span></label>
                                <input type="time" name="appointment_time" class="form-control" required>
                            </div>
                        </div>

                        <div class="mt-4 d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg me-1"></i> Confirm Appointment
                            </button>
                            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>