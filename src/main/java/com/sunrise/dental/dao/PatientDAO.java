package com.sunrise.dental.dao;

import com.sunrise.dental.model.Patient;
import com.sunrise.dental.util.DBConnection;
import java.sql.*;

public class PatientDAO {
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
}
