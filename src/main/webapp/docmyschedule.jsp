<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Schedule</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.form-card{background:#fff;border-radius:16px;padding:24px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:24px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.form-control:focus,.form-select:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-save{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-save:hover{opacity:.9;transform:translateY(-1px)}
.schedule-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px}
.sched-card{background:#fff;border-radius:14px;padding:18px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;position:relative}
.sched-card .day{font-size:15px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sched-card .time{font-size:13px;color:#19b37a;font-weight:600}
.btn-del{position:absolute;top:12px;right:12px;background:#fee2e2;color:#991b1b;border:none;padding:5px 10px;border-radius:8px;font-size:12px;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px}
.btn-del:hover{background:#fecaca;color:#991b1b}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-clock me-2" style="color:#19b37a"></i>My Schedule</h2>
        <p>Set your available days and times for patient appointments.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <!-- Add Schedule Form -->
    <div class="form-card">
        <h5 style="font-weight:700;color:#0f172a;margin-bottom:16px">Add Availability</h5>
        <form action="/HospitalManagement/doctor/schedule/save" method="post">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Day of Week *</label>
                    <select name="dayOfWeek" class="form-select" required>
                        <option value="">Select Day</option>
                        <% String[] days={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};
                           for(String d:days){ %><option><%=d%></option><% } %>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Start Time *</label>
                    <input type="time" name="startTime" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">End Time *</label>
                    <input type="time" name="endTime" class="form-control" required>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn-save w-100"><i class="fa fa-plus"></i> Add</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Current Schedule -->
    <h5 style="font-weight:700;color:#0f172a;margin-bottom:14px">Current Schedule</h5>
    <%
        List<Map<String,Object>> schedules=(List<Map<String,Object>>)request.getAttribute("schedules");
        if(schedules==null||schedules.isEmpty()){
    %>
    <div style="background:#fff;border-radius:14px;padding:40px;text-align:center;color:#94a3b8;box-shadow:0 2px 12px rgba(0,0,0,.06)">
        <i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0;display:block"></i>
        No schedule set yet. Add your availability above.
    </div>
    <%}else{%>
    <div class="schedule-grid">
    <%for(Map<String,Object> sc:schedules){%>
    <div class="sched-card">
        <a href="/HospitalManagement/doctor/schedule/delete/<%=sc.get("id")%>" class="btn-del" onclick="return confirm('Remove this slot?')"><i class="fa fa-trash"></i></a>
        <div class="day"><i class="fa fa-calendar-day me-2" style="color:#19b37a"></i><%=sc.get("day_of_week")%></div>
        <div class="time"><i class="fa fa-clock me-1"></i><%=sc.get("start_time")%> – <%=sc.get("end_time")%></div>
    </div>
    <%}%>
    </div>
    <%}%>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
