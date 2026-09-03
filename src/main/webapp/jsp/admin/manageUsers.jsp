<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background-color: #f2f2f2; }
        .modal { display:none; position:fixed; top:10%; left:20%; width:60%; background:#fff; padding:20px; border:1px solid #ccc; }
    </style>
    <script>
        function toggleDentistFields(roleSelectId, dentistFieldsId) {
            var role = document.getElementById(roleSelectId).value;
            var dentistFields = document.getElementById(dentistFieldsId);
            dentistFields.style.display = (role === "Dentist") ? "block" : "none";
        }
        function openModal(id) { document.getElementById(id).style.display = 'block'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        function fillEditForm(userId, username, email, address, phone, role, specialization, licenseNumber) {
            document.getElementById("editUserId").value = userId;
            document.getElementById("editUsername").value = username;
            document.getElementById("editEmail").value = email;
            document.getElementById("editAddress").value = address;
            document.getElementById("editPhone").value = phone;
            document.getElementById("editRoleSelect").value = role;
            toggleDentistFields('editRoleSelect','editDentistFields');
            document.getElementById("editSpecialization").value = specialization;
            document.getElementById("editLicenseNumber").value = licenseNumber;
            openModal('editModal');
        }
    </script>
</head>
<body>
<jsp:include page="navbar.jsp" />

<h2>Manage Users</h2>
<button onclick="openModal('addModal')">Add User</button>

<!-- Users Table -->
<table>
    <tr>
        <th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Image</th><th>Actions</th>
    </tr>
    <%
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM users")) {
            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("user_id") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("role") %></td>
        <td>
            <% if (rs.getString("image_path") != null) { %>
            <img src="<%= request.getContextPath() + "/" + rs.getString("image_path") %>" width="50">
            <% } %>
        </td>
        <td>
            <button onclick="fillEditForm(
                    '<%= rs.getInt("user_id") %>',
                    '<%= rs.getString("username") %>',
                    '<%= rs.getString("email") %>',
                    '<%= rs.getString("address") %>',
                    '<%= rs.getString("phone") %>',
                    '<%= rs.getString("role") %>',
                    '<%= rs.getString("specialization") %>',
                    '<%= rs.getString("license_number") %>'
                    )">Edit</button>
            <form action="<%= request.getContextPath() %>/admin/users/delete" method="post" style="display:inline;">
                <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
                <input type="submit" value="Delete">
            </form>
            <form action="<%= request.getContextPath() %>/admin/users/toggle" method="post" style="display:inline;">
                <input type="hidden" name="user_id" value="<%= rs.getInt("user_id") %>">
                <input type="hidden" name="active" value="<%= !rs.getBoolean("active") %>">
                <input type="submit" value="<%= rs.getBoolean("active") ? "Deactivate" : "Activate" %>">
            </form>
        </td>
    </tr>
    <%      }
    } catch (Exception e) { out.println("<tr><td colspan='6'>Error loading users</td></tr>"); }
    %>
</table>

<!-- Add User Modal -->
<div id="addModal" class="modal">
    <h3>Add User</h3>
    <form action="<%= request.getContextPath() %>/admin/users/new" method="post" enctype="multipart/form-data">
        Username: <input type="text" name="username" required><br>
        Email: <input type="email" name="email" required><br>
        Address: <input type="text" name="address"><br>
        Phone Number: <input type="text" name="phone"><br>
        Password: <input type="password" name="password" required><br>
        Confirm Password: <input type="password" name="confirmPassword" required><br>
        Role:
        <select name="role" id="roleSelect" onchange="toggleDentistFields('roleSelect','dentistFields')" required>
            <option value="Receptionist">Receptionist</option>
            <option value="Dentist">Dentist</option>
        </select><br>
        Profile Image: <input type="file" name="image"><br>
        <div id="dentistFields" style="display:none;">
            Specialization: <input type="text" name="specialization"><br>
            License Number: <input type="text" name="licenseNumber"><br>
        </div>
        <input type="submit" value="Add User">
        <button type="button" onclick="closeModal('addModal')">Cancel</button>
    </form>
</div>

<!-- Edit User Modal -->
<div id="editModal" class="modal">
    <h3>Edit User</h3>
    <form action="<%= request.getContextPath() %>/admin/users/edit" method="post" enctype="multipart/form-data">
        <input type="hidden" name="user_id" id="editUserId">
        Username: <input type="text" id="editUsername" name="username" required><br>
        Email: <input type="email" id="editEmail" name="email" required><br>
        Address: <input type="text" id="editAddress" name="address"><br>
        Phone Number: <input type="text" id="editPhone" name="phone"><br>
        New Password: <input type="password" name="password"><br>
        Role:
        <select name="role" id="editRoleSelect" onchange="toggleDentistFields('editRoleSelect','editDentistFields')" required>
            <option value="Receptionist">Receptionist</option>
            <option value="Dentist">Dentist</option>
        </select><br>
        Replace Profile Image: <input type="file" name="image"><br>
        <div id="editDentistFields" style="display:none;">
            Specialization: <input type="text" id="editSpecialization" name="specialization"><br>
            License Number: <input type="text" id="editLicenseNumber" name="licenseNumber"><br>
        </div>
        <input type="submit" value="Save Changes">
        <button type="button" onclick="closeModal('editModal')">Cancel</button>
    </form>
</div>

</body>
</html>
