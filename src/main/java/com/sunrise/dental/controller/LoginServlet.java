package com.sunrise.dental.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.sunrise.dental.util.DBConnection;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            // 1. Check Admin
            String adminSql = "SELECT id, username FROM admin WHERE username = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(adminSql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("user_id", rs.getInt("id"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", "Admin");

                    resp.sendRedirect(req.getContextPath() + "/jsp/admin/dashboard.jsp");
                    return;
                }
            }

            // 2. Check Dentist / Receptionist
            String userSql = "SELECT * FROM users WHERE username = ? AND password = ? AND active = TRUE";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String role = rs.getString("role");

                    HttpSession session = req.getSession(true);
                    session.setAttribute("user_id", userId);
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", role);

                    if ("Dentist".equalsIgnoreCase(role)) {
                        // Dentist goes directly to appointments page
                        resp.sendRedirect(req.getContextPath() + "/dentist/appointments");
                    } else if ("Receptionist".equalsIgnoreCase(role)) {
                        resp.sendRedirect(req.getContextPath() + "/jsp/receptionist/dashboard.jsp");
                    } else {
                        resp.getWriter().println("Unknown role");
                    }
                    return;
                }
            }

            // Login failed
            resp.setContentType("text/html");
            resp.getWriter().println("<h3 style='color:red;'>Invalid username or password</h3>");
            resp.getWriter().println("<a href='" + req.getContextPath() + "/jsp/login.jsp'>Try Again</a>");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Database error: " + e.getMessage());
        }
    }
}