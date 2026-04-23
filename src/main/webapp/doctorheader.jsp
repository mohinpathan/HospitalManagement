<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f4f8;color:#1e293b}
a{text-decoration:none}
.role-nav{display:flex;justify-content:space-between;align-items:center;padding:0 28px;height:62px;background:#fff;border-bottom:2px solid #e8edf5;position:sticky;top:0;z-index:1000;box-shadow:0 2px 12px rgba(0,0,0,.06)}
.role-nav .brand{display:flex;align-items:center;gap:10px;font-weight:800;font-size:17px;color:#0f172a}
.role-nav .brand-box{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;padding:6px 11px;border-radius:9px;font-weight:900;font-size:14px}
.role-nav .nav-right{display:flex;align-items:center;gap:4px}
.role-nav .nav-right a{padding:7px 13px;border-radius:9px;color:#374151;font-weight:500;font-size:14px;transition:all .2s}
.role-nav .nav-right a:hover{background:#f0fdf4;color:#19b37a}
.role-nav .user-chip{display:flex;align-items:center;gap:8px;padding:6px 14px;background:#f8fafc;border-radius:30px;border:1px solid #e5e7eb;font-size:14px;font-weight:500;color:#374151}
.role-nav .badge-doctor{background:#d1fae5;color:#065f46;font-size:10px;font-weight:700;padding:3px 8px;border-radius:20px;letter-spacing:.5px}
.role-nav .btn-logout{background:#fee2e2;color:#dc2626!important;padding:7px 14px!important;border-radius:9px!important;font-weight:600!important;border:1px solid #fecaca}
.role-nav .btn-logout:hover{background:#fecaca!important}
</style>
<div class="role-nav">
    <div class="brand">
        <span class="brand-box">H+</span>
        HealthCare Connect
    </div>
    <div class="nav-right">
        <a href="/HospitalManagement/doctor/dashboard"><i class="fa fa-th-large me-1"></i>Dashboard</a>
        <a href="/HospitalManagement/doctorabout.jsp">About</a>
        <a href="/HospitalManagement/doctorcontact.jsp">Contact</a>
        <div class="user-chip">
            <i class="fa fa-user-md" style="color:#19b37a"></i>
            <%= session.getAttribute("doctorName") != null ? session.getAttribute("doctorName") : "Doctor" %>
            <span class="badge-doctor">DOCTOR</span>
        </div>
        <a href="/HospitalManagement/logout" class="btn-logout"><i class="fa fa-sign-out-alt me-1"></i>Logout</a>
        <jsp:include page="/langswitcher.jsp" />
    </div>
</div>
