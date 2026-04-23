<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Feedback Messages</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.fb-card{background:#fff;border-radius:14px;padding:20px 22px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:16px;position:relative}
.fb-card .fb-name{font-weight:700;font-size:15px;color:#0f172a;margin-bottom:2px}
.fb-card .fb-email{font-size:12px;color:#64748b;margin-bottom:8px}
.fb-card .fb-subject{font-weight:600;font-size:14px;color:#2b7cff;margin-bottom:6px}
.fb-card .fb-msg{font-size:14px;color:#374151;line-height:1.6}
.fb-card .fb-time{font-size:11px;color:#94a3b8;margin-top:8px}
.btn-del{position:absolute;top:16px;right:16px;background:#fee2e2;color:#991b1b;border:none;padding:6px 12px;border-radius:8px;font-size:12px;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px}
.btn-del:hover{background:#fecaca;color:#991b1b}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8;background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(0,0,0,.06)}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-comments me-2" style="color:#2b7cff"></i><%=L(hi,"फ़ीडबैक और संदेश","Feedback & Messages")%></h2>
        <p>Messages received from patients and visitors.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <%
        List<Map<String,Object>> feedbacks=(List<Map<String,Object>>)request.getAttribute("feedbacks");
        if(feedbacks==null||feedbacks.isEmpty()){
    %>
    <div class="empty-state">
        <i class="fa fa-inbox fa-2x mb-3" style="color:#e2e8f0;display:block"></i>
        <h4 style="font-size:18px;font-weight:700;color:#374151;margin-bottom:8px">No messages yet</h4>
        <p>Feedback from patients will appear here.</p>
    </div>
    <%}else{for(Map<String,Object> fb:feedbacks){%>
    <div class="fb-card">
        <a href="/HospitalManagement/admin/feedback/delete/<%=fb.get("id")%>" class="btn-del" onclick="return confirm('<%=L(hi,"हटाएं","Delete")%> this message?')"><i class="fa fa-trash"></i></a>
        <div class="fb-name"><%=fb.get("name")!=null?fb.get("name"):"Anonymous"%></div>
        <div class="fb-email"><i class="fa fa-envelope fa-xs me-1"></i><%=fb.get("email")!=null?fb.get("email"):"—"%></div>
        <div class="fb-subject"><%=fb.get("subject")!=null?fb.get("subject"):"No Subject"%></div>
        <div class="fb-msg"><%=fb.get("message")%></div>
        <div class="fb-time"><i class="fa fa-clock fa-xs me-1"></i><%=fb.get("submitted_at")%></div>
    </div>
    <%}}%>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
