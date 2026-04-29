<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Patient History</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 18px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
/* Patient hero */
.patient-hero{background:linear-gradient(135deg,#7c3aed,#8b5cf6);border-radius:18px;padding:24px 28px;color:#fff;margin-bottom:24px;display:flex;align-items:center;gap:18px;flex-wrap:wrap}
.pat-avatar{width:64px;height:64px;border-radius:18px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:28px;flex-shrink:0;overflow:hidden}
.pat-avatar img{width:100%;height:100%;object-fit:cover}
.pat-name{font-size:20px;font-weight:800;margin-bottom:4px}
.pat-meta{font-size:13px;opacity:.85}
.info-chips{display:flex;gap:10px;flex-wrap:wrap;margin-top:8px}
.info-chip{background:rgba(255,255,255,.2);border-radius:20px;padding:4px 12px;font-size:12px;font-weight:600}
/* Stats */
.mini-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:24px}
.mini-stat{background:#fff;border-radius:14px;padding:16px;text-align:center;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5}
.mini-stat .ms-val{font-size:26px;font-weight:900;color:#0f172a}
.mini-stat .ms-label{font-size:11px;color:#64748b;font-weight:600;text-transform:uppercase;letter-spacing:.5px;margin-top:3px}
/* Panel */
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.ph{padding:15px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.ph span{font-size:12px;color:#64748b;font-weight:500}
.panel-empty{padding:32px 20px;text-align:center;color:#94a3b8;font-size:14px}
/* Table */
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:12px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:12px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
/* Badges */
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved,.badge-confirmed,.badge-active,.badge-paid{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled,.badge-inactive{background:#fee2e2;color:#991b1b}
/* Report items */
.report-item{padding:12px 16px;border-bottom:1px solid #f8fafc;display:flex;align-items:center;gap:12px}
.report-item:last-child{border-bottom:none}
.report-icon{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.ri-xray{background:#dbeafe;color:#2b7cff}
.ri-lab{background:#d1fae5;color:#065f46}
.ri-prescription{background:#ede9fe;color:#7c3aed}
.ri-other{background:#fef3c7;color:#92400e}
@media(max-width:1200px){.mini-stats{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.dash-main{padding:16px}.mini-stats{grid-template-columns:1fr 1fr}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-file-medical me-2" style="color:#7c3aed"></i>Patient Full History</h2>
            <p>Complete medical history, appointments and reports.</p>
        </div>
        <a href="/HospitalManagement/admin/patients" class="btn-back"><i class="fa fa-arrow-left"></i> Back to Patients</a>
    </div>

    <%
        Patient p = (Patient) request.getAttribute("patient");
        List<?> appts = (List<?>) request.getAttribute("appointments");
        List<?> bills  = (List<?>) request.getAttribute("bills");
        List<Map<String,Object>> reports = (List<Map<String,Object>>) request.getAttribute("reports");

        int apptCount = appts != null ? appts.size() : 0;
        int billCount = bills != null ? bills.size() : 0;
        int reportCount = reports != null ? reports.size() : 0;
        int completedCount = 0;
        if(appts != null) for(Object o : appts) { if("completed".equals(((Appointment)o).getStatus())) completedCount++; }
    %>

    <!-- Patient Hero -->
    <div class="patient-hero">
        <div class="pat-avatar">
            <% if(p.getPhoto()!=null&&!p.getPhoto().isEmpty()){ %><img src="<%=p.getPhoto()%>" alt="Photo"><% }else{ %><i class="fa fa-user"></i><% } %>
        </div>
        <div>
            <div class="pat-name"><%=p.getFullName()%></div>
            <div class="pat-meta"><%=p.getEmail()%></div>
            <div class="info-chips">
                <% if(p.getPhone()!=null){ %><span class="info-chip"><i class="fa fa-phone me-1"></i><%=p.getPhone()%></span><% } %>
                <% if(p.getGender()!=null){ %><span class="info-chip"><i class="fa fa-venus-mars me-1"></i><%=p.getGender()%></span><% } %>
                <% if(p.getAge()>0){ %><span class="info-chip"><i class="fa fa-calendar me-1"></i>Age <%=p.getAge()%></span><% } %>
                <% if(p.getBloodGroup()!=null){ %><span class="info-chip" style="background:#fee2e2;color:#991b1b"><i class="fa fa-tint me-1"></i><%=p.getBloodGroup()%></span><% } %>
                <span class="info-chip" style="background:#d1fae5;color:#065f46"><%=p.getStatus().toUpperCase()%></span>
            </div>
        </div>
    </div>

    <!-- Mini Stats -->
    <div class="mini-stats">
        <div class="mini-stat"><div class="ms-val"><%=apptCount%></div><div class="ms-label">Appointments</div></div>
        <div class="mini-stat"><div class="ms-val"><%=completedCount%></div><div class="ms-label">Completed</div></div>
        <div class="mini-stat"><div class="ms-val"><%=billCount%></div><div class="ms-label">Bills</div></div>
        <div class="mini-stat"><div class="ms-val"><%=reportCount%></div><div class="ms-label">Reports</div></div>
    </div>

    <!-- Appointment History -->
    <div class="panel">
        <div class="ph"><span><i class="fa fa-calendar-check me-2" style="color:#2b7cff"></i>Appointment History</span><span><%=apptCount%> total</span></div>
        <% if(appts==null||appts.isEmpty()){ %>
        <div class="panel-empty">No appointments found.</div>
        <% }else{ %>
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th>Doctor</th><th>Department</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th></tr></thead>
            <tbody>
            <% int idx=1; for(Object obj:appts){ Appointment a=(Appointment)obj; %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td><strong><%=a.getDoctorName()%></strong></td>
                <td><span style="background:#ede9fe;color:#6d28d9;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700"><%=a.getDepartmentName()!=null?a.getDepartmentName():"—"%></span></td>
                <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                <td style="font-size:13px;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                <td><span class="badge badge-<%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>
        <% } %>
    </div>

    <!-- Bills & Prescriptions -->
    <div class="panel">
        <div class="ph"><span><i class="fa fa-file-invoice-dollar me-2" style="color:#f59e0b"></i>Bills & Prescriptions</span><span><%=billCount%> total</span></div>
        <% if(bills==null||bills.isEmpty()){ %>
        <div class="panel-empty">No bills found.</div>
        <% }else{ %>
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th>Doctor</th><th>Diagnosis</th><th>Medicines</th><th>Total</th><th>Status</th><th>PDF</th></tr></thead>
            <tbody>
            <% int bidx=1; for(Object obj:bills){ Bill b=(Bill)obj; %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=bidx++%></td>
                <td><strong><%=b.getDoctorName()%></strong></td>
                <td style="font-size:13px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=b.getDiagnosis()!=null?b.getDiagnosis():"—"%></td>
                <td style="font-size:12px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#64748b"><%=b.getMedicines()!=null?b.getMedicines():"—"%></td>
                <td style="font-weight:800;color:#0f172a">₹<%=String.format("%.0f",b.getTotalAmount())%></td>
                <td><span class="badge badge-<%=b.getPaymentStatus()%>"><%=b.getPaymentStatus().toUpperCase()%></span></td>
                <td><a href="/HospitalManagement/admin/bill/pdf/<%=b.getId()%>" target="_blank" style="color:#2b7cff;font-size:13px"><i class="fa fa-file-pdf"></i></a></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        </div>
        <% } %>
    </div>

    <!-- Medical Reports -->
    <div class="panel">
        <div class="ph"><span><i class="fa fa-file-medical me-2" style="color:#7c3aed"></i>Medical Reports & X-Rays</span><span><%=reportCount%> total</span></div>
        <% if(reports==null||reports.isEmpty()){ %>
        <div class="panel-empty">No reports uploaded yet.</div>
        <% }else{ for(Map<String,Object> r:reports){
            String rt=(String)r.get("report_type");
            String iconClass="xray".equals(rt)?"ri-xray":"lab".equals(rt)?"ri-lab":"prescription".equals(rt)?"ri-prescription":"ri-other";
            String icon="xray".equals(rt)?"fa-x-ray":"lab".equals(rt)?"fa-flask":"prescription".equals(rt)?"fa-file-prescription":"fa-file-medical";
        %>
        <div class="report-item">
            <div class="report-icon <%=iconClass%>"><i class="fa <%=icon%>"></i></div>
            <div style="flex:1">
                <div style="font-weight:600;font-size:14px;color:#0f172a;text-transform:capitalize"><%=rt%></div>
                <div style="font-size:12px;color:#64748b">By: <%=r.get("doctor_name")%></div>
                <div style="font-size:12px;color:#374151;margin-top:2px"><%=r.get("description")!=null?r.get("description"):""%></div>
                <div style="font-size:11px;color:#94a3b8;margin-top:2px"><%=r.get("created_at")%></div>
            </div>
            <a href="<%=r.get("file_path")%>" target="_blank" style="color:#2b7cff;font-size:13px;font-weight:600;text-decoration:none"><i class="fa fa-download me-1"></i>Download</a>
        </div>
        <% }} %>
    </div>

</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
