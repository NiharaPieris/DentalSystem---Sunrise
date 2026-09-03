<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dentist Navbar</title>
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
    <a href="<%= request.getContextPath() %>/jsp/dentist/dashboard.jsp">Dashboard</a>
    <a href="<%= request.getContextPath() %>/jsp/dentist/appointments.jsp">My Appointments</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</nav>
</body>
</html>