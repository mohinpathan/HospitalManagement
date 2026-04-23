<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html lang="<%=hi?"hi":"en"%>"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"मेरे अपॉइंटमेंट","My Appointments")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.page-hdr p{font-size:14px;color:#64748b;margin:3px 0 0}
.btn-primary-custom{background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff;border:none;border-radius:10px;padding:10px 20px;font-size:14px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-primary-custom:hover{opacity:.9;color:#fff;transform:translateY(-1px)}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.table-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase;padding:13px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:14px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled{background:#fee2e2;color:#991b1b}
.btn-cancel{background:#fee2e2;color:#991b1b;border:none;padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;text-decoration:none;display:inline-flex;align-items:center;gap:5px}
.btn-cancel:hover{background:#fecaca;color:#991b1b}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:16px;color:#e2e8f0;display:block}
@media(max-width:768px){.dash-main{padding:16px}.tbl{font-size:12px}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">
    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-calendar-check me-2" style="color:#7c3aed"></i><%=L(hi,"मेरे अपॉइंटमेंट","My Appointments")%></h2>
            <p><%=L(hi,"अपने सभी अपॉइंटमेंट देखें और प्रबंधित करें।","View and manage all your appointments.")%></p>
        </div>
        <a href="/HospitalManagement/patient/bookAppointment" class="btn-primary-custom"><i class="fa fa-calendar-plus"></i> <%=L(hi,"नया बुक करें","Book New")%></a>
    </div>
    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>
    <%
        List<?> appts=(List<?>)request.getAttribute("appointments");
        if(appts==null||appts.isEmpty()){
    %>
    <div class="table-card">
        <div class="empty-state">
            <i class="fa fa-calendar-xmark"></i>
            <h4 style="font-size:18px;font-weight:700;color:#374151;margin-bottom:8px"><%=L(hi,"अभी तक कोई अपॉइंटमेंट नहीं","No appointments yet")%></h4>
            <p><%=L(hi,"हमारे किसी विशेषज्ञ के साथ अपना पहला अपॉइंटमेंट बुक करें।","Book your first appointment with one of our specialists.")%></p>
            <a href="/HospitalManagement/patient/bookAppointment" class="btn-primary-custom mt-3"><i class="fa fa-calendar-plus"></i> <%=L(hi,"अपॉइंटमेंट बुक करें","Book Appointment")%></a>
        </div>
    </div>
    <% }else{ %>
    <div class="table-card">
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr>
                <th>#</th>
                <th><%=L(hi,"डॉक्टर","Doctor")%></th>
                <th><%=L(hi,"विभाग","Department")%></th>
                <th><%=L(hi,"तारीख","Date")%></th>
                <th><%=L(hi,"समय","Time")%></th>
                <th><%=L(hi,"कारण","Reason")%></th>
                <th><%=L(hi,"स्थिति","Status")%></th>
                <th><%=L(hi,"कार्रवाई","Action")%></th>
            </tr></thead>
            <tbody>
            <% int idx=1; for(Object obj:appts){ Appointment a=(Appointment)obj; String st=a.getStatus(); %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td><strong style="color:#0f172a"><%=a.getDoctorName()%></strong></td>
                <td><span style="background:#ede9fe;color:#6d28d9;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700"><%=a.getDepartmentName()!=null?a.getDepartmentName():"—"%></span></td>
                <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#374151"><%=a.getReason()%></td>
                <td><span class="badge badge-<%=st%>"><%=st.toUpperCase()%></span></td>
                <td>
                    <% if("pending".equals(st)||"approved".equals(st)){ %>
                    <a href="/HospitalManagement/patient/cancelAppointment?id=<%=a.getId()%>" class="btn-cancel" onclick="return confirm('<%=L(hi,"क्या आप इस अपॉइंटमेंट को रद्द करना चाहते हैं?","Cancel this appointment?")%>')"><i class="fa fa-times"></i> <%=L(hi,"रद्द करें","Cancel")%></a>
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
