<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"Admin".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f0f2f5;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .header {
            width: 100%;
            background: #2c3e50;
            color: white;
            padding: 25px 0;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 500;
        }

        .header span {
            color: #3498db;
            font-weight: 600;
        }

        .container {
            margin-top: 50px;
            display: flex;
            gap: 25px;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
            max-width: 1100px;
        }

        .box {
            width: 200px;
            height: 130px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-decoration: none;
            color: #2c3e50;
            font-size: 17px;
            font-weight: 600;
            transition: all 0.25s ease;
        }

        .box:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .box span {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .box.users       { border-bottom: 5px solid #3498db; }
        .box.treatments  { border-bottom: 5px solid #9b59b6; }
        .box.patients    { border-bottom: 5px solid #2ecc71; }
        .box.appointments{ border-bottom: 5px solid #f39c12; }
        .box.reports     { border-bottom: 5px solid #1abc9c; }
        .box.logout      { border-bottom: 5px solid #e74c3c; }
    </style>
</head>
<body>

<div class="header">
    <h1>Welcome, <span><%= username %></span></h1>
</div>

<div class="container">

    <a href="<%= request.getContextPath() %>/jsp/admin/manageUsers.jsp" class="box users">
        <span>👥</span>
        Manage Users
    </a>

    <a href="<%= request.getContextPath() %>/jsp/admin/manageTreatments.jsp" class="box treatments">
        <span>🦷</span>
        Manage Treatments
    </a>

    <a href="<%= request.getContextPath() %>/admin/patients" class="box patients">
        <span>👤</span>
        View Patients
    </a>

    <a href="<%= request.getContextPath() %>/jsp/admin/viewAppointments.jsp" class="box appointments">
        <span>📅</span>
        View Appointments
    </a>

    <a href="<%= request.getContextPath() %>/jsp/admin/reports.jsp" class="box reports">
        <span>📊</span>
        Reports
    </a>

    <a href="<%= request.getContextPath() %>/logout" class="box logout">
        <span>🚪</span>
        Logout
    </a>

</div>

</body>
</html>