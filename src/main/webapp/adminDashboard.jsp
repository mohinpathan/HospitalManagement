<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Doctor" %>

<%
    if (session.getAttribute("role") == null || 
        !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
</head>
<body>

<header>
<h1>Admin Dashboard</h1>
<a href="LogoutServlet">Logout</a>
</header>

<div class="container">

<h2>Add Doctor</h2>

<form action="DoctorServlet" method="post">
    <input type="hidden" name="action" value="add">

    Name:
    <input type="text" name="name" required>

    Specialization:
    <input type="text" name="specialization" required>

    <button type="submit">Add</button>
</form>

<hr>

<h2>Doctor List</h2>

<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Specialization</th>
<th>Action</th>
</tr>

<%
List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");

if (doctors != null) {
    for (Doctor d : doctors) {
%>

<tr>
<td><%=d.getId()%></td>

<td>
<form action="DoctorServlet" method="post">
<input type="hidden" name="action" value="update">
<input type="hidden" name="id" value="<%=d.getId()%>">

<input type="text" name="name" value="<%=d.getName()%>">
</td>

<td>
<input type="text" name="specialization" value="<%=d.getSpecialization()%>">
</td>

<td>
<button type="submit">Update</button>
<a href="DoctorServlet?action=delete&id=<%=d.getId()%>">Delete</a>
</form>
</td>
</tr>

<%
    }
}
%>

</table>

</div>
</body>
</html>
