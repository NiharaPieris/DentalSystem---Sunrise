package com.sunrise.dental.service;

import com.sunrise.dental.dao.AppointmentDAO;
import com.sunrise.dental.model.Appointment;

import java.util.List;

public class DentistService {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    public List<Appointment> getTodayAppointments(int dentistId) throws Exception {
        // First auto-mark missed appointments
        appointmentDAO.autoMarkMissed(dentistId);

        // Then return today's paid appointments
        return appointmentDAO.getTodayAppointmentsForDentist(dentistId);
    }

    public void updateAppointmentStatus(int appointmentId, String newStatus) throws Exception {
        // Validate allowed transitions
        if (!List.of("process", "finished").contains(newStatus)) {
            throw new Exception("Invalid status transition");
        }
        appointmentDAO.updateStatus(appointmentId, newStatus);
    }
}