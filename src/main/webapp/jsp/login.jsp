<!DOCTYPE html>
<html>
<head>
    <title>Login - Sunrise Dental System</title>
</head>
<body>
<h2>Admin Login</h2>
<form action="<%= request.getContextPath() %>/login" method="post">
    Username: <input type="text" name="username"><br><br>
    Password: <input type="password" name="password"><br><br>
    <input type="submit" value="Login">
</form>
</body>
</html>
