<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Doctor Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:28px 32px;overflow-y:auto}
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:24px}
.stat-card{background:#fff;border-radius:16px;padding:22px 20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:transform .2s}
.stat-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.1)}
.stat-card .sc-label{font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase}
.stat-card .sc-value{font-size:34px;font-weight:900;color:#0f172a;margin-top:4px;line-height:1}
.stat-card .sc-icon{width:54px;height:54px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:22px;color:#fff;flex-shrink:0}
.ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)} .ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)} .ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)} .ic-gray{background:linear-gradient(135deg,#64748b,#475569)}
.panel-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.panel-card .ph{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-card .ph a{color:#19b37a;font-size:13px;font-weight:500}
.panel-card .p-empty{padding:40px 20px;text-align:center;color:#94a3b8;font-size:14px}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:12px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:13px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
.bs-approved{background:#d1fae5;color:#065f46;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-pending{background:#fef3c7;color:#92400e;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-completed{background:#dbeafe;color:#1e40af;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.btn-prescribe{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;padding:7px 14px;border-radius:9px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:all .2s}
.btn-prescribe:hover{opacity:.9;color:#fff}
.page-hdr{margin-bottom:24px}
.page-hdr h2{font-size:24px;font-weight:900;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.dash-main{padding:16px}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2>Welcome, <%= session.getAttribute("doctorName")!=null?session.getAttribute("doctorName"):"Doctor" %> 👋</h2>
        <p><%= session.getAttribute("doctorDept")!=null?session.getAttribute("doctorDept"):"Department" %></p>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card"><div><div class="sc-label">Total Appointments</div><div class="sc-value">${totalAppts}</div></div><div class="sc-icon ic-blue"><i class="fa fa-calendar"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Today</div><div class="sc-value">${todayAppts}</div></div><div class="sc-icon ic-green"><i class="fa fa-clock"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Pending</div><div class="sc-value">${pendingAppts}</div></div><div class="sc-icon ic-orange"><i class="fa fa-hourglass-half"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Completed</div><div class="sc-value">${completedAppts}</div></div><div class="sc-icon ic-gray"><i class="fa fa-circle-check"></i></div></div>
    </div>

    <!-- Appointments Table -->
    <div class="panel-card">
        <div class="ph">Today's & Upcoming Appointments <a href="/HospitalManagement/doctor/appointments">View All →</a></div>
        <%
            List<?> appts=(List<?>)request.getAttribute("appointments");
            if(appts==null||appts.isEmpty()){
        %><div class="p-empty"><i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0"></i><br>No appointments scheduled.</div><%
        }else{%>
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th>Patient</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <%int idx=1;for(Object obj:appts){Appointment a=(Appointment)obj;String st=a.getStatus();String cls="approved".equals(st)?"bs-approved":"completed".equals(st)?"bs-completed":"bs-pending";%>
            <tr>
                <td style="color:#94a3b8;font-size:13px"><%=idx++%></td>
                <td><strong><%=a.getPatientName()%></strong></td>
                <td><%=a.getAppointmentDate()%></td>
                <td><%=a.getAppointmentTime()%></td>
                <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                <td><span class="<%=cls%>"><%=st.toUpperCase()%></span></td>
                <td><%if("approved".equals(st)){%><a href="/HospitalManagement/doctor/prescription/<%=a.getId()%>" class="btn-prescribe"><i class="fa fa-file-prescription"></i> Prescribe</a><%}else{%><span style="color:#94a3b8;font-size:12px">—</span><%}%></td>
            </tr>
            <%}%>
            </tbody>
        </table>
        </div>
        <%}%>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
