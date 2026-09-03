package com.sunrise.dental.dao;

import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    // ===================== EXISTING METHOD (kept) =====================
    public int addPatient(Patient p) throws Exception {
        String sql = "INSERT INTO patients (name,email,phone,address) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getName());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getAddress());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    // ===================== NEW METHODS =====================

    /**
     * Flexible search by name / phone / email
     * Any field can be empty → works as partial search
     */
    public List<Patient> searchPatients(String name, String phone, String email) throws Exception {
        List<Patient> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM patients WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql.append(" AND phone LIKE ?");
            params.add("%" + phone.trim() + "%");
        }
        if (email != null && !email.trim().isEmpty()) {
            sql.append(" AND email LIKE ?");
            params.add("%" + email.trim() + "%");
        }

        sql.append(" ORDER BY name");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPatient(rs));
            }
        }
        return list;
    }

    public Patient getPatientById(int patientId) throws Exception {
        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapPatient(rs);
            }
        }
        return null;
    }

    /**
     * Get all appointments of a patient (with treatment name)
     */
    public List<Appointment> getAppointmentsByPatient(int patientId) throws SQLException {
        List<Appointment> list = new ArrayList<>();

        String sql = """
            SELECT a.appointment_id, a.patient_id, a.treatment_id,
                   a.appointment_date, a.appointment_time, a.token_number,
                   t.name AS treatment_name
            FROM appointments a
            JOIN treatments t ON a.treatment_id = t.treatment_id
            WHERE a.patient_id = ?
            ORDER BY a.appointment_date DESC, a.appointment_time DESC
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTreatmentId(rs.getInt("treatment_id"));
                a.setAppointmentDate(rs.getDate("appointment_date"));
                a.setAppointmentTime(rs.getTime("appointment_time"));
                a.setTokenNumber(rs.getInt("token_number"));
                a.setTreatmentName(rs.getString("treatment_name"));
                list.add(a);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    // ===================== Helper =====================
    private Patient mapPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setPatientId(rs.getInt("patient_id"));
        p.setName(rs.getString("name"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        p.setAddress(rs.getString("address"));
        return p;
    }
}