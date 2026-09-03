package com.sunrise.dental.service;

import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Appointment;

import java.sql.SQLException;
import java.io.OutputStream;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.pdf.PdfWriter;

public class AppointmentService {
    private final PatientDAO patientDAO = new PatientDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    public void createAppointment(Patient p, Appointment a, OutputStream out) throws Exception {
        // Save patient
        int patientId = patientDAO.addPatient(p);
        a.setPatientId(patientId);

        // Assign token number
        int token = appointmentDAO.getNextTokenNumber(a.getTreatmentId());
        a.setTokenNumber(token);

        // Save appointment
        appointmentDAO.addAppointment(a);

        // Generate PDF receipt directly to response output stream
        generatePdfReceipt(a, out);
    }

    private void generatePdfReceipt(Appointment a, OutputStream out) throws Exception {
        Document document = new Document();
        PdfWriter.getInstance(document, out);
        document.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

        document.add(new Paragraph("Sunrise Dental Clinic", titleFont));
        document.add(new Paragraph("Appointment Receipt", titleFont));
        document.add(new Paragraph(" "));

        document.add(new Paragraph("Token Number: " + a.getTokenNumber(), normalFont));
        document.add(new Paragraph("Treatment ID: " + a.getTreatmentId(), normalFont));
        document.add(new Paragraph("Appointment Date: " + a.getAppointmentDate(), normalFont));
        document.add(new Paragraph("Appointment Time: " + a.getAppointmentTime(), normalFont));

        document.close();
    }
}
