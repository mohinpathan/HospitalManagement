<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Forgot Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a,#2b7cff 60%,#06b6d4);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:440px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(43,124,255,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.form-control:focus,.form-select:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.1)}
.input-group{display:flex;align-items:stretch;margin-bottom:20px}
.ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 14px;display:flex;align-items:center;color:#64748b}
.input-group .form-control{border-radius:0 10px 10px 0}
.btn-submit{width:100%;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s}
.btn-submit:hover{opacity:.92;transform:translateY(-1px)}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
.success-icon{width:80px;height:80px;background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:36px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(25,179,122,.35)}
</style>
</head><body>
<jsp:include page="/header.jsp" />
<div class="wrap">
<div class="card">
<% String sent=request.getParameter("sent"); String email=request.getParameter("email");
   if(sent==null){ %>
    <div class="card-icon"><i class="fa fa-key"></i></div>
    <h2>Forgot Password?</h2>
    <p class="sub">Enter your email and role. We'll send you an OTP to reset your password.</p>
    <% if(request.getAttribute("error")!=null){ %><div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div><% } %>
    <form action="/HospitalManagement/forgotPassword" method="post">
        <div style="margin-bottom:16px">
            <label class="form-label">Login Role *</label>
            <select name="role" class="form-select" required>
                <option value="">Select Role</option>
                <option value="patient">🧑 Patient</option>
                <option value="doctor">👨‍⚕️ Doctor</option>
                <option value="admin">🛡️ Admin</option>
            </select>
        </div>
        <label class="form-label">Email Address *</label>
        <div class="input-group">
            <span class="ig-icon"><i class="fa fa-envelope"></i></span>
            <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
        </div>
        <button type="submit" class="btn-submit"><i class="fa fa-paper-plane me-2"></i>Send OTP</button>
    </form>
<% }else{ %>
    <div class="success-icon"><i class="fa fa-check"></i></div>
    <h2>Check Your Email</h2>
    <p class="sub">We've sent a 6-digit OTP to <strong><%=email%></strong>. Please check your inbox.</p>
    <a href="/HospitalManagement/verifyOtp.jsp" class="btn-submit" style="display:block;text-align:center;margin-top:16px"><i class="fa fa-shield-halved me-2"></i>Enter OTP</a>
<% } %>
    <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b"><a href="/HospitalManagement/login.jsp" style="color:#2b7cff;font-weight:600">← Back to Login</a></p>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
