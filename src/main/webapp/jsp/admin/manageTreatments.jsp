<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Treatments</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background-color: #f2f2f2; }
        .modal { display:none; position:fixed; top:10%; left:20%; width:60%; background:#fff; padding:20px; border:1px solid #ccc; }
    </style>
    <script>
        function openModal(id) { document.getElementById(id).style.display = 'block'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        function fillEditForm(id,name,desc,cost,duration,start,end,days,dentistId) {
            document.getElementById("editTreatmentId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editDescription").value = desc;
            document.getElementById("editCost").value = cost;
            document.getElementById("editDuration").value = duration;
            document.getElementById("editStart").value = start;
            document.getElementById("editEnd").value = end;
            // reset days
            let dayArray = days.split(",");
            document.querySelectorAll("#editDays input[type=checkbox]").forEach(cb => {
                cb.checked = dayArray.includes(cb.value);
            });
            document.getElementById("editDentistId").value = dentistId;
            openModal('editModal');
        }
    </script>
</head>
<body>
<jsp:include page="navbar.jsp" />

<h2>Manage Treatments</h2>
<button onclick="openModal('addModal')">Add Treatment</button>

<table>
    <tr>
        <th>ID</th><th>Name</th><th>Description</th><th>Cost</th><th>Duration</th><th>Active Time</th><th>Days</th><th>Dentist</th><th>Actions</th>
    </tr>
    <%
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT t.*, u.username AS dentist_name FROM treatments t JOIN users u ON t.dentist_id=u.user_id")) {
            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("treatment_id") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getBigDecimal("cost") %></td>
        <td><%= rs.getInt("duration_minutes") %> min</td>
        <td><%= rs.getString("active_start") %> - <%= rs.getString("active_end") %></td>
        <td><%= rs.getString("active_days") %></td>
        <td><%= rs.getString("dentist_name") %></td>
        <td>
            <button onclick="fillEditForm(
                    '<%= rs.getInt("treatment_id") %>',
                    '<%= rs.getString("name") %>',
                    '<%= rs.getString("description") %>',
                    '<%= rs.getBigDecimal("cost") %>',
                    '<%= rs.getInt("duration_minutes") %>',
                    '<%= rs.getString("active_start") %>',
                    '<%= rs.getString("active_end") %>',
                    '<%= rs.getString("active_days") %>',
                    '<%= rs.getInt("dentist_id") %>'
                    )">Edit</button>
            <form action="<%= request.getContextPath() %>/admin/treatments/delete" method="post" style="display:inline;">
                <input type="hidden" name="treatment_id" value="<%= rs.getInt("treatment_id") %>">
                <input type="submit" value="Delete">
            </form>
        </td>
    </tr>
    <%      }
    } catch (Exception e) { out.println("<tr><td colspan='9'>Error loading treatments</td></tr>"); }
    %>
</table>

<!-- Add Treatment Modal -->
<div id="addModal" class="modal">
    <h3>Add Treatment</h3>
    <form action="<%= request.getContextPath() %>/admin/treatments/new" method="post">
        Treatment Name: <input type="text" name="name" required><br>
        Description: <textarea name="description"></textarea><br>
        Cost: <input type="number" step="0.01" name="cost" required><br>
        Duration (minutes): <input type="number" name="duration" required><br>
        Active Start: <input type="time" name="active_start" required><br>
        Active End: <input type="time" name="active_end" required><br>
        Active Days:<br>
        <div>
            <label><input type="checkbox" name="active_days" value="MON"> Monday</label>
            <label><input type="checkbox" name="active_days" value="TUE"> Tuesday</label>
            <label><input type="checkbox" name="active_days" value="WED"> Wednesday</label>
            <label><input type="checkbox" name="active_days" value="THU"> Thursday</label>
            <label><input type="checkbox" name="active_days" value="FRI"> Friday</label>
            <label><input type="checkbox" name="active_days" value="SAT"> Saturday</label>
            <label><input type="checkbox" name="active_days" value="SUN"> Sunday</label>
        </div>
        Dentist:
        <select name="dentist_id" required>
            <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT user_id, username FROM users WHERE role='Dentist'");
                     ResultSet drs = ps.executeQuery()) {
                    while (drs.next()) {
            %>
            <option value="<%= drs.getInt("user_id") %>"><%= drs.getString("username") %></option>
            <%      }
            } catch (Exception e) { out.println("<option>Error loading dentists</option>"); }
            %>
        </select><br>
        <input type="submit" value="Save Treatment">
        <button type="button" onclick="closeModal('addModal')">Cancel</button>
    </form>
</div>

<!-- Edit Treatment Modal -->
<div id="editModal" class="modal">
    <h3>Edit Treatment</h3>
    <form action="<%= request.getContextPath() %>/admin/treatments/edit" method="post">
        <input type="hidden" name="treatment_id" id="editTreatmentId">
        Treatment Name: <input type="text" id="editName" name="name" required><br>
        Description: <textarea id="editDescription" name="description"></textarea><br>
        Cost: <input type="number" step="0.01" id="editCost" name="cost" required><br>
        Duration (minutes): <input type="number" id="editDuration" name="duration" required><br>
        Active Start: <input type="time" id="editStart" name="active_start" required><br>
        Active End: <input type="time" id="editEnd" name="active_end" required><br>
        Active Days:<br>
        <div id="editDays">
            <label><input type="checkbox" name="active_days" value="MON"> Monday</label>
            <label><input type="checkbox" name="active_days" value="TUE"> Tuesday</label>
            <label><input type="checkbox" name="active_days" value="WED"> Wednesday</label>
            <label><input type="checkbox" name="active_days" value="THU"> Thursday</label>
            <label><input type="checkbox" name="active_days" value="FRI"> Friday</label>
            <label><input type="checkbox" name="active_days" value="SAT"> Saturday</label>
            <label><input type="checkbox" name="active_days" value="SUN"> Sunday</label>
        </div>
        Dentist:
        <select name="dentist_id" id="editDentistId" required>
            <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT user_id, username FROM users WHERE role='Dentist'");
                     ResultSet drs = ps.executeQuery()) {
                    while (drs.next()) {
            %>
            <option value="<%= drs.getInt("user_id") %>"><%= drs.getString("username") %></option>
            <%      }
            } catch (Exception e) { out.println("<option>Error loading dentists</option>"); }
            %>
        </select><br>
        <input type="submit" value="Save Changes">
        <button type="button" onclick="closeModal('editModal')">Cancel</button>
    </form>
</div>

</body>
</html>
