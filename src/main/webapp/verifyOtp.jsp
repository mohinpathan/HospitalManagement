<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Verify OTP - HealthCare Connect</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a 0%,#2b7cff 60%,#06b6d4 100%);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:440px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#7c3aed,#6d28d9);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(124,58,237,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.otp-sent-banner{background:linear-gradient(135deg,#d1fae5,#a7f3d0);border:1px solid #6ee7b7;border-radius:12px;padding:14px 18px;margin-bottom:20px;display:flex;align-items:center;gap:10px}
.otp-sent-banner i{color:#065f46;font-size:18px;flex-shrink:0}
.otp-sent-banner p{color:#065f46;font-size:13px;font-weight:600;margin:0}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:8px;display:block;text-align:center}
.otp-input{background:#f8fafc;border:2px solid #e5e7eb;border-radius:12px;padding:16px 14px;font-size:32px;font-weight:800;width:100%;outline:none;transition:border-color .2s,box-shadow .2s;text-align:center;letter-spacing:12px;font-family:monospace;color:#0f172a}
.otp-input:focus{border-color:#7c3aed;box-shadow:0 0 0 3px rgba(124,58,237,.12)}
.btn-submit{width:100%;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:20px;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-submit:hover{opacity:.92;transform:translateY(-1px)}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
.timer-box{text-align:center;margin-top:14px;font-size:13px;color:#64748b}
.timer-box span{color:#7c3aed;font-weight:700}
</style>
<script>
let seconds = 600;
function tick() {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    const el = document.getElementById('timer');
    if (el) el.textContent = m + ':' + (s < 10 ? '0' : '') + s;
    if (seconds > 0) { seconds--; setTimeout(tick, 1000); }
    else { if(el) el.parentElement.innerHTML = '<span style="color:#ef4444;font-weight:600">OTP expired. <a href="/HospitalManagement/forgetpass.jsp" style="color:#ef4444">Request a new one</a></span>'; }
}
window.onload = tick;
</script>
</head><body>
<jsp:include page="/header.jsp" />
<div class="wrap">
<div class="card">
    <div class="card-icon"><i class="fa fa-shield-halved"></i></div>
    <h2>Verify OTP</h2>
    <p class="sub">Enter the 6-digit code sent to your email.</p>

    <%-- Show the email from session --%>
    <% String otpEmail = (String) session.getAttribute("otpEmail"); %>
    <% if (otpEmail != null) { %>
    <div class="otp-sent-banner">
        <i class="fa fa-envelope-circle-check"></i>
        <p>OTP sent to <strong><%=otpEmail%></strong>. Check your inbox!</p>
    </div>
    <% } %>

    <% if(request.getAttribute("error") != null){ %>
    <div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div>
    <% } %>

    <form action="/HospitalManagement/verifyOtp" method="post">
        <%-- No hidden email/role needed — controller reads from session --%>
        <label class="form-label">Enter OTP Code</label>
        <input type="text" name="otp" class="otp-input"
               placeholder="000000" maxlength="6" required
               autocomplete="one-time-code" inputmode="numeric">

        <div class="timer-box">OTP expires in: <span id="timer">10:00</span></div>

        <button type="submit" class="btn-submit">
            <i class="fa fa-check-circle"></i> Verify OTP
        </button>
    </form>

    <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b">
        Didn't receive it?
        <a href="/HospitalManagement/forgetpass.jsp" style="color:#7c3aed;font-weight:600">Resend OTP</a>
        &nbsp;|&nbsp;
        <a href="/HospitalManagement/login.jsp" style="color:#64748b;font-weight:600">← Back to Login</a>
    </p>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
