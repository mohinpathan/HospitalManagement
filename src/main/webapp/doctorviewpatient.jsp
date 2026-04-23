<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Patient Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 18px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
.profile-card{background:#fff;border-radius:18px;padding:24px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;text-align:center;margin-bottom:20px}
.profile-avatar{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#d1fae5,#a7f3d0);display:flex;align-items:center;justify-content:center;margin:0 auto 14px;font-size:32px;color:#19b37a;overflow:hidden}
.profile-avatar img{width:100%;height:100%;object-fit:cover;border-radius:50%}
.info-row{display:flex;align-items:center;gap:10px;padding:8px 0;border-bottom:1px solid #f8fafc;font-size:14px;color:#374151;text-align:left}
.info-row:last-child{border-bottom:none}
.info-row i{width:18px;text-align:center}
/* Panel */
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px}
.ph{padding:15px 20px;border-bottom:1px solid #f1f5f9;font-weight:700;font-size:15px;display:flex;justify-content:space-between;align-items:center;color:#0f172a}
.panel-empty{padding:28px 20px;text-align:center;color:#94a3b8;font-size:14px}
/* Table */
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.5px;text-transform:uppercase;padding:11px 14px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:12px 14px;font-size:13px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#f0fdf4}
/* Badges */
.badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700}
.badge-approved,.badge-confirmed,.badge-active{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-completed{background:#dbeafe;color:#1e40af}
.badge-rejected,.badge-cancelled{background:#fee2e2;color:#991b1b}
/* Upload form */
.upload-form{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:20px}
.upload-form h5{font-size:15px;font-weight:700;color:#0f172a;margin-bottom:16px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:5px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 13px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.form-control:focus,.form-select:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-upload{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-upload:hover{opacity:.9;transform:translateY(-1px)}
.btn-note{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-note:hover{opacity:.9}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.note-item{padding:12px 16px;border-bottom:1px solid #f8fafc;font-size:14px;color:#374151}
.note-item:last-child{border-bottom:none}
.note-time{font-size:11px;color:#94a3b8;margin-top:4px}
.report-item{padding:12px 16px;border-bottom:1px solid #f8fafc;display:flex;justify-content:space-between;align-items:center}
.report-item:last-child{border-bottom:none}
.report-type{background:#ede9fe;color:#6d28d9;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700;text-transform:capitalize}
@media(max-width:768px){.dash-main{padding:16px}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-user me-2" style="color:#19b37a"></i>Patient Details</h2>
        <a href="/HospitalManagement/doctor/patients" class="btn-back"><i class="fa fa-arrow-left"></i> Back</a>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <%
        Patient p=(Patient)request.getAttribute("patient");
        if(p==null){
    %><div style="background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:16px">Patient not found.</div><%
    }else{
        List<?> appts=(List<?>)request.getAttribute("appointments");
        List<Map<String,Object>> reports=(List<Map<String,Object>>)request.getAttribute("reports");
        List<Map<String,Object>> notes=(List<Map<String,Object>>)request.getAttribute("notes");
    %>

    <div class="row g-4">
        <!-- Profile -->
        <div class="col-lg-4">
            <div class="profile-card">
                <div class="profile-avatar">
                    <%if(p.getPhoto()!=null&&!p.getPhoto().isEmpty()){%><img src="<%=p.getPhoto()%>" alt=""><%}else{%><i class="fa fa-user"></i><%}%>
                </div>
                <h4 style="font-weight:800;color:#0f172a;margin-bottom:4px"><%=p.getFullName()%></h4>
                <p style="color:#64748b;font-size:13px;margin-bottom:12px"><%=p.getEmail()%></p>
                <hr style="border-color:#f1f5f9;margin:12px 0">
                <div class="info-row"><i class="fa fa-phone" style="color:#19b37a"></i> <%=p.getPhone()!=null?p.getPhone():"—"%></div>
                <div class="info-row"><i class="fa fa-venus-mars" style="color:#7c3aed"></i> <%=p.getGender()!=null?p.getGender():"—"%></div>
                <div class="info-row"><i class="fa fa-calendar" style="color:#f59e0b"></i> Age: <%=p.getAge()>0?p.getAge():"—"%></div>
                <div class="info-row"><i class="fa fa-tint" style="color:#ef4444"></i> <span style="background:#fee2e2;color:#991b1b;padding:2px 8px;border-radius:20px;font-size:11px;font-weight:700"><%=p.getBloodGroup()!=null?p.getBloodGroup():"—"%></span></div>
                <div class="info-row"><i class="fa fa-map-marker-alt" style="color:#64748b"></i> <span style="font-size:12px"><%=p.getAddress()!=null?p.getAddress():"—"%></span></div>
            </div>

            <!-- Add Note -->
            <div class="upload-form">
                <h5><i class="fa fa-sticky-note me-2" style="color:#2b7cff"></i>Add Private Note</h5>
                <form action="/HospitalManagement/doctor/patient/note" method="post">
                    <input type="hidden" name="patientId" value="<%=p.getId()%>">
                    <div class="mb-3">
                        <label class="form-label">Note</label>
                        <textarea name="note" class="form-control" rows="3" placeholder="Private note about this patient..." required></textarea>
                    </div>
                    <button type="submit" class="btn-note w-100"><i class="fa fa-save"></i> Save Note</button>
                </form>
            </div>
        </div>

        <!-- Right side -->
        <div class="col-lg-8">

            <!-- Upload Report -->
            <div class="upload-form">
                <h5><i class="fa fa-upload me-2" style="color:#19b37a"></i>Upload Report / X-Ray</h5>
                <form action="/HospitalManagement/doctor/patient/uploadReport" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="patientId" value="<%=p.getId()%>">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Report Type *</label>
                            <select name="reportType" class="form-select" required>
                                <option value="xray">X-Ray</option>
                                <option value="lab">Lab Report</option>
                                <option value="prescription">Prescription</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Appointment (optional)</label>
                            <select name="appointmentId" class="form-select">
                                <option value="0">Select Appointment</option>
                                <%if(appts!=null)for(Object obj:appts){com.hospital.model.Appointment a=(com.hospital.model.Appointment)obj;%>
                                <option value="<%=a.getId()%>"><%=a.getAppointmentDate()%> — <%=a.getReason()%></option>
                                <%}%>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">File *</label>
                            <input type="file" name="reportFile" class="form-control" required accept=".pdf,.jpg,.jpeg,.png,.doc,.docx">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description</label>
                            <input type="text" name="description" class="form-control" placeholder="Brief description of the report">
                        </div>
                        <div class="col-12">
                            <div style="display:flex;align-items:center;gap:8px;font-size:14px;color:#374151;margin-bottom:12px">
                                <input type="checkbox" name="sendEmail" style="accent-color:#19b37a;width:16px;height:16px">
                                <span>Send email notification to patient</span>
                            </div>
                            <button type="submit" class="btn-upload"><i class="fa fa-cloud-upload-alt"></i> Upload Report</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Uploaded Reports -->
            <div class="panel">
                <div class="ph"><span><i class="fa fa-folder-open me-2" style="color:#7c3aed"></i>Uploaded Reports</span></div>
                <%if(reports==null||reports.isEmpty()){%>
                <div class="panel-empty">No reports uploaded yet.</div>
                <%}else{for(Map<String,Object> r:reports){%>
                <div class="report-item">
                    <div>
                        <span class="report-type"><%=r.get("report_type")%></span>
                        <div style="font-weight:600;font-size:14px;color:#0f172a;margin-top:5px"><%=r.get("file_name")%></div>
                        <div style="font-size:12px;color:#64748b;margin-top:2px"><%=r.get("description")!=null?r.get("description"):""%></div>
                        <div style="font-size:11px;color:#94a3b8;margin-top:3px"><i class="fa fa-clock fa-xs me-1"></i><%=r.get("created_at")%></div>
                    </div>
                    <div style="display:flex;align-items:center;gap:10px">
                        <%if(Boolean.TRUE.equals(r.get("email_sent"))||Integer.valueOf(1).equals(r.get("email_sent"))){%>
                        <span style="background:#d1fae5;color:#065f46;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:700"><i class="fa fa-envelope-circle-check me-1"></i>Sent</span>
                        <%}%>
                        <a href="<%=r.get("file_path")%>" target="_blank" style="color:#2b7cff;font-size:13px;font-weight:600"><i class="fa fa-download me-1"></i>Download</a>
                    </div>
                </div>
                <%}}%>
            </div>

            <!-- Appointment History -->
            <div class="panel">
                <div class="ph"><span><i class="fa fa-calendar-check me-2" style="color:#2b7cff"></i>Appointment History</span></div>
                <%if(appts==null||appts.isEmpty()){%>
                <div class="panel-empty">No appointments found.</div>
                <%}else{%>
                <div style="overflow-x:auto">
                <table class="tbl">
                    <thead><tr><th>Date</th><th>Time</th><th>Reason</th><th>Status</th></tr></thead>
                    <tbody>
                    <%for(Object obj:appts){com.hospital.model.Appointment a=(com.hospital.model.Appointment)obj;%>
                    <tr>
                        <td style="font-weight:600"><%=a.getAppointmentDate()%></td>
                        <td style="color:#64748b"><%=a.getAppointmentTime()%></td>
                        <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=a.getReason()%></td>
                        <td><span class="badge badge-<%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span></td>
                    </tr>
                    <%}%>
                    </tbody>
                </table>
                </div>
                <%}%>
            </div>

            <!-- Private Notes -->
            <div class="panel">
                <div class="ph"><span><i class="fa fa-sticky-note me-2" style="color:#f59e0b"></i>My Notes</span></div>
                <%if(notes==null||notes.isEmpty()){%>
                <div class="panel-empty">No notes yet.</div>
                <%}else{for(Map<String,Object> n:notes){%>
                <div class="note-item">
                    <div><%=n.get("note")%></div>
                    <div class="note-time"><i class="fa fa-clock fa-xs me-1"></i><%=n.get("created_at")%></div>
                </div>
                <%}}%>
            </div>

        </div>
    </div>
    <%}%>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
