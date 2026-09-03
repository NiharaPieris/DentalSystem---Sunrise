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
    <title>Receptionist - Patient Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f9;
        }
        .container {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .card {
            background: #fff;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        h2 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #eee;
            padding-bottom: 8px;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
            color: #444;
        }
        input[type=text], input[type=email] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .search-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }
        input[type=submit], button {
            background: #2c3e50;
            color: white;
            border: none;
            padding: 11px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        input[type=submit]:hover, button:hover {
            background: #1a252f;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .btn-view {
            background: #17a2b8;
            padding: 6px 14px;
            font-size: 13px;
        }
        .btn-view:hover {
            background: #138496;
        }
        .paid {
            color: #28a745;
            font-weight: bold;
        }
        .unpaid {
            color: #dc3545;
            font-weight: bold;
        }
        .details-grid {
            display: grid;
            grid-template-columns: 160px 1fr;
            gap: 10px 20px;
            margin-top: 10px;
        }
        .details-grid strong {
            color: #555;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #2c3e50;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%-- Include the existing navbar --%>
<jsp:include page="navbar.jsp" />

<div class="container">

    <h1>Patient Management</h1>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <!-- ===================== SEARCH FORM ===================== -->
    <div class="card">
        <h2>Search Patient</h2>
        <form action="<%= request.getContextPath() %>/receptionist/patients" method="post">
            <input type="hidden" name="action" value="search">

            <div class="search-row">
                <div>
                    <label>Name</label>
                    <input type="text" name="name" value="<%= searchName != null ? searchName : "" %>"
                           placeholder="Enter patient name">
                </div>
                <div>
                    <label>Phone</label>
                    <input type="text" name="phone" value="<%= searchPhone != null ? searchPhone : "" %>"
                           placeholder="Enter phone number">
                </div>
                <div>
                    <label>Email</label>
                    <input type="text" name="email" value="<%= searchEmail != null ? searchEmail : "" %>"
                           placeholder="Enter email">
                </div>
                <div>
                    <input type="submit" value="Search">
                </div>
            </div>
        </form>
    </div>

    <!-- ===================== SEARCH RESULTS (List of patients) ===================== -->
    <% if (patients != null) { %>
    <div class="card">
        <h2>Search Results (<%= patients.size() %> found)</h2>

        <% if (patients.isEmpty()) { %>
        <p>No patients found.</p>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Address</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Patient p : patients) { %>
            <tr>
                <td><%= p.getPatientId() %></td>
                <td><%= p.getName() %></td>
                <td><%= p.getPhone() %></td>
                <td><%= p.getEmail() %></td>
                <td><%= p.getAddress() != null ? p.getAddress() : "-" %></td>
                <td>
                    <form action="<%= request.getContextPath() %>/receptionist/patients" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="view">
                        <input type="hidden" name="patient_id" value="<%= p.getPatientId() %>">
                        <input type="submit" value="View Details" class="btn-view">
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
    <% } %>

    <!-- ===================== PATIENT DETAILS + APPOINTMENTS ===================== -->
    <% if (patient != null) { %>
    <div class="card">
        <a href="<%= request.getContextPath() %>/receptionist/patients" class="back-link">← Back to Search</a>

        <h2>Patient Details</h2>
        <div class="details-grid">
            <strong>Patient ID:</strong>     <span><%= patient.getPatientId() %></span>
            <strong>Name:</strong>           <span><%= patient.getName() %></span>
            <strong>Phone:</strong>          <span><%= patient.getPhone() %></span>
            <strong>Email:</strong>          <span><%= patient.getEmail() %></span>
            <strong>Address:</strong>        <span><%= patient.getAddress() != null ? patient.getAddress() : "-" %></span>
        </div>
    </div>

    <div class="card">
        <h2>Appointments History</h2>

        <% if (appointments == null || appointments.isEmpty()) { %>
        <p>This patient has no appointments yet.</p>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>Appointment ID</th>
                <th>Treatment</th>
                <th>Date</th>
                <th>Time</th>
                <th>Token</th>
                <th>Payment Status</th>
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
                <td><%= a.getTokenNumber() %></td>
                <td>
                    <% if (pay != null && pay.isPaid()) { %>
                    <span class="paid">PAID</span>
                    <% } else { %>
                    <span class="unpaid">UNPAID</span>
                    <% } %>
                </td>
                <td>
                    <% if (pay != null && pay.isPaid()) { %>
                    Rs. <%= pay.getTotalAmount() %>
                    <% } else { %>
                    -
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