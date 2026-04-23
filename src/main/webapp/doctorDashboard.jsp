<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Doctor <%=L(hi,"डैशबोर्ड","Dashboard")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}

/* Welcome */
.welcome-banner{background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:18px;padding:24px 28px;color:#fff;margin-bottom:24px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px}
.welcome-banner h2{font-size:22px;font-weight:800;margin:0 0 4px}
.welcome-banner p{font-size:14px;opacity:.85;margin:0}
.doc-chips{display:flex;gap:10px;flex-wrap:wrap;margin-top:10px}
.doc-chip{background:rgba(255,255,255,.2);border-radius:20px;padding:5px 14px;font-size:12px;font-weight:600;display:flex;align-items:center;gap:6px}
.rating-display{background:rgba(255,255,255,.15);border-radius:12px;padding:12px 18px;text-align:center;flex-shrink:0}
.rating-display .stars{color:#fbbf24;font-size:18px;margin-bottom:4px}
.rating-display .rating-val{font-size:22px;font-weight:900;color:#fff}
.rating-display .rating-sub{font-size:11px;opacity:.8}

/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.scard{background:#fff;border-radius:16px;padding:20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:transform .2s}
.scard:hover{transform:translateY(-3px)}
.scard .label{font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase}
.scard .value{font-size:32px;font-weight:900;color:#0f172a;margin-top:4px;line-height:1}
.scard .sub-val{font-size:12px;color:#64748b;margin-top:2px}
.scard-icon{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;color:#fff;flex-shrink:0}
.ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)}
.ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)}
.ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)}
.ic-gray{background:linear-gradient(135deg,#64748b,#475569)}
.ic-purple{background:linear-gradient(135deg,#7c3aed,#6d28d9)}

/* Today panel */
.today-panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.today-panel .ph{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a;background:#f0fdf4}
.today-panel .ph a{color:#19b37a;font-size:13px;font-weight:500}
.today-item{padding:14px 20px;border-bottom:1px solid #f8fafc;display:flex;justify-content:space-between;align-items:center}
.today-item:last-child{border-bottom:none}
.today-item .t-patient{font-weight:600;font-size:14px;color:#0f172a}
.today-item .t-meta{font-size:12px;color:#64748b;margin-top:2px}
.panel-empty{padding:36px 20px;text-align:center;color:#94a3b8;font-size:14px}

/* All appointments table */
.table-panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.table-panel .ph{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.table-panel .ph a{color:#19b37a;font-size:13px;font-weight:500}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:12px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:13px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#f0fdf4}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-cancelled,.badge-rejected{background:#fee2e2;color:#991b1b}
.btn-prescribe{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;padding:6px 13px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:all .2s}
.btn-prescribe:hover{opacity:.9;color:#fff}

@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.dash-main{padding:16px}.welcome-banner{flex-direction:column}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

<%
    Doctor doc = (Doctor) request.getAttribute("doctor");
    String dname = doc!=null?doc.getFullName():(String)session.getAttribute("doctorName");
    String ddept = doc!=null&&doc.get<%=L(hi,"विभाग","Department")%>Name()!=null?doc.get<%=L(hi,"विभाग","Department")%>Name():(String)session.getAttribute("doctorDept");
    String dspec = doc!=null&&doc.getSpecialization()!=null?doc.getSpecialization():"";
    double dfee  = doc!=null?doc.getConsultationFee():0;
    int dexp     = doc!=null?doc.getExperienceYrs():0;
    double earnings = request.getAttribute("monthlyEarnings")!=null?((Number)request.getAttribute("monthlyEarnings")).doubleValue():0;
    int uniquePats  = request.getAttribute("unique<%=L(hi,"मरीज़","Patient")%>s")!=null?((Number)request.getAttribute("unique<%=L(hi,"मरीज़","Patient")%>s")).intValue():0;
%>

<!-- Welcome Banner -->
<div class="welcome-banner">
    <div>
        <h2>Welcome, <%=dname%> 👋</h2>
        <p><%=ddept%> &nbsp;|&nbsp; <%=dspec%></p>
        <div class="doc-chips">
            <span class="doc-chip"><i class="fa fa-briefcase-medical"></i> <%=dexp%> yrs exp</span>
            <span class="doc-chip"><i class="fa fa-indian-rupee-sign"></i> ₹<%=String.format("%.0f",dfee)%>/consult</span>
            <span class="doc-chip"><i class="fa fa-users"></i> <%=uniquePats%> patients</span>
        </div>
    </div>
    <div class="rating-display">
        <div class="stars">
            <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star-half-stroke"></i>
        </div>
        <div class="rating-val">4.5</div>
        <div class="rating-sub">Avg Rating</div>
    </div>
</div>

<!-- Stats -->
<div class="stats-grid">
    <div class="scard">
        <div><div class="label"><%=L(hi,"कुल अपॉइंटमेंट","Total <%=L(hi,"अपॉइंटमेंट","Appointments")%>")%></div><div class="value">${totalAppts}</div></div>
        <div class="scard-icon ic-blue"><i class="fa fa-calendar"></i></div>
    </div>
    <div class="scard">
        <div><div class="label">Today</div><div class="value">${todayAppts}</div></div>
        <div class="scard-icon ic-green"><i class="fa fa-clock"></i></div>
    </div>
    <div class="scard">
        <div><div class="label">Pending</div><div class="value">${pendingAppts}</div></div>
        <div class="scard-icon ic-orange"><i class="fa fa-hourglass-half"></i></div>
    </div>
    <div class="scard">
        <div>
            <div class="label">Monthly Earnings</div>
            <div class="value" style="font-size:22px">₹<%=String.format("%.0f",earnings)%></div>
            <div class="sub-val">This month</div>
        </div>
        <div class="scard-icon ic-purple"><i class="fa fa-indian-rupee-sign"></i></div>
    </div>
</div>

<!-- Today's <%=L(hi,"अपॉइंटमेंट","Appointments")%> -->
<div class="today-panel">
    <div class="ph">
        <span><i class="fa fa-sun me-2" style="color:#f59e0b"></i>Today's <%=L(hi,"अपॉइंटमेंट","Appointments")%></span>
        <a href="/HospitalManagement/doctor/appointments"><%=L(hi,"सभी देखें","<%=L(hi,"देखें","View")%> All")%> →</a>
    </div>
    <%
        List<?> todayList=(List<?>)request.getAttribute("todayList");
        if(todayList==null||todayList.isEmpty()){
    %><div class="panel-empty"><i class="fa fa-calendar-day fa-2x mb-3" style="color:#e2e8f0;display:block"></i>No appointments scheduled for today.</div><%
    }else{for(Object obj:todayList){Appointment a=(Appointment)obj;String st=a.get<%=L(hi,"स्थिति","Status")%>();%>
    <div class="today-item">
        <div>
            <div class="t-patient"><%=a.get<%=L(hi,"मरीज़","Patient")%>Name()%></div>
            <div class="t-meta"><i class="fa fa-clock fa-xs me-1"></i><%=a.getAppointmentTime()%> &nbsp;|&nbsp; <%=a.getReason()%></div>
        </div>
        <div style="display:flex;align-items:center;gap:10px">
            <span class="badge badge-<%=st%>"><%=st.toUpperCase()%></span>
            <%if("approved".equals(st)){%>
            <a href="/HospitalManagement/doctor/prescription/<%=a.getId()%>" class="btn-prescribe"><i class="fa fa-file-prescription"></i> Prescribe</a>
            <%}%>
        </div>
    </div>
    <%}}%>
</div>

<!-- All <%=L(hi,"अपॉइंटमेंट","Appointments")%> Table -->
<div class="table-panel">
    <div class="ph">
        All <%=L(hi,"अपॉइंटमेंट","Appointments")%>
        <a href="/HospitalManagement/doctor/appointments">Full List →</a>
    </div>
    <%
        List<?> appts=(List<?>)request.getAttribute("appointments");
        if(appts==null||appts.isEmpty()){
    %><div class="panel-empty"><%=L(hi,"कोई अपॉइंटमेंट नहीं मिला","No appointments found")%>.</div><%
    }else{%>
    <div style="overflow-x:auto">
    <table class="tbl">
        <thead><tr><th>#</th><th><%=L(hi,"मरीज़","Patient")%></th><th>Date</th><th>Time</th><th>Reason</th><th><%=L(hi,"स्थिति","Status")%></th><th>Action</th></tr></thead>
        <tbody>
        <%int idx=1;for(Object obj:appts){if(idx>8)break;Appointment a=(Appointment)obj;String st=a.get<%=L(hi,"स्थिति","Status")%>();
          String cls="approved".equals(st)?"badge-approved":"completed".equals(st)?"badge-completed":"cancelled".equals(st)||"rejected".equals(st)?"badge-cancelled":"badge-pending";%>
        <tr>
            <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
            <td><strong><%=a.get<%=L(hi,"मरीज़","Patient")%>Name()%></strong></td>
            <td><%=a.getAppointmentDate()%></td>
            <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
            <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
            <td><span class="badge <%=cls%>"><%=st.toUpperCase()%></span></td>
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
