<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sunrise.dental.model.Appointment" %>
<%@ page import="com.sunrise.dental.model.Payment" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>

<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Payment payment = (Payment) request.getAttribute("payment");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Receptionist - Payment & Invoice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
        }
        .container {
            max-width: 850px;
            margin: auto;
        }
        .card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        h2 {
            margin-top: 0;
            color: #222;
            border-bottom: 2px solid #eee;
            padding-bottom: 8px;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
            color: #444;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type=submit], button {
            width: auto;
            background: #2c3e50;
            color: white;
            border: none;
            padding: 11px 22px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 18px;
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
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .details-grid {
            display: grid;
            grid-template-columns: 180px 1fr;
            gap: 10px 15px;
            margin-top: 15px;
        }
        .details-grid strong {
            color: #555;
        }
        .paid-badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }
        .unpaid-badge {
            display: inline-block;
            background: #dc3545;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }
        .btn-print {
            background: #17a2b8 !important;
        }
        .btn-print:hover {
            background: #138496 !important;
        }
        .btn-pay {
            background: #28a745 !important;
        }
        .btn-pay:hover {
            background: #218838 !important;
        }
    </style>
</head>
<body>
<div class="container">

    <h1>Payment & Invoice Management</h1>

    <%-- Error Message --%>
    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <!-- ===================== STEP 1: SEARCH ===================== -->
    <div class="card">
        <h2>Find Appointment</h2>
        <form action="<%= request.getContextPath() %>/receptionist/payment" method="post">
            <input type="hidden" name="action" value="search">

            <label for="treatment_id">Treatment Name</label>
            <select name="treatment_id" id="treatment_id" required>
                <option value="">-- Select Treatment --</option>
                <%
                    try (Connection conn = DBConnection.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery(
                                 "SELECT MIN(treatment_id) AS tid, UPPER(name) AS uname " +
                                         "FROM treatments GROUP BY uname ORDER BY uname")) {

                        while (rs.next()) {
                            int tid = rs.getInt("tid");
                            String name = rs.getString("uname");
                            String displayName = name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
                %>
                <option value="<%= tid %>"><%= displayName %></option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading treatments</option>");
                    }
                %>
            </select>

            <label for="appointment_date">Appointment Date</label>
            <input type="date" name="appointment_date" id="appointment_date" required>

            <label for="token_number">Token Number</label>
            <input type="number" name="token_number" id="token_number" min="1" required placeholder="Enter token number">

            <input type="submit" value="Search Appointment">
        </form>
    </div>

    <!-- ===================== STEP 2: DETAILS + PAYMENT ===================== -->
    <% if (appointment != null) { %>
    <div class="card">
        <h2>Appointment & Patient Details</h2>

        <div class="details-grid">
            <strong>Patient Name:</strong>
            <span><%= appointment.getPatientName() %></span>

            <strong>Email:</strong>
            <span><%= appointment.getPatientEmail() %></span>

            <strong>Phone:</strong>
            <span><%= appointment.getPatientPhone() %></span>

            <strong>Treatment:</strong>
            <span><%= appointment.getTreatmentName() %></span>

            <strong>Date:</strong>
            <span><%= appointment.getAppointmentDate() %></span>

            <strong>Time:</strong>
            <span><%= appointment.getAppointmentTime() %></span>

            <strong>Token Number:</strong>
            <span><%= appointment.getTokenNumber() %></span>

            <strong>Appointment ID:</strong>
            <span><%= appointment.getAppointmentId() %></span>

            <strong>Payment Status:</strong>
            <span>
                <% if (payment != null && payment.isPaid()) { %>
                    <span class="paid-badge">PAID</span>
                <% } else { %>
                    <span class="unpaid-badge">UNPAID</span>
                <% } %>
            </span>
        </div>

        <%-- ========== IF ALREADY PAID → PRINT INVOICE ========== --%>
        <% if (payment != null && payment.isPaid()) { %>
        <div style="margin-top: 25px;">
            <p><strong>Payment already completed.</strong></p>
            <p>Consultation Fee: Rs. <%= payment.getConsultationFee() %></p>
            <% if (payment.getOtherFeeName() != null && !payment.getOtherFeeName().isBlank()) { %>
            <p>Other Fee (<%= payment.getOtherFeeName() %>): Rs. <%= payment.getOtherFee() %></p>
            <% } %>
            <p><strong>Total Paid: Rs. <%= payment.getTotalAmount() %></strong></p>
            <p>Paid At: <%= payment.getPaidAt() %></p>

            <form action="<%= request.getContextPath() %>/receptionist/payment" method="post" style="display:inline;">
                <input type="hidden" name="action" value="print">
                <input type="hidden" name="appointment_id" value="<%= appointment.getAppointmentId() %>">
                <input type="submit" value="Print Invoice" class="btn-print">
            </form>
        </div>

        <%-- ========== IF UNPAID → PAYMENT FORM ========== --%>
        <% } else { %>
        <div style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
            <h3 style="margin-top:0;">Enter Payment Details</h3>

            <form action="<%= request.getContextPath() %>/receptionist/payment" method="post">
                <input type="hidden" name="action" value="pay">
                <input type="hidden" name="appointment_id" value="<%= appointment.getAppointmentId() %>">

                <label for="consultation_fee">Consultation Fee</label>
                <select name="consultation_fee" id="consultation_fee" required>
                    <option value="">-- Select Fee --</option>
                    <option value="500">Rs. 500</option>
                    <option value="1000">Rs. 1000</option>
                    <option value="1500">Rs. 1500</option>
                </select>

                <label for="other_fee_name">Other Payment Name (optional)</label>
                <input type="text" name="other_fee_name" id="other_fee_name"
                       placeholder="e.g. Special Checking, X-Ray, etc.">

                <label for="other_fee">Other Payment Amount (optional)</label>
                <input type="number" name="other_fee" id="other_fee"
                       step="0.01" min="0" placeholder="e.g. 1000">

                <input type="submit" value="Pay & Generate Invoice" class="btn-pay">
            </form>
        </div>
        <% } %>
    </div>
    <% } %>

</div>
</body>
</html>