<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<%@ include file="/WEB-INF/lang.jsp" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Patient <%=L(hi,"डैशबोर्ड","Dashboard")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}

/* Welcome Banner */
.welcome-banner{background:linear-gradient(135deg,#7c3aed,#8b5cf6);border-radius:18px;padding:24px 28px;color:#fff;margin-bottom:24px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px}
.welcome-banner h2{font-size:22px;font-weight:800;margin:0 0 4px}
.welcome-banner p{font-size:14px;opacity:.85;margin:0}
.health-chips{display:flex;gap:10px;flex-wrap:wrap;margin-top:10px}
.health-chip{background:rgba(255,255,255,.2);border-radius:20px;padding:5px 14px;font-size:12px;font-weight:600;display:flex;align-items:center;gap:6px}
.btn-book-now{background:#fff;color:#7c3aed;border:none;border-radius:10px;padding:11px 22px;font-size:14px;font-weight:700;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s;flex-shrink:0}
.btn-book-now:hover{background:#f5f3ff;color:#6d28d9;transform:translateY(-1px)}

/* Next Appointment Card */
.next-appt-card{background:#fff;border-radius:16px;padding:20px 22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:24px;border-left:4px solid #7c3aed;display:flex;align-items:center;gap:18px;flex-wrap:wrap}
.next-appt-card .na-icon{width:52px;height:52px;border-radius:14px;background:linear-gradient(135deg,#ede9fe,#ddd6fe);display:flex;align-items:center;justify-content:center;font-size:22px;color:#7c3aed;flex-shrink:0}
.next-appt-card .na-label{font-size:11px;font-weight:700;color:#7c3aed;letter-spacing:.6px;text-transform:uppercase;margin-bottom:3px}
.next-appt-card .na-doc{font-size:16px;font-weight:800;color:#0f172a}
.next-appt-card .na-meta{font-size:13px;color:#64748b;margin-top:3px}

/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.scard{background:#fff;border-radius:16px;padding:20px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:transform .2s}
.scard:hover{transform:translateY(-3px)}
.scard .label{font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase}
.scard .value{font-size:32px;font-weight:900;color:#0f172a;margin-top:4px;line-height:1}
.scard-icon{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;color:#fff;flex-shrink:0}
.ic-purple{background:linear-gradient(135deg,#7c3aed,#6d28d9)}
.ic-blue{background:linear-gradient(135deg,#2b7cff,#1a5fd4)}
.ic-green{background:linear-gradient(135deg,#19b37a,#0d9668)}
.ic-orange{background:linear-gradient(135deg,#f59e0b,#d97706)}

/* Two col */
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px}
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.panel-head{padding:16px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-head a{color:#7c3aed;font-size:13px;font-weight:500}
.panel-empty{padding:36px 20px;text-align:center;color:#94a3b8;font-size:14px}
.appt-row{padding:13px 20px;border-bottom:1px solid #f8fafc;display:flex;justify-content:space-between;align-items:center}
.appt-row:last-child{border-bottom:none}
.appt-doc{font-weight:600;font-size:14px;color:#0f172a}
.appt-dept{font-size:12px;color:#7c3aed;font-weight:600;margin-top:2px}
.appt-meta{font-size:12px;color:#64748b;margin-top:3px}

/* Action cards */
.action-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:24px}
.acard{border-radius:16px;padding:22px;color:#fff;text-decoration:none;display:block;transition:all .2s}
.acard:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.15);color:#fff}
.acard .ac-icon{font-size:24px;margin-bottom:10px}
.acard h5{font-size:15px;font-weight:700;margin-bottom:4px}
.acard p{font-size:12px;opacity:.85;margin:0}
.ac-purple{background:linear-gradient(135deg,#7c3aed,#8b5cf6)}
.ac-blue{background:linear-gradient(135deg,#1d4ed8,#3b82f6)}
.ac-green{background:linear-gradient(135deg,#19b37a,#0d9668)}

/* Badges */
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled{background:#fee2e2;color:#991b1b}

@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,1fr)}.action-grid{grid-template-columns:1fr 1fr}}
@media(max-width:768px){.dash-main{padding:16px}.two-col{grid-template-columns:1fr}.action-grid{grid-template-columns:1fr}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

<%
    Patient pat = (Patient) request.getAttribute("patient");
    String pname = pat!=null?pat.getFullName():(String)session.getAttribute("patientName");
    String blood = pat!=null&&pat.getBloodGroup()!=null?pat.getBloodGroup():"—";
    int age = pat!=null?pat.get<%=L(hi,"आयु","Age")%>():0;
    Appointment nextAppt = (Appointment) request.getAttribute("nextAppt");
%>

<!-- Welcome Banner -->
<div class="welcome-banner">
    <div>
        <h2><%=L(hi,"नमस्ते,","Welcome back,")%> <%=pname%> 👋</h2>
        <p><%=L(hi,"आज आपके स्वास्थ्य का अवलोकन यहाँ है।","Here's your health overview for today.")%></p>
        <div class="health-chips">
            <span class="health-chip"><i class="fa fa-tint"></i> Blood: <%=blood%></span>
            <% if(age>0){ %><span class="health-chip"><i class="fa fa-calendar"></i> <%=L(hi,"आयु","Age")%>: <%=age%></span><% } %>
            <span class="health-chip"><i class="fa fa-circle-check" style="color:#a7f3d0"></i> Active Patient</span>
        </div>
    </div>
    <a href="/HospitalManagement/patient/bookAppointment" class="btn-book-now">
        <i class="fa fa-calendar-plus"></i> <%=L(hi,"अपॉइंटमेंट बुक करें","Book Appointment")%>
    </a>
</div>

<!-- Next Appointment Highlight -->
<% if(nextAppt != null){ %>
<div class="next-appt-card">
    <div class="na-icon"><i class="fa fa-calendar-check"></i></div>
    <div style="flex:1">
        <div class="na-label">Next Upcoming Appointment</div>
        <div class="na-doc"><%=nextAppt.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></div>
        <div class="na-meta">
            <i class="fa fa-hospital fa-xs me-1"></i><%=nextAppt.get<%=L(hi,"विभाग","Department")%>Name()%>
            &nbsp;|&nbsp;
            <i class="fa fa-calendar fa-xs me-1"></i><%=nextAppt.getAppointmentDate()%>
            &nbsp;|&nbsp;
            <i class="fa fa-clock fa-xs me-1"></i><%=nextAppt.getAppointmentTime()%>
        </div>
    </div>
    <span class="badge badge-approved">CONFIRMED</span>
</div>
<% } %>

<!-- Stats -->
<div class="stats-grid">
    <div class="scard">
        <div><div class="label"><%=L(hi,"कुल अपॉइंटमेंट","Total <%=L(hi,"अपॉइंटमेंट","Appointments")%>")%></div><div class="value">${totalAppts}</div></div>
        <div class="scard-icon ic-purple"><i class="fa fa-calendar"></i></div>
    </div>
    <div class="scard">
        <div><div class="label">Upcoming</div><div class="value">${upcomingAppts}</div></div>
        <div class="scard-icon ic-blue"><i class="fa fa-clock"></i></div>
    </div>
    <div class="scard">
        <div><div class="label">Completed</div><div class="value">${completedAppts}</div></div>
        <div class="scard-icon ic-green"><i class="fa fa-circle-check"></i></div>
    </div>
    <div class="scard">
        <div><div class="label">Prescriptions</div><div class="value">${not empty bills ? bills.size() : 0}</div></div>
        <div class="scard-icon ic-orange"><i class="fa fa-file-medical"></i></div>
    </div>
</div>

<!-- Quick <%=L(hi,"कार्रवाई","Actions")%> -->
<div class="action-grid">
    <a href="/HospitalManagement/patient/find<%=L(hi,"डॉक्टर","Doctor")%>s" class="acard ac-purple">
        <div class="ac-icon"><i class="fa fa-search"></i></div>
        <h5><%=L(hi,"डॉक्टर खोजें","Find a <%=L(hi,"डॉक्टर","Doctor")%>")%></h5>
        <p><%=L(hi,"खोजें","Search")%> by specialization, department or fee</p>
    </a>
    <a href="/HospitalManagement/patient/bookAppointment" class="acard ac-blue">
        <div class="ac-icon"><i class="fa fa-calendar-plus"></i></div>
        <h5><%=L(hi,"अपॉइंटमेंट बुक करें","Book Appointment")%></h5>
        <p>Schedule your next consultation</p>
    </a>
    <a href="/HospitalManagement/patient/medicalRecords" class="acard ac-green">
        <div class="ac-icon"><i class="fa fa-file-medical"></i></div>
        <h5><%=L(hi,"चिकित्सा रिकॉर्ड","Medical Records")%></h5>
        <p><%=L(hi,"देखें","View")%> prescriptions and bills</p>
    </a>
</div>

<!-- Recent <%=L(hi,"अपॉइंटमेंट","Appointments")%> + Prescriptions -->
<div class="two-col">
    <div class="panel">
        <div class="panel-head">
            Recent <%=L(hi,"अपॉइंटमेंट","Appointments")%>
            <a href="/HospitalManagement/patient/appointments"><%=L(hi,"सभी देखें","<%=L(hi,"देखें","View")%> All")%> →</a>
        </div>
        <%
            List<?> appts=(List<?>)request.getAttribute("recentAppts");
            if(appts==null||appts.isEmpty()){
        %><div class="panel-empty"><i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0;display:block"></i>No appointments yet.</div><%
        }else{int shown=0;for(Object obj:appts){if(shown++>=5)break;Appointment a=(Appointment)obj;String st=a.get<%=L(hi,"स्थिति","Status")%>();
              String cls="approved".equals(st)?"badge-approved":"completed".equals(st)?"badge-completed":"rejected".equals(st)||"cancelled".equals(st)?"badge-rejected":"badge-pending";%>
        <div class="appt-row">
            <div>
                <div class="appt-doc"><%=a.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></div>
                <div class="appt-dept"><%=a.get<%=L(hi,"विभाग","Department")%>Name()%></div>
                <div class="appt-meta"><i class="fa fa-calendar fa-xs"></i> <%=a.getAppointmentDate()%> &nbsp;<i class="fa fa-clock fa-xs"></i> <%=a.getAppointmentTime()%></div>
            </div>
            <span class="badge <%=cls%>"><%=st.toUpperCase()%></span>
        </div>
        <%}}%>
    </div>

    <div class="panel">
        <div class="panel-head">
            <%=L(hi,"हाल के पर्चे","Recent Prescriptions")%>
            <a href="/HospitalManagement/patient/medicalRecords"><%=L(hi,"सभी देखें","<%=L(hi,"देखें","View")%> All")%> →</a>
        </div>
        <%
            List<?> bills=(List<?>)request.getAttribute("bills");
            if(bills==null||bills.isEmpty()){
        %><div class="panel-empty"><i class="fa fa-file-medical fa-2x mb-3" style="color:#e2e8f0;display:block"></i>No prescriptions yet.</div><%
        }else{for(Object obj:bills){com.hospital.model.Bill b=(com.hospital.model.Bill)obj;%>
        <div class="appt-row">
            <div>
                <div class="appt-doc"><%=b.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></div>
                <div class="appt-dept" style="color:#19b37a"><%=b.get<%=L(hi,"निदान","Diagnosis")%>()!=null?b.get<%=L(hi,"निदान","Diagnosis")%>():"Prescription"%></div>
                <div class="appt-meta">Total: ₹<%=String.format("%.0f",b.getTotalAmount())%></div>
            </div>
            <span class="badge <%="confirmed".equals(b.getPayment<%=L(hi,"स्थिति","Status")%>())?"badge-approved":"badge-pending"%>"><%=b.getPayment<%=L(hi,"स्थिति","Status")%>().toUpperCase()%></span>
        </div>
        <%}}%>
    </div>
</div>

</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
