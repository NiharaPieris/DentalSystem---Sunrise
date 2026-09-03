<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <script>
        function toggleDentistFields(roleSelectId, dentistFieldsId) {
            var role = document.getElementById(roleSelectId).value;
            var dentistFields = document.getElementById(dentistFieldsId);
            dentistFields.style.display = (role === "Dentist") ? "block" : "none";
        }
    </script>
</head>
<body>
<jsp:include page="navbar.jsp" />

<h2>Manage Users</h2>

<!-- Add User Form -->
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
</form>

<!-- Edit User Form (example modal placeholder) -->
<form id="editForm" action="<%= request.getContextPath() %>/admin/users/edit" method="post" enctype="multipart/form-data">
    <!-- Pre-filled fields would be set via JS -->
    Username: <input type="text" name="username" required><br>
    Email: <input type="email" name="email" required><br>
    Address: <input type="text" name="address"><br>
    Phone Number: <input type="text" name="phone"><br>
    New Password: <input type="password" name="newPassword"><br>
    Confirm New Password: <input type="password" name="confirmNewPassword"><br>
    Role:
    <select name="role" id="editRoleSelect" onchange="toggleDentistFields('editRoleSelect','editDentistFields')" required>
        <option value="Receptionist">Receptionist</option>
        <option value="Dentist">Dentist</option>
    </select><br>
    Replace Profile Image: <input type="file" name="image"><br>

    <div id="editDentistFields" style="display:none;">
        Specialization: <input type="text" name="specialization"><br>
        License Number: <input type="text" name="licenseNumber"><br>
    </div>

    <input type="submit" value="Save Changes">
</form>

</body>
</html>
