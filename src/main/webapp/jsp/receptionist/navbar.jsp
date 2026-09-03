<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Navbar</title>
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
    <a href="<%= request.getContextPath() %>/jsp/receptionist/dashboard.jsp">Dashboard</a>
    <a href="<%= request.getContextPath() %>/jsp/receptionist/patients.jsp">Patient Management</a>
    <a href="<%= request.getContextPath() %>/jsp/receptionist/payment.jsp">Appointment Management</a>
    <a href="<%= request.getContextPath() %>/jsp/receptionist/reports.jsp">Reports</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</nav>
</body>
</html>
