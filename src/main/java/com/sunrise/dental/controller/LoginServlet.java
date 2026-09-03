package com.sunrise.dental.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.sunrise.dental.util.DBConnection;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admin WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                resp.sendRedirect(req.getContextPath() + "/jsp/admin/dashboard.jsp");
            } else {
                resp.getWriter().println("<h3>Invalid credentials. Try again.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h3>Error connecting to database.</h3>");
        }
    }
}
