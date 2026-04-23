<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Register - HealthCare Connect</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f4f8;color:#1e293b;display:flex;flex-direction:column;min-height:100vh}
a{text-decoration:none}
.reg-wrap{flex:1;padding:40px 20px}
.reg-card{max-width:880px;margin:0 auto;background:#fff;border-radius:22px;padding:40px;box-shadow:0 8px 32px rgba(0,0,0,.09);border:1px solid #e8edf5}
.reg-card .card-header-area{text-align:center;margin-bottom:32px}
.reg-card .card-icon{width:68px;height:68px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 16px;box-shadow:0 8px 20px rgba(43,124,255,.3)}
.reg-card h2{font-size:26px;font-weight:800;color:#0f172a;margin-bottom:6px}
.reg-card .sub{color:#64748b;font-size:15px}
/* Role tabs */
.role-tabs{display:flex;justify-content:center;gap:12px;margin-bottom:32px}
.role-tab{display:flex;align-items:center;gap:8px;padding:11px 24px;border-radius:12px;font-weight:600;font-size:14px;border:2px solid #e5e7eb;cursor:pointer;transition:all .2s;color:#374151;background:#fff}
.role-tab:hover{border-color:#2b7cff;color:#2b7cff;background:#eff6ff}
.role-tab.active{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border-color:transparent;box-shadow:0 4px 14px rgba(43,124,255,.35)}
/* Form */
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;transition:border-color .2s,box-shadow .2s;outline:none}
.form-control:focus,.form-select:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.1)}
.input-group{display:flex;align-items:stretch}
.input-group .ig-icon{background:#f1f5f9;border:1.5px solid #e5e7eb;border-right:none;border-radius:10px 0 0 10px;padding:0 13px;display:flex;align-items:center;color:#64748b}
.input-group .form-control{border-radius:0 10px 10px 0}
.section-divider{background:#f8fafc;border:1px solid #e8edf5;border-radius:12px;padding:20px;margin-top:20px}
.section-divider .section-label{font-size:11px;font-weight:800;color:#94a3b8;letter-spacing:1px;text-transform:uppercase;margin-bottom:16px}
.btn-register{width:100%;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:12px;padding:14px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;margin-top:8px}
.btn-register:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 8px 20px rgba(43,124,255,.35)}
.alert-msg{padding:11px 14px;border-radius:10px;font-size:14px;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
</style>
<script>
function selectRole(role,el){
    document.querySelectorAll('.role-tab').forEach(t=>t.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('roleInput').value=role;
    document.getElementById('patientFields').style.display=role==='patient'?'block':'none';
    document.getElementById('doctorFields').style.display=role==='doctor'?'block':'none';
}
</script>
</head><body>
<jsp:include page="/header.jsp" />
<div class="reg-wrap">
<div class="reg-card">
    <div class="card-header-area">
        <div class="card-icon"><i class="fa fa-user-plus"></i></div>
        <h2>Create Your Account</h2>
        <p class="sub">Select your role and fill in your details to get started</p>
    </div>

    <% if(request.getAttribute("error")!=null){ %><div class="alert-msg alert-danger"><i class="fa fa-exclamation-circle"></i> <%=request.getAttribute("error")%></div><% } %>

    <div class="role-tabs">
        <div class="role-tab active" onclick="selectRole('patient',this)"><i class="fa fa-user"></i> Patient</div>
        <div class="role-tab" onclick="selectRole('doctor',this)"><i class="fa fa-user-md"></i> Doctor</div>
        <div class="role-tab" onclick="selectRole('admin',this)"><i class="fa fa-user-shield"></i> Admin</div>
    </div>

    <form action="/HospitalManagement/register" method="post">
        <input type="hidden" name="role" id="roleInput" value="patient">

        <div class="section-divider">
            <div class="section-label">Basic Information</div>
            <div class="row g-3">
                <div class="col-md-6"><label class="form-label">Full Name *</label><div class="input-group"><span class="ig-icon"><i class="fa fa-user"></i></span><input type="text" name="fullName" class="form-control" placeholder="John Doe" required></div></div>
                <div class="col-md-6"><label class="form-label">Email Address *</label><div class="input-group"><span class="ig-icon"><i class="fa fa-envelope"></i></span><input type="email" name="email" class="form-control" placeholder="john@example.com" required></div></div>
                <div class="col-md-6"><label class="form-label">Phone Number *</label><div class="input-group"><span class="ig-icon"><i class="fa fa-phone"></i></span><input type="text" name="phone" class="form-control" placeholder="+91 98765 43210" required></div></div>
                <div class="col-md-6"><label class="form-label">Gender *</label><select name="gender" class="form-select" required><option value="">Select Gender</option><option>Male</option><option>Female</option><option>Other</option></select></div>
            </div>
        </div>

        <!-- Patient Fields -->
        <div id="patientFields" class="section-divider">
            <div class="section-label">Patient Details</div>
            <div class="row g-3">
                <div class="col-md-4"><label class="form-label">Age *</label><input type="number" name="age" class="form-control" placeholder="25" min="0"></div>
                <div class="col-md-4"><label class="form-label">Blood Group</label><select name="bloodGroup" class="form-select"><option value="">Select</option><option>O+</option><option>A+</option><option>B+</option><option>AB+</option><option>O-</option><option>A-</option><option>B-</option><option>AB-</option></select></div>
                <div class="col-md-4"><label class="form-label">Address</label><input type="text" name="address" class="form-control" placeholder="Your address"></div>
            </div>
        </div>

        <!-- Doctor Fields -->
        <div id="doctorFields" class="section-divider" style="display:none">
            <div class="section-label">Doctor Details</div>
            <div class="row g-3">
                <div class="col-md-6"><label class="form-label">Qualification *</label><input type="text" name="qualification" class="form-control" placeholder="MD, FACC"></div>
                <div class="col-md-6"><label class="form-label">Specialization *</label><input type="text" name="specialization" class="form-control" placeholder="Cardiologist"></div>
                <div class="col-md-4"><label class="form-label">Department</label><select name="departmentId" class="form-select"><option value="0">Select</option><option value="1">Cardiology</option><option value="2">Neurology</option><option value="3">Pediatrics</option><option value="4">Orthopedics</option><option value="5">Dermatology</option><option value="6">General</option></select></div>
                <div class="col-md-4"><label class="form-label">Experience (Years)</label><input type="number" name="experienceYrs" class="form-control" placeholder="5" min="0"></div>
                <div class="col-md-4"><label class="form-label">Consultation Fee (₹)</label><input type="number" step="0.01" name="consultationFee" class="form-control" placeholder="500"></div>
                <div class="col-12"><label class="form-label">Address</label><input type="text" name="address" class="form-control" placeholder="Hospital address"></div>
            </div>
        </div>

        <div class="section-divider">
            <div class="section-label">Set Password</div>
            <div class="row g-3">
                <div class="col-md-6"><label class="form-label">Password *</label><div class="input-group"><span class="ig-icon"><i class="fa fa-lock"></i></span><input type="password" name="password" class="form-control" required minlength="6" placeholder="Min 6 characters"></div></div>
                <div class="col-md-6"><label class="form-label">Confirm Password *</label><div class="input-group"><span class="ig-icon"><i class="fa fa-lock"></i></span><input type="password" name="confirmPassword" class="form-control" required minlength="6" placeholder="Repeat password"></div></div>
            </div>
        </div>

        <div style="display:flex;align-items:center;gap:8px;margin-top:20px;font-size:14px;color:#374151">
            <input type="checkbox" required style="accent-color:#2b7cff;width:16px;height:16px">
            I agree to the <a href="#" style="color:#2b7cff;font-weight:600">Terms and Conditions</a> and <a href="#" style="color:#2b7cff;font-weight:600">Privacy Policy</a>
        </div>

        <button type="submit" class="btn-register"><i class="fa fa-user-plus me-2"></i>Create Account</button>

        <p style="text-align:center;margin-top:18px;font-size:14px;color:#64748b">
            Already have an account? <a href="/HospitalManagement/login.jsp" style="color:#2b7cff;font-weight:600">Sign In</a>
        </p>
    </form>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
