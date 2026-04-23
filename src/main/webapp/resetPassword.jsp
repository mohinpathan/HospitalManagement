<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<!DOCTYPE html><html lang="<%=hi?"hi":"en"%>"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"नया पासवर्ड सेट करें","Reset Password")%> - HealthCare Connect</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#1e3a8a 0%,#2b7cff 60%,#06b6d4 100%);min-height:100vh;display:flex;flex-direction:column}
a{text-decoration:none}
.wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.card{background:#fff;border-radius:22px;padding:40px 38px;width:100%;max-width:440px;box-shadow:0 24px 64px rgba(0,0,0,.18)}
.card-icon{width:68px;height:68px;background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 20px;box-shadow:0 8px 20px rgba(25,179,122,.35)}
h2{text-align:center;font-size:24px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sub{text-align:center;color:#64748b;font-size:14px;margin-bottom:24px}
.verified-badge{background:linear-gradient(135deg,#d1fae5,#a7f3d0);border:1px solid #6ee7b7;border-radius:12px;padding:12px 16px;margin-bottom:20px;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:600;color:#065f46}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.input-group{display:flex;align-items:stretch;margin-bottom:16px}
.ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 14px;display:flex;align-items:center;color:#64748b}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:0 10px 10px 0;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s}
.form-control:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.strength-bar{height:5px;border-radius:4px;background:#e5e7eb;margin-top:6px;overflow:hidden}
.strength-fill{height:100%;border-radius:4px;transition:width .3s,background .3s;width:0}
.strength-text{font-size:11px;color:#64748b;margin-top:4px;height:14px}
.btn-submit{width:100%;background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:12px;padding:13px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:8px;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-submit:hover{opacity:.92;transform:translateY(-1px)}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
</style>
<script>
function checkStrength(val) {
    const fill = document.getElementById('strengthFill');
    const text = document.getElementById('strengthText');
    let score = 0;
    if (val.length >= 6) score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    const levels = [{w:'0%',c:'#e5e7eb',t:''},{w:'25%',c:'#ef4444',t:'<%=L(hi,"कमज़ोर","Weak")%>'},{w:'50%',c:'#f59e0b',t:'<%=L(hi,"ठीक","Fair")%>'},{w:'75%',c:'#2b7cff',t:'<%=L(hi,"अच्छा","Good")%>'},{w:'100%',c:'#19b37a',t:'<%=L(hi,"मज़बूत","Strong")%>'}];
    const l = levels[Math.min(score, 4)];
    fill.style.width = l.w; fill.style.background = l.c;
    text.textContent = l.t ? '<%=L(hi,"मज़बूती:","Strength:")%> ' + l.t : '';
}
function checkMatch() {
    const np = document.getElementById('newPass').value;
    const cp = document.getElementById('confirmPass').value;
    const hint = document.getElementById('matchHint');
    if (cp.length === 0) { hint.textContent = ''; return; }
    if (np === cp) { hint.style.color='#19b37a'; hint.textContent='✓ <%=L(hi,"पासवर्ड मेल खाते हैं","Passwords match")%>'; }
    else           { hint.style.color='#ef4444'; hint.textContent='✗ <%=L(hi,"पासवर्ड मेल नहीं खाते","Passwords do not match")%>'; }
}
</script>
</head><body>
<jsp:include page="/header.jsp" />
<div class="wrap">
<div class="card">
    <%
        String otpEmail    = (String)  session.getAttribute("otpEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        if (otpEmail == null || !Boolean.TRUE.equals(otpVerified)) {
            response.sendRedirect("/HospitalManagement/forgetpass.jsp");
            return;
        }
    %>
    <div class="card-icon"><i class="fa fa-lock-open"></i></div>
    <h2><%=L(hi,"नया पासवर्ड सेट करें","Set New Password")%></h2>
    <p class="sub"><%=L(hi,"OTP सत्यापित हो गया। एक मज़बूत नया पासवर्ड चुनें।","OTP verified. Choose a strong new password.")%></p>
    <div class="verified-badge">
        <i class="fa fa-circle-check" style="font-size:16px"></i>
        <%=L(hi,"पहचान सत्यापित:","Identity verified for")%> <strong><%=otpEmail%></strong>
    </div>
    <% if(request.getAttribute("error") != null){ %>
    <div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div>
    <% } %>
    <form action="/HospitalManagement/resetPassword" method="post">
        <div style="margin-bottom:4px">
            <label class="form-label"><%=L(hi,"नया पासवर्ड *","New Password *")%></label>
            <div class="input-group">
                <span class="ig-icon"><i class="fa fa-lock"></i></span>
                <input type="password" name="newPassword" id="newPass" class="form-control" placeholder="<%=L(hi,"कम से कम 6 अक्षर","Min 6 characters")%>" required minlength="6" oninput="checkStrength(this.value); checkMatch()">
            </div>
            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
            <div class="strength-text" id="strengthText"></div>
        </div>
        <div style="margin-top:16px;margin-bottom:4px">
            <label class="form-label"><%=L(hi,"पासवर्ड की पुष्टि करें *","Confirm Password *")%></label>
            <div class="input-group">
                <span class="ig-icon"><i class="fa fa-key"></i></span>
                <input type="password" name="confirmPassword" id="confirmPass" class="form-control" placeholder="<%=L(hi,"पासवर्ड दोहराएं","Repeat your password")%>" required minlength="6" oninput="checkMatch()">
            </div>
            <div class="strength-text" id="matchHint"></div>
        </div>
        <button type="submit" class="btn-submit"><i class="fa fa-shield-halved"></i> <%=L(hi,"पासवर्ड रीसेट करें","Reset Password")%></button>
    </form>
    <p style="text-align:center;margin-top:20px;font-size:14px;color:#64748b">
        <a href="/HospitalManagement/login.jsp" style="color:#19b37a;font-weight:600">← <%=L(hi,"लॉगिन पर वापस जाएं","Back to Login")%></a>
    </p>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
