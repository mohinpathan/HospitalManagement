<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Patient Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 18px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
.profile-card{background:#fff;border-radius:18px;padding:24px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:20px}
.profile-avatar{width:72px;height:72px;border-radius:18px;background:linear-gradient(135deg,#d1fae5,#a7f3d0);display:flex;align-items:center;justify-content:center;font-size:28px;color:#19b37a;overflow:hidden}
.profile-avatar img{width:100%;height:100%;object-fit:cover}
.info-chip{display:inline-flex;align-items:center;gap:6px;background:#f8fafc;border:1px solid #e5e7eb;border-radius:20px;padding:5px 12px;font-size:12px;font-weight:600;color:#374151;margin:3px}
.info-chip.blood{background:#fee2e2;color:#991b1b;border-color:#fecaca}
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.ph{padding:15px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-empty{padding:28px 20px;text-align:center;color:#94a3b8;font-size:14px}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:11px 16px;border-bottom:1px solid #e8edf5}
.tbl tbody td{padding:12px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#f0fdf4}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved,.badge-confirmed{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled{background:#fee2e2;color:#991b1b}
/* Form */
.form-card{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:20px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s;margin-bottom:14px}
.form-control:focus,.form-select:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-green{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-green:hover{opacity:.9;transform:translateY(-1px)}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
/* Note item */
.note-item{padding:12px 16px;border-bottom:1px solid #f8fafc;font-size:14px;color:#374151}
.note-item:last-child{border-bottom:none}
.note-time{font-size:11px;color:#94a3b8;margin-top:4px}
/* Report item */
.report-item{padding:12px 16px;border-bottom:1px solid #f8fafc;display:flex;align-items:center;gap:12px}
.report-item:last-child{border-bottom:none}
.report-icon{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.ri-xray{background:#dbeafe;color:#2b7cff}
.ri-lab{background:#d1fae5;color:#065f46}
.ri-prescription{background:#ede9fe;color:#7c3aed}
.ri-other{background:#fef3c7;color:#92400e}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-user me-2" style="color:#19b37a"></i>Patient Details</h2>
        <a href="/HospitalManagement/doctor/patients" class="btn-back"><i class="fa fa-arrow-left"></i> My Patients</a>
    </div>

    <% String s=(String)request.getAttribute("success"); String e=(String)request.getAttribute("error");
       if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% }
       if(e!=null){ %><div class="alert-danger"><i class="fa fa-exclamation-circle"></i> <%=e%></div><% } %>

    <%
        Patient p = (Patient) request.getAttribute("patient");
        if (p == null) {
    %><div class="alert-danger"><i class="fa fa-exclamation-circle"></i> Patient not found.</div><%
    } else {
        List<?> appts   = (List<?>) request.getAttribute("appointments");
        List<Map<String,Object>> reports = (List<Map<String,Object>>) request.getAttribute("reports");
        List<Map<String,Object>> notes   = (List<Map<String,Object>>) request.getAttribute("notes");
    %>

    <!-- Profile -->
    <div class="profile-card">
        <div style="display:flex;align-items:center;gap:18px;flex-wrap:wrap">
            <div class="profile-avatar">
                <% if (p.getPhoto() != null && !p.getPhoto().isEmpty()) { %>
                <img src="<%=p.getPhoto()%>" alt="Photo">
                <% } else { %><i class="fa fa-user"></i><% } %>
            </div>
            <div>
                <div style="font-size:20px;font-weight:800;color:#0f172a;margin-bottom:6px"><%=p.getFullName()%></div>
                <div style="font-size:14px;color:#64748b;margin-bottom:10px"><%=p.getEmail()%></div>
                <div>
                    <% if(p.getPhone()!=null){ %><span class="info-chip"><i class="fa fa-phone" style="color:#19b37a"></i><%=p.getPhone()%></span><% } %>
                    <% if(p.getGender()!=null){ %><span class="info-chip"><i class="fa fa-venus-mars" style="color:#7c3aed"></i><%=p.getGender()%></span><% } %>
                    <% if(p.getAge()>0){ %><span class="info-chip"><i class="fa fa-calendar" style="color:#f59e0b"></i>Age <%=p.getAge()%></span><% } %>
                    <% if(p.getBloodGroup()!=null){ %><span class="info-chip blood"><i class="fa fa-tint"></i><%=p.getBloodGroup()%></span><% } %>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <!-- Appointments -->
            <div class="panel">
                <div class="ph"><span><i class="fa fa-calendar-check me-2" style="color:#19b37a"></i>Appointment History</span></div>
                <% if(appts==null||appts.isEmpty()){ %>
                <div class="panel-empty">No appointments found.</div>
                <% }else{ %>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th>Date</th><th>Time</th><th>Reason</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                    <% for(Object obj:appts){ Appointment a=(Appointment)obj; %>
                    <tr>
                        <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                        <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                        <td style="font-size:13px;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                        <td><span class="badge badge-<%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span></td>
                        <td><%if("approved".equals(a.getStatus())){%><a href="/HospitalManagement/doctor/prescription/<%=a.getId()%>" style="color:#19b37a;font-size:13px;font-weight:600"><i class="fa fa-file-prescription me-1"></i>Prescribe</a><%}else{%><span style="color:#94a3b8;font-size:12px">—</span><%}%></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                </div>
                <% } %>
            </div>

            <!-- Reports -->
            <div class="panel">
                <div class="ph"><span><i class="fa fa-file-medical me-2" style="color:#7c3aed"></i>Uploaded Reports</span></div>
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
                        <div style="font-size:12px;color:#64748b"><%=r.get("description")!=null?r.get("description"):""%></div>
                        <div style="font-size:11px;color:#94a3b8;margin-top:2px"><%=r.get("created_at")%></div>
                    </div>
                    <a href="<%=r.get("file_path")%>" target="_blank" style="color:#2b7cff;font-size:13px;font-weight:600"><i class="fa fa-download me-1"></i>Download</a>
                </div>
                <% }} %>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Upload Report -->
            <div class="form-card">
                <h5 style="font-weight:800;color:#0f172a;margin-bottom:16px"><i class="fa fa-upload me-2" style="color:#7c3aed"></i>Upload Report / X-Ray</h5>
                <form action="/HospitalManagement/doctor/patients/uploadReport" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="patientId" value="<%=p.getId()%>">
                    <label class="form-label">Report Type *</label>
                    <select name="reportType" class="form-select" required>
                        <option value="xray">X-Ray</option>
                        <option value="lab">Lab Report</option>
                        <option value="prescription">Prescription</option>
                        <option value="other">Other</option>
                    </select>
                    <label class="form-label">Appointment (optional)</label>
                    <select name="appointmentId" class="form-select">
                        <option value="0">Select appointment</option>
                        <% if(appts!=null)for(Object obj:appts){ Appointment a=(Appointment)obj; %>
                        <option value="<%=a.getId()%>"><%=a.getAppointmentDate()%> — <%=a.getReason()%></option>
                        <% } %>
                    </select>
                    <label class="form-label">Description</label>
                    <input type="text" name="description" class="form-control" placeholder="Brief description">
                    <label class="form-label">File * (PDF, JPG, PNG — max 20MB)</label>
                    <input type="file" name="reportFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png" required>
                    <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px;font-size:13px;color:#374151">
                        <input type="checkbox" name="sendEmail" value="true" id="sendEmailChk" style="accent-color:#19b37a;width:16px;height:16px">
                        <label for="sendEmailChk">Notify patient via email</label>
                    </div>
                    <button type="submit" class="btn-green w-100"><i class="fa fa-upload"></i> Upload Report</button>
                </form>
            </div>

            <!-- Add Note -->
            <div class="form-card">
                <h5 style="font-weight:800;color:#0f172a;margin-bottom:16px"><i class="fa fa-note-sticky me-2" style="color:#f59e0b"></i>Doctor Notes</h5>
                <form action="/HospitalManagement/doctor/patients/addNote" method="post">
                    <input type="hidden" name="patientId" value="<%=p.getId()%>">
                    <label class="form-label">Add Note</label>
                    <textarea name="note" class="form-control" rows="3" placeholder="Clinical notes, observations..." required></textarea>
                    <button type="submit" class="btn-green w-100"><i class="fa fa-plus"></i> Add Note</button>
                </form>
                <% if(notes!=null&&!notes.isEmpty()){ %>
                <div style="margin-top:16px;border-top:1px solid #f1f5f9;padding-top:12px">
                    <div style="font-size:12px;font-weight:700;color:#94a3b8;letter-spacing:.5px;text-transform:uppercase;margin-bottom:8px">Previous Notes</div>
                    <% for(Map<String,Object> n:notes){ %>
                    <div class="note-item">
                        <div><%=n.get("note")%></div>
                        <div class="note-time"><i class="fa fa-clock fa-xs me-1"></i><%=n.get("created_at")%></div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
