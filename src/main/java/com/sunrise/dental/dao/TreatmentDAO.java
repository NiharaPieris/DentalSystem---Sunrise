package com.sunrise.dental.dao;

import com.sunrise.dental.model.Treatment;
import com.sunrise.dental.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TreatmentDAO {

    public void addTreatment(Treatment t) {
        String sql = "INSERT INTO treatments (name,description,cost,duration_minutes,active_start,active_end,active_days,dentist_id) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getDescription());
            ps.setBigDecimal(3, t.getCost());
            ps.setInt(4, t.getDurationMinutes());
            ps.setString(5, t.getActiveStart());
            ps.setString(6, t.getActiveEnd());
            ps.setString(7, t.getActiveDays());
            ps.setInt(8, t.getDentistId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error adding treatment", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void updateTreatment(Treatment t) {
        String sql = "UPDATE treatments SET name=?,description=?,cost=?,duration_minutes=?,active_start=?,active_end=?,active_days=?,dentist_id=? WHERE treatment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getDescription());
            ps.setBigDecimal(3, t.getCost());
            ps.setInt(4, t.getDurationMinutes());
            ps.setString(5, t.getActiveStart());
            ps.setString(6, t.getActiveEnd());
            ps.setString(7, t.getActiveDays());
            ps.setInt(8, t.getDentistId());
            ps.setInt(9, t.getTreatmentId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating treatment", e);
        }
    }

    public void deleteTreatment(int id) {
        String sql = "DELETE FROM treatments WHERE treatment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting treatment", e);
        }
    }

    public List<Treatment> getAllTreatments() {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT * FROM treatments";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Treatment t = new Treatment();
                t.setTreatmentId(rs.getInt("treatment_id"));
                t.setName(rs.getString("name"));
                t.setDescription(rs.getString("description"));
                t.setCost(rs.getBigDecimal("cost"));
                t.setDurationMinutes(rs.getInt("duration_minutes"));
                t.setActiveStart(rs.getString("active_start"));
                t.setActiveEnd(rs.getString("active_end"));
                t.setActiveDays(rs.getString("active_days"));
                t.setDentistId(rs.getInt("dentist_id"));
                list.add(t);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching treatments", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }
}
