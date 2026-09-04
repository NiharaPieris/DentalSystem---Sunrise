package com.sunrise.dental.service;

import com.sunrise.dental.dao.ReportDAO;
import com.sunrise.dental.model.Report;
import com.sunrise.dental.model.Appointment;

import java.sql.Date;
import java.util.List;
import java.util.Map;

public class ReportService {
    private final ReportDAO reportDAO = new ReportDAO();

    // Summary
    public Report getDailyReport(Date date) throws Exception {
        return reportDAO.getDailyReport(date);
    }

    public Report getRangeReport(Date startDate, Date endDate) throws Exception {
        return reportDAO.getRangeReport(startDate, endDate);
    }

    public Report getMonthlyReport(int year, int month) throws Exception {
        return reportDAO.getMonthlyReport(year, month);
    }

    // Lists
    public List<Appointment> getAppointmentsByDay(Date date) throws Exception {
        return reportDAO.getAppointmentsByDay(date);
    }

    public List<Appointment> getAppointmentsByRange(Date startDate, Date endDate) throws Exception {
        return reportDAO.getAppointmentsByRange(startDate, endDate);
    }

    public List<Appointment> getAppointmentsByMonth(int year, int month) throws Exception {
        return reportDAO.getAppointmentsByMonth(year, month);
    }

    // Full details for modal
    public Map<String, Object> getAppointmentFullDetails(int appointmentId) throws Exception {
        return reportDAO.getAppointmentFullDetails(appointmentId);
    }
}