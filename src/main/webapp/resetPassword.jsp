<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Reset Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a,#2b7cff 60%,#06b6d4);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:420px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(25,179,122,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s;margin-bottom:16px}
.form-control:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-submit{width:100%;background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s}
.btn-submit:hover{opacity:.92;transform:translateY(-1px)}
</style>
</head><body>
<jsp:include page="/header.jsp" />
<div class="wrap">
<div class="card">
    <div class="card-icon"><i class="fa fa-lock-open"></i></div>
    <h2>Set New Password</h2>
    <p class="sub">Choose a strong password for your account.</p>
    <form action="/HospitalManagement/resetPassword" method="post">
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="role"  value="${role}">
        <label class="form-label">New Password *</label>
        <input type="password" name="newPassword" class="form-control" placeholder="Min 6 characters" required minlength="6">
        <label class="form-label">Confirm Password *</label>
        <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required minlength="6">
        <button type="submit" class="btn-submit"><i class="fa fa-check me-2"></i>Reset Password</button>
    </form>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
