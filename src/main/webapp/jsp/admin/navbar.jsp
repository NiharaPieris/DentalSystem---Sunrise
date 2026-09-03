<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Navbar</title>
    <style>
        nav {
            background-color: #333;
            padding: 10px;
        }
        nav a {
            color: white;
            margin-right: 15px;
            text-decoration: none;
        }
        nav a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<nav>
    <a href="<%= request.getContextPath() %>/jsp/admin/dashboard.jsp">Dashboard</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/manageUsers.jsp">Manage Users</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/manageTreatments.jsp">Manage Treatments</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/viewPatients.jsp">View Patients</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/viewAppointments.jsp">View Appointments</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/viewBills.jsp">View Bills</a>
    <a href="<%= request.getContextPath() %>/jsp/admin/reports.jsp">Reports</a>
</nav>
</body>
</html>
