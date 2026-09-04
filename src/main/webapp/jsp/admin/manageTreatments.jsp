<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.sunrise.dental.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Treatments - Sunrise Dental</title>

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
            white-space: nowrap;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 12px;
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

        .day-badge {
            font-size: 0.75rem;
            margin: 1px;
        }

        .cost-badge {
            background: #e8f5e9;
            color: #2e7d32;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="container py-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">
                <i class="bi bi-heart-pulse me-2 text-primary"></i>Manage Treatments
            </h2>
            <small class="text-muted">Add, edit and manage available dental treatments</small>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/jsp/admin/dashboard.jsp" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
            </a>
            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="bi bi-plus-lg me-1"></i> Add Treatment
            </button>
        </div>
    </div>

    <!-- Treatments Table -->
    <div class="card card-main">
        <div class="card-header bg-white py-3">
            <h5 class="mb-0 fw-semibold">
                <i class="bi bi-list-ul me-2"></i>All Treatments
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Treatment</th>
                        <th>Cost</th>
                        <th>Duration</th>
                        <th>Active Time</th>
                        <th>Days</th>
                        <th>Dentist</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection();
                             Statement st = conn.createStatement();
                             ResultSet rs = st.executeQuery(
                                     "SELECT t.*, u.username AS dentist_name " +
                                             "FROM treatments t " +
                                             "JOIN users u ON t.dentist_id = u.user_id " +
                                             "ORDER BY t.treatment_id DESC")) {

                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;

                                int id = rs.getInt("treatment_id");
                                String name = rs.getString("name");
                                String desc = rs.getString("description") != null ? rs.getString("description") : "";
                                String cost = rs.getBigDecimal("cost").toString();
                                int duration = rs.getInt("duration_minutes");
                                String start = rs.getString("active_start") != null ? rs.getString("active_start").substring(0,5) : "-";
                                String end = rs.getString("active_end") != null ? rs.getString("active_end").substring(0,5) : "-";
                                String days = rs.getString("active_days") != null ? rs.getString("active_days") : "";
                                int dentistId = rs.getInt("dentist_id");
                                String dentistName = rs.getString("dentist_name");
                    %>
                    <tr>
                        <td><strong>#<%= id %></strong></td>
                        <td>
                            <div class="fw-semibold"><%= name %></div>
                            <small class="text-muted"><%= desc.length() > 40 ? desc.substring(0,40) + "..." : desc %></small>
                        </td>
                        <td>
                            <span class="cost-badge">Rs. <%= cost %></span>
                        </td>
                        <td><%= duration %> min</td>
                        <td>
                            <i class="bi bi-clock me-1 text-muted"></i>
                            <%= start %> – <%= end %>
                        </td>
                        <td>
                            <%
                                if (!days.isEmpty()) {
                                    String[] dayArr = days.split(",");
                                    for (String d : dayArr) {
                                        d = d.trim();
                            %>
                            <span class="badge bg-light text-dark border day-badge"><%= d %></span>
                            <%
                                }
                            } else {
                            %>
                            <span class="text-muted">-</span>
                            <% } %>
                        </td>
                        <td>
                            <i class="bi bi-person-badge me-1 text-primary"></i>
                            <%= dentistName %>
                        </td>
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-1">
                                <!-- Edit -->
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        onclick="fillEditForm(
                                            <%= id %>,
                                                '<%= name.replace("'", "\\'") %>',
                                                '<%= desc.replace("'", "\\'").replace("\n", " ").replace("\r", "") %>',
                                                '<%= cost %>',
                                            <%= duration %>,
                                                '<%= start %>',
                                                '<%= end %>',
                                                '<%= days %>',
                                            <%= dentistId %>
                                                )">
                                    <i class="bi bi-pencil"></i>
                                </button>

                                <!-- Delete -->
                                <form action="<%= request.getContextPath() %>/admin/treatments/delete" method="post" class="d-inline"
                                      onsubmit="return confirm('Are you sure you want to delete this treatment?');">
                                    <input type="hidden" name="treatment_id" value="<%= id %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
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
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="bi bi-heart-pulse fs-3 d-block mb-2"></i>
                            No treatments found. Click "Add Treatment" to create one.
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="8" class="text-center text-danger py-4">
                            Error loading treatments: <%= e.getMessage() %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ===================== ADD TREATMENT MODAL ===================== -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-plus-circle me-2"></i>Add New Treatment
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin/treatments/new" method="post">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Treatment Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Cost (Rs.) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" name="cost" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Duration (minutes) <span class="text-danger">*</span></label>
                            <input type="number" name="duration" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Active Start <span class="text-danger">*</span></label>
                            <input type="time" name="active_start" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Active End <span class="text-danger">*</span></label>
                            <input type="time" name="active_end" class="form-control" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Active Days</label>
                            <div class="d-flex flex-wrap gap-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="MON" id="addMon">
                                    <label class="form-check-label" for="addMon">Mon</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="TUE" id="addTue">
                                    <label class="form-check-label" for="addTue">Tue</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="WED" id="addWed">
                                    <label class="form-check-label" for="addWed">Wed</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="THU" id="addThu">
                                    <label class="form-check-label" for="addThu">Thu</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="FRI" id="addFri">
                                    <label class="form-check-label" for="addFri">Fri</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="SAT" id="addSat">
                                    <label class="form-check-label" for="addSat">Sat</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="SUN" id="addSun">
                                    <label class="form-check-label" for="addSun">Sun</label>
                                </div>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Dentist <span class="text-danger">*</span></label>
                            <select name="dentist_id" class="form-select" required>
                                <option value="">-- Select Dentist --</option>
                                <%
                                    try (Connection conn = DBConnection.getConnection();
                                         PreparedStatement ps = conn.prepareStatement(
                                                 "SELECT user_id, username FROM users WHERE role='Dentist' AND active=TRUE");
                                         ResultSet drs = ps.executeQuery()) {
                                        while (drs.next()) {
                                %>
                                <option value="<%= drs.getInt("user_id") %>"><%= drs.getString("username") %></option>
                                <%
                                    }
                                } catch (Exception e) {
                                %>
                                <option disabled>Error loading dentists</option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Save Treatment
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== EDIT TREATMENT MODAL ===================== -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil-square me-2"></i>Edit Treatment
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin/treatments/edit" method="post">
                <input type="hidden" name="treatment_id" id="editTreatmentId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Treatment Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" id="editName" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Cost (Rs.) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" name="cost" id="editCost" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description" id="editDescription" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Duration (minutes) <span class="text-danger">*</span></label>
                            <input type="number" name="duration" id="editDuration" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Active Start <span class="text-danger">*</span></label>
                            <input type="time" name="active_start" id="editStart" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Active End <span class="text-danger">*</span></label>
                            <input type="time" name="active_end" id="editEnd" class="form-control" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Active Days</label>
                            <div class="d-flex flex-wrap gap-3" id="editDays">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="MON" id="editMon">
                                    <label class="form-check-label" for="editMon">Mon</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="TUE" id="editTue">
                                    <label class="form-check-label" for="editTue">Tue</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="WED" id="editWed">
                                    <label class="form-check-label" for="editWed">Wed</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="THU" id="editThu">
                                    <label class="form-check-label" for="editThu">Thu</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="FRI" id="editFri">
                                    <label class="form-check-label" for="editFri">Fri</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="SAT" id="editSat">
                                    <label class="form-check-label" for="editSat">Sat</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="active_days" value="SUN" id="editSun">
                                    <label class="form-check-label" for="editSun">Sun</label>
                                </div>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Dentist <span class="text-danger">*</span></label>
                            <select name="dentist_id" id="editDentistId" class="form-select" required>
                                <option value="">-- Select Dentist --</option>
                                <%
                                    try (Connection conn = DBConnection.getConnection();
                                         PreparedStatement ps = conn.prepareStatement(
                                                 "SELECT user_id, username FROM users WHERE role='Dentist' AND active=TRUE");
                                         ResultSet drs = ps.executeQuery()) {
                                        while (drs.next()) {
                                %>
                                <option value="<%= drs.getInt("user_id") %>"><%= drs.getString("username") %></option>
                                <%
                                    }
                                } catch (Exception e) {
                                %>
                                <option disabled>Error loading dentists</option>
                                <% } %>
                            </select>
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
    function fillEditForm(id, name, desc, cost, duration, start, end, days, dentistId) {
        document.getElementById("editTreatmentId").value = id;
        document.getElementById("editName").value = name;
        document.getElementById("editDescription").value = desc;
        document.getElementById("editCost").value = cost;
        document.getElementById("editDuration").value = duration;
        document.getElementById("editStart").value = start;
        document.getElementById("editEnd").value = end;
        document.getElementById("editDentistId").value = dentistId;

        // Reset and check days
        document.querySelectorAll("#editDays input[type=checkbox]").forEach(cb => {
            cb.checked = false;
        });

        if (days) {
            const dayArray = days.split(",").map(d => d.trim());
            document.querySelectorAll("#editDays input[type=checkbox]").forEach(cb => {
                if (dayArray.includes(cb.value)) {
                    cb.checked = true;
                }
            });
        }

        const modal = new bootstrap.Modal(document.getElementById('editModal'));
        modal.show();
    }
</script>

</body>
</html>