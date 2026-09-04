package com.sunrise.dental.controller;

import com.itextpdf.text.pdf.PdfPCell;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.sunrise.dental.service.ReportService;
import com.sunrise.dental.model.Report;
import com.sunrise.dental.model.Appointment;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class ReportServlet extends HttpServlet {

    private final ReportService reportService = new ReportService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action"); // view | download | details

        // ========== 1. DETAILS FOR MODAL ==========
        if ("details".equals(action)) {
            handleDetails(req, resp);
            return;
        }

        String type = req.getParameter("type");

        // First time opening the page
        if (type == null || type.trim().isEmpty()) {
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);
            return;
        }

        Report report = null;
        List<Appointment> appointments = null;

        try {
            LocalDate today = LocalDate.now();

            if ("day".equals(type)) {
                Date date = Date.valueOf(today);
                report = reportService.getDailyReport(date);
                appointments = reportService.getAppointmentsByDay(date);

                req.setAttribute("selectedDate", today.toString());

            } else if ("week".equals(type)) {
                LocalDate monday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                LocalDate friday = monday.plusDays(4);

                Date start = Date.valueOf(monday);
                Date end   = Date.valueOf(friday);

                report = reportService.getRangeReport(start, end);
                appointments = reportService.getAppointmentsByRange(start, end);

                req.setAttribute("weekStart", monday.toString());
                req.setAttribute("weekEnd", friday.toString());

            } else if ("custom".equals(type)) {
                String startStr = req.getParameter("startDate");
                String endStr   = req.getParameter("endDate");

                if (startStr == null || startStr.trim().isEmpty() ||
                        endStr == null || endStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Please select both Start Date and End Date for Custom Range");
                }

                Date start = Date.valueOf(startStr.trim());
                Date end   = Date.valueOf(endStr.trim());

                if (end.before(start)) {
                    throw new IllegalArgumentException("End Date cannot be before Start Date");
                }

                report = reportService.getRangeReport(start, end);
                appointments = reportService.getAppointmentsByRange(start, end);

                req.setAttribute("startDate", startStr);
                req.setAttribute("endDate", endStr);

            } else if ("month".equals(type)) {
                String yearStr  = req.getParameter("year");
                String monthStr = req.getParameter("month");

                // Fall back to the current year/month instead of failing,
                // in case fields ever arrive blank.
                int year  = (yearStr != null && !yearStr.trim().isEmpty())
                        ? Integer.parseInt(yearStr.trim()) : today.getYear();
                int month = (monthStr != null && !monthStr.trim().isEmpty())
                        ? Integer.parseInt(monthStr.trim()) : today.getMonthValue();

                report = reportService.getMonthlyReport(year, month);
                appointments = reportService.getAppointmentsByMonth(year, month);

                req.setAttribute("selectedYear", year);
                req.setAttribute("selectedMonth", month);

            } else {
                throw new IllegalArgumentException("Invalid report type");
            }

            req.setAttribute("selectedType", type);

            // ========== DOWNLOAD PDF ==========
            if ("download".equals(action)) {
                generatePdf(resp, type, report, appointments);
                return;
            }

            // ========== NORMAL VIEW ==========
            req.setAttribute("report", report);
            req.setAttribute("appointments", appointments);
            req.setAttribute("type", type);
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("selectedType", type);
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error generating report: " + e.getMessage());
            req.setAttribute("selectedType", type);
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);
        }
    }

    // ---------- JSON details for modal ----------
    private void handleDetails(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String idParam = req.getParameter("appointmentId");
            if (idParam == null || idParam.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Appointment ID is required\"}");
                return;
            }

            int appointmentId = Integer.parseInt(idParam.trim());
            Map<String, Object> details = reportService.getAppointmentFullDetails(appointmentId);

            if (details == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\":\"Appointment not found\"}");
                return;
            }

            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(details));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    // ---------- PDF Generation ----------
    // Builds the PDF fully in memory first, then writes it to the response only
    // once generation succeeds. This avoids sending a half-written PDF to the
    // browser (which also shows up as ERR_INCOMPLETE_CHUNKED_ENCODING) if
    // something throws partway through.
    private void generatePdf(HttpServletResponse resp, String type,
                             Report report, List<Appointment> appointments) throws Exception {

        ByteArrayOutputStream buffer = new ByteArrayOutputStream();

        Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        PdfWriter.getInstance(document, buffer);
        document.open();

        Font titleFont  = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

        document.add(new Paragraph("Sunrise Dental - Admin Report (" + type.toUpperCase() + ")", titleFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Income          : Rs. " + (report != null ? report.getIncome() : 0), normalFont));
        document.add(new Paragraph("Appointments    : " + (report != null ? report.getAppointments() : 0), normalFont));
        document.add(new Paragraph("Unique Patients : " + (report != null ? report.getPatients() : 0), normalFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Appointment Details", headerFont));
        document.add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1.2f, 2.5f, 2.5f, 1.8f, 1.5f, 1.5f});

        table.addCell(new Phrase("ID", headerFont));
        table.addCell(new Phrase("Patient", headerFont));
        table.addCell(new Phrase("Treatment", headerFont));
        table.addCell(new Phrase("Date", headerFont));
        table.addCell(new Phrase("Time", headerFont));
        table.addCell(new Phrase("Status", headerFont));

        if (appointments != null && !appointments.isEmpty()) {
            for (Appointment a : appointments) {
                table.addCell(String.valueOf(a.getAppointmentId()));
                table.addCell(a.getPatientName() != null ? a.getPatientName() : "-");
                table.addCell(a.getTreatmentName() != null ? a.getTreatmentName() : "-");
                table.addCell(a.getAppointmentDate() != null ? a.getAppointmentDate().toString() : "-");
                table.addCell(a.getAppointmentTime() != null ? a.getAppointmentTime().toString() : "-");
                table.addCell(a.getStatus() != null ? a.getStatus() : "-");
            }
        } else {
            PdfPCell noData = new PdfPCell(new Phrase("No appointments found", normalFont));
            noData.setColspan(6);
            noData.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(noData);
        }

        document.add(table);
        document.close();

        // Only now, with a fully-built PDF in hand, do we touch the response.
        resp.setContentType("application/pdf");
        resp.setContentLength(buffer.size());
        resp.setHeader("Content-Disposition", "attachment; filename=report_" + type + ".pdf");

        try (OutputStream out = resp.getOutputStream()) {
            buffer.writeTo(out);
        }
    }
}