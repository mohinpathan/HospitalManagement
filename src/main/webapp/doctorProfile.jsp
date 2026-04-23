<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Doctor" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Doctor Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.profile-hero{background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:18px;padding:28px;color:#fff;margin-bottom:24px;display:flex;align-items:center;gap:20px}
.profile-avatar{width:72px;height:72px;border-radius:18px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:30px;flex-shrink:0}
.profile-hero h3{font-size:20px;font-weight:800;margin-bottom:4px}
.profile-hero p{font-size:14px;opacity:.85;margin:0}
.profile-hero .badge-role{background:rgba(255,255,255,.2);color:#fff;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;display:inline-block;margin-top:8px}
.form-card{background:#fff;border-radius:18px;padding:26px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:20px}
.form-card .card-title{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.form-card .card-title i{color:#19b37a}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s}
.form-control:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.form-control[readonly]{background:#f1f5f9;color:#64748b;cursor:not-allowed}
.input-group{display:flex;align-items:stretch}
.ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 13px;display:flex;align-items:center;color:#64748b}
.input-group .form-control{border-radius:0 10px 10px 0}
.btn-save{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:11px 24px;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-save:hover{opacity:.9;transform:translateY(-1px)}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
@media(max-width:768px){.dash-main{padding:16px}.profile-hero{flex-direction:column;text-align:center}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-user-md me-2" style="color:#19b37a"></i>My Profile</h2>
        <p>Manage your professional information and account settings.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); String e=(String)request.getAttribute("pwError");
       if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% }
       if(e!=null){ %><div class="alert-danger"><i class="fa fa-exclamation-circle"></i> <%=e%></div><% } %>

    <%
        Doctor d=(Doctor)request.getAttribute("doctor");
        String name=d!=null?d.getFullName():"";
        String email=d!=null?d.getEmail():"";
        String phone=d!=null?(d.getPhone()!=null?d.getPhone():""):"";
        String spec=d!=null?(d.getSpecialization()!=null?d.getSpecialization():""):"";
        String dept=d!=null?(d.getDepartmentName()!=null?d.getDepartmentName():""):"";
        String addr=d!=null?(d.getAddress()!=null?d.getAddress():""):"";
        String qual=d!=null?(d.getQualification()!=null?d.getQualification():""):"";
        int exp=d!=null?d.getExperienceYrs():0;
        double fee=d!=null?d.getConsultationFee():0;
    %>

    <div class="profile-hero">
        <div class="profile-avatar"><i class="fa fa-user-md"></i></div>
        <div>
            <h3><%=name%></h3>
            <p><%=spec%> &nbsp;|&nbsp; <%=dept%></p>
            <span class="badge-role">DOCTOR</span>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="form-card">
                <div class="card-title"><i class="fa fa-user-edit"></i> Professional Information</div>
                <form action="/HospitalManagement/doctor/updateProfile" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Full Name *</label>
                            <div class="input-group"><span class="ig-icon"><i class="fa fa-user"></i></span><input type="text" name="name" class="form-control" value="<%=name%>" required></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email (read-only)</label>
                            <div class="input-group"><span class="ig-icon"><i class="fa fa-envelope"></i></span><input type="email" class="form-control" value="<%=email%>" readonly></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone</label>
                            <div class="input-group"><span class="ig-icon"><i class="fa fa-phone"></i></span><input type="text" name="phone" class="form-control" value="<%=phone%>"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Specialization (read-only)</label>
                            <input type="text" class="form-control" value="<%=spec%>" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Department (read-only)</label>
                            <input type="text" class="form-control" value="<%=dept%>" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Qualification (read-only)</label>
                            <input type="text" class="form-control" value="<%=qual%>" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Address</label>
                            <input type="text" name="address" class="form-control" value="<%=addr%>">
                        </div>
                    </div>
                    <div style="margin-top:20px">
                        <button type="submit" class="btn-save"><i class="fa fa-save"></i> Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="form-card">
                <div class="card-title"><i class="fa fa-lock"></i> Change Password</div>
                <form action="/HospitalManagement/doctor/changePassword" method="post">
                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <div class="input-group"><span class="ig-icon"><i class="fa fa-lock"></i></span><input type="password" name="currentPass" class="form-control" required></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <div class="input-group"><span class="ig-icon"><i class="fa fa-key"></i></span><input type="password" name="newPass" class="form-control" required minlength="6"></div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Confirm New Password</label>
                        <div class="input-group"><span class="ig-icon"><i class="fa fa-key"></i></span><input type="password" name="confirmPass" class="form-control" required minlength="6"></div>
                    </div>
                    <button type="submit" class="btn-save w-100"><i class="fa fa-shield-halved"></i> Update Password</button>
                </form>
            </div>

            <div class="form-card">
                <div class="card-title"><i class="fa fa-info-circle"></i> Professional Details</div>
                <div style="font-size:14px;color:#374151">
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f1f5f9"><span style="color:#64748b">Experience</span><strong><%=exp%> years</strong></div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f1f5f9"><span style="color:#64748b">Consultation Fee</span><strong style="color:#19b37a">₹<%=String.format("%.0f",fee)%></strong></div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0"><span style="color:#64748b">Status</span><span style="background:#d1fae5;color:#065f46;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700">ACTIVE</span></div>
                </div>
            </div>
        </div>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
