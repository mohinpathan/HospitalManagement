<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%
    String sessionRole = (String) session.getAttribute("role");
    if (sessionRole != null) {
        if ("patient".equals(sessionRole)) response.sendRedirect("/HospitalManagement/patient/dashboard");
        else if ("doctor".equals(sessionRole)) response.sendRedirect("/HospitalManagement/doctor/dashboard");
        else if ("admin".equals(sessionRole))  response.sendRedirect("/HospitalManagement/admin/dashboard");
        return;
    }
    String savedEmail = ""; String savedRole = ""; boolean hasCookie = false;
    if (request.getCookies() != null) {
        for (jakarta.servlet.http.Cookie c : request.getCookies()) {
            if ("hms_email".equals(c.getName())) { savedEmail = c.getValue(); hasCookie = true; }
            if ("hms_role".equals(c.getName()))  { savedRole  = c.getValue(); }
        }
    }
%>
<!DOCTYPE html><html lang="<%=hi?"hi":"en"%>"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=t(hi,"लॉगिन","Login")%> - HealthCare Connect</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a 0%,#2b7cff 60%,#06b6d4 100%);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.login-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.login-card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:440px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(43,124,255,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;transition:border-color .2s,box-shadow .2s;outline:none}
.form-control:focus,.form-select:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.12)}
.input-group{display:flex;align-items:stretch;margin-bottom:16px}
.ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 14px;display:flex;align-items:center;color:#64748b}
.input-group .form-control{border-radius:0 10px 10px 0}
.ig-eye{background:#f1f5f9;border:1.5px solid #e5e7eb;border-left:none;border-radius:0 10px 10px 0;padding:0 14px;display:flex;align-items:center;color:#64748b;cursor:pointer}
.ig-eye:hover{background:#e2e8f0}
.btn-login{width:100%;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:4px;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-login:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 8px 20px rgba(43,124,255,.35)}
.remember-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;font-size:13px}
.remember-label{display:flex;align-items:center;gap:7px;color:#374151;cursor:pointer;font-weight:500}
.remember-label input[type=checkbox]{width:16px;height:16px;accent-color:#2b7cff;cursor:pointer}
.demo-card{background:#f8fafc;border:1px solid #e5e7eb;border-radius:12px;padding:14px 16px;font-size:13px;margin-top:18px}
.demo-card strong{color:#0f172a;display:block;margin-bottom:8px}
.demo-row{display:flex;justify-content:space-between;padding:5px 0;border-bottom:1px solid #f1f5f9;color:#374151}
.demo-row:last-child{border-bottom:none}
.demo-row .role-tag{font-weight:600}
.demo-row .creds{color:#64748b;font-family:monospace;font-size:12px}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0}
.cookie-banner{background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;padding:10px 14px;margin-bottom:16px;font-size:13px;color:#1e40af;display:flex;align-items:center;gap:8px}
/* Lang switcher on login page */
.login-lang{display:flex;justify-content:center;gap:8px;margin-bottom:20px}
.login-lang a{padding:5px 14px;border-radius:20px;font-size:12px;font-weight:700;text-decoration:none;border:1.5px solid #e5e7eb;color:#64748b;transition:all .2s}
.login-lang a.on{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border-color:transparent}
</style>
<script>
function togglePass(){
    const p=document.getElementById("pass");
    const i=document.getElementById("eyeIcon");
    p.type=p.type==="password"?"text":"password";
    i.className=p.type==="password"?"fa fa-eye":"fa fa-eye-slash";
}
</script>
</head><body>
<jsp:include page="/header.jsp" />
<div class="login-wrap">
<div class="login-card">
    <div class="card-icon"><i class="fa fa-user-lock"></i></div>
    <h2><%=t(hi,"वापस आएं","Welcome Back")%></h2>
    <p class="sub"><%=t(hi,"जारी रखने के लिए अपने खाते में साइन इन करें","Sign in to your account to continue")%></p>

    <% if(request.getAttribute("error")!=null){ %>
    <div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div>
    <% } %>
    <% if(request.getAttribute("success")!=null){ %>
    <div class="alert-msg alert-success"><i class="fa fa-check-circle"></i> <%=request.getAttribute("success")%></div>
    <% } %>
    <% if("1".equals(request.getParameter("error"))){ %>
    <div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=t(hi,"अमान्य ईमेल या पासवर्ड।","Invalid email or password.")%></div>
    <% } %>
    <% if(hasCookie){ %>
    <div class="cookie-banner"><i class="fa fa-cookie-bite"></i> <%=t(hi,"आपका ईमेल पहले से भरा हुआ है।","Welcome back! Your email has been pre-filled.")%></div>
    <% } %>

    <form action="/HospitalManagement/login" method="post">
        <div style="margin-bottom:16px">
            <label class="form-label"><%=t(hi,"भूमिका चुनें *","Login As *")%></label>
            <select name="role" class="form-select" required>
                <option value=""><%=t(hi,"भूमिका चुनें","Select Role")%></option>
                <option value="patient"  <%="patient".equals(savedRole)?"selected":""%>>🧑 <%=t(hi,"मरीज़","Patient")%></option>
                <option value="doctor"   <%="doctor".equals(savedRole) ?"selected":""%>>👨‍⚕️ <%=t(hi,"डॉक्टर","Doctor")%></option>
                <option value="admin"    <%="admin".equals(savedRole)  ?"selected":""%>>🛡️ <%=t(hi,"एडमिन","Admin")%></option>
            </select>
        </div>
        <div style="margin-bottom:16px">
            <label class="form-label"><%=t(hi,"ईमेल पता","Email Address")%></label>
            <div class="input-group">
                <span class="ig-icon"><i class="fa fa-envelope"></i></span>
                <input type="email" name="email" class="form-control" placeholder="<%=t(hi,"अपना ईमेल दर्ज करें","Enter your email")%>" value="<%=savedEmail%>" required>
            </div>
        </div>
        <div style="margin-bottom:12px">
            <label class="form-label"><%=t(hi,"पासवर्ड","Password")%></label>
            <div class="input-group">
                <span class="ig-icon"><i class="fa fa-lock"></i></span>
                <input type="password" name="password" id="pass" class="form-control" placeholder="<%=t(hi,"पासवर्ड दर्ज करें","Enter your password")%>" required>
                <span class="ig-eye" onclick="togglePass()"><i class="fa fa-eye" id="eyeIcon"></i></span>
            </div>
        </div>
        <div class="remember-row">
            <label class="remember-label">
                <input type="checkbox" name="rememberMe" <%=hasCookie?"checked":""%>>
                <%=t(hi,"30 दिनों के लिए याद रखें","Remember me for 30 days")%>
            </label>
            <a href="/HospitalManagement/forgetpass.jsp" style="color:#2b7cff;font-weight:600"><%=t(hi,"पासवर्ड भूल गए?","Forgot Password?")%></a>
        </div>
        <button type="submit" class="btn-login">
            <i class="fa fa-sign-in-alt"></i> <%=t(hi,"साइन इन","Sign In")%>
        </button>
    </form>

    <div class="demo-card">
        <strong><%=t(hi,"डेमो क्रेडेंशियल","Demo Credentials")%></strong>
        <div class="demo-row"><span class="role-tag">🛡️ Admin</span><span class="creds">admin@hms.com / admin123</span></div>
        <div class="demo-row"><span class="role-tag">👨‍⚕️ Doctor</span><span class="creds">sarah@hms.com / admin123</span></div>
        <div class="demo-row"><span class="role-tag">🧑 Patient</span><span class="creds">john@hms.com / admin123</span></div>
    </div>

    <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b">
        <%=t(hi,"खाता नहीं है?","Don't have an account?")%>
        <a href="/HospitalManagement/register.jsp" style="color:#2b7cff;font-weight:600"><%=t(hi,"यहाँ रजिस्टर करें","Register here")%></a>
    </p>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
