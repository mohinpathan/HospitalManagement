<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<% String uri = request.getRequestURI(); %>
<style>
.adm-sidebar{width:240px;background:#fff;border-right:2px solid #e8edf5;padding:22px 14px;min-height:calc(100vh - 62px);flex-shrink:0;box-shadow:2px 0 8px rgba(0,0,0,.04)}
.adm-sidebar .sb-title{font-size:10px;font-weight:800;color:#94a3b8;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:16px;padding:0 8px}
.adm-sidebar ul{list-style:none;padding:0;margin:0}
.adm-sidebar ul li{margin-bottom:3px}
.adm-sidebar ul li a{display:flex;align-items:center;gap:10px;padding:11px 12px;border-radius:10px;color:#475569;font-weight:500;font-size:14px;transition:all .2s;text-decoration:none}
.adm-sidebar ul li a:hover{background:#eff6ff;color:#2b7cff}
.adm-sidebar ul li a i{width:18px;text-align:center;font-size:15px}
.adm-sidebar ul li.active a{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;box-shadow:0 4px 12px rgba(43,124,255,.3)}
.adm-sidebar ul li.active a i{color:#fff}
.adm-sidebar .sb-divider{height:1px;background:#f1f5f9;margin:12px 8px}
</style>
<aside class="adm-sidebar">
    <div class="sb-title">Admin Panel</div>
    <ul>
        <li class="<%= uri.contains("dashboard") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/dashboard"><i class="fa fa-th-large"></i> Dashboard</a>
        </li>
        <div class="sb-divider"></div>
        <li class="<%= uri.contains("doctor") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/doctors"><i class="fa fa-user-md"></i> Manage Doctors</a>
        </li>
        <li class="<%= uri.contains("patient") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/patients"><i class="fa fa-users"></i> Manage Patients</a>
        </li>
        <li class="<%= uri.contains("appointment") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/appointments"><i class="fa fa-calendar-check"></i> Appointments</a>
        </li>
        <li class="<%= uri.contains("department") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/departments"><i class="fa fa-hospital"></i> Departments</a>
        </li>
        <li class="<%= uri.contains("bills") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/bills"><i class="fa fa-file-invoice-dollar"></i> Bills & Payments</a>
        </li>
        <div class="sb-divider"></div>
        <li class="<%= uri.contains("profile") ? "active" : "" %>">
            <a href="/HospitalManagement/admin/profile"><i class="fa fa-user-cog"></i> My Profile</a>
        </li>
    </ul>
</aside>
