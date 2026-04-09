<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Book Appointment</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.form-card{background:#fff;border-radius:18px;padding:28px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;max-width:800px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s}
.form-control:focus,.form-select:focus{border-color:#7c3aed;box-shadow:0 0 0 3px rgba(124,58,237,.1)}
.note-box{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af;border-radius:10px;padding:14px 16px;font-size:13px;display:flex;align-items:flex-start;gap:10px}
.btn-submit{background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff;border:none;border-radius:10px;padding:12px 28px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:8px}
.btn-submit:hover{opacity:.9;transform:translateY(-1px)}
.btn-cancel-link{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:12px 22px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-cancel-link:hover{background:#e2e8f0;color:#374151}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
@media(max-width:768px){.dash-main{padding:16px}.form-card{padding:20px}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-calendar-plus me-2" style="color:#7c3aed"></i>Book Appointment</h2>
        <p>Schedule a consultation with one of our specialists.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <div class="form-card">
        <form action="/HospitalManagement/patient/bookAppointment" method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Department *</label>
                    <select name="departmentId" class="form-select" required>
                        <option value="">Select Department</option>
                        <%
                            List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
                            if(depts!=null)for(Map<String,Object> dept:depts){
                        %><option value="<%=dept.get("id")%>"><%=dept.get("name")%></option><%}%>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Select Doctor *</label>
                    <select name="doctorId" class="form-select" required>
                        <option value="">Select Doctor</option>
                        <%
                            List<?> doctors=(List<?>)request.getAttribute("doctors");
                            int preselected=request.getAttribute("preselectedDoctorId")!=null?(int)request.getAttribute("preselectedDoctorId"):0;
                            if(doctors!=null)for(Object obj:doctors){
                                Doctor doc=(Doctor)obj;
                                boolean sel=doc.getId()==preselected;
                        %><option value="<%=doc.getId()%>" <%=sel?"selected":""%>><%=doc.getFullName()%> — <%=doc.getDepartmentName()%> (₹<%=String.format("%.0f",doc.getConsultationFee())%>)</option><%}%>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Appointment Date *</label>
                    <input type="date" name="date" class="form-control" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Preferred Time *</label>
                    <input type="time" name="time" class="form-control" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Reason for Visit *</label>
                    <textarea name="reason" class="form-control" rows="4" placeholder="Describe your symptoms or reason for consultation..." required></textarea>
                </div>
                <div class="col-12">
                    <div class="note-box"><i class="fa fa-info-circle mt-1"></i><span>Your appointment request will be reviewed by the hospital staff. You will receive a confirmation once it's approved.</span></div>
                </div>
            </div>
            <div style="display:flex;gap:12px;margin-top:24px;flex-wrap:wrap">
                <button type="submit" class="btn-submit"><i class="fa fa-calendar-check"></i> Submit Request</button>
                <a href="/HospitalManagement/patient/dashboard" class="btn-cancel-link"><i class="fa fa-arrow-left"></i> Cancel</a>
            </div>
        </form>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
