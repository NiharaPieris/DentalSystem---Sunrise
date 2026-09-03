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
            // Check in users table
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                // Store user info in session
                HttpSession session = req.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", role);

                // Redirect based on role
                if ("Dentist".equalsIgnoreCase(role)) {
                    resp.sendRedirect(req.getContextPath() + "/jsp/dentist/dashboard.jsp");
                } else if ("Receptionist".equalsIgnoreCase(role)) {
                    resp.sendRedirect(req.getContextPath() + "/jsp/receptionist/dashboard.jsp");
                } else {
                    resp.getWriter().println("<h3>Unknown role. Contact admin.</h3>");
                }
            } else {
                resp.getWriter().println("<h3>Invalid credentials. Try again.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>Error connecting to database.</h3>");
        }
    }
}
