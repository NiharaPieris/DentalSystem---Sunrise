<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sunrise Dental Clinic</title>
    <style>
        body { font-family: Arial, sans-serif; margin:0; padding:0; }
        header, footer { background:#333; color:#fff; padding:15px; }
        nav a { color:#fff; margin-right:15px; text-decoration:none; }
        nav a:hover { text-decoration:underline; }
        .hero { background:#f2f2f2; padding:50px; text-align:center; }
        .section { padding:40px; }
        .cards { display:flex; flex-wrap:wrap; gap:20px; }
        .card { border:1px solid #ccc; padding:20px; width:250px; border-radius:5px; }
        .card h3 { margin-top:0; }
    </style>
</head>
<body>

<!-- Header / Navigation -->
<header>
    <h1>Sunrise Dental Clinic</h1>
    <nav>
        <a href="<%= request.getContextPath() %>/jsp/home.jsp">Home</a>
        <a href="#about">About Us</a>
        <a href="#treatments">Treatments / Services</a>
        <a href="#contact">Contact Us</a>
        <a href="<%= request.getContextPath() %>/jsp/login.jsp">Login</a>
    </nav>
</header>

<!-- Hero Section -->
<div class="hero">
    <h2>Your Smile, Our Care</h2>
    <p>Quality dental care with professional dentists and modern treatments.</p>
    <button onclick="location.href='<%= request.getContextPath() %>/jsp/patient/makeAppointment.jsp'">Book Appointment</button>
    <button onclick="location.href='<%= request.getContextPath() %>/jsp/login.jsp'">Login</button>
</div>

<!-- About Section -->
<div class="section" id="about">
    <h2>About Sunrise Dental Clinic</h2>
    <p>We are committed to providing professional, patient-focused care with modern treatments and a compassionate approach.</p>
    <p><strong>Mission:</strong> To deliver quality dental care accessible to all.</p>
    <p><strong>Vision:</strong> Healthy smiles through innovation and trust.</p>
</div>

<!-- Treatments / Services -->
<div class="section" id="treatments">
    <h2>Our Treatments</h2>
    <div class="cards">
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM treatments")) {
                while (rs.next()) {
        %>
        <div class="card">
            <h3><%= rs.getString("name") %></h3>
            <p><%= rs.getString("description") %></p>
            <p>Duration: <%= rs.getInt("duration_minutes") %> min</p>
            <p>Starting Cost: Rs. <%= rs.getBigDecimal("cost") %></p>
            <form action="<%= request.getContextPath() %>/jsp/makeAppointment.jsp" method="get">
                <input type="hidden" name="treatment_id" value="<%= rs.getInt("treatment_id") %>">
                <input type="submit" value="Book Appointment">
            </form>
        </div>
        <%      }
        } catch (Exception e) { out.println("<p>Error loading treatments.</p>"); }
        %>
    </div>
</div>

<!-- Our Dentists -->
<div class="section" id="dentists">
    <h2>Meet Our Dentists</h2>
    <div class="cards">
        <%
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE role='Dentist' AND active=TRUE");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
        %>
        <div class="card">
            <h3><%= rs.getString("username") %></h3>
            <p>Specialization: <%= rs.getString("specialization") %></p>
            <p>Contact: <%= rs.getString("email") %> | <%= rs.getString("phone") %></p>
            <p>Status: Active</p>
        </div>
        <%      }
        } catch (Exception e) { out.println("<p>Error loading dentists.</p>"); }
        %>
    </div>
</div>

<!-- Why Choose Us -->
<div class="section" id="why">
    <h2>Why Choose Us</h2>
    <ul>
        <li>Qualified dentists</li>
        <li>Easy appointment booking</li>
        <li>Secure patient records</li>
        <li>Professional service</li>
        <li>Clear billing</li>
    </ul>
</div>

<!-- Contact Section -->
<div class="section" id="contact">
    <h2>Contact Us</h2>
    <p>Address: 123 Main Street, Ratnapura, Sri Lanka</p>
    <p>Phone: +94 71 234 5678</p>
    <p>Email: info@sunrisedental.com</p>
    <p>Opening Hours: Mon–Sat, 9 AM – 7 PM</p>
</div>

<!-- Footer -->
<footer>
    <p>Sunrise Dental Clinic</p>
    <p>
        <a href="#about">About</a> |
        <a href="#treatments">Treatments</a> |
        <a href="#contact">Contact</a> |
        <a href="<%= request.getContextPath() %>/jsp/login.jsp">Login</a>
    </p>
    <p>&copy; 2026 Sunrise Dental Clinic. All rights reserved.</p>
</footer>

</body>
</html>
