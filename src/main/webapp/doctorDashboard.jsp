<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("role") == null || 
        !"doctor".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css"></head>
<body>

<header>
<h1>Doctor Dashboard</h1>
<a href="LogoutServlet">Logout</a>
</header>

<div class="container">
<h2>Welcome Doctor 👨‍⚕️</h2>
<p>View appointments / patients (Demo UI)</p>
</div>

</body>
</html>
