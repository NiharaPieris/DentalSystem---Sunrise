package com.sunrise.dental.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.service.AppointmentService;

public class AppointmentServlet extends HttpServlet {
    private final AppointmentService service = new AppointmentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Patient info
            Patient p = new Patient();
            p.setName(req.getParameter("name"));
            p.setEmail(req.getParameter("email"));
            p.setPhone(req.getParameter("phone"));
            p.setAddress(req.getParameter("address"));

            // Appointment info
            Appointment a = new Appointment();
            a.setTreatmentId(Integer.parseInt(req.getParameter("treatment_id")));
            a.setAppointmentDate(Date.valueOf(req.getParameter("appointment_date")));
            a.setAppointmentTime(Time.valueOf(req.getParameter("appointment_time") + ":00"));

            // Set response headers for PDF download
            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", "attachment; filename=appointment_receipt.pdf");

            // Generate appointment + PDF directly to browser
            service.createAppointment(p, a, resp.getOutputStream());

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>Error booking appointment.</h3>");
        }
    }
}
