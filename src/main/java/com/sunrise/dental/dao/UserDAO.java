package com.sunrise.dental.dao;

import com.sunrise.dental.model.User;
import com.sunrise.dental.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public void addUser(User user) {
        String sql = "INSERT INTO users (username,email,address,phone,password,role,image_path,specialization,license_number) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getImagePath());
            ps.setString(8, user.getSpecialization());
            ps.setString(9, user.getLicenseNumber());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error adding user", e);
        }
    }

    public void updateUser(User user) {
        String sql = "UPDATE users SET username=?,email=?,address=?,phone=?,role=?,specialization=?,license_number=? WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getSpecialization());
            ps.setString(7, user.getLicenseNumber());
            ps.setInt(8, user.getUserId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating user", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting user", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setAddress(rs.getString("address"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setImagePath(rs.getString("image_path"));
                u.setSpecialization(rs.getString("specialization"));
                u.setLicenseNumber(rs.getString("license_number"));
                users.add(u);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error fetching users", e);
        }
        return users;
    }
}
