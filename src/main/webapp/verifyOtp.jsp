<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Verify OTP</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a,#2b7cff 60%,#06b6d4);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:420px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#7c3aed,#6d28d9);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(124,58,237,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s;text-align:center;letter-spacing:6px;font-size:22px;font-weight:700}
.form-control:focus{border-color:#7c3aed;box-shadow:0 0 0 3px rgba(124,58,237,.1)}
.btn-submit{width:100%;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:20px}
.btn-submit:hover{opacity:.92;transform:translateY(-1px)}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
</style>
</head><body>
<jsp:include page="/header.jsp" />
<div class="wrap">
<div class="card">
    <div class="card-icon"><i class="fa fa-shield-halved"></i></div>
    <h2>Enter OTP</h2>
    <p class="sub">We sent a 6-digit OTP to your email. Enter it below.</p>
    <% if(request.getAttribute("error")!=null){ %><div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div><% } %>
    <form action="/HospitalManagement/verifyOtp" method="post">
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="role"  value="${role}">
        <label class="form-label" style="text-align:center;display:block">OTP Code</label>
        <input type="text" name="otp" class="form-control" placeholder="000000" maxlength="6" required>
        <button type="submit" class="btn-submit"><i class="fa fa-check me-2"></i>Verify OTP</button>
    </form>
    <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b">
        Didn't receive it? <a href="/HospitalManagement/forgetpass.jsp" style="color:#7c3aed;font-weight:600">Resend OTP</a>
    </p>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
