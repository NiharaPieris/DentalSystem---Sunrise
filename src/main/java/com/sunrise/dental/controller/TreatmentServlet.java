package com.sunrise.dental.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.sunrise.dental.util.DBConnection;

public class TreatmentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // e.g. /new, /edit, /delete

        try (Connection conn = DBConnection.getConnection()) {
            if ("/new".equals(path)) {
                String sql = "INSERT INTO treatments (name,description,cost,duration_minutes,active_start,active_end,active_days,dentist_id) VALUES (?,?,?,?,?,?,?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, req.getParameter("name"));
                ps.setString(2, req.getParameter("description"));
                ps.setBigDecimal(3, new java.math.BigDecimal(req.getParameter("cost")));
                ps.setInt(4, Integer.parseInt(req.getParameter("duration")));
                ps.setString(5, req.getParameter("active_start"));
                ps.setString(6, req.getParameter("active_end"));
                ps.setString(7, String.join(",", req.getParameterValues("active_days")));
                ps.setInt(8, Integer.parseInt(req.getParameter("dentist_id")));
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageTreatments.jsp");

            } else if ("/edit".equals(path)) {
                String sql = "UPDATE treatments SET name=?,description=?,cost=?,duration_minutes=?,active_start=?,active_end=?,active_days=?,dentist_id=? WHERE treatment_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, req.getParameter("name"));
                ps.setString(2, req.getParameter("description"));
                ps.setBigDecimal(3, new java.math.BigDecimal(req.getParameter("cost")));
                ps.setInt(4, Integer.parseInt(req.getParameter("duration")));
                ps.setString(5, req.getParameter("active_start"));
                ps.setString(6, req.getParameter("active_end"));
                ps.setString(7, String.join(",", req.getParameterValues("active_days")));
                ps.setInt(8, Integer.parseInt(req.getParameter("dentist_id")));
                ps.setInt(9, Integer.parseInt(req.getParameter("treatment_id")));
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageTreatments.jsp");

            } else if ("/delete".equals(path)) {
                String sql = "DELETE FROM treatments WHERE treatment_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(req.getParameter("treatment_id")));
                ps.executeUpdate();

                resp.sendRedirect(req.getContextPath() + "/jsp/admin/manageTreatments.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>SQL Error: " + e.getMessage() + "</h3>");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>Error processing treatment action.</h3>");
        }
    }
}
