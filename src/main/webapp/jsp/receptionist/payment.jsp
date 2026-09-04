<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Payment" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>

<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Payment payment = (Payment) request.getAttribute("payment");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment & Invoice - Sunrise Dental</title>

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

        .form-control, .form-select {
            border-radius: 10px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
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
            padding: 6px 12px;
        }

        .payment-summary {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.25rem;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">
                <i class="bi bi-credit-card me-2 text-primary"></i>Payment & Invoice
            </h2>
            <small class="text-muted">Find appointments, collect payments and generate invoices</small>
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

    <!-- ===================== STEP 1: SEARCH ===================== -->
    <div class="card card-main mb-4">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-search me-2"></i>Find Appointment
            </h5>
        </div>
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/receptionist/payment" method="post">
                <input type="hidden" name="action" value="search">

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Treatment</label>
                        <select name="treatment_id" class="form-select" required>
                            <option value="">-- Select Treatment --</option>
                            <%
                                try (Connection conn = DBConnection.getConnection();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery(
                                             "SELECT MIN(treatment_id) AS tid, UPPER(name) AS uname " +
                                                     "FROM treatments WHERE active = TRUE " +
                                                     "GROUP BY uname ORDER BY uname")) {

                                    while (rs.next()) {
                                        int tid = rs.getInt("tid");
                                        String name = rs.getString("uname");
                                        String displayName = name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
                            %>
                            <option value="<%= tid %>"><%= displayName %></option>
                            <%
                                }
                            } catch (Exception e) {
                            %>
                            <option disabled>Error loading treatments</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Appointment Date</label>
                        <input type="date" name="appointment_date" class="form-control" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Token Number</label>
                        <input type="number" name="token_number" class="form-control" min="1" required
                               placeholder="Enter token number">
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search me-1"></i> Search Appointment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ===================== STEP 2: DETAILS + PAYMENT ===================== -->
    <% if (appointment != null) { %>
    <div class="card card-main mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-file-earmark-medical me-2"></i>Appointment Details
            </h5>
            <% if (payment != null && payment.isPaid()) { %>
            <span class="badge bg-success">Paid</span>
            <% } else { %>
            <span class="badge bg-danger">Unpaid</span>
            <% } %>
        </div>
        <div class="card-body">

            <!-- Patient & Appointment Info -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Patient Name</div>
                        <div class="value"><%= appointment.getPatientName() %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Phone</div>
                        <div class="value"><%= appointment.getPatientPhone() != null ? appointment.getPatientPhone() : "—" %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card">
                        <div class="label">Email</div>
                        <div class="value"><%= appointment.getPatientEmail() != null ? appointment.getPatientEmail() : "—" %></div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="info-card">
                        <div class="label">Treatment</div>
                        <div class="value"><%= appointment.getTreatmentName() %></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <div class="label">Date</div>
                        <div class="value"><%= appointment.getAppointmentDate() %></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <div class="label">Time</div>
                        <div class="value"><%= appointment.getAppointmentTime() %></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <div class="label">Token / Appt ID</div>
                        <div class="value">#<%= appointment.getTokenNumber() %> / #<%= appointment.getAppointmentId() %></div>
                    </div>
                </div>
            </div>

            <%-- ========== ALREADY PAID ========== --%>
            <% if (payment != null && payment.isPaid()) { %>
            <div class="payment-summary">
                <h6 class="fw-semibold mb-3">
                    <i class="bi bi-check-circle-fill text-success me-2"></i>Payment Completed
                </h6>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="label text-muted small">Consultation Fee</div>
                        <div class="fw-semibold">Rs. <%= payment.getConsultationFee() %></div>
                    </div>
                    <% if (payment.getOtherFeeName() != null && !payment.getOtherFeeName().isBlank()) { %>
                    <div class="col-md-4">
                        <div class="label text-muted small"><%= payment.getOtherFeeName() %></div>
                        <div class="fw-semibold">Rs. <%= payment.getOtherFee() %></div>
                    </div>
                    <% } %>
                    <div class="col-md-4">
                        <div class="label text-muted small">Total Paid</div>
                        <div class="fw-bold text-success fs-5">Rs. <%= payment.getTotalAmount() %></div>
                    </div>
                    <div class="col-12">
                        <div class="label text-muted small">Paid At</div>
                        <div><%= payment.getPaidAt() != null ? payment.getPaidAt() : "—" %></div>
                    </div>
                </div>

                <div class="mt-4">
                    <form action="<%= request.getContextPath() %>/receptionist/payment" method="post" class="d-inline">
                        <input type="hidden" name="action" value="print">
                        <input type="hidden" name="appointment_id" value="<%= appointment.getAppointmentId() %>">
                        <button type="submit" class="btn btn-info text-white">
                            <i class="bi bi-printer me-1"></i> Print Invoice
                        </button>
                    </form>
                </div>
            </div>

            <%-- ========== UNPAID → PAYMENT FORM ========== --%>
            <% } else { %>
            <div class="border-top pt-4">
                <h6 class="fw-semibold mb-3">
                    <i class="bi bi-cash-coin me-2 text-success"></i>Enter Payment Details
                </h6>

                <form action="<%= request.getContextPath() %>/receptionist/payment" method="post">
                    <input type="hidden" name="action" value="pay">
                    <input type="hidden" name="appointment_id" value="<%= appointment.getAppointmentId() %>">

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Consultation Fee <span class="text-danger">*</span></label>
                            <select name="consultation_fee" class="form-select" required>
                                <option value="">-- Select Fee --</option>
                                <option value="500">Rs. 500</option>
                                <option value="1000">Rs. 1000</option>
                                <option value="1500">Rs. 1500</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Other Fee Name (optional)</label>
                            <input type="text" name="other_fee_name" class="form-control"
                                   placeholder="e.g. X-Ray, Special Check">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Other Fee Amount (optional)</label>
                            <input type="number" name="other_fee" class="form-control"
                                   step="0.01" min="0" placeholder="e.g. 1000">
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-lg me-1"></i> Pay & Generate Invoice
                        </button>
                    </div>
                </form>
            </div>
            <% } %>

        </div>
    </div>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>