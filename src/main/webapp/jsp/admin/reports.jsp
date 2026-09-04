<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page buffer="64kb" autoFlush="false" %>
<%@ page import="com.sunrise.dental.model.Report, java.util.List, com.sunrise.dental.model.Appointment, java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reports - Sunrise Dental</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d6efd;
            --primary-dark: #0b5ed7;
            --success: #198754;
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

        .card-filter, .card-summary, .card-table {
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            background: white;
        }

        .card-summary {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card-summary:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .summary-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
        }

        .summary-value {
            font-size: 1.75rem;
            font-weight: 700;
            line-height: 1.2;
        }

        .table thead th {
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            color: white;
            font-weight: 600;
            border: none;
            padding: 14px 12px;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 12px;
        }

        .btn-view {
            padding: 4px 12px;
            font-size: 0.85rem;
            border-radius: 8px;
        }

        .modal-header {
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            color: white;
            border-radius: 0;
        }

        .detail-label {
            font-weight: 600;
            color: #555;
            width: 150px;
        }

        .section-title {
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 6px;
            margin-bottom: 14px;
            font-size: 1.05rem;
            font-weight: 600;
            color: #0d6efd;
        }

        .badge {
            font-weight: 500;
            padding: 5px 10px;
        }

        .form-select, .form-control {
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .form-select:focus, .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
            padding: 0.5rem 1.1rem;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">
                <i class="bi bi-bar-chart-line me-2 text-primary"></i>Admin Reports
            </h2>
            <small class="text-muted">View income, appointments and patient statistics</small>
        </div>
        <a href="<%= request.getContextPath() %>/jsp/admin/dashboard.jsp" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>

    <%
        LocalDate now = LocalDate.now();
        Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
        Integer selectedYear  = (Integer) request.getAttribute("selectedYear");
        int defaultMonth = (selectedMonth != null) ? selectedMonth : now.getMonthValue();
        int defaultYear  = (selectedYear != null) ? selectedYear : now.getYear();
    %>

    <!-- Filter Card -->
    <div class="card card-filter mb-4">
        <div class="card-body p-4">
            <form id="reportForm" action="<%= request.getContextPath() %>/admin/reports" method="get" class="row g-3 align-items-end">

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Report Type</label>
                    <select name="type" id="reportType" class="form-select" required>
                        <option value="">-- Select Type --</option>
                        <option value="day"    <%= "day".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>Day (Today)</option>
                        <option value="week"   <%= "week".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>Week (Mon–Fri)</option>
                        <option value="month"  <%= "month".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>Month</option>
                        <option value="custom" <%= "custom".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>Custom Range</option>
                    </select>
                </div>

                <!-- Custom Range -->
                <div class="col-md-3 d-none" id="startField">
                    <label class="form-label fw-semibold">Start Date</label>
                    <input type="date" name="startDate" id="startDateInput" class="form-control"
                           value="<%= request.getAttribute("startDate") != null ? request.getAttribute("startDate") : "" %>">
                </div>
                <div class="col-md-3 d-none" id="endField">
                    <label class="form-label fw-semibold">End Date</label>
                    <input type="date" name="endDate" id="endDateInput" class="form-control"
                           value="<%= request.getAttribute("endDate") != null ? request.getAttribute("endDate") : "" %>">
                </div>

                <!-- Month -->
                <div class="col-md-2 d-none" id="yearField">
                    <label class="form-label fw-semibold">Year</label>
                    <input type="number" name="year" id="yearInput" class="form-control" min="2020" max="2035"
                           value="<%= defaultYear %>">
                </div>
                <div class="col-md-2 d-none" id="monthField">
                    <label class="form-label fw-semibold">Month</label>
                    <select name="month" id="monthInput" class="form-select">
                        <%
                            String[] monthNames = {"January","February","March","April","May","June",
                                    "July","August","September","October","November","December"};
                            for (int m = 1; m <= 12; m++) {
                        %>
                        <option value="<%= m %>" <%= (defaultMonth == m) ? "selected" : "" %>>
                            <%= monthNames[m-1] %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill">
                        <i class="bi bi-search me-1"></i> Generate
                    </button>
                    <button type="submit" name="action" value="download" class="btn btn-success flex-fill">
                        <i class="bi bi-download me-1"></i> PDF
                    </button>
                </div>
            </form>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="alert alert-danger mt-3 mb-0">
                <i class="bi bi-exclamation-triangle me-2"></i><%= error %>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Summary + Table -->
    <%
        Report report = (Report) request.getAttribute("report");
        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
        String type = (String) request.getAttribute("type");

        if (report != null) {
    %>
    <!-- Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card card-summary h-100">
                <div class="card-body d-flex align-items-center gap-3 p-4">
                    <div class="summary-icon bg-success bg-opacity-10 text-success">
                        <i class="bi bi-currency-rupee"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Income</div>
                        <div class="summary-value text-success">Rs. <%= report.getIncome() %></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-summary h-100">
                <div class="card-body d-flex align-items-center gap-3 p-4">
                    <div class="summary-icon bg-primary bg-opacity-10 text-primary">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Appointments</div>
                        <div class="summary-value text-primary"><%= report.getAppointments() %></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-summary h-100">
                <div class="card-body d-flex align-items-center gap-3 p-4">
                    <div class="summary-icon bg-info bg-opacity-10 text-info">
                        <i class="bi bi-people"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Unique Patients</div>
                        <div class="summary-value text-info"><%= report.getPatients() %></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Period Info -->
    <div class="alert alert-light border py-2 mb-3 d-flex align-items-center">
        <i class="bi bi-info-circle me-2 text-primary"></i>
        <% if ("day".equals(type)) { %>
        Showing appointments for <strong>Today</strong>
        <% } else if ("week".equals(type)) { %>
        Showing appointments for <strong>This Week (Mon – Fri)</strong>
        <% } else if ("custom".equals(type)) { %>
        Showing appointments from <strong><%= request.getAttribute("startDate") %></strong>
        to <strong><%= request.getAttribute("endDate") %></strong>
        <% } else if ("month".equals(type)) { %>
        Showing appointments for
        <strong>
            <%= java.time.Month.of((Integer) request.getAttribute("selectedMonth")).name().substring(0,1)
                    + java.time.Month.of((Integer) request.getAttribute("selectedMonth")).name().substring(1).toLowerCase() %>
            <%= request.getAttribute("selectedYear") %>
        </strong>
        <% } %>
    </div>

    <!-- Appointments Table -->
    <div class="card card-table">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-list-ul me-2"></i>Appointment Details
                <span class="badge bg-primary ms-2"><%= type != null ? type.toUpperCase() : "" %></span>
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Treatment</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Token</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment a : appointments) {
                    %>
                    <tr>
                        <td><strong>#<%= a.getAppointmentId() %></strong></td>
                        <td><%= a.getPatientName() != null ? a.getPatientName() : "-" %></td>
                        <td><%= a.getTreatmentName() != null ? a.getTreatmentName() : "-" %></td>
                        <td><%= a.getAppointmentDate() != null ? a.getAppointmentDate() : "-" %></td>
                        <td><%= a.getAppointmentTime() != null ? a.getAppointmentTime() : "-" %></td>
                        <td><%= a.getTokenNumber() %></td>
                        <td>
                            <%
                                String status = a.getStatus() != null ? a.getStatus() : "pending";
                                String badgeClass = "bg-secondary";
                                if ("finished".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                else if ("process".equalsIgnoreCase(status)) badgeClass = "bg-primary";
                                else if ("missed".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                                else if ("pending".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
                            %>
                            <span class="badge <%= badgeClass %>"><%= status %></span>
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-sm btn-outline-primary btn-view"
                                    onclick="viewAppointment(<%= a.getAppointmentId() %>)">
                                <i class="bi bi-eye"></i> View
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                            No appointments found for the selected period.
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="alert alert-info d-flex align-items-center">
        <i class="bi bi-info-circle fs-4 me-3"></i>
        <div>
            Select a report type and click <strong>Generate</strong> to view data.
        </div>
    </div>
    <% } %>
</div>

<!-- Modal -->
<div class="modal fade" id="appointmentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-file-earmark-medical me-2"></i>Appointment Details
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="modalBody">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary"></div>
                    <p class="mt-2 text-muted">Loading details...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const reportType = document.getElementById('reportType');
    const startField = document.getElementById('startField');
    const endField   = document.getElementById('endField');
    const yearField  = document.getElementById('yearField');
    const monthField = document.getElementById('monthField');

    function updateFields() {
        const type = reportType.value;

        startField.classList.add('d-none');
        endField.classList.add('d-none');
        yearField.classList.add('d-none');
        monthField.classList.add('d-none');

        if (type === 'custom') {
            startField.classList.remove('d-none');
            endField.classList.remove('d-none');
        } else if (type === 'month') {
            yearField.classList.remove('d-none');
            monthField.classList.remove('d-none');
        }
    }

    reportType.addEventListener('change', updateFields);
    updateFields();

    function viewAppointment(id) {
        if (typeof bootstrap === 'undefined') {
            alert('Bootstrap failed to load. Check your internet connection.');
            return;
        }

        const modal = new bootstrap.Modal(document.getElementById('appointmentModal'));
        const modalBody = document.getElementById('modalBody');

        modalBody.innerHTML = `
            <div class="text-center py-5">
                <div class="spinner-border text-primary"></div>
                <p class="mt-2 text-muted">Loading details...</p>
            </div>`;
        modal.show();

        fetch('<%= request.getContextPath() %>/admin/reports?action=details&appointmentId=' + id)
            .then(r => {
                if (!r.ok) throw new Error('Failed to load (status ' + r.status + ')');
                return r.json();
            })
            .then(data => {
                modalBody.innerHTML = buildModalContent(data);
            })
            .catch(err => {
                console.error(err);
                modalBody.innerHTML = `
                    <div class="alert alert-danger m-3">
                        Unable to load details<br>
                        <small>\${err.message}</small>
                    </div>`;
            });
    }

    function buildModalContent(d) {
        const paidBadge = d.paid
            ? '<span class="badge bg-success">Paid</span>'
            : '<span class="badge bg-warning text-dark">Unpaid</span>';

        return `
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="section-title">Appointment</div>
                    <table class="table table-sm table-borderless">
                        <tr><td class="detail-label">ID</td><td>\${d.appointmentId}</td></tr>
                        <tr><td class="detail-label">Date</td><td>\${d.appointmentDate || '-'}</td></tr>
                        <tr><td class="detail-label">Time</td><td>\${d.appointmentTime || '-'}</td></tr>
                        <tr><td class="detail-label">Token</td><td>\${d.tokenNumber || '-'}</td></tr>
                        <tr><td class="detail-label">Status</td><td><span class="badge bg-primary">\${d.status || '-'}</span></td></tr>
                    </table>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="section-title">Patient</div>
                    <table class="table table-sm table-borderless">
                        <tr><td class="detail-label">Name</td><td>\${d.patientName || '-'}</td></tr>
                        <tr><td class="detail-label">Email</td><td>\${d.patientEmail || '-'}</td></tr>
                        <tr><td class="detail-label">Phone</td><td>\${d.patientPhone || '-'}</td></tr>
                        <tr><td class="detail-label">Address</td><td>\${d.patientAddress || '-'}</td></tr>
                    </table>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="section-title">Treatment & Dentist</div>
                    <table class="table table-sm table-borderless">
                        <tr><td class="detail-label">Treatment</td><td>\${d.treatmentName || '-'}</td></tr>
                        <tr><td class="detail-label">Description</td><td>\${d.treatmentDescription || '-'}</td></tr>
                        <tr><td class="detail-label">Duration</td><td>\${d.durationMinutes || 0} mins</td></tr>
                        <tr><td class="detail-label">Cost</td><td>Rs. \${d.treatmentCost || 0}</td></tr>
                        <tr><td class="detail-label">Dentist</td><td>\${d.dentistName || '-'}</td></tr>
                        <tr><td class="detail-label">Specialization</td><td>\${d.specialization || '-'}</td></tr>
                    </table>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="section-title">Payment</div>
                    <table class="table table-sm table-borderless">
                        <tr><td class="detail-label">Status</td><td>\${paidBadge}</td></tr>
                        <tr><td class="detail-label">Consultation</td><td>Rs. \${d.consultationFee || 0}</td></tr>
                        <tr><td class="detail-label">Other Fee</td><td>\${d.otherFeeName || '-'} : Rs. \${d.otherFee || 0}</td></tr>
                        <tr><td class="detail-label">Total</td><td><strong>Rs. \${d.totalAmount || 0}</strong></td></tr>
                        <tr><td class="detail-label">Paid At</td><td>\${d.paidAt || '-'}</td></tr>
                    </table>
                </div>
            </div>
        `;
    }
</script>

</body>
</html>