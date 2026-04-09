<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<% String uri = request.getRequestURI(); %>
<style>
.pat-sidebar{width:240px;background:#fff;border-right:2px solid #e8edf5;padding:22px 14px;min-height:calc(100vh - 62px);flex-shrink:0;box-shadow:2px 0 8px rgba(0,0,0,.04)}
.pat-sidebar .sb-title{font-size:10px;font-weight:800;color:#94a3b8;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:16px;padding:0 8px}
.pat-sidebar a{display:flex;align-items:center;gap:10px;padding:11px 12px;border-radius:10px;color:#475569;font-weight:500;font-size:14px;transition:all .2s;text-decoration:none;margin-bottom:3px}
.pat-sidebar a:hover{background:#f5f3ff;color:#7c3aed}
.pat-sidebar a i{width:18px;text-align:center;font-size:15px}
.pat-sidebar a.active{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;box-shadow:0 4px 12px rgba(124,58,237,.3)}
.pat-sidebar a.active i{color:#fff}
.pat-sidebar .sb-divider{height:1px;background:#f1f5f9;margin:12px 8px}
.pat-sidebar .btn-logout-sb{color:#dc2626!important;background:#fff1f2;border:1px solid #fecaca;margin-top:8px}
.pat-sidebar .btn-logout-sb:hover{background:#fee2e2!important}
</style>
<aside class="pat-sidebar">
    <div class="sb-title">Patient Portal</div>
    <a href="/HospitalManagement/patient/dashboard"       class="<%= uri.contains("dashboard") ? "active" : "" %>"><i class="fa fa-th-large"></i> Dashboard</a>
    <a href="/HospitalManagement/patient/findDoctors"     class="<%= uri.contains("findDoctors") ? "active" : "" %>"><i class="fa fa-search"></i> Find Doctors</a>
    <a href="/HospitalManagement/patient/bookAppointment" class="<%= uri.contains("bookAppointment") ? "active" : "" %>"><i class="fa fa-calendar-plus"></i> Book Appointment</a>
    <a href="/HospitalManagement/patient/appointments"    class="<%= uri.contains("appointments") ? "active" : "" %>"><i class="fa fa-history"></i> My Appointments</a>
    <a href="/HospitalManagement/patient/medicalRecords"  class="<%= uri.contains("medical") ? "active" : "" %>"><i class="fa fa-file-medical"></i> Medical Records</a>
    <div class="sb-divider"></div>
    <a href="/HospitalManagement/patient/profile"         class="<%= uri.contains("profile") ? "active" : "" %>"><i class="fa fa-user"></i> My Profile</a>
    <a href="/HospitalManagement/logout" class="btn-logout-sb"><i class="fa fa-sign-out-alt"></i> Logout</a>
</aside>
