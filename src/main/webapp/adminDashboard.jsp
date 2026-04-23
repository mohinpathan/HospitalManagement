<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}

/* Welcome */
.welcome-bar{background:linear-gradient(135deg,#1e3a8a,#2b7cff);border-radius:18px;padding:22px 28px;color:#fff;margin-bottom:24px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.welcome-bar h2{font-size:20px;font-weight:800;margin:0 0 3px}
.welcome-bar p{font-size:13px;opacity:.85;margin:0}
.welcome-bar .date-chip{background:rgba(255,255,255,.15);border-radius:10px;padding:8px 16px;font-size:13px;font-weight:600}

/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:20px}
.scard{background:#fff;border-radius:16px;padding:20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:transform .2s;text-decoration:none;color:inherit}
.scard:hover{transform:translateY(-3px);color:inherit}
.scard .label{font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase}
.scard .value{font-size:30px;font-weight:900;color:#0f172a;margin-top:4px;line-height:1}
.scard .sub{font-size:11px;color:#94a3b8;margin-top:3px}
.scard-icon{width:50px;height:50px;border-radius:13px;display:flex;align-items:center;justify-content:center;font-size:21px;color:#fff;flex-shrink:0}
.ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)}
.ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)}
.ic-purple{background:linear-gradient(135deg,#7c3aed,#6d28d9)}
.ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)}
.ic-red{background:linear-gradient(135deg,#ef4444,#dc2626)}
.ic-teal{background:linear-gradient(135deg,#06b6d4,#0891b2)}

/* Quick actions */
.quick-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:20px}
.qcard{background:#fff;border-radius:14px;padding:18px 14px;text-align:center;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;text-decoration:none;color:#0f172a;transition:all .2s;display:block}
.qcard:hover{transform:translateY(-4px);box-shadow:0 10px 28px rgba(0,0,0,.1);color:#0f172a}
.qcard .qc-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:18px;color:#fff;margin:0 auto 10px}
.qcard h6{font-size:12px;font-weight:700;margin:0;color:#374151}

/* Three col layout */
.three-col{display:grid;grid-template-columns:1fr 1fr 1fr;gap:18px;margin-bottom:20px}
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-bottom:20px}

/* Panel */
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.ph{padding:15px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:14px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.ph a{color:#2b7cff;font-size:12px;font-weight:500}
.panel-empty{padding:28px 20px;text-align:center;color:#94a3b8;font-size:13px}

/* Pending */
.pend-item{padding:13px 20px;border-bottom:1px solid #f8fafc}
.pend-item:last-child{border-bottom:none}
.pend-name{font-weight:600;font-size:13px;color:#0f172a;margin-bottom:2px}
.pend-meta{font-size:11px;color:#64748b;margin-bottom:7px}
.pend-actions{display:flex;gap:7px}
.btn-approve{background:#d1fae5;color:#065f46;border:none;padding:5px 12px;border-radius:7px;font-size:11px;font-weight:600;cursor:pointer;transition:all .2s}
.btn-approve:hover{background:#a7f3d0}
.btn-reject{background:#fee2e2;color:#991b1b;border:none;padding:5px 12px;border-radius:7px;font-size:11px;font-weight:600;cursor:pointer;transition:all .2s}
.btn-reject:hover{background:#fecaca}

/* Recent list */
.recent-item{padding:11px 18px;border-bottom:1px solid #f8fafc;display:flex;align-items:center;gap:12px}
.recent-item:last-child{border-bottom:none}
.recent-avatar{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:14px;color:#fff;flex-shrink:0}
.recent-name{font-weight:600;font-size:13px;color:#0f172a}
.recent-sub{font-size:11px;color:#64748b;margin-top:1px}

/* Dept grid */
.dept-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;padding:14px}
.dept-tile{background:#f8fafc;border-radius:10px;padding:12px;text-align:center;border:1px solid #e8edf5}
.dept-tile h5{font-size:12px;font-weight:700;color:#0f172a;margin-bottom:3px}
.dept-tile p{font-size:11px;color:#64748b;margin:0}

/* Top doctor */
.top-doc-item{padding:11px 18px;border-bottom:1px solid #f8fafc;display:flex;align-items:center;gap:12px}
.top-doc-item:last-child{border-bottom:none}
.rank-badge{width:26px;height:26px;border-radius:7px;background:linear-gradient(135deg,#f59e0b,#d97706);color:#fff;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0}
.stars{color:#f59e0b;font-size:11px}

/* Badge */
.badge-pending{background:#fef3c7;color:#92400e;padding:3px 9px;border-radius:20px;font-size:10px;font-weight:700}

@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(3,1fr)}.three-col{grid-template-columns:1fr 1fr}.quick-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.dash-main{padding:16px}.stats-grid{grid-template-columns:repeat(2,1fr)}.two-col,.three-col{grid-template-columns:1fr}.quick-grid{grid-template-columns:repeat(2,1fr)}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

<%
    String adminName = session.getAttribute("adminName")!=null?(String)session.getAttribute("adminName"):"Admin";
    double totalRevenue = request.getAttribute("totalRevenue")!=null?((Number)request.getAttribute("totalRevenue")).doubleValue():0;
    int pendingBills = request.getAttribute("pendingBills")!=null?((Number)request.getAttribute("pendingBills")).intValue():0;
    int todayAppts   = request.getAttribute("todayAppts")!=null?((Number)request.getAttribute("todayAppts")).intValue():0;
    int unreadFb     = request.getAttribute("unreadFeedback")!=null?((Number)request.getAttribute("unreadFeedback")).intValue():0;
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, dd MMM yyyy");
%>

<!-- Welcome Bar -->
<div class="welcome-bar">
    <div>
        <h2>Admin Dashboard 🏥</h2>
        <p>Welcome back, <strong><%=adminName%></strong>. Here's your hospital overview.</p>
    </div>
    <div class="date-chip"><i class="fa fa-calendar me-2"></i><%=sdf.format(new java.util.Date())%></div>
</div>

<!-- Stats Row 1 -->
<div class="stats-grid">
    <a href="/HospitalManagement/admin/doctors" class="scard">
        <div><div class="label">Total Doctors</div><div class="value">${totalDoctors}</div><div class="sub">Active staff</div></div>
        <div class="scard-icon ic-blue"><i class="fa fa-user-md"></i></div>
    </a>
    <a href="/HospitalManagement/admin/patients" class="scard">
        <div><div class="label">Total Patients</div><div class="value">${totalPatients}</div><div class="sub">Registered</div></div>
        <div class="scard-icon ic-green"><i class="fa fa-users"></i></div>
    </a>
    <a href="/HospitalManagement/admin/appointments" class="scard">
        <div><div class="label">Appointments</div><div class="value">${totalAppointments}</div><div class="sub"><%=todayAppts%> today</div></div>
        <div class="scard-icon ic-purple"><i class="fa fa-calendar-check"></i></div>
    </a>
    <a href="/HospitalManagement/admin/bills" class="scard">
        <div><div class="label">Total Revenue</div><div class="value" style="font-size:22px">₹<%=String.format("%.0f",totalRevenue)%></div><div class="sub"><%=pendingBills%> bills pending</div></div>
        <div class="scard-icon ic-orange"><i class="fa fa-indian-rupee-sign"></i></div>
    </a>
</div>

<!-- Quick Actions -->
<div class="quick-grid">
    <a href="/HospitalManagement/admin/doctors/add" class="qcard">
        <div class="qc-icon ic-blue"><i class="fa fa-user-plus"></i></div>
        <h6>Add Doctor</h6>
    </a>
    <a href="/HospitalManagement/admin/departments" class="qcard">
        <div class="qc-icon ic-green"><i class="fa fa-hospital"></i></div>
        <h6>Departments</h6>
    </a>
    <a href="/HospitalManagement/admin/reports" class="qcard">
        <div class="qc-icon ic-purple"><i class="fa fa-chart-line"></i></div>
        <h6>Reports</h6>
    </a>
    <a href="/HospitalManagement/admin/feedback" class="qcard" style="position:relative">
        <div class="qc-icon ic-orange"><i class="fa fa-comments"></i></div>
        <h6>Feedback <% if(unreadFb>0){ %><span style="background:#ef4444;color:#fff;border-radius:20px;padding:1px 6px;font-size:10px;margin-left:4px"><%=unreadFb%></span><% } %></h6>
    </a>
</div>

<!-- Pending + Departments -->
<div class="two-col">
    <div class="panel">
        <div class="ph">⏳ Pending Appointments <a href="/HospitalManagement/admin/appointments">View All →</a></div>
        <%
            List<?> pendingList=(List<?>)request.getAttribute("pendingAppts");
            if(pendingList==null||pendingList.isEmpty()){
        %><div class="panel-empty"><i class="fa fa-check-circle fa-2x mb-2" style="color:#d1fae5;display:block"></i>No pending appointments</div><%
        }else{int shown=0;for(Object obj:pendingList){if(shown++>=5)break;Appointment ap=(Appointment)obj;%>
        <div class="pend-item">
            <div class="pend-name"><%=ap.getPatientName()%> <span class="badge-pending ms-1">PENDING</span></div>
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

    <div class="panel">
        <div class="ph">🏥 Departments <a href="/HospitalManagement/admin/departments">Manage →</a></div>
        <div class="dept-grid">
        <%
            List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
            if(depts!=null)for(Map<String,Object> dept:depts){
        %><div class="dept-tile"><h5><%=dept.get("name")%></h5><p><%=dept.get("doctor_count")%> Doctors</p></div><%}%>
        </div>
    </div>
</div>

<!-- Recent Registrations + Top Doctors -->
<div class="three-col">
    <div class="panel">
        <div class="ph">🧑 Recent Patients <a href="/HospitalManagement/admin/patients">All →</a></div>
        <%
            List<?> recPats=(List<?>)request.getAttribute("recentPatients");
            if(recPats==null||recPats.isEmpty()){
        %><div class="panel-empty">No patients yet.</div><%
        }else{for(Object obj:recPats){Patient p=(Patient)obj;%>
        <div class="recent-item">
            <div class="recent-avatar ic-green"><i class="fa fa-user"></i></div>
            <div>
                <div class="recent-name"><%=p.getFullName()%></div>
                <div class="recent-sub"><%=p.getEmail()%></div>
            </div>
        </div>
        <%}}%>
    </div>

    <div class="panel">
        <div class="ph">👨‍⚕️ Recent Doctors <a href="/HospitalManagement/admin/doctors">All →</a></div>
        <%
            List<?> recDocs=(List<?>)request.getAttribute("recentDoctors");
            if(recDocs==null||recDocs.isEmpty()){
        %><div class="panel-empty">No doctors yet.</div><%
        }else{for(Object obj:recDocs){Doctor d=(Doctor)obj;%>
        <div class="recent-item">
            <div class="recent-avatar ic-blue"><i class="fa fa-user-md"></i></div>
            <div>
                <div class="recent-name"><%=d.getFullName()%></div>
                <div class="recent-sub"><%=d.getDepartmentName()!=null?d.getDepartmentName():""%></div>
            </div>
        </div>
        <%}}%>
    </div>

    <div class="panel">
        <div class="ph">🏆 Top Rated Doctors <a href="/HospitalManagement/admin/reports">Reports →</a></div>
        <%
            List<Map<String,Object>> topDocs=(List<Map<String,Object>>)request.getAttribute("topDoctors");
            if(topDocs==null||topDocs.isEmpty()){
        %><div class="panel-empty">No reviews yet.</div><%
        }else{int rank=1;for(Map<String,Object> d:topDocs){
            double avg=d.get("avg_rating")!=null?((Number)d.get("avg_rating")).doubleValue():0;
            int cnt=d.get("review_count")!=null?((Number)d.get("review_count")).intValue():0;%>
        <div class="top-doc-item">
            <div class="rank-badge"><%=rank++%></div>
            <div style="flex:1">
                <div style="font-weight:600;font-size:13px;color:#0f172a"><%=d.get("full_name")%></div>
                <div class="stars">
                    <%for(int i=1;i<=5;i++){%><i class="fa fa-star<%=i<=avg?"":" fa-regular"%>"></i><%}%>
                    <span style="color:#64748b;font-size:10px;margin-left:3px"><%=String.format("%.1f",avg)%> (<%=cnt%>)</span>
                </div>
            </div>
        </div>
        <%}}%>
    </div>
</div>

</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
