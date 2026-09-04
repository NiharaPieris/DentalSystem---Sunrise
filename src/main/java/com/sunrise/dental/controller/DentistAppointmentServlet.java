package com.sunrise.dental.controller;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.service.DentistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class DentistAppointmentServlet extends HttpServlet {

    private final DentistService service = new DentistService();
    private static final String JSP = "/jsp/dentist/appointments.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // ===== DEBUG =====
        System.out.println("===== DENTIST APPOINTMENT DEBUG =====");
        if (session == null) {
            System.out.println("Session is NULL");
        } else {
            System.out.println("user_id   = " + session.getAttribute("user_id"));
            System.out.println("username  = " + session.getAttribute("username"));
            System.out.println("role      = " + session.getAttribute("role"));
        }
        System.out.println("=====================================");

        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"Dentist".equalsIgnoreCase(role)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            int dentistId = (Integer) session.getAttribute("user_id");
            System.out.println("Loading appointments for dentistId = " + dentistId);

            List<Appointment> appointments = service.getTodayAppointments(dentistId);
            System.out.println("Found " + (appointments != null ? appointments.size() : 0) + " appointments");

            req.setAttribute("appointments", appointments);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher(JSP).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));
            String newStatus = req.getParameter("status");

            service.updateAppointmentStatus(appointmentId, newStatus);
            resp.sendRedirect(req.getContextPath() + "/dentist/appointments");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}