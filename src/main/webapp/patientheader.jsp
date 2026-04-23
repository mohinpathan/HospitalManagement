<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f4f8;color:#1e293b}
a{text-decoration:none}
.role-nav{display:flex;justify-content:space-between;align-items:center;padding:0 28px;height:62px;background:#fff;border-bottom:2px solid #e8edf5;position:sticky;top:0;z-index:1000;box-shadow:0 2px 12px rgba(0,0,0,.06)}
.role-nav .brand{display:flex;align-items:center;gap:10px;font-weight:800;font-size:17px;color:#0f172a}
.role-nav .brand-box{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;padding:6px 11px;border-radius:9px;font-weight:900;font-size:14px}
.role-nav .nav-right{display:flex;align-items:center;gap:4px}
.role-nav .nav-right a{padding:7px 13px;border-radius:9px;color:#374151;font-weight:500;font-size:14px;transition:all .2s}
.role-nav .nav-right a:hover{background:#f5f3ff;color:#7c3aed}
.user-chip{display:flex;align-items:center;gap:8px;padding:6px 14px;background:#f8fafc;border-radius:30px;border:1px solid #e5e7eb;font-size:14px;font-weight:500;color:#374151}
.badge-patient{background:#ede9fe;color:#6d28d9;font-size:10px;font-weight:700;padding:3px 8px;border-radius:20px}
.btn-logout{background:#fee2e2;color:#dc2626!important;padding:7px 14px!important;border-radius:9px!important;font-weight:600!important;border:1px solid #fecaca}
.btn-logout:hover{background:#fecaca!important}
.lang-sw{display:flex;align-items:center;gap:4px;background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:30px;padding:3px 5px;margin-left:6px}
.lang-sw a{padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;text-decoration:none;color:#64748b;transition:all .2s}
.lang-sw a.on{background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff}
.lang-sw a:hover:not(.on){background:#f1f5f9}
</style>
<div class="role-nav">
    <div class="brand">
        <span class="brand-box">H+</span>
        <%=t(hi,"HealthCare Connect","हेल्थकेयर कनेक्ट")%>
    </div>
    <div class="nav-right">
        <a href="/HospitalManagement/patient/dashboard"><i class="fa fa-th-large me-1"></i><%=t(hi,"Dashboard","डैशबोर्ड")%></a>
        <a href="/HospitalManagement/patientabout.jsp"><%=t(hi,"About","हमारे बारे में")%></a>
        <a href="/HospitalManagement/patientcontact.jsp"><%=t(hi,"Contact","संपर्क")%></a>
        <a href="/HospitalManagement/notifications" style="position:relative">
            <i class="fa fa-bell"></i>
            <span id="notifBadge" style="display:none;position:absolute;top:-4px;right:-4px;background:#ef4444;color:#fff;border-radius:50%;width:16px;height:16px;font-size:9px;font-weight:700;align-items:center;justify-content:center">0</span>
        </a>
        <div class="user-chip">
            <i class="fa fa-user" style="color:#7c3aed"></i>
            <%= session.getAttribute("patientName") != null ? session.getAttribute("patientName") : "Patient" %>
            <span class="badge-patient"><%=t(hi,"मरीज़","PATIENT")%></span>
        </div>
        <a href="/HospitalManagement/logout" class="btn-logout"><i class="fa fa-sign-out-alt me-1"></i><%=t(hi,"लॉगआउट","Logout")%></a>
        <div class="lang-sw">
            <a href="/HospitalManagement/changeLang?lang=en" class="<%=!hi?"on":""%>">EN</a>
            <a href="/HospitalManagement/changeLang?lang=hi" class="<%=hi?"on":""%>">हि</a>
        </div>
    </div>
</div>
<script>
function loadNotifCount(){
    fetch('/HospitalManagement/notifications/count')
    .then(r=>r.json()).then(d=>{
        const b=document.getElementById('notifBadge');
        if(b){b.textContent=d.count;b.style.display=d.count>0?'inline-flex':'none';}
    }).catch(()=>{});
}
loadNotifCount(); setInterval(loadNotifCount,60000);
</script>
