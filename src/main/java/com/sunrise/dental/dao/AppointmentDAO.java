package com.sunrise.dental.dao;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    // ===================== EXISTING METHODS (kept) =====================
    public int getNextTokenNumber(int treatmentId) throws Exception {
        String sql = "SELECT COUNT(*) FROM appointments WHERE treatment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, treatmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
        }
        return 1;
    }

    public void addAppointment(Appointment a) throws SQLException {
        String sql = "INSERT INTO appointments (patient_id, treatment_id, appointment_date, appointment_time, token_number, status) " +
                "VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getPatientId());
            ps.setInt(2, a.getTreatmentId());
            ps.setDate(3, a.getAppointmentDate());
            ps.setTime(4, a.getAppointmentTime());
            ps.setInt(5, a.getTokenNumber());
            ps.setString(6, a.getStatus() != null ? a.getStatus() : "pending");
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ===================== NEW METHODS FOR DENTIST =====================

    /**
     * Get today's paid appointments for a specific dentist
     */
    public List<Appointment> getTodayAppointmentsForDentist(int dentistId) throws Exception {
        List<Appointment> list = new ArrayList<>();

        String sql = """
            SELECT a.appointment_id, a.patient_id, a.treatment_id,
                   a.appointment_date, a.appointment_time, a.token_number, a.status,
                   t.name AS treatment_name,
                   p.name AS patient_name, p.email AS patient_email, p.phone AS patient_phone
            FROM appointments a
            JOIN treatments t ON a.treatment_id = t.treatment_id
            JOIN patients p   ON a.patient_id = p.patient_id
            JOIN payments pay ON a.appointment_id = pay.appointment_id
            WHERE t.dentist_id = ?
              AND a.appointment_date = CURDATE()
              AND pay.paid = TRUE
            ORDER BY a.appointment_time ASC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dentistId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        }
        return list;
    }

    /**
     * Update appointment status
     */
    public void updateStatus(int appointmentId, String newStatus) throws SQLException {
        String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Auto mark as missed if time has passed
     */
    public void autoMarkMissed(int dentistId) throws Exception {
        String sql = """
            UPDATE appointments a
            JOIN treatments t ON a.treatment_id = t.treatment_id
            SET a.status = 'missed'
            WHERE t.dentist_id = ?
              AND a.appointment_date = CURDATE()
              AND a.status IN ('pending', 'process')
              AND a.appointment_time < CURTIME()
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dentistId);
            ps.executeUpdate();
        }
    }

    // ===================== Helper =====================
    private Appointment mapAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setTreatmentId(rs.getInt("treatment_id"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setAppointmentTime(rs.getTime("appointment_time"));
        a.setTokenNumber(rs.getInt("token_number"));
        a.setStatus(rs.getString("status"));
        a.setTreatmentName(rs.getString("treatment_name"));
        a.setPatientName(rs.getString("patient_name"));
        a.setPatientEmail(rs.getString("patient_email"));
        a.setPatientPhone(rs.getString("patient_phone"));
        return a;
    }
}