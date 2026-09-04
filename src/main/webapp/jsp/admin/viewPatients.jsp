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
<html>
<head>
    <title>Admin - View Patients</title>
    <style>
        :root {
            --primary: #1a73e8;
            --primary-dark: #0d47a1;
            --success: #0f9d58;
            --danger: #d93025;
            --bg: #f8f9fa;
            --card-bg: #ffffff;
            --text: #202124;
            --text-secondary: #5f6368;
            --border: #dadce0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Roboto, Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.5;
        }

        .topbar {
            background: var(--primary);
            color: white;
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .topbar h1 {
            font-size: 22px;
            font-weight: 500;
        }

        .topbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            opacity: 0.9;
        }

        .topbar a:hover {
            opacity: 1;
            text-decoration: underline;
        }

        .main {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            padding: 28px;
            margin-bottom: 28px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 16px;
            align-items: end;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 6px;
        }

        input[type="text"] {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            transition: border 0.2s;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26,115,232,0.15);
        }

        .btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 11px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn:hover {
            background: var(--primary-dark);
        }

        .btn-view {
            background: #e8f0fe;
            color: var(--primary);
            padding: 7px 16px;
            font-size: 13px;
        }

        .btn-view:hover {
            background: #d2e3fc;
        }

        .error-box {
            background: #fce8e6;
            color: var(--danger);
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            border-left: 4px solid var(--danger);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        th {
            text-align: left;
            padding: 14px 16px;
            background: #f1f3f4;
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-paid {
            background: #e6f4ea;
            color: var(--success);
        }

        .badge-unpaid {
            background: #fce8e6;
            color: var(--danger);
        }

        .patient-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .back-btn {
            color: var(--primary);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        .back-btn:hover {
            text-decoration: underline;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .info-item {
            background: #f8f9fa;
            padding: 16px;
            border-radius: 8px;
        }

        .info-item .label {
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 4px;
        }

        .info-item .value {
            font-size: 16px;
            font-weight: 500;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>

<div class="topbar">
    <h1>Patient Records</h1>
    <a href="<%= request.getContextPath() %>/jsp/admin/dashboard.jsp">← Back to Dashboard</a>
</div>

<div class="main">

    <% if (error != null) { %>
    <div class="error-box"><%= error %></div>
    <% } %>

    <!-- SEARCH -->
    <div class="card">
        <div class="card-title">Search Patients</div>
        <form action="<%= request.getContextPath() %>/admin/patients" method="post">
            <input type="hidden" name="action" value="search">
            <div class="search-grid">
                <div>
                    <label>Name</label>
                    <input type="text" name="name" value="<%= searchName != null ? searchName : "" %>" placeholder="Patient name">
                </div>
                <div>
                    <label>Phone</label>
                    <input type="text" name="phone" value="<%= searchPhone != null ? searchPhone : "" %>" placeholder="Phone number">
                </div>
                <div>
                    <label>Email</label>
                    <input type="text" name="email" value="<%= searchEmail != null ? searchEmail : "" %>" placeholder="Email address">
                </div>
                <div>
                    <button type="submit" class="btn">Search</button>
                </div>
            </div>
        </form>
    </div>

    <!-- SEARCH RESULTS -->
    <% if (patients != null) { %>
    <div class="card">
        <div class="card-title">
            Search Results
            <span style="font-size:13px; font-weight:400; color:var(--text-secondary);">
                    (<%= patients.size() %> found)
                </span>
        </div>

        <% if (patients.isEmpty()) { %>
        <div class="empty">No patients found matching your criteria.</div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Address</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <% for (Patient p : patients) { %>
            <tr>
                <td><%= p.getPatientId() %></td>
                <td><strong><%= p.getName() %></strong></td>
                <td><%= p.getPhone() %></td>
                <td><%= p.getEmail() %></td>
                <td><%= p.getAddress() != null ? p.getAddress() : "—" %></td>
                <td>
                    <form action="<%= request.getContextPath() %>/admin/patients" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="view">
                        <input type="hidden" name="patient_id" value="<%= p.getPatientId() %>">
                        <button type="submit" class="btn btn-view">View</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
    <% } %>

    <!-- PATIENT DETAILS -->
    <% if (patient != null) { %>
    <div class="card">
        <div class="patient-header">
            <div class="card-title" style="margin:0;">Patient Details</div>
            <a href="<%= request.getContextPath() %>/admin/patients" class="back-btn">← Back to Search</a>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <div class="label">Patient ID</div>
                <div class="value">#<%= patient.getPatientId() %></div>
            </div>
            <div class="info-item">
                <div class="label">Full Name</div>
                <div class="value"><%= patient.getName() %></div>
            </div>
            <div class="info-item">
                <div class="label">Phone</div>
                <div class="value"><%= patient.getPhone() %></div>
            </div>
            <div class="info-item">
                <div class="label">Email</div>
                <div class="value"><%= patient.getEmail() %></div>
            </div>
            <div class="info-item" style="grid-column: span 2;">
                <div class="label">Address</div>
                <div class="value"><%= patient.getAddress() != null ? patient.getAddress() : "—" %></div>
            </div>
        </div>
    </div>

    <!-- APPOINTMENTS -->
    <div class="card">
        <div class="card-title">Appointment History</div>

        <% if (appointments == null || appointments.isEmpty()) { %>
        <div class="empty">This patient has no appointments yet.</div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Treatment</th>
                <th>Date</th>
                <th>Time</th>
                <th>Token</th>
                <th>Status</th>
                <th>Amount</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> row : appointments) {
                Appointment a = (Appointment) row.get("appointment");
                Payment pay = (Payment) row.get("payment");
            %>
            <tr>
                <td><%= a.getAppointmentId() %></td>
                <td><%= a.getTreatmentName() %></td>
                <td><%= a.getAppointmentDate() %></td>
                <td><%= a.getAppointmentTime() %></td>
                <td>#<%= a.getTokenNumber() %></td>
                <td>
                    <% if (pay != null && pay.isPaid()) { %>
                    <span class="badge badge-paid">PAID</span>
                    <% } else { %>
                    <span class="badge badge-unpaid">UNPAID</span>
                    <% } %>
                </td>
                <td>
                    <% if (pay != null && pay.isPaid()) { %>
                    Rs. <%= String.format("%.2f", pay.getTotalAmount()) %>
                    <% } else { %>
                    —
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
    <% } %>

</div>
</body>
</html>