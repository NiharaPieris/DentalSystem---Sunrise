package com.sunrise.dental.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/sunrise_dental_system";
    private static final String USER = "root"; // default XAMPP user
    private static final String PASSWORD = ""; // default XAMPP password is empty

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
