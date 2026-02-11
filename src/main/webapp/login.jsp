<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
<h2>Login</h2>

<form action="LoginServlet" method="post">

    Role:
    <select name="role">
        <option value="admin">Admin</option>
        <option value="doctor">Doctor</option>
        <option value="patient">Patient</option>
    </select>

    Username:
    <input type="text" name="username" required>

    Password:
    <input type="password" name="password" required>

    <button type="submit">Login</button>
    <h4>Admin   → admin / admin
		Doctor  → doctor / doctor
		Patient → patient / patient
    </h4>

</form>
</div>

</body>
</html>
