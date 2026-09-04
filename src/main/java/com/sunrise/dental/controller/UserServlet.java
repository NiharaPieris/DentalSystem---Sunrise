package com.sunrise.dental.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.sunrise.dental.util.DBConnection;

@MultipartConfig // enables file upload handling
public class UserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // e.g. /new, /edit, /delete

        try (Connection conn = DBConnection.getConnection()) {
            if ("/new".equals(path)) {
                String role = req.getParameter("role");

                String sql = "INSERT INTO users (username,email,address,phone,password,role,image_path,specialization,license_number) VALUES (?,?,?,?,?,?,?,?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, req.getParameter("username"));
                ps.setString(2, req.getParameter("email"));
                ps.setString(3, req.getParameter("address"));
                ps.setString(4, req.getParameter("phone"));
                ps.setString(5, req.getParameter("password"));
                ps.setString(6, role);

                // Handle image upload
                Part imagePart = req.getPart("image");
                String imagePath = null;
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String uploadDir = req.getServletContext().getRealPath("/uploads");
                    File dir = new File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();
                    imagePart.write(uploadDir + File.separator + fileName);
                    imagePath = "uploads/" + fileName;
                }
                if (imagePath != null) {
                    ps.setString(7, imagePath);
                } else {
                    ps.setNull(7, Types.VARCHAR);
                }

                // Dentist-only fields
                if ("Dentist".equalsIgnoreCase(role)) {
                    ps.setString(8, req.getParameter("specialization"));
                    ps.setString(9, req.getParameter("licenseNumber"));
                } else {
                    ps.setNull(8, Types.VARCHAR);
                    ps.setNull(9, Types.VARCHAR);
                }

                ps.executeUpdate();
                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageUsers.jsp");

            } else if ("/edit".equals(path)) {
                String role = req.getParameter("role");

                String sql = "UPDATE users SET username=?,email=?,address=?,phone=?,role=?,specialization=?,license_number=?,image_path=? WHERE user_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, req.getParameter("username"));
                ps.setString(2, req.getParameter("email"));
                ps.setString(3, req.getParameter("address"));
                ps.setString(4, req.getParameter("phone"));
                ps.setString(5, role);

                if ("Dentist".equalsIgnoreCase(role)) {
                    ps.setString(6, req.getParameter("specialization"));
                    ps.setString(7, req.getParameter("licenseNumber"));
                } else {
                    ps.setNull(6, Types.VARCHAR);
                    ps.setNull(7, Types.VARCHAR);
                }

                // Handle image replacement
                Part imagePart = req.getPart("image");
                String imagePath = null;
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String uploadDir = req.getServletContext().getRealPath("/uploads");
                    File dir = new File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();
                    imagePart.write(uploadDir + File.separator + fileName);
                    imagePath = "uploads/" + fileName;
                }
                if (imagePath != null) {
                    ps.setString(8, imagePath);
                } else {
                    ps.setNull(8, Types.VARCHAR);
                }

                ps.setInt(9, Integer.parseInt(req.getParameter("user_id")));
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageUsers.jsp");

            } else if ("/delete".equals(path)) {
                // Soft delete – hide the user instead of permanently deleting
                String sql = "UPDATE users SET active = FALSE WHERE user_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(req.getParameter("user_id")));
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageUsers.jsp");

            }else if ("/toggle".equals(path)) {
                int userId = Integer.parseInt(req.getParameter("user_id"));
                boolean newStatus = Boolean.parseBoolean(req.getParameter("active"));

                String sql = "UPDATE users SET active=? WHERE user_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setBoolean(1, newStatus);
                ps.setInt(2, userId);
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageUsers.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>SQL Error: " + e.getMessage() + "</h3>");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>Error processing user action.</h3>");
        }
    }
}
