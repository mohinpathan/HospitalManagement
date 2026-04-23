<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Patients</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.patient-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:18px}
.pat-card{background:#fff;border-radius:16px;padding:20px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;transition:all .2s}
.pat-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.1)}
.pat-avatar{width:52px;height:52px;border-radius:14px;background:linear-gradient(135deg,#d1fae5,#a7f3d0);display:flex;align-items:center;justify-content:center;font-size:20px;color:#19b37a;margin-bottom:14px;overflow:hidden}
.pat-avatar img{width:100%;height:100%;object-fit:cover}
.pat-name{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:3px}
.pat-email{font-size:12px;color:#64748b;margin-bottom:12px}
.pat-chips{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.chip{background:#f8fafc;border:1px solid #e5e7eb;border-radius:20px;padding:3px 10px;font-size:11px;font-weight:600;color:#374151}
.chip.blood{background:#fee2e2;color:#991b1b;border-color:#fecaca}
.pat-stats{display:flex;gap:12px;margin-bottom:16px}
.ps{text-align:center;flex:1;background:#f8fafc;border-radius:10px;padding:8px}
.ps .pv{font-size:18px;font-weight:800;color:#0f172a}
.ps .pl{font-size:10px;color:#64748b;font-weight:600;text-transform:uppercase}
.btn-view{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:9px;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:block;text-align:center;transition:all .2s}
.btn-view:hover{opacity:.9;color:#fff}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8;background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06)}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-users me-2" style="color:#19b37a"></i>My Patients</h2>
        <p>All patients who have had appointments with you.</p>
    </div>

    <%
        List<Map<String,Object>> patients = (List<Map<String,Object>>) request.getAttribute("patients");
        if (patients == null || patients.isEmpty()) {
    %>
    <div class="empty-state">
        <i class="fa fa-users fa-3x mb-3" style="color:#e2e8f0;display:block"></i>
        <h4 style="font-size:18px;font-weight:700;color:#374151;margin-bottom:8px">No patients yet</h4>
        <p>Patients will appear here after their appointments with you.</p>
    </div>
    <% } else { %>
    <div class="patient-grid">
    <% for (Map<String,Object> p : patients) {
        String photo = (String) p.get("photo");
        int visits = p.get("visit_count") != null ? ((Number)p.get("visit_count")).intValue() : 0;
    %>
    <div class="pat-card">
        <div class="pat-avatar">
            <% if (photo != null && !photo.isEmpty()) { %>
            <img src="<%=photo%>" alt="Photo">
            <% } else { %>
            <i class="fa fa-user"></i>
            <% } %>
        </div>
        <div class="pat-name"><%=p.get("full_name")%></div>
        <div class="pat-email"><%=p.get("email")%></div>
        <div class="pat-chips">
            <% if (p.get("gender") != null) { %><span class="chip"><%=p.get("gender")%></span><% } %>
            <% if (p.get("age") != null) { %><span class="chip">Age <%=p.get("age")%></span><% } %>
            <% if (p.get("blood_group") != null) { %><span class="chip blood"><%=p.get("blood_group")%></span><% } %>
        </div>
        <div class="pat-stats">
            <div class="ps"><div class="pv"><%=visits%></div><div class="pl">Visits</div></div>
            <div class="ps"><div class="pv" style="font-size:12px"><%=p.get("last_visit")!=null?p.get("last_visit").toString().substring(0,10):"—"%></div><div class="pl">Last Visit</div></div>
        </div>
        <a href="/HospitalManagement/doctor/patients/view/<%=p.get("id")%>" class="btn-view">
            <i class="fa fa-eye me-2"></i>View Patient
        </a>
    </div>
    <% } %>
    </div>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
