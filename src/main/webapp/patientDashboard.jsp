<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Patient Dashboard</title>
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
.ic-purple{background:linear-gradient(135deg,#7c3aed,#6d28d9)} .ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)} .ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)} .ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)}
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px}
.panel-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.panel-card .ph{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-card .ph a{color:#7c3aed;font-size:13px;font-weight:500}
.panel-card .p-empty{padding:36px 20px;text-align:center;color:#94a3b8;font-size:14px}
.appt-row{padding:13px 20px;border-bottom:1px solid #f8fafc;display:flex;justify-content:space-between;align-items:center}
.appt-row:last-child{border-bottom:none}
.appt-doc{font-weight:600;font-size:14px;color:#0f172a}
.appt-dept{font-size:12px;color:#7c3aed;font-weight:600;margin-top:2px}
.appt-meta{font-size:12px;color:#64748b;margin-top:3px}
.action-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.action-card{border-radius:18px;padding:28px;color:#fff;text-decoration:none;display:block;transition:all .2s}
.action-card:hover{transform:translateY(-4px);box-shadow:0 14px 36px rgba(0,0,0,.18);color:#fff}
.action-card h4{font-size:18px;font-weight:800;margin-bottom:8px}
.action-card p{font-size:13px;opacity:.9;margin:0}
.ac-purple{background:linear-gradient(135deg,#7c3aed,#8b5cf6)}
.ac-blue{background:linear-gradient(135deg,#1d4ed8,#3b82f6)}
.bs-approved{background:#d1fae5;color:#065f46;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-pending{background:#fef3c7;color:#92400e;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-completed{background:#dbeafe;color:#1e40af;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-rejected{background:#fee2e2;color:#991b1b;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.bs-cancelled{background:#f1f5f9;color:#475569;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.page-hdr{margin-bottom:24px}
.page-hdr h2{font-size:24px;font-weight:900;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.btn-book-now{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;border:none;padding:9px 18px;border-radius:10px;font-size:13px;font-weight:600;cursor:pointer;margin-top:12px;text-decoration:none;display:inline-block}
@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.two-col,.action-grid{grid-template-columns:1fr}.dash-main{padding:16px}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2>Welcome, <%= session.getAttribute("patientName")!=null?session.getAttribute("patientName"):"Patient" %> 👋</h2>
        <p>Manage your health and appointments from here.</p>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card"><div><div class="sc-label">Total Appointments</div><div class="sc-value">${totalAppts}</div></div><div class="sc-icon ic-purple"><i class="fa fa-calendar"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Upcoming</div><div class="sc-value">${upcomingAppts}</div></div><div class="sc-icon ic-blue"><i class="fa fa-clock"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Completed</div><div class="sc-value">${completedAppts}</div></div><div class="sc-icon ic-green"><i class="fa fa-circle-check"></i></div></div>
        <div class="stat-card"><div><div class="sc-label">Prescriptions</div><div class="sc-value">${not empty bills ? bills.size() : 0}</div></div><div class="sc-icon ic-orange"><i class="fa fa-file-medical"></i></div></div>
    </div>

    <!-- Panels -->
    <div class="two-col">
        <div class="panel-card">
            <div class="ph">Recent Appointments <a href="/HospitalManagement/patient/appointments">View All →</a></div>
            <%
                List<?> appts=(List<?>)request.getAttribute("recentAppts");
                if(appts==null||appts.isEmpty()){
            %><div class="p-empty"><i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0"></i><br>No appointments yet.<br><a href="/HospitalManagement/patient/bookAppointment" class="btn-book-now">Book Now</a></div><%
            }else{int shown=0;for(Object obj:appts){if(shown++>=4)break;Appointment a=(Appointment)obj;String st=a.getStatus();String cls="approved".equals(st)?"bs-approved":"completed".equals(st)?"bs-completed":"rejected".equals(st)?"bs-rejected":"cancelled".equals(st)?"bs-cancelled":"bs-pending";%>
            <div class="appt-row">
                <div><div class="appt-doc"><%=a.getDoctorName()%></div><div class="appt-dept"><%=a.getDepartmentName()%></div><div class="appt-meta"><i class="fa fa-calendar fa-xs"></i> <%=a.getAppointmentDate()%> &nbsp;<i class="fa fa-clock fa-xs"></i> <%=a.getAppointmentTime()%></div></div>
                <span class="<%=cls%>"><%=st.toUpperCase()%></span>
            </div>
            <%}}%>
        </div>

        <div class="panel-card">
            <div class="ph">Recent Prescriptions <a href="/HospitalManagement/patient/medicalRecords">View All →</a></div>
            <%
                List<?> bills=(List<?>)request.getAttribute("bills");
                if(bills==null||bills.isEmpty()){
            %><div class="p-empty"><i class="fa fa-file-medical fa-2x mb-3" style="color:#e2e8f0"></i><br>No prescriptions yet.</div><%
            }else{for(Object obj:bills){com.hospital.model.Bill b=(com.hospital.model.Bill)obj;%>
            <div class="appt-row">
                <div><div class="appt-doc"><%=b.getDoctorName()%></div><div class="appt-dept" style="color:#19b37a"><%=b.getDiagnosis()!=null?b.getDiagnosis():"Prescription"%></div><div class="appt-meta">Total: ₹<%=String.format("%.0f",b.getTotalAmount())%></div></div>
                <span class="<%="confirmed".equals(b.getPaymentStatus())?"bs-approved":"bs-pending"%>"><%=b.getPaymentStatus().toUpperCase()%></span>
            </div>
            <%}}%>
        </div>
    </div>

    <!-- Action Cards -->
    <div class="action-grid">
        <a href="/HospitalManagement/patient/findDoctors" class="action-card ac-purple"><h4><i class="fa fa-search me-2"></i>Find a Doctor</h4><p>Search specialists by department and book instantly.</p></a>
        <a href="/HospitalManagement/patient/bookAppointment" class="action-card ac-blue"><h4><i class="fa fa-calendar-plus me-2"></i>Book Appointment</h4><p>Schedule your next consultation with our doctors.</p></a>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
