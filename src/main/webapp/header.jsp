<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f4f8;color:#1e293b}
a{text-decoration:none}
.pub-nav{display:flex;justify-content:space-between;align-items:center;padding:0 60px;height:66px;background:#fff;border-bottom:2px solid #e8edf5;position:sticky;top:0;z-index:1000;box-shadow:0 2px 12px rgba(43,124,255,.08)}
.pub-nav .brand{display:flex;align-items:center;gap:10px;font-weight:800;font-size:19px;color:#0f172a}
.pub-nav .brand-box{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;padding:7px 12px;border-radius:10px;font-weight:900;font-size:15px}
.pub-nav .nav-links{display:flex;align-items:center;gap:4px}
.pub-nav .nav-links a{padding:8px 15px;border-radius:9px;color:#374151;font-weight:500;font-size:14px;transition:all .2s}
.pub-nav .nav-links a:hover{background:#eff6ff;color:#2b7cff}
.pub-nav .nav-links .btn-reg{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff!important;padding:9px 20px;border-radius:9px;font-weight:600}
.pub-nav .nav-links .btn-reg:hover{opacity:.9;transform:translateY(-1px)}
/* Lang switcher */
.lang-sw{display:flex;align-items:center;gap:4px;background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:30px;padding:3px 5px;margin-left:8px}
.lang-sw a{padding:4px 11px;border-radius:20px;font-size:12px;font-weight:700;text-decoration:none;color:#64748b;transition:all .2s}
.lang-sw a.on{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;box-shadow:0 2px 8px rgba(43,124,255,.3)}
.lang-sw a:hover:not(.on){background:#f1f5f9;color:#374151}
@media(max-width:768px){.pub-nav{padding:12px 16px;flex-wrap:wrap;height:auto;gap:8px}.pub-nav .nav-links{flex-wrap:wrap}}
</style>
<nav class="pub-nav">
    <div class="brand">
        <span class="brand-box">H+</span>
        <%=t(hi,"HealthCare Connect","हेल्थकेयर कनेक्ट")%>
    </div>
    <div class="nav-links">
        <a href="/HospitalManagement/home.jsp"><i class="fa fa-home me-1"></i><%=t(hi,"Home","होम")%></a>
        <a href="/HospitalManagement/about.jsp"><%=t(hi,"About","हमारे बारे में")%></a>
        <a href="/HospitalManagement/contact.jsp"><%=t(hi,"Contact","संपर्क")%></a>
        <a href="/HospitalManagement/login.jsp"><i class="fa fa-sign-in-alt me-1"></i><%=t(hi,"Login","लॉगिन")%></a>
        <a href="/HospitalManagement/register.jsp" class="btn-reg"><i class="fa fa-user-plus me-1"></i><%=t(hi,"Register","रजिस्टर")%></a>
        <div class="lang-sw">
            <a href="/HospitalManagement/changeLang?lang=en" class="<%=!hi?"on":""%>">🇬🇧 EN</a>
            <a href="/HospitalManagement/changeLang?lang=hi" class="<%=hi?"on":""%>">🇮🇳 हि</a>
        </div>
    </div>
</nav>
