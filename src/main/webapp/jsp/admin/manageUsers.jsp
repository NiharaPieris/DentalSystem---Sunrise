<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Sunrise Dental</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #0d6efd;
            --card-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
        }

        .page-header {
            background: white;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .card-main {
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            background: white;
        }

        .table thead th {
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            color: white;
            font-weight: 600;
            border: none;
            padding: 14px 12px;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 12px;
        }

        .user-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }

        .btn {
            border-radius: 10px;
            font-weight: 500;
        }

        .btn-sm {
            padding: 0.35rem 0.75rem;
            font-size: 0.85rem;
        }

        .modal-header {
            background: linear-gradient(90deg, #0d6efd, #0b5ed7);
            color: white;
        }

        .form-control, .form-select {
            border-radius: 10px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .badge {
            font-weight: 500;
            padding: 5px 10px;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">
                <i class="bi bi-people me-2 text-primary"></i>Manage Users
            </h2>
            <small class="text-muted">Add, edit and manage Receptionists & Dentists</small>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/jsp/admin/dashboard.jsp" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
            </a>
            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="bi bi-plus-lg me-1"></i> Add User
            </button>
        </div>
    </div>

    <!-- Users Table Card -->
    <div class="card card-main">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-list-ul me-2"></i>All Users
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection();
                             Statement st = conn.createStatement();
                             ResultSet rs = st.executeQuery("SELECT * FROM users ORDER BY user_id DESC")) {

                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;

                                int userId = rs.getInt("user_id");
                                String username = rs.getString("username") != null ? rs.getString("username") : "";
                                String email = rs.getString("email") != null ? rs.getString("email") : "";
                                String address = rs.getString("address") != null ? rs.getString("address") : "";
                                String phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                                String role = rs.getString("role") != null ? rs.getString("role") : "";
                                String specialization = rs.getString("specialization") != null ? rs.getString("specialization") : "";
                                String license = rs.getString("license_number") != null ? rs.getString("license_number") : "";
                                String imagePath = rs.getString("image_path");
                                boolean active = rs.getBoolean("active");

                                // Escape for JavaScript
                                String jsUsername = username.replace("\\", "\\\\").replace("'", "\\'");
                                String jsEmail = email.replace("\\", "\\\\").replace("'", "\\'");
                                String jsAddress = address.replace("\\", "\\\\").replace("'", "\\'");
                                String jsPhone = phone.replace("\\", "\\\\").replace("'", "\\'");
                                String jsSpecialization = specialization.replace("\\", "\\\\").replace("'", "\\'");
                                String jsLicense = license.replace("\\", "\\\\").replace("'", "\\'");
                    %>
                    <tr>
                        <td><strong>#<%= userId %></strong></td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <% if (imagePath != null && !imagePath.isEmpty()) { %>
                                <img src="<%= request.getContextPath() + "/" + imagePath %>"
                                     class="user-avatar" alt="avatar">
                                <% } else { %>
                                <div class="user-avatar bg-primary bg-opacity-10 d-flex align-items-center justify-content-center text-primary">
                                    <i class="bi bi-person"></i>
                                </div>
                                <% } %>
                                <div>
                                    <div class="fw-semibold"><%= username %></div>
                                    <small class="text-muted"><%= phone.isEmpty() ? "-" : phone %></small>
                                </div>
                            </div>
                        </td>
                        <td><%= email %></td>
                        <td>
                            <% if ("Dentist".equalsIgnoreCase(role)) { %>
                            <span class="badge bg-info text-dark">
                                    <i class="bi bi-person-badge me-1"></i>Dentist
                                </span>
                            <% } else { %>
                            <span class="badge bg-secondary">
                                    <i class="bi bi-headset me-1"></i>Receptionist
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <% if (active) { %>
                            <span class="badge bg-success">Active</span>
                            <% } else { %>
                            <span class="badge bg-danger">Inactive</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-1">

                                <!-- Edit Button -->
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        onclick="fillEditForm(<%= userId %>, '<%= jsUsername %>', '<%= jsEmail %>', '<%= jsAddress %>', '<%= jsPhone %>', '<%= role %>', '<%= jsSpecialization %>', '<%= jsLicense %>')">
                                    <i class="bi bi-pencil"></i>
                                </button>

                                <!-- Toggle Active -->
                                <form action="<%= request.getContextPath() %>/admin/users/toggle" method="post" class="d-inline">
                                    <input type="hidden" name="user_id" value="<%= userId %>">
                                    <input type="hidden" name="active" value="<%= !active %>">
                                    <button type="submit"
                                            class="btn btn-sm <%= active ? "btn-outline-warning" : "btn-outline-success" %>"
                                            title="<%= active ? "Deactivate" : "Activate" %>">
                                        <i class="bi <%= active ? "bi-pause-circle" : "bi-play-circle" %>"></i>
                                    </button>
                                </form>

                                <!-- Soft Delete -->
                                <form action="<%= request.getContextPath() %>/admin/users/delete" method="post" class="d-inline"
                                      onsubmit="return confirm('Are you sure you want to deactivate this user? They will be marked as Inactive and can be reactivated later.');">
                                    <input type="hidden" name="user_id" value="<%= userId %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Deactivate User">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>

                            </div>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hasData) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-muted py-5">
                            <i class="bi bi-people fs-3 d-block mb-2"></i>
                            No users found. Click "Add User" to create one.
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-danger py-4">
                            Error loading users: <%= e.getMessage() %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ===================== ADD USER MODAL ===================== -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-person-plus me-2"></i>Add New User
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin/users/new" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                            <input type="text" name="username" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" name="phone" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
                            <select name="role" id="roleSelect" class="form-select" required
                                    onchange="toggleDentistFields('roleSelect','dentistFields')">
                                <option value="Receptionist">Receptionist</option>
                                <option value="Dentist">Dentist</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Address</label>
                            <input type="text" name="address" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Confirm Password <span class="text-danger">*</span></label>
                            <input type="password" name="confirmPassword" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Profile Image</label>
                            <input type="file" name="image" class="form-control" accept="image/*">
                        </div>

                        <!-- Dentist only fields -->
                        <div id="dentistFields" class="col-12" style="display:none;">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Specialization</label>
                                    <input type="text" name="specialization" class="form-control">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">License Number</label>
                                    <input type="text" name="licenseNumber" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Add User
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== EDIT USER MODAL ===================== -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil-square me-2"></i>Edit User
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin/users/edit" method="post" enctype="multipart/form-data">
                <input type="hidden" name="user_id" id="editUserId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                            <input type="text" name="username" id="editUsername" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" id="editEmail" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" name="phone" id="editPhone" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
                            <select name="role" id="editRoleSelect" class="form-select" required
                                    onchange="toggleDentistFields('editRoleSelect','editDentistFields')">
                                <option value="Receptionist">Receptionist</option>
                                <option value="Dentist">Dentist</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Address</label>
                            <input type="text" name="address" id="editAddress" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">New Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Replace Profile Image</label>
                            <input type="file" name="image" class="form-control" accept="image/*">
                        </div>

                        <!-- Dentist only fields -->
                        <div id="editDentistFields" class="col-12" style="display:none;">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Specialization</label>
                                    <input type="text" name="specialization" id="editSpecialization" class="form-control">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">License Number</label>
                                    <input type="text" name="licenseNumber" id="editLicenseNumber" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleDentistFields(roleSelectId, fieldsId) {
        const role = document.getElementById(roleSelectId).value;
        const fields = document.getElementById(fieldsId);
        fields.style.display = (role === "Dentist") ? "block" : "none";
    }

    function fillEditForm(userId, username, email, address, phone, role, specialization, licenseNumber) {
        document.getElementById("editUserId").value = userId;
        document.getElementById("editUsername").value = username;
        document.getElementById("editEmail").value = email;
        document.getElementById("editAddress").value = address;
        document.getElementById("editPhone").value = phone;
        document.getElementById("editRoleSelect").value = role;
        document.getElementById("editSpecialization").value = specialization;
        document.getElementById("editLicenseNumber").value = licenseNumber;

        toggleDentistFields('editRoleSelect', 'editDentistFields');

        const modal = new bootstrap.Modal(document.getElementById('editModal'));
        modal.show();
    }
</script>

</body>
</html>