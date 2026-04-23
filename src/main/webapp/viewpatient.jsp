<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>View Patient</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

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
.profile-card{background:#fff;border-radius:18px;padding:28px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;text-align:center;margin-bottom:20px}
.profile-avatar{width:90px;height:90px;border-radius:50%;background:linear-gradient(135deg,#dbeafe,#bfdbfe);display:flex;align-items:center;justify-content:center;font-size:36px;color:#2b7cff;margin:0 auto 16px;overflow:hidden}
.profile-avatar img{width:100%;height:100%;object-fit:cover}
.profile-name{font-size:20px;font-weight:800;color:#0f172a;margin-bottom:4px}
.profile-email{font-size:14px;color:#64748b;margin-bottom:12px}
.info-row{display:flex;align-items:center;gap:10px;padding:9px 0;border-bottom:1px solid #f8fafc;font-size:14px;color:#374151;text-align:left}
.info-row:last-child{border-bottom:none}
.info-row i{width:20px;text-align:center}
/* Panel */
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.ph{padding:15px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.ph span{font-size:12px;color:#64748b;font-weight:500}
.panel-empty{padding:32px 20px;text-align:center;color:#94a3b8;font-size:14px}
/* Table */
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:12px 16px;border-bottom:1px solid #e8edf5}
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
.mini-stat{background:#fff;border-radius:14px;padding:16px;text-align:center;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5}
.mini-stat .ms-val{font-size:26px;font-weight:900;color:#0f172a}
.mini-stat .ms-label{font-size:11px;color:#64748b;font-weight:600;text-transform:uppercase;letter-spacing:.5px;margin-top:3px}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-user me-2" style="color:#2b7cff"></i>Patient Details</h2>
            <p>Full patient information, appointment history and bills.</p>
        </div>
        <a href="/HospitalManagement/admin/patients" class="btn-back"><i class="fa fa-arrow-left"></i> Back to Patients</a>
    </div>

    <%
        Patient p = (Patient) request.getAttribute("patient");
        if (p == null) {
    %>
    <div style="background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:12px;padding:16px;display:flex;align-items:center;gap:10px;font-size:14px">
        <i class="fa fa-exclamation-circle fa-lg"></i>
        <strong>Patient not found.</strong> The patient may have been deleted or the ID is invalid.
    </div>
    <% } else {
        List<?> appts = (List<?>) request.getAttribute("appointments");
        List<?> bills  = (List<?>) request.getAttribute("bills");
        int apptCount  = appts  != null ? appts.size()  : 0;
        int billCount  = bills  != null ? bills.size()  : 0;
        int completedCount = 0;
        if (appts != null) for (Object o : appts) { if ("completed".equals(((Appointment)o).getStatus())) completedCount++; }
    %>

    <div class="row g-4">
        <!-- Left: Profile -->
        <div class="col-lg-4">
            <div class="profile-card">
                <div class="profile-avatar">
                    <% if (p.getPhoto() != null && !p.getPhoto().isEmpty()) { %>
                    <img src="<%=p.getPhoto()%>" alt="Photo">
                    <% } else { %>
                    <i class="fa fa-user"></i>
                    <% } %>
                </div>
                <div class="profile-name"><%=p.getFullName()%></div>
                <div class="profile-email"><%=p.getEmail()%></div>
                <span class="badge badge-<%="active".equals(p.getStatus())?"active":"inactive"%>">
                    <%=p.getStatus().toUpperCase()%>
                </span>
                <hr style="border-color:#f1f5f9;margin:16px 0">
                <div class="info-row"><i class="fa fa-phone" style="color:#19b37a"></i> <%=p.getPhone()!=null?p.getPhone():"—"%></div>
                <div class="info-row"><i class="fa fa-venus-mars" style="color:#7c3aed"></i> <%=p.getGender()!=null?p.getGender():"—"%></div>
                <div class="info-row"><i class="fa fa-calendar" style="color:#f59e0b"></i> Age: <%=p.getAge()>0?p.getAge()+" years":"—"%></div>
                <div class="info-row"><i class="fa fa-tint" style="color:#ef4444"></i> Blood Group: <strong><%=p.getBloodGroup()!=null?p.getBloodGroup():"—"%></strong></div>
                <div class="info-row"><i class="fa fa-map-marker-alt" style="color:#64748b"></i> <%=p.getAddress()!=null?p.getAddress():"—"%></div>
            </div>

            <!-- Mini Stats -->
            <div class="mini-stats">
                <div class="mini-stat">
                    <div class="ms-val"><%=apptCount%></div>
                    <div class="ms-label">Appointments</div>
                </div>
                <div class="mini-stat">
                    <div class="ms-val"><%=completedCount%></div>
                    <div class="ms-label">Completed</div>
                </div>
                <div class="mini-stat">
                    <div class="ms-val"><%=billCount%></div>
                    <div class="ms-label">Bills</div>
                </div>
            </div>
        </div>

        <!-- Right: History -->
        <div class="col-lg-8">
            <!-- Appointments -->
            <div class="panel">
                <div class="ph">
                    <span><i class="fa fa-calendar-check me-2" style="color:#2b7cff"></i>Appointment History</span>
                    <span><%=apptCount%> total</span>
                </div>
                <% if (appts == null || appts.isEmpty()) { %>
                <div class="panel-empty"><i class="fa fa-calendar-xmark fa-2x mb-2" style="color:#e2e8f0;display:block"></i>No appointments found.</div>
                <% } else { %>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th>Doctor</th><th>Department</th><th>Date</th><th>Reason</th><th>Status</th></tr></thead>
                    <tbody>
                    <% for (Object obj : appts) { Appointment a = (Appointment) obj; %>
                    <tr>
                        <td><strong><%=a.getDoctorName()%></strong></td>
                        <td><span style="background:#ede9fe;color:#6d28d9;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700"><%=a.getDepartmentName()!=null?a.getDepartmentName():"—"%></span></td>
                        <td style="font-size:13px;font-weight:600"><%=a.getAppointmentDate()%></td>
                        <td style="font-size:13px;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                        <td><span class="badge badge-<%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span></td>
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
                    <span><i class="fa fa-file-invoice-dollar me-2" style="color:#f59e0b"></i>Bills & Payments</span>
                    <span><%=billCount%> total</span>
                </div>
                <% if (bills == null || bills.isEmpty()) { %>
                <div class="panel-empty"><i class="fa fa-file-invoice fa-2x mb-2" style="color:#e2e8f0;display:block"></i>No bills found.</div>
                <% } else { %>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th>Doctor</th><th>Diagnosis</th><th>Total</th><th>Method</th><th>Status</th><th>PDF</th></tr></thead>
                    <tbody>
                    <% for (Object obj : bills) { Bill b = (Bill) obj; %>
                    <tr>
                        <td><strong><%=b.getDoctorName()%></strong></td>
                        <td style="font-size:13px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=b.getDiagnosis()!=null?b.getDiagnosis():"—"%></td>
                        <td style="font-weight:800;color:#0f172a">₹<%=String.format("%.0f",b.getTotalAmount())%></td>
                        <td style="font-size:13px;text-transform:capitalize"><%=b.getPaymentMethod()%></td>
                        <td><span class="badge badge-<%=b.getPaymentStatus()%>"><%=b.getPaymentStatus().toUpperCase()%></span></td>
                        <td><a href="/HospitalManagement/admin/bill/pdf/<%=b.getId()%>" target="_blank" style="color:#2b7cff;font-size:13px"><i class="fa fa-file-pdf"></i> PDF</a></td>
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
