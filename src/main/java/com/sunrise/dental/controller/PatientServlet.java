package com.sunrise.dental.controller;

import com.sunrise.dental.model.Patient;
import com.sunrise.dental.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public class PatientServlet extends HttpServlet {

    private final PatientService service = new PatientService();
    private static final String PATIENT_JSP = "/jsp/receptionist/managePatients.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Just show the empty search page
        req.getRequestDispatcher(PATIENT_JSP).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("search".equals(action)) {
                handleSearch(req, resp);
            } else if ("view".equals(action)) {
                handleView(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher(PATIENT_JSP).forward(req, resp);
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String name  = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        List<Patient> patients = service.searchPatients(name, phone, email);

        req.setAttribute("patients", patients);
        req.setAttribute("searchName", name);
        req.setAttribute("searchPhone", phone);
        req.setAttribute("searchEmail", email);

        req.getRequestDispatcher(PATIENT_JSP).forward(req, resp);
    }

    private void handleView(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int patientId = Integer.parseInt(req.getParameter("patient_id"));

        Patient patient = service.getPatientById(patientId);
        if (patient == null) {
            throw new Exception("Patient not found");
        }

        List<Map<String, Object>> appointments = service.getPatientAppointmentsWithPayment(patientId);

        req.setAttribute("patient", patient);
        req.setAttribute("appointments", appointments);

        req.getRequestDispatcher(PATIENT_JSP).forward(req, resp);
    }
}