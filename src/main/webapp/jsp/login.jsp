<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sunrise Dental System</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #f5f7fa 50%, #e8eaf6 100%);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 420px;
            width: 100%;
        }

        .login-header {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white;
            padding: 2rem 2rem 1.75rem;
            text-align: center;
        }

        .login-header .icon {
            width: 70px;
            height: 70px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2rem;
        }

        .login-body {
            padding: 2rem;
        }

        .form-control {
            border-radius: 10px;
            padding: 0.7rem 1rem;
            border: 1px solid #dee2e6;
        }

        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #495057;
        }

        .btn-login {
            border-radius: 10px;
            padding: 0.7rem;
            font-weight: 600;
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            border: none;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #0b5ed7, #0a58ca);
        }

        .input-group-text {
            border-radius: 10px 0 0 10px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
        }

        .form-control.with-icon {
            border-radius: 0 10px 10px 0;
        }
    </style>
</head>
<body>

<div class="login-card">
    <!-- Header -->
    <div class="login-header">
        <div class="icon">
            <i class="bi bi-hospital"></i>
        </div>
        <h3 class="mb-1 fw-bold">Sunrise Dental</h3>
        <p class="mb-0 opacity-75">Sign in to your account</p>
    </div>

    <!-- Body -->
    <div class="login-body">
        <form action="<%= request.getContextPath() %>/login" method="post">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-person"></i>
                    </span>
                    <input type="text" name="username" class="form-control with-icon"
                           placeholder="Enter your username" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-lock"></i>
                    </span>
                    <input type="password" name="password" class="form-control with-icon"
                           placeholder="Enter your password" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-login w-100">
                <i class="bi bi-box-arrow-in-right me-2"></i> Login
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>