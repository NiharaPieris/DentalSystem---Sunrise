package com.sunrise.dental.dao;

import com.sunrise.dental.model.Report;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    // ==================== SUMMARY REPORTS ====================

    public Report getDailyReport(Date date) throws Exception {
        String sql = "SELECT " +
                "COALESCE(SUM(p.total_amount), 0) AS income, " +
                "COUNT(a.appointment_id) AS appointments, " +
                "COUNT(DISTINCT a.patient_id) AS patients " +
                "FROM appointments a " +
                "LEFT JOIN payments p ON a.appointment_id = p.appointment_id " +
                "WHERE a.appointment_date = ?";
        return executeSummary(sql, ps -> ps.setDate(1, date));
    }

    public Report getRangeReport(Date startDate, Date endDate) throws Exception {
        String sql = "SELECT " +
                "COALESCE(SUM(p.total_amount), 0) AS income, " +
                "COUNT(a.appointment_id) AS appointments, " +
                "COUNT(DISTINCT a.patient_id) AS patients " +
                "FROM appointments a " +
                "LEFT JOIN payments p ON a.appointment_id = p.appointment_id " +
                "WHERE a.appointment_date BETWEEN ? AND ?";
        return executeSummary(sql, ps -> {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
        });
    }

    public Report getMonthlyReport(int year, int month) throws Exception {
        String sql = "SELECT " +
                "COALESCE(SUM(p.total_amount), 0) AS income, " +
                "COUNT(a.appointment_id) AS appointments, " +
                "COUNT(DISTINCT a.patient_id) AS patients " +
                "FROM appointments a " +
                "LEFT JOIN payments p ON a.appointment_id = p.appointment_id " +
                "WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ?";
        return executeSummary(sql, ps -> {
            ps.setInt(1, year);
            ps.setInt(2, month);
        });
    }

    // ==================== APPOINTMENT LISTS ====================

    public List<Appointment> getAppointmentsByDay(Date date) throws Exception {
        String sql = baseAppointmentListSql() + " WHERE a.appointment_date = ? ORDER BY a.appointment_time";
        return executeAppointmentList(sql, ps -> ps.setDate(1, date));
    }

    public List<Appointment> getAppointmentsByRange(Date startDate, Date endDate) throws Exception {
        String sql = baseAppointmentListSql() + " WHERE a.appointment_date BETWEEN ? AND ? ORDER BY a.appointment_date, a.appointment_time";
        return executeAppointmentList(sql, ps -> {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
        });
    }

    public List<Appointment> getAppointmentsByMonth(int year, int month) throws Exception {
        String sql = baseAppointmentListSql() +
                " WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? " +
                "ORDER BY a.appointment_date, a.appointment_time";
        return executeAppointmentList(sql, ps -> {
            ps.setInt(1, year);
            ps.setInt(2, month);
        });
    }

    // ==================== FULL DETAILS FOR MODAL ====================

    public Map<String, Object> getAppointmentFullDetails(int appointmentId) throws Exception {
        String sql =
                "SELECT " +
                        "  a.appointment_id, a.appointment_date, a.appointment_time, a.token_number, a.status, a.created_at, " +
                        "  p.patient_id, p.name AS patient_name, p.email AS patient_email, p.phone AS patient_phone, p.address AS patient_address, " +
                        "  t.treatment_id, t.name AS treatment_name, t.description AS treatment_description, t.cost AS treatment_cost, " +
                        "  t.duration_minutes, " +
                        "  u.user_id AS dentist_id, u.username AS dentist_name, u.specialization, " +
                        "  pay.payment_id, pay.consultation_fee, pay.other_fee_name, pay.other_fee, " +
                        "  pay.total_amount, pay.paid, pay.paid_at " +
                        "FROM appointments a " +
                        "JOIN patients p ON a.patient_id = p.patient_id " +
                        "JOIN treatments t ON a.treatment_id = t.treatment_id " +
                        "JOIN users u ON t.dentist_id = u.user_id " +
                        "LEFT JOIN payments pay ON a.appointment_id = pay.appointment_id " +
                        "WHERE a.appointment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return null;

            Map<String, Object> map = new HashMap<>();

            // Appointment
            map.put("appointmentId", rs.getInt("appointment_id"));
            map.put("appointmentDate", rs.getDate("appointment_date").toString());
            map.put("appointmentTime", rs.getTime("appointment_time").toString());
            map.put("tokenNumber", rs.getInt("token_number"));
            map.put("status", rs.getString("status"));
            map.put("createdAt", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString() : null);

            // Patient
            map.put("patientId", rs.getInt("patient_id"));
            map.put("patientName", rs.getString("patient_name"));
            map.put("patientEmail", rs.getString("patient_email"));
            map.put("patientPhone", rs.getString("patient_phone"));
            map.put("patientAddress", rs.getString("patient_address"));

            // Treatment + Dentist
            map.put("treatmentId", rs.getInt("treatment_id"));
            map.put("treatmentName", rs.getString("treatment_name"));
            map.put("treatmentDescription", rs.getString("treatment_description"));
            map.put("treatmentCost", rs.getBigDecimal("treatment_cost"));
            map.put("durationMinutes", rs.getInt("duration_minutes"));
            map.put("dentistId", rs.getInt("dentist_id"));
            map.put("dentistName", rs.getString("dentist_name"));
            map.put("specialization", rs.getString("specialization"));

            // Payment (can be null)
            if (rs.getObject("payment_id") != null) {
                map.put("paymentId", rs.getInt("payment_id"));
                map.put("consultationFee", rs.getBigDecimal("consultation_fee"));
                map.put("otherFeeName", rs.getString("other_fee_name"));
                map.put("otherFee", rs.getBigDecimal("other_fee"));
                map.put("totalAmount", rs.getBigDecimal("total_amount"));
                map.put("paid", rs.getBoolean("paid"));
                map.put("paidAt", rs.getTimestamp("paid_at") != null ? rs.getTimestamp("paid_at").toString() : null);
            } else {
                map.put("paymentId", null);
                map.put("consultationFee", BigDecimal.ZERO);
                map.put("otherFeeName", null);
                map.put("otherFee", BigDecimal.ZERO);
                map.put("totalAmount", BigDecimal.ZERO);
                map.put("paid", false);
                map.put("paidAt", null);
            }

            return map;
        }
    }

    // ==================== PRIVATE HELPERS ====================

    private String baseAppointmentListSql() {
        return "SELECT a.appointment_id, p.name AS patient_name, " +
                "t.name AS treatment_name, a.appointment_date, a.appointment_time, a.status, a.token_number " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.patient_id " +
                "JOIN treatments t ON a.treatment_id = t.treatment_id";
    }

    private Report executeSummary(String sql, SQLConsumer<PreparedStatement> binder) throws Exception {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            binder.accept(ps);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Report(
                        rs.getBigDecimal("income"),
                        rs.getInt("appointments"),
                        rs.getInt("patients")
                );
            }
        }
        return Report.empty();
    }

    private List<Appointment> executeAppointmentList(String sql, SQLConsumer<PreparedStatement> binder) throws Exception {
        List<Appointment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            binder.accept(ps);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setAppointmentId(rs.getInt("appointment_id"));
                ap.setPatientName(rs.getString("patient_name"));
                ap.setTreatmentName(rs.getString("treatment_name"));
                ap.setAppointmentDate(rs.getDate("appointment_date"));
                ap.setAppointmentTime(rs.getTime("appointment_time"));
                // Optional extra fields if your Appointment model has them
                try {
                    ap.setStatus(rs.getString("status"));
                    ap.setTokenNumber(rs.getInt("token_number"));
                } catch (Exception ignored) {}
                list.add(ap);
            }
        }
        return list;
    }

    @FunctionalInterface
    private interface SQLConsumer<T> {
        void accept(T t) throws SQLException;
    }
}