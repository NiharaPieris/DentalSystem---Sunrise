package com.sunrise.dental.service;

import com.sunrise.dental.dao.UserDAO;
import com.sunrise.dental.model.User;
import java.sql.SQLException;
import java.util.List;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    public void addUser(User user) throws SQLException {
        userDAO.addUser(user);
    }

    public void updateUser(User user) throws SQLException {
        userDAO.updateUser(user);
    }

    public void deleteUser(int userId) throws SQLException {
        userDAO.deleteUser(userId);
    }

    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }
}
