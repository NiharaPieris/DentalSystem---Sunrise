<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dentist Dashboard</title>
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
            margin-top: 60px;
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }

        .box {
            width: 220px;
            height: 140px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-decoration: none;
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
            transition: all 0.25s ease;
        }

        .box:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .box.dashboard {
            border-bottom: 5px solid #3498db;
        }

        .box.appointments {
            border-bottom: 5px solid #2ecc71;
        }

        .box.logout {
            border-bottom: 5px solid #e74c3c;
        }

        .box span {
            font-size: 36px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Welcome, <span><%= username %></span></h1>
</div>

<div class="container">

    <a href="<%= request.getContextPath() %>/jsp/dentist/dashboard.jsp" class="box dashboard">
        <span>🏠</span>
        Dashboard
    </a>

    <a href="<%= request.getContextPath() %>/dentist/appointments" class="box appointments">
        <span>📅</span>
        Appointments
    </a>

    <a href="<%= request.getContextPath() %>/logout" class="box logout">
        <span>🚪</span>
        Logout
    </a>

</div>

</body>
</html>