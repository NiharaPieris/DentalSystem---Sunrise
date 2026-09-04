<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="java.util.List" %>

<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments - Dentist</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f9;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        .card {
            background: #fff;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
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
            margin-top: 10px;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            color: white;
        }
        .pending  { background: #ffc107; color: #333; }
        .process  { background: #17a2b8; }
        .finished { background: #28a745; }
        .missed   { background: #dc3545; }

        .btn {
            border: none;
            padding: 7px 14px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            color: white;
            margin-right: 5px;
        }
        .btn-process {
            background: #17a2b8;
        }
        .btn-process:hover {
            background: #138496;
        }
        .btn-finish {
            background: #28a745;
        }
        .btn-finish:hover {
            background: #218838;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #777;
            font-size: 16px;
        }
        .info-text {
            color: #666;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<%-- Include Dentist Navbar --%>
<jsp:include page="navbar.jsp" />

<div class="container">

    <h1>Today's Appointments</h1>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <div class="card">
        <p class="info-text">
            Showing only <strong>paid</strong> appointments for today.
            Status is automatically marked as <strong>Missed</strong> if the patient does not arrive on time.
        </p>

        <% if (appointments == null || appointments.isEmpty()) { %>
        <div class="no-data">
            No paid appointments scheduled for today.
        </div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>Token</th>
                <th>Patient Name</th>
                <th>Phone</th>
                <th>Treatment</th>
                <th>Time</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Appointment a : appointments) {
                String status = a.getStatus() != null ? a.getStatus().toLowerCase() : "pending";
            %>
            <tr>
                <td><strong>#<%= a.getTokenNumber() %></strong></td>
                <td><%= a.getPatientName() %></td>
                <td><%= a.getPatientPhone() %></td>
                <td><%= a.getTreatmentName() %></td>
                <td><%= a.getAppointmentTime() %></td>
                <td>
                                <span class="status <%= status %>">
                                    <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                </span>
                </td>
                <td>
                    <% if ("pending".equals(status)) { %>
                    <form action="<%= request.getContextPath() %>/dentist/appointments" method="post" style="display:inline;">
                        <input type="hidden" name="appointment_id" value="<%= a.getAppointmentId() %>">
                        <input type="hidden" name="status" value="process">
                        <button type="submit" class="btn btn-process">Start (Process)</button>
                    </form>
                    <% } else if ("process".equals(status)) { %>
                    <form action="<%= request.getContextPath() %>/dentist/appointments" method="post" style="display:inline;">
                        <input type="hidden" name="appointment_id" value="<%= a.getAppointmentId() %>">
                        <input type="hidden" name="status" value="finished">
                        <button type="submit" class="btn btn-finish">Mark Finished</button>
                    </form>
                    <% } else { %>
                    <span style="color:#999;">—</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

</body>
</html>