package com.sunrise.dental.dao;

import com.sunrise.dental.model.Payment;
import com.sunrise.dental.util.DBConnection;
import java.sql.*;

public class PaymentDAO {

    public Payment getPaymentByAppointment(int appointmentId) throws Exception {
        String sql = "SELECT * FROM payments WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setConsultationFee(rs.getDouble("consultation_fee"));
                p.setOtherFeeName(rs.getString("other_fee_name"));
                p.setOtherFee(rs.getDouble("other_fee"));
                p.setTotalAmount(rs.getDouble("total_amount"));
                p.setPaid(rs.getBoolean("paid"));
                p.setPaidAt(rs.getTimestamp("paid_at"));
                return p;
            }
        }
        return null;
    }

    public void savePayment(Payment p) throws Exception {
        String sql = "INSERT INTO payments (appointment_id, consultation_fee, other_fee_name, other_fee, total_amount, paid, paid_at) " +
                "VALUES (?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE " +
                "consultation_fee=VALUES(consultation_fee), " +
                "other_fee_name=VALUES(other_fee_name), " +
                "other_fee=VALUES(other_fee), " +
                "total_amount=VALUES(total_amount), " +
                "paid=VALUES(paid), " +
                "paid_at=VALUES(paid_at)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, p.getAppointmentId());
            ps.setDouble(2, p.getConsultationFee());
            ps.setString(3, p.getOtherFeeName() == null ? "" : p.getOtherFeeName());
            ps.setDouble(4, p.getOtherFee());
            ps.setDouble(5, p.getTotalAmount());
            ps.setBoolean(6, p.isPaid());
            ps.setTimestamp(7, p.getPaidAt());

            ps.executeUpdate();
        }
    }
}