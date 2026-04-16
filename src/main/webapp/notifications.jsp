<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    String header  = "patient".equals(role) ? "/patientheader.jsp" : "doctor".equals(role) ? "/doctorheader.jsp" : "/adminheader.jsp";
    String sidebar = "patient".equals(role) ? "/patientsidebar.jsp" : "doctor".equals(role) ? "/doctorsidebar.jsp" : "/adminsidebar.jsp";
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Notifications</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.notif-card{background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;overflow:hidden}
.notif-item{padding:16px 20px;border-bottom:1px solid #f8fafc;display:flex;align-items:flex-start;gap:14px;transition:background .2s}
.notif-item:last-child{border-bottom:none}
.notif-item:hover{background:#fafbff}
.notif-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.ic-info{background:#dbeafe;color:#2b7cff}
.ic-success{background:#d1fae5;color:#065f46}
.ic-warning{background:#fef3c7;color:#92400e}
.notif-title{font-weight:700;font-size:14px;color:#0f172a;margin-bottom:3px}
.notif-msg{font-size:13px;color:#374151;line-height:1.5}
.notif-time{font-size:11px;color:#94a3b8;margin-top:4px}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:16px;color:#e2e8f0;display:block}
</style>
</head><body>
<jsp:include page="<%=header%>" />
<div class="dash-body">
<jsp:include page="<%=sidebar%>" />
<div class="dash-main">
    <div class="page-hdr">
        <h2><i class="fa fa-bell me-2" style="color:#f59e0b"></i>Notifications</h2>
        <p>All your recent notifications.</p>
    </div>
    <%
        List<Map<String,Object>> notifs = (List<Map<String,Object>>) request.getAttribute("notifications");
        if(notifs==null||notifs.isEmpty()){
    %>
    <div class="notif-card">
        <div class="empty-state">
            <i class="fa fa-bell-slash"></i>
            <h4 style="font-size:18px;font-weight:700;color:#374151;margin-bottom:8px">No notifications</h4>
            <p>You're all caught up!</p>
        </div>
    </div>
    <%}else{%>
    <div class="notif-card">
    <%for(Map<String,Object> n:notifs){
        String type=(String)n.get("type");
        String iconClass="info".equals(type)?"ic-info":"success".equals(type)?"ic-success":"ic-warning";
        String icon="info".equals(type)?"fa-info-circle":"success".equals(type)?"fa-check-circle":"fa-exclamation-triangle";
    %>
    <div class="notif-item">
        <div class="notif-icon <%=iconClass%>"><i class="fa <%=icon%>"></i></div>
        <div style="flex:1">
            <div class="notif-title"><%=n.get("title")%></div>
            <div class="notif-msg"><%=n.get("message")%></div>
            <div class="notif-time"><i class="fa fa-clock fa-xs me-1"></i><%=n.get("created_at")%></div>
        </div>
    </div>
    <%}%>
    </div>
    <%}%>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
