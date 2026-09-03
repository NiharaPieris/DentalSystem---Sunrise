package com.sunrise.dental.controller;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

public class PaymentServlet extends HttpServlet {

    private final PaymentService service = new PaymentService();

    // Correct path according to your folder structure
    private static final String PAYMENT_JSP = "/jsp/receptionist/payment.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(PAYMENT_JSP).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("search".equals(action)) {
                handleSearch(req, resp);
            } else if ("pay".equals(action)) {
                handlePay(req, resp);
            } else if ("print".equals(action)) {
                handlePrint(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher(PAYMENT_JSP).forward(req, resp);
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int treatmentId = Integer.parseInt(req.getParameter("treatment_id"));
        Date date = Date.valueOf(req.getParameter("appointment_date"));
        int token = Integer.parseInt(req.getParameter("token_number"));

        Appointment appointment = service.searchAppointment(treatmentId, date, token);

        if (appointment == null) {
            req.setAttribute("error", "No appointment found with the given Treatment, Date and Token.");
        } else {
            Payment payment = service.viewPayment(appointment.getAppointmentId());
            req.setAttribute("appointment", appointment);
            req.setAttribute("payment", payment);
        }

        req.getRequestDispatcher(PAYMENT_JSP).forward(req, resp);
    }

    private void handlePay(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));

        Appointment appointment = service.getAppointmentById(appointmentId);
        if (appointment == null) {
            throw new Exception("Appointment not found");
        }

        double consultationFee = Double.parseDouble(req.getParameter("consultation_fee"));
        String otherFeeName = req.getParameter("other_fee_name");
        double otherFee = 0.0;

        String otherFeeStr = req.getParameter("other_fee");
        if (otherFeeStr != null && !otherFeeStr.isBlank()) {
            otherFee = Double.parseDouble(otherFeeStr);
        }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=invoice_" + appointmentId + ".pdf");

        service.makePayment(appointment, consultationFee, otherFeeName, otherFee, resp.getOutputStream());
    }

    private void handlePrint(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int appointmentId = Integer.parseInt(req.getParameter("appointment_id"));

        Appointment appointment = service.getAppointmentById(appointmentId);
        Payment payment = service.viewPayment(appointmentId);

        if (appointment == null || payment == null || !payment.isPaid()) {
            throw new Exception("Invoice cannot be printed. Payment not found or not paid.");
        }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=invoice_" + appointmentId + ".pdf");

        service.printInvoice(appointment, payment, resp.getOutputStream());
    }
}