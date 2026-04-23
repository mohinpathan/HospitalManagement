<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Appointments</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.table-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase;padding:13px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:14px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#f0fdf4}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected{background:#fee2e2;color:#991b1b}
.badge-cancelled{background:#f1f5f9;color:#475569}
.btn-prescribe{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;padding:7px 14px;border-radius:9px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:all .2s}
.btn-prescribe:hover{opacity:.9;color:#fff}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:16px;color:#e2e8f0;display:block}
.empty-state h4{font-size:18px;font-weight:700;color:#374151;margin-bottom:8px}
@media(max-width:768px){.dash-main{padding:16px}.tbl{font-size:12px}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-calendar-check me-2" style="color:#19b37a"></i>My Appointments</h2>
        <p>Manage your scheduled appointments and write prescriptions.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <%
        List<?> appts=(List<?>)request.getAttribute("appointments");
        if(appts==null||appts.isEmpty()){
    %>
    <div class="table-card">
        <div class="empty-state">
            <i class="fa fa-calendar-xmark"></i>
            <h4>No appointments found</h4>
            <p>Your appointments will appear here once patients book with you.</p>
        </div>
    </div>
    <% }else{ %>
    <div class="table-card">
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th>Patient</th><th>Department</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% int idx=1; for(Object obj:appts){ Appointment a=(Appointment)obj; String st=a.getStatus(); %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td><strong style="color:#0f172a"><%=a.getPatientName()%></strong></td>
                <td><span style="background:#d1fae5;color:#065f46;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700"><%=a.getDepartmentName()!=null?a.getDepartmentName():"—"%></span></td>
                <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                <td><span class="badge badge-<%=st%>"><%=st.toUpperCase()%></span></td>
                <td>
                    <% if("approved".equals(st)){ %>
                    <a href="/HospitalManagement/doctor/prescription/<%=a.getId()%>" class="btn-prescribe"><i class="fa fa-file-prescription"></i> Write Prescription</a>
                    <% }else{ %><span style="color:#94a3b8;font-size:12px">—</span><% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>
    </div>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
