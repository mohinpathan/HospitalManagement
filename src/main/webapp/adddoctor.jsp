<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Add Doctor</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.form-card{background:#fff;border-radius:18px;padding:28px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;max-width:860px}
.section-title{font-size:13px;font-weight:800;color:#94a3b8;letter-spacing:1px;text-transform:uppercase;margin-bottom:16px;padding-bottom:8px;border-bottom:1px solid #f1f5f9}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s}
.form-control:focus,.form-select:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.1)}
.btn-save{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:10px;padding:11px 24px;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-save:hover{opacity:.9;transform:translateY(-1px)}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 20px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
@media(max-width:768px){.dash-main{padding:16px}.form-card{padding:18px}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-user-plus me-2" style="color:#2b7cff"></i>Add New Doctor</h2>
        <p>Fill in the details to register a new doctor in the system.</p>
    </div>

    <% String e=(String)request.getAttribute("error"); if(e!=null){ %><div class="alert-danger"><i class="fa fa-exclamation-circle"></i> <%=e%></div><% } %>

    <div class="form-card">
        <form action="/HospitalManagement/admin/doctors/add" method="post">
            <div class="section-title">Personal Information</div>
            <div class="row g-3 mb-4">
                <div class="col-md-6"><label class="form-label">Full Name *</label><input type="text" name="fullName" class="form-control" placeholder="Dr. John Doe" required></div>
                <div class="col-md-6"><label class="form-label">Email *</label><input type="email" name="email" class="form-control" placeholder="doctor@hospital.com" required></div>
                <div class="col-md-6"><label class="form-label">Phone *</label><input type="text" name="phone" class="form-control" placeholder="+91 98765 43210" required></div>
                <div class="col-md-6"><label class="form-label">Gender *</label><select name="gender" class="form-select" required><option value="">Select</option><option>Male</option><option>Female</option><option>Other</option></select></div>
            </div>

            <div class="section-title">Professional Details</div>
            <div class="row g-3 mb-4">
                <div class="col-md-6"><label class="form-label">Qualification *</label><input type="text" name="qualification" class="form-control" placeholder="MD, FACC" required></div>
                <div class="col-md-6"><label class="form-label">Specialization *</label><input type="text" name="specialization" class="form-control" placeholder="Cardiologist" required></div>
                <div class="col-md-4"><label class="form-label">Department *</label>
                    <select name="departmentId" class="form-select" required>
                        <option value="">Select</option>
                        <% List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
                           if(depts!=null)for(Map<String,Object> dept:depts){ %><option value="<%=dept.get("id")%>"><%=dept.get("name")%></option><%}%>
                    </select>
                </div>
                <div class="col-md-4"><label class="form-label">Experience (Years)</label><input type="number" name="experienceYrs" class="form-control" value="0" min="0"></div>
                <div class="col-md-4"><label class="form-label">Consultation Fee (₹)</label><input type="number" step="0.01" name="consultationFee" class="form-control" value="500"></div>
                <div class="col-12"><label class="form-label">Address</label><input type="text" name="address" class="form-control" placeholder="Hospital address"></div>
            </div>

            <div class="section-title">Account Password</div>
            <div class="row g-3 mb-4">
                <div class="col-md-6"><label class="form-label">Password *</label><input type="password" name="password" class="form-control" required minlength="6" placeholder="Min 6 characters"></div>
                <div class="col-md-6"><label class="form-label">Confirm Password *</label><input type="password" name="confirmPassword" class="form-control" required minlength="6" placeholder="Repeat password"></div>
            </div>

            <div style="display:flex;gap:12px;flex-wrap:wrap">
                <button type="submit" class="btn-save"><i class="fa fa-save"></i> Save Doctor</button>
                <a href="/HospitalManagement/admin/doctors" class="btn-back"><i class="fa fa-arrow-left"></i> Cancel</a>
            </div>
        </form>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
