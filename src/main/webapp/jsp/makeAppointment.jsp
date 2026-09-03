<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Make Appointment - Sunrise Dental Clinic</title>
    <style>
        body { font-family: Arial, sans-serif; margin:20px; }
        .container { max-width: 700px; margin:auto; }
        .card { border:1px solid #ccc; padding:20px; border-radius:5px; margin-bottom:20px; }
        h2 { margin-top:0; }
        label { display:block; margin-top:10px; }
        input, textarea, select { width:100%; padding:8px; margin-top:5px; }
        input[type=submit], button { width:auto; background:#333; color:#fff; border:none; padding:10px 15px; cursor:pointer; margin-top:15px; }
        input[type=submit]:hover, button:hover { background:#555; }
    </style>
</head>
<body>
<div class="container">
    <h1>Book Your Appointment</h1>

    <!-- Treatment Details -->
    <div class="card">
        <%
            String treatmentId = request.getParameter("treatment_id");
            if (treatmentId != null) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT * FROM treatments WHERE treatment_id=?")) {
                    ps.setInt(1, Integer.parseInt(treatmentId));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
        %>
        <h2><%= rs.getString("name") %></h2>
        <p><%= rs.getString("description") %></p>
        <p>Duration: <%= rs.getInt("duration_minutes") %> minutes</p>
        <p>Cost: Rs. <%= rs.getBigDecimal("cost") %></p>
        <p>Available Time: <%= rs.getString("active_start") %> - <%= rs.getString("active_end") %></p>
        <p>Days: <%= rs.getString("active_days") %></p>
        <%
                    } else {
                        out.println("<p>Treatment not found.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error loading treatment details.</p>");
                }
            } else {
                out.println("<p>No treatment selected.</p>");
            }
        %>
    </div>

    <!-- Patient Form -->
    <div class="card">
        <h2>Patient Information</h2>
        <form action="<%= request.getContextPath() %>/patient/appointments/new" method="post">
            <input type="hidden" name="treatment_id" value="<%= treatmentId %>">

            <label for="name">Full Name:</label>
            <input type="text" name="name" required>

            <label for="email">Email:</label>
            <input type="email" name="email">

            <label for="phone">Phone:</label>
            <input type="text" name="phone">

            <label for="address">Address:</label>
            <textarea name="address"></textarea>

            <label for="date">Appointment Date:</label>
            <input type="date" name="appointment_date" required>

            <label for="time">Appointment Time:</label>
            <input type="time" name="appointment_time" required>

            <input type="submit" value="Confirm Appointment">
        </form>
    </div>
</div>
</body>
</html>
