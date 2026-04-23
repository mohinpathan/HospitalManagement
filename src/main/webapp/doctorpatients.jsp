<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Patients</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.patient-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:18px}
.pat-card{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:all .2s;display:flex;flex-direction:column}
.pat-card:hover{transform:translateY(-4px);box-shadow:0 10px 28px rgba(0,0,0,.1)}
.pat-avatar{width:56px;height:56px;border-radius:14px;background:linear-gradient(135deg,#ede9fe,#ddd6fe);display:flex;align-items:center;justify-content:center;font-size:22px;color:#7c3aed;margin-bottom:14px;overflow:hidden;flex-shrink:0}
.pat-avatar img{width:100%;height:100%;object-fit:cover;border-radius:14px}
.pat-name{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:3px}
.pat-email{font-size:12px;color:#64748b;margin-bottom:12px}
.pat-info{font-size:13px;color:#374151;margin-bottom:5px;display:flex;align-items:center;gap:7px}
.pat-info i{width:16px;text-align:center;color:#94a3b8}
.pat-stats{display:flex;gap:10px;margin-top:14px;padding-top:14px;border-top:1px solid #f1f5f9}
.ps-item{flex:1;text-align:center}
.ps-val{font-size:18px;font-weight:800;color:#0f172a}
.ps-label{font-size:10px;color:#64748b;font-weight:600;text-transform:uppercase;letter-spacing:.5px}
.btn-view{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:9px;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:block;text-align:center;margin-top:14px;transition:all .2s}
.btn-view:hover{opacity:.9;color:#fff}
.blood-badge{background:#fee2e2;color:#991b1b;padding:2px 8px;border-radius:20px;font-size:11px;font-weight:700}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8;background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06)}
@media(max-width:768px){.dash-main{padding:16px}.patient-grid{grid-template-columns:1fr}}
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
        List<Map<String,Object>> patients=(List<Map<String,Object>>)request.getAttribute("patients");
        if(patients==null||patients.isEmpty()){
    %>
    <div class="empty-state">
        <i class="fa fa-users fa-3x mb-3" style="color:#e2e8f0;display:block"></i>
        <h4 style="font-size:18px;font-weight:700;color:#374151;margin-bottom:8px">No patients yet</h4>
        <p>Patients will appear here after their appointments with you.</p>
    </div>
    <%}else{%>
    <div class="patient-grid">
    <%for(Map<String,Object> p:patients){
        String photo=(String)p.get("photo");
        int visits=p.get("visit_count")!=null?((Number)p.get("visit_count")).intValue():0;
    %>
    <div class="pat-card">
        <div style="display:flex;align-items:center;gap:14px;margin-bottom:12px">
            <div class="pat-avatar">
                <%if(photo!=null&&!photo.isEmpty()){%><img src="<%=photo%>" alt=""><%}else{%><i class="fa fa-user"></i><%}%>
            </div>
            <div>
                <div class="pat-name"><%=p.get("full_name")%></div>
                <div class="pat-email"><%=p.get("email")%></div>
            </div>
        </div>
        <div class="pat-info"><i class="fa fa-phone"></i> <%=p.get("phone")!=null?p.get("phone"):"—"%></div>
        <div class="pat-info"><i class="fa fa-venus-mars"></i> <%=p.get("gender")!=null?p.get("gender"):"—"%> &nbsp;|&nbsp; Age: <%=p.get("age")!=null?p.get("age"):"—"%></div>
        <div class="pat-info"><i class="fa fa-tint" style="color:#ef4444"></i> <span class="blood-badge"><%=p.get("blood_group")!=null?p.get("blood_group"):"—"%></span></div>
        <div class="pat-stats">
            <div class="ps-item"><div class="ps-val"><%=visits%></div><div class="ps-label">Visits</div></div>
            <div class="ps-item"><div class="ps-val" style="font-size:12px;margin-top:4px"><%=p.get("last_visit")!=null?p.get("last_visit").toString().substring(0,10):"—"%></div><div class="ps-label">Last Visit</div></div>
        </div>
        <a href="/HospitalManagement/doctor/patient/<%=p.get("id")%>" class="btn-view"><i class="fa fa-eye me-1"></i> View Patient</a>
    </div>
    <%}}%>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
