<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:28px 32px;overflow-y:auto}
/* stat cards */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:24px}
.stat-card{background:#fff;border-radius:16px;padding:22px 20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:transform .2s}
.stat-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.1)}
.stat-card .sc-label{font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase}
.stat-card .sc-value{font-size:34px;font-weight:900;color:#0f172a;margin-top:4px;line-height:1}
.stat-card .sc-icon{width:54px;height:54px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:22px;color:#fff;flex-shrink:0}
.ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)} .ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)} .ic-purple{background:linear-gradient(135deg,#7c3aed,#6d28d9)} .ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)}
/* quick links */
.quick-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.quick-card{background:#fff;border-radius:16px;padding:22px 16px;text-align:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;text-decoration:none;color:#0f172a;transition:all .2s;display:block}
.quick-card:hover{transform:translateY(-4px);box-shadow:0 10px 28px rgba(0,0,0,.12);color:#0f172a}
.quick-card .qc-icon{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;color:#fff;margin:0 auto 12px}
.quick-card h6{font-size:13px;font-weight:700;margin:0;color:#374151}
/* panels */
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px}
.panel-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.panel-card .ph{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-card .ph a{color:#2b7cff;font-size:13px;font-weight:500}
.panel-card .p-empty{padding:36px 20px;text-align:center;color:#94a3b8;font-size:14px}
/* pending */
.pend-row{padding:14px 20px;border-bottom:1px solid #f8fafc}
.pend-row:last-child{border-bottom:none}
.pend-name{font-weight:600;font-size:14px;color:#0f172a;margin-bottom:3px}
.pend-meta{font-size:12px;color:#64748b;margin-bottom:8px}
.pend-actions{display:flex;gap:8px}
.btn-approve{background:#d1fae5;color:#065f46;border:none;padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;transition:all .2s}
.btn-approve:hover{background:#a7f3d0}
.btn-reject{background:#fee2e2;color:#991b1b;border:none;padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;transition:all .2s}
.btn-reject:hover{background:#fecaca}
/* dept grid */
.dept-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;padding:16px}
.dept-tile{background:#f8fafc;border-radius:10px;padding:14px;text-align:center;border:1px solid #e8edf5}
.dept-tile h5{font-size:13px;font-weight:700;color:#0f172a;margin-bottom:4px}
.dept-tile p{font-size:12px;color:#64748b;margin:0}
/* badge */
.badge-pending{background:#fef3c7;color:#92400e;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700}
/* page header */
.page-hdr{margin-bottom:24px}
.page-hdr h2{font-size:24px;font-weight:900;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
@media(max-width:1200px){.stats-grid,.quick-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.two-col{grid-template-columns:1fr}.dash-main{padding:16px}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2>🏥 Admin Dashboard</h2>
        <p>Welcome back, <strong><%= session.getAttribute("adminName")!=null?session.getAttribute("adminName"):"Admin" %></strong>. Here's today's overview.</p>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
        <div class="stat-card"><div><div class="sc-label">Total Doctors</div><div class="sc-value">${totalDoctors}</div></div><div class="sc-icon ic-blue"><i class="fa fa-user-md"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Total Patients</div><div class="sc-value">${totalPatients}</div></div><div class="sc-icon ic-green"><i class="fa fa-users"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Appointments</div><div class="sc-value">${totalAppointments}</div></div><div class="sc-icon ic-purple"><i class="fa fa-calendar-check"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Departments</div><div class="sc-value">${totalDepts}</div></div><div class="sc-icon ic-orange"><i class="fa fa-hospital"></i></div></div>
    </div>

    <!-- Quick Links -->
    <div class="quick-grid">
        <a href="/HospitalManagement/admin/doctors" class="quick-card"><div class="qc-icon ic-blue"><i class="fa fa-user-md"></i></div><h6>Manage Doctors</h6></a>
        <a href="/HospitalManagement/admin/patients" class="quick-card"><div class="qc-icon ic-green"><i class="fa fa-users"></i></div><h6>Manage Patients</h6></a>
        <a href="/HospitalManagement/admin/appointments" class="quick-card"><div class="qc-icon ic-purple"><i class="fa fa-calendar-check"></i></div><h6>Appointments</h6></a>
        <a href="/HospitalManagement/admin/bills" class="quick-card"><div class="qc-icon ic-orange"><i class="fa fa-file-invoice-dollar"></i></div><h6>Bills & Payments</h6></a>
    </div>

    <!-- Pending + Departments -->
    <div class="two-col">
        <div class="panel-card">
            <div class="ph">⏳ Pending Appointments <a href="/HospitalManagement/admin/appointments">View All →</a></div>
            <%
                List<?> pendingList=(List<?>)request.getAttribute("pendingAppts");
                if(pendingList==null||pendingList.isEmpty()){
            %><div class="p-empty"><i class="fa fa-check-circle fa-2x mb-2" style="color:#d1fae5"></i><br>No pending appointments</div><%
            }else{for(Object obj:pendingList){Appointment ap=(Appointment)obj;%>
            <div class="pend-row">
                <div class="pend-name"><%=ap.getPatientName()%> <span class="badge-pending">PENDING</span></div>
                <div class="pend-meta"><i class="fa fa-user-md fa-xs"></i> <%=ap.getDoctorName()%> &nbsp;|&nbsp; <i class="fa fa-calendar fa-xs"></i> <%=ap.getAppointmentDate()%></div>
                <div class="pend-actions">
                    <form action="/HospitalManagement/admin/appointments/status" method="post" style="margin:0">
                        <input type="hidden" name="id" value="<%=ap.getId()%>"><input type="hidden" name="status" value="approved">
                        <button class="btn-approve"><i class="fa fa-check"></i> Approve</button>
                    </form>
                    <form action="/HospitalManagement/admin/appointments/status" method="post" style="margin:0">
                        <input type="hidden" name="id" value="<%=ap.getId()%>"><input type="hidden" name="status" value="rejected">
                        <button class="btn-reject"><i class="fa fa-times"></i> Reject</button>
                    </form>
                </div>
            </div>
            <%}}%>
        </div>

        <div class="panel-card">
            <div class="ph">🏥 Departments Overview <a href="/HospitalManagement/admin/departments">Manage →</a></div>
            <div class="dept-grid">
            <%
                List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
                if(depts!=null)for(Map<String,Object> dept:depts){
            %><div class="dept-tile"><h5><%=dept.get("name")%></h5><p><%=dept.get("doctor_count")%> Doctors</p></div><%}%>
            </div>
        </div>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
