package com.sunrise.dental.service;

import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Payment;
import com.sunrise.dental.util.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;

import java.io.OutputStream;
import java.sql.*;
import java.sql.Date;

public class PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    // ===================== SEARCH =====================
    /**
     * Search appointment by Treatment + Date + Token
     * Also loads patient details
     */
    public Appointment searchAppointment(int treatmentId, Date date, int tokenNumber) throws Exception {
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.treatment_id,
                   a.appointment_date, a.appointment_time, a.token_number,
                   t.name AS treatment_name,
                   p.name AS patient_name, p.email AS patient_email, p.phone AS patient_phone
            FROM appointments a
            JOIN treatments t ON a.treatment_id = t.treatment_id
            JOIN patients p   ON a.patient_id = p.patient_id
            WHERE a.treatment_id = ?
              AND a.appointment_date = ?
              AND a.token_number = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, treatmentId);
            ps.setDate(2, date);
            ps.setInt(3, tokenNumber);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTreatmentId(rs.getInt("treatment_id"));
                a.setAppointmentDate(rs.getDate("appointment_date"));
                a.setAppointmentTime(rs.getTime("appointment_time"));
                a.setTokenNumber(rs.getInt("token_number"));

                // These extra fields must exist in your Appointment model
                // (or create simple getters/setters for them)
                a.setTreatmentName(rs.getString("treatment_name"));
                a.setPatientName(rs.getString("patient_name"));
                a.setPatientEmail(rs.getString("patient_email"));
                a.setPatientPhone(rs.getString("patient_phone"));

                return a;
            }
        }
        return null;
    }

    public Appointment getAppointmentById(int appointmentId) throws Exception {
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.treatment_id,
                   a.appointment_date, a.appointment_time, a.token_number,
                   t.name AS treatment_name,
                   p.name AS patient_name, p.email AS patient_email, p.phone AS patient_phone
            FROM appointments a
            JOIN treatments t ON a.treatment_id = t.treatment_id
            JOIN patients p   ON a.patient_id = p.patient_id
            WHERE a.appointment_id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTreatmentId(rs.getInt("treatment_id"));
                a.setAppointmentDate(rs.getDate("appointment_date"));
                a.setAppointmentTime(rs.getTime("appointment_time"));
                a.setTokenNumber(rs.getInt("token_number"));
                a.setTreatmentName(rs.getString("treatment_name"));
                a.setPatientName(rs.getString("patient_name"));
                a.setPatientEmail(rs.getString("patient_email"));
                a.setPatientPhone(rs.getString("patient_phone"));
                return a;
            }
        }
        return null;
    }

    // ===================== PAYMENT =====================
    public Payment viewPayment(int appointmentId) throws Exception {
        return paymentDAO.getPaymentByAppointment(appointmentId);
    }

    public void makePayment(Appointment a, double consultationFee,
                            String otherFeeName, double otherFee,
                            OutputStream out) throws Exception {

        double total = consultationFee + otherFee;

        Payment p = new Payment();
        p.setAppointmentId(a.getAppointmentId());
        p.setConsultationFee(consultationFee);
        p.setOtherFeeName(otherFeeName == null ? "" : otherFeeName);
        p.setOtherFee(otherFee);
        p.setTotalAmount(total);
        p.setPaid(true);
        p.setPaidAt(new Timestamp(System.currentTimeMillis()));

        paymentDAO.savePayment(p);
        generateInvoicePdf(a, p, out);
    }

    public void printInvoice(Appointment a, Payment p, OutputStream out) throws Exception {
        generateInvoicePdf(a, p, out);
    }

    // ===================== PDF =====================
    private void generateInvoicePdf(Appointment a, Payment p, OutputStream out) throws Exception {
        Document document = new Document();
        PdfWriter.getInstance(document, out);
        document.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Font headingFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

        document.add(new Paragraph("Sunrise Dental Clinic", titleFont));
        document.add(new Paragraph("INVOICE", titleFont));
        document.add(new Paragraph(" "));

        // Patient
        document.add(new Paragraph("Patient Details", headingFont));
        document.add(new Paragraph("Name  : " + a.getPatientName(), normalFont));
        document.add(new Paragraph("Email : " + a.getPatientEmail(), normalFont));
        document.add(new Paragraph("Phone : " + a.getPatientPhone(), normalFont));
        document.add(new Paragraph(" "));

        // Appointment
        document.add(new Paragraph("Appointment Details", headingFont));
        document.add(new Paragraph("Appointment ID : " + a.getAppointmentId(), normalFont));
        document.add(new Paragraph("Treatment      : " + a.getTreatmentName(), normalFont));
        document.add(new Paragraph("Date           : " + a.getAppointmentDate(), normalFont));
        document.add(new Paragraph("Time           : " + a.getAppointmentTime(), normalFont));
        document.add(new Paragraph("Token Number   : " + a.getTokenNumber(), normalFont));
        document.add(new Paragraph(" "));

        // Payment
        document.add(new Paragraph("Payment Details", headingFont));
        document.add(new Paragraph("Consultation Fee : Rs. " + p.getConsultationFee(), normalFont));
        if (p.getOtherFeeName() != null && !p.getOtherFeeName().isBlank()) {
            document.add(new Paragraph("Other Fee (" + p.getOtherFeeName() + ") : Rs. " + p.getOtherFee(), normalFont));
        }
        document.add(new Paragraph("Total Amount     : Rs. " + p.getTotalAmount(), normalFont));
        document.add(new Paragraph("Paid             : Yes", normalFont));
        document.add(new Paragraph("Paid At          : " + p.getPaidAt(), normalFont));

        document.close();
    }
}