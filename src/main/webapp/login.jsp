<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login - HealthCare Connect</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a 0%,#2b7cff 60%,#06b6d4 100%);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.login-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.login-card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:440px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.login-card .card-icon{width:68px;height:68px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(43,124,255,.35)}
.login-card h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.login-card .sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;transition:border-color .2s,box-shadow .2s;outline:none}
.form-control:focus,.form-select:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.12)}
.input-group{display:flex;align-items:stretch;margin-bottom:16px}
.input-group .ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 14px;display:flex;align-items:center;color:#64748b}
.input-group .form-control{border-radius:0 10px 10px 0}
.input-group .ig-eye{background:#f1f5f9;border:1.5px solid #e5e7eb;border-left:none;border-radius:0 10px 10px 0;padding:0 14px;display:flex;align-items:center;color:#64748b;cursor:pointer}
.btn-login{width:100%;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:4px}
.btn-login:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 8px 20px rgba(43,124,255,.35)}
.demo-card{background:#f8fafc;border:1px solid #e5e7eb;border-radius:12px;padding:14px 16px;font-size:13px;margin-top:18px;color:#374151}
.demo-card strong{color:#0f172a}
.demo-card .demo-row{display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid #f1f5f9}
.demo-card .demo-row:last-child{border-bottom:none}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0}
.divider{display:flex;align-items:center;gap:12px;margin:18px 0;color:#94a3b8;font-size:13px}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:#e5e7eb}
</style>
<script>
function togglePass(){const p=document.getElementById("pass");const i=document.getElementById("eyeIcon");p.type=p.type==="password"?"text":"password";i.className=p.type==="password"?"fa fa-eye":"fa fa-eye-slash"}
</script>
</head><body>
<jsp:include page="/header.jsp" />
<div class="login-wrap">
    <div class="login-card">
        <div class="card-icon"><i class="fa fa-user-lock"></i></div>
        <h2>Welcome Back</h2>
        <p class="sub">Sign in to your account to continue</p>

        <% if(request.getAttribute("error")!=null){ %><div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div><% } %>
        <% if(request.getAttribute("success")!=null){ %><div class="alert-msg alert-success"><i class="fa fa-check-circle"></i> <%=request.getAttribute("success")%></div><% } %>
        <% if("1".equals(request.getParameter("error"))){ %><div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> Invalid email or password.</div><% } %>

        <form action="/HospitalManagement/login" method="post">
            <div style="margin-bottom:16px">
                <label class="form-label">Login As *</label>
                <select name="role" class="form-select" required>
                    <option value="">Select Role</option>
                    <option value="patient">🧑 Patient</option>
                    <option value="doctor">👨‍⚕️ Doctor</option>
                    <option value="admin">🛡️ Admin</option>
                </select>
            </div>
            <div style="margin-bottom:16px">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="ig-icon"><i class="fa fa-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
            </div>
            <div style="margin-bottom:12px">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="ig-icon"><i class="fa fa-lock"></i></span>
                    <input type="password" name="password" id="pass" class="form-control" placeholder="Enter your password" required>
                    <span class="ig-eye" onclick="togglePass()"><i class="fa fa-eye" id="eyeIcon"></i></span>
                </div>
            </div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;font-size:13px">
                <label style="display:flex;align-items:center;gap:6px;color:#374151;cursor:pointer"><input type="checkbox" style="accent-color:#2b7cff"> Remember me</label>
                <a href="/HospitalManagement/forgetpass.jsp" style="color:#2b7cff;font-weight:600">Forgot Password?</a>
            </div>
            <button type="submit" class="btn-login"><i class="fa fa-sign-in-alt me-2"></i>Sign In</button>
        </form>

        <div class="demo-card">
            <strong>Demo Credentials</strong>
            <div class="demo-row"><span>🛡️ Admin</span><span>admin@hms.com / admin123</span></div>
            <div class="demo-row"><span>👨‍⚕️ Doctor</span><span>sarah@hms.com / admin123</span></div>
            <div class="demo-row"><span>🧑 Patient</span><span>john@hms.com / admin123</span></div>
        </div>

        <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b">
            Don't have an account? <a href="/HospitalManagement/register.jsp" style="color:#2b7cff;font-weight:600">Register here</a>
        </p>
    </div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
