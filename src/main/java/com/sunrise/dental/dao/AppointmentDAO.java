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

    // ===================== EXISTING METHODS FOR DENTIST (kept) =====================

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

    // ===================== NEW METHODS FOR ADMIN VIEW =====================

    // Shared SELECT used by all admin queries.
    // NOTE: confirm your actual column names match these:
    //   treatments.dentist_id -> users.user_id (dentist name = u.name)
    //   payments.paid (boolean), payments.amount
    //   patients.address
    private static final String ADMIN_BASE_SELECT = """
        SELECT a.appointment_id, a.patient_id, a.treatment_id,
               a.appointment_date, a.appointment_time, a.token_number, a.status,
               t.name AS treatment_name, t.duration, t.cost,
               u.name AS dentist_name,
               p.name AS patient_name, p.email AS patient_email,
               p.phone AS patient_phone, p.address AS patient_address,
               pay.paid AS pay_paid, pay.amount AS pay_amount
        FROM appointments a
        JOIN treatments t ON a.treatment_id = t.treatment_id
        JOIN patients p   ON a.patient_id = p.patient_id
        JOIN users u      ON t.dentist_id = u.user_id
        LEFT JOIN payments pay ON a.appointment_id = pay.appointment_id
        """;

    /** Get all appointments, newest first */
    public List<Appointment> getAllAppointments() throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " ORDER BY a.appointment_date DESC, a.appointment_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapAdminAppointment(rs));
        }
        return list;
    }

    /** Filter: today's appointments (all dentists) */
    public List<Appointment> getTodayAppointmentsAdmin() throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE a.appointment_date = CURDATE() ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapAdminAppointment(rs));
        }
        return list;
    }

    /** Filter: upcoming appointments (today onward) */
    public List<Appointment> getUpcomingAppointments() throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE a.appointment_date >= CURDATE() ORDER BY a.appointment_date ASC, a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapAdminAppointment(rs));
        }
        return list;
    }

    /** Search by date only */
    public List<Appointment> searchByDate(Date date) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE a.appointment_date = ? ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAdminAppointment(rs));
            }
        }
        return list;
    }

    /** Search by date + token number */
    public List<Appointment> searchByDateAndToken(Date date, int token) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE a.appointment_date = ? AND a.token_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setInt(2, token);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAdminAppointment(rs));
            }
        }
        return list;
    }

    /** Search by treatment name + date (partial match on treatment name) */
    public List<Appointment> searchByTreatmentAndDate(String treatmentName, Date date) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE t.name LIKE ? AND a.appointment_date = ? ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + treatmentName + "%");
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAdminAppointment(rs));
            }
        }
        return list;
    }

    /** Search by patient name (partial match) */
    public List<Appointment> searchByPatientName(String name) throws Exception {
        List<Appointment> list = new ArrayList<>();
        String sql = ADMIN_BASE_SELECT + " WHERE p.name LIKE ? ORDER BY a.appointment_date DESC, a.appointment_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAdminAppointment(rs));
            }
        }
        return list;
    }

    /** Get one appointment with full admin details (for detail page) */
    public Appointment getAppointmentByIdAdmin(int appointmentId) throws Exception {
        String sql = ADMIN_BASE_SELECT + " WHERE a.appointment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapAdminAppointment(rs);
            }
        }
        return null;
    }

    public List<Appointment> searchAppointmentsFlexible(Date date, Integer token,
                                                        String treatmentName, String patientName) throws Exception {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(ADMIN_BASE_SELECT + " WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (date != null) {
            sql.append(" AND a.appointment_date = ?");
            params.add(date);
        }
        if (token != null) {
            sql.append(" AND a.token_number = ?");
            params.add(token);
        }
        if (treatmentName != null && !treatmentName.isBlank()) {
            sql.append(" AND t.name LIKE ?");
            params.add("%" + treatmentName + "%");
        }
        if (patientName != null && !patientName.isBlank()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + patientName + "%");
        }

        sql.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAdminAppointment(rs));
            }
        }
        return list;
    }

    // ===================== Helpers =====================

    // Existing helper — kept exactly as-is for the dentist methods above
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

    // NEW helper — maps the wider admin query (extra columns: dentist, cost, payment, address)
    private Appointment mapAdminAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setTreatmentId(rs.getInt("treatment_id"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setAppointmentTime(rs.getTime("appointment_time"));
        a.setTokenNumber(rs.getInt("token_number"));
        a.setStatus(rs.getString("status"));
        a.setTreatmentName(rs.getString("treatment_name"));
        a.setDuration(rs.getInt("duration"));
        a.setCost(rs.getDouble("cost"));
        a.setDentistName(rs.getString("dentist_name"));
        a.setPatientName(rs.getString("patient_name"));
        a.setPatientEmail(rs.getString("patient_email"));
        a.setPatientPhone(rs.getString("patient_phone"));
        a.setPatientAddress(rs.getString("patient_address"));
        a.setPaid(rs.getBoolean("pay_paid"));     // false if no payment row (LEFT JOIN -> null -> false)
        a.setAmountPaid(rs.getDouble("pay_amount")); // 0.0 if no payment row
        return a;
    }
}