<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"देखें","View")%> <%=L(hi,"मरीज़","Patient")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.page-hdr p{font-size:14px;color:#64748b;margin:3px 0 0}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 18px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
/* Profile card */
.profile-card{background:#fff;border-radius:18px;padding:28px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;text-align:center}
.profile-avatar{width:90px;height:90px;border-radius:50%;background:linear-gradient(135deg,#dbeafe,#bfdbfe);display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:36px;color:#2b7cff;overflow:hidden}
.profile-avatar img{width:100%;height:100%;object-fit:cover;border-radius:50%}
.profile-name{font-size:20px;font-weight:800;color:#0f172a;margin-bottom:4px}
.profile-email{font-size:13px;color:#64748b;margin-bottom:12px}
.info-row{display:flex;align-items:center;gap:10px;padding:9px 0;border-bottom:1px solid #f8fafc;font-size:14px;color:#374151;text-align:left}
.info-row:last-child{border-bottom:none}
.info-row i{width:20px;text-align:center}
.info-label{color:#64748b;font-size:12px;font-weight:600;min-width:80px}
/* Panel */
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
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
.badge-approved,.badge-active,.badge-confirmed{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled,.badge-inactive{background:#fee2e2;color:#991b1b}
/* Stats row */
.mini-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:20px}
.mini-stat{background:#fff;border-radius:12px;padding:16px;text-align:center;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5}
.mini-stat .ms-val{font-size:24px;font-weight:800;color:#0f172a}
.mini-stat .ms-label{font-size:11px;color:#64748b;font-weight:600;text-transform:uppercase;letter-spacing:.5px;margin-top:3px}
/* Blood badge */
.blood-badge{background:#fee2e2;color:#991b1b;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:700}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-user me-2" style="color:#2b7cff"></i><%=L(hi,"मरीज़","Patient")%> Details</h2>
            <p>Complete patient profile, appointment history and billing.</p>
        </div>
        <a href="/HospitalManagement/admin/patients" class="btn-back"><i class="fa fa-arrow-left"></i> <%=L(hi,"वापस","Back to")%> <%=L(hi,"मरीज़","Patient")%>s</a>
    </div>

    <%
        <%=L(hi,"मरीज़","Patient")%> p = (<%=L(hi,"मरीज़","Patient")%>) request.getAttribute("patient");
        if (p == null) {
    %>
    <div style="background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:16px;display:flex;align-items:center;gap:10px">
        <i class="fa fa-exclamation-circle"></i> <%=L(hi,"मरीज़","Patient")%> not found. Please go back and try again.
    </div>
    <%} else {
        List<?> appts = (List<?>) request.getAttribute("appointments");
        List<?> bills = (List<?>) request.getAttribute("bills");
        int totalAppts = appts != null ? appts.size() : 0;
        int totalBills = bills != null ? bills.size() : 0;
        long completedCount = appts != null ? appts.stream().filter(a -> "completed".equals(((Appointment)a).get<%=L(hi,"स्थिति","Status")%>())).count() : 0;
    %>

    <!-- Mini Stats -->
    <div class="mini-stats">
        <div class="mini-stat">
            <div class="ms-val"><%=totalAppts%></div>
            <div class="ms-label"><%=L(hi,"कुल अपॉइंटमेंट","Total <%=L(hi,"अपॉइंटमेंट","Appointments")%>")%></div>
        </div>
        <div class="mini-stat">
            <div class="ms-val"><%=completedCount%></div>
            <div class="ms-label">Completed</div>
        </div>
        <div class="mini-stat">
            <div class="ms-val"><%=totalBills%></div>
            <div class="ms-label">Bills</div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Left: Profile -->
        <div class="col-lg-4">
            <div class="profile-card">
                <div class="profile-avatar">
                    <% if(p.getPhoto() != null && !p.getPhoto().isEmpty()){ %>
                    <img src="<%=p.getPhoto()%>" alt="Photo">
                    <% } else { %>
                    <i class="fa fa-user"></i>
                    <% } %>
                </div>
                <div class="profile-name"><%=p.getFullName()%></div>
                <div class="profile-email"><%=p.getEmail()%></div>
                <span class="badge badge-<%="active".equals(p.get<%=L(hi,"स्थिति","Status")%>())?"active":"inactive"%>">
                    <%=p.get<%=L(hi,"स्थिति","Status")%>().toUpperCase()%>
                </span>

                <hr style="border-color:#f1f5f9;margin:16px 0">

                <div class="info-row">
                    <i class="fa fa-phone" style="color:#19b37a"></i>
                    <span class="info-label"><%=L(hi,"फ़ोन","Phone")%></span>
                    <span><%=p.get<%=L(hi,"फ़ोन","Phone")%>()!=null?p.get<%=L(hi,"फ़ोन","Phone")%>():"—"%></span>
                </div>
                <div class="info-row">
                    <i class="fa fa-venus-mars" style="color:#7c3aed"></i>
                    <span class="info-label"><%=L(hi,"लिंग","Gender")%></span>
                    <span><%=p.get<%=L(hi,"लिंग","Gender")%>()!=null?p.get<%=L(hi,"लिंग","Gender")%>():"—"%></span>
                </div>
                <div class="info-row">
                    <i class="fa fa-calendar" style="color:#f59e0b"></i>
                    <span class="info-label"><%=L(hi,"आयु","Age")%></span>
                    <span><%=p.get<%=L(hi,"आयु","Age")%>()>0?p.get<%=L(hi,"आयु","Age")%>()+" years":"—"%></span>
                </div>
                <div class="info-row">
                    <i class="fa fa-tint" style="color:#ef4444"></i>
                    <span class="info-label">Blood</span>
                    <span class="blood-badge"><%=p.getBloodGroup()!=null?p.getBloodGroup():"—"%></span>
                </div>
                <div class="info-row">
                    <i class="fa fa-map-marker-alt" style="color:#64748b"></i>
                    <span class="info-label"><%=L(hi,"पता","Address")%></span>
                    <span style="font-size:13px"><%=p.get<%=L(hi,"पता","Address")%>()!=null?p.get<%=L(hi,"पता","Address")%>():"—"%></span>
                </div>
            </div>
        </div>

        <!-- Right: <%=L(hi,"अपॉइंटमेंट","Appointments")%> + Bills -->
        <div class="col-lg-8">

            <!-- <%=L(hi,"अपॉइंटमेंट इतिहास","Appointment History")%> -->
            <div class="panel">
                <div class="ph">
                    <span><i class="fa fa-calendar-check me-2" style="color:#2b7cff"></i><%=L(hi,"अपॉइंटमेंट इतिहास","Appointment History")%></span>
                    <span><%=totalAppts%> total</span>
                </div>
                <% if(appts==null||appts.isEmpty()){ %>
                <div class="panel-empty">
                    <i class="fa fa-calendar-xmark fa-2x mb-2" style="color:#e2e8f0;display:block"></i>
                    <%=L(hi,"कोई अपॉइंटमेंट नहीं मिला","No appointments found")%>.
                </div>
                <% }else{ %>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th><%=L(hi,"डॉक्टर","Doctor")%></th><th><%=L(hi,"विभाग","Department")%></th><th>Date</th><th>Time</th><th>Reason</th><th><%=L(hi,"स्थिति","Status")%></th></tr></thead>
                    <tbody>
                    <% for(Object obj:appts){ Appointment a=(Appointment)obj; %>
                    <tr>
                        <td><strong><%=a.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></strong></td>
                        <td><span style="background:#ede9fe;color:#6d28d9;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700"><%=a.get<%=L(hi,"विभाग","Department")%>Name()!=null?a.get<%=L(hi,"विभाग","Department")%>Name():"—"%></span></td>
                        <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                        <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                        <td style="max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:13px"><%=a.getReason()%></td>
                        <td><span class="badge badge-<%=a.get<%=L(hi,"स्थिति","Status")%>()%>"><%=a.get<%=L(hi,"स्थिति","Status")%>().toUpperCase()%></span></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                </div>
                <% } %>
            </div>

            <!-- Bills -->
            <div class="panel">
                <div class="ph">
                    <span><i class="fa fa-file-invoice-dollar me-2" style="color:#f59e0b"></i><%=L(hi,"बिलिंग इतिहास","Billing History")%></span>
                    <span><%=totalBills%> bills</span>
                </div>
                <% if(bills==null||bills.isEmpty()){ %>
                <div class="panel-empty">
                    <i class="fa fa-file-invoice fa-2x mb-2" style="color:#e2e8f0;display:block"></i>
                    <%=L(hi,"कोई बिल नहीं मिला","No bills found")%>.
                </div>
                <% }else{ %>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th>Bill #</th><th><%=L(hi,"डॉक्टर","Doctor")%></th><th><%=L(hi,"निदान","Diagnosis")%></th><th>Total</th><th>Method</th><th><%=L(hi,"स्थिति","Status")%></th><th>PDF</th></tr></thead>
                    <tbody>
                    <% for(Object obj:bills){ Bill b=(Bill)obj; %>
                    <tr>
                        <td style="color:#94a3b8;font-size:12px">#<%=b.getId()%></td>
                        <td style="font-weight:600"><%=b.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></td>
                        <td style="font-size:13px;max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=b.get<%=L(hi,"निदान","Diagnosis")%>()!=null?b.get<%=L(hi,"निदान","Diagnosis")%>():"—"%></td>
                        <td style="font-weight:800;color:#0f172a">₹<%=String.format("%.0f",b.getTotalAmount())%></td>
                        <td style="text-transform:capitalize;font-size:13px"><%=b.getPaymentMethod()!=null?b.getPaymentMethod():"—"%></td>
                        <td><span class="badge badge-<%=b.getPayment<%=L(hi,"स्थिति","Status")%>()%>"><%=b.getPayment<%=L(hi,"स्थिति","Status")%>().toUpperCase()%></span></td>
                        <td><a href="/HospitalManagement/admin/bill/pdf/<%=b.getId()%>" style="color:#2b7cff;font-size:13px" target="_blank"><i class="fa fa-file-pdf"></i> PDF</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                </div>
                <% } %>
            </div>

        </div>
    </div>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
