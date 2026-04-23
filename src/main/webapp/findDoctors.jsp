<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Find Doctors</title>
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
/* Filter Card */
.filter-card{background:#fff;border-radius:16px;padding:20px 24px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:24px}
.filter-card .form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.filter-card .form-control,.filter-card .form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.filter-card .form-control:focus,.filter-card .form-select:focus{border-color:#7c3aed;box-shadow:0 0 0 3px rgba(124,58,237,.1)}
.btn-filter{background:linear-gradient(135deg,#7c3aed,#6d28d9);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-filter:hover{opacity:.9;transform:translateY(-1px)}
.btn-clear{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 18px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px;text-decoration:none}
.btn-clear:hover{background:#e2e8f0;color:#374151}
/* Results info */
.results-info{font-size:14px;color:#64748b;margin-bottom:16px;font-weight:500}
.results-info span{color:#7c3aed;font-weight:700}
/* Doctor Grid */
.doc-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px}
.doc-card{background:#fff;border-radius:18px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;transition:all .25s;display:flex;flex-direction:column}
.doc-card:hover{transform:translateY(-5px);box-shadow:0 12px 32px rgba(0,0,0,.12)}
.doc-card-top{height:6px;background:linear-gradient(90deg,#7c3aed,#8b5cf6)}
.doc-card-body{padding:22px;flex:1;display:flex;flex-direction:column}
.doc-avatar{width:56px;height:56px;border-radius:14px;background:linear-gradient(135deg,#ede9fe,#ddd6fe);display:flex;align-items:center;justify-content:center;font-size:22px;color:#7c3aed;margin-bottom:14px}
.doc-name{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:4px}
.doc-spec{font-size:13px;color:#7c3aed;font-weight:600;margin-bottom:14px}
.doc-badge{display:inline-block;background:#ede9fe;color:#6d28d9;font-size:11px;font-weight:700;padding:3px 10px;border-radius:20px;margin-bottom:14px}
.doc-info-row{display:flex;align-items:center;gap:8px;font-size:13px;color:#475569;margin-bottom:7px}
.doc-info-row i{width:16px;text-align:center;color:#94a3b8}
.doc-fee{font-size:18px;font-weight:800;color:#0f172a;margin:12px 0 16px}
.doc-fee span{font-size:13px;font-weight:500;color:#64748b}
.btn-book{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;border:none;border-radius:10px;padding:11px;font-size:14px;font-weight:600;cursor:pointer;width:100%;transition:all .2s;text-decoration:none;display:block;text-align:center}
.btn-book:hover{opacity:.9;color:#fff;transform:translateY(-1px)}
/* Empty state */
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:16px;color:#e2e8f0}
.empty-state h4{font-size:18px;font-weight:700;color:#374151;margin-bottom:8px}
/* Responsive */
@media(max-width:768px){.dash-main{padding:16px}.doc-grid{grid-template-columns:1fr}}
@media(max-width:576px){.filter-card .row{flex-direction:column}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-search me-2" style="color:#7c3aed"></i>Find a Doctor</h2>
        <p>Search and filter doctors by specialization, department, or consultation fee.</p>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <form action="/HospitalManagement/patient/findDoctors" method="get">
            <div class="row g-3 align-items-end">
                <div class="col-md-3 col-sm-6">
                    <label class="form-label">Search by Name</label>
                    <input type="text" name="search" class="form-control" placeholder="Doctor name..." value="<%= request.getParameter("search")!=null?request.getParameter("search"):"" %>">
                </div>
                <div class="col-md-3 col-sm-6">
                    <label class="form-label">Department</label>
                    <select name="dept" class="form-select">
                        <option value="0">All Departments</option>
                        <%
                            List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
                            String selDept=request.getParameter("dept");
                            if(depts!=null)for(Map<String,Object> d:depts){
                                boolean sel=String.valueOf(d.get("id")).equals(selDept);
                        %><option value="<%=d.get("id")%>" <%=sel?"selected":""%>><%=d.get("name")%></option><%}%>
                    </select>
                </div>
                <div class="col-md-2 col-sm-6">
                    <label class="form-label">Max Fee (₹)</label>
                    <input type="number" name="maxFee" class="form-control" placeholder="e.g. 1000" value="<%= request.getParameter("maxFee")!=null?request.getParameter("maxFee"):"" %>">
                </div>
                <div class="col-md-2 col-sm-6">
                    <label class="form-label">Sort By</label>
                    <select name="sort" class="form-select">
                        <option value="">Default</option>
                        <option value="fee_asc" <%="fee_asc".equals(request.getParameter("sort"))?"selected":""%>>Fee: Low to High</option>
                        <option value="fee_desc" <%="fee_desc".equals(request.getParameter("sort"))?"selected":""%>>Fee: High to Low</option>
                        <option value="exp_desc" <%="exp_desc".equals(request.getParameter("sort"))?"selected":""%>>Most Experienced</option>
                    </select>
                </div>
                <div class="col-md-2 col-sm-12">
                    <div style="display:flex;gap:8px">
                        <button type="submit" class="btn-filter"><i class="fa fa-search"></i> Search</button>
                        <a href="/HospitalManagement/patient/findDoctors" class="btn-clear"><i class="fa fa-times"></i></a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Results -->
    <%
        List<?> doctors=(List<?>)request.getAttribute("doctors");
        int total=doctors!=null?doctors.size():0;
    %>
    <div class="results-info">Showing <span><%=total%></span> doctor<%= total!=1?"s":"" %></div>

    <% if(doctors==null||doctors.isEmpty()){ %>
    <div class="empty-state">
        <i class="fa fa-user-md"></i>
        <h4>No doctors found</h4>
        <p>Try adjusting your search filters.</p>
        <a href="/HospitalManagement/patient/findDoctors" class="btn-clear mt-3">Clear Filters</a>
    </div>
    <% }else{ %>
    <div class="doc-grid">
    <% for(Object obj:doctors){ Doctor d=(Doctor)obj; %>
    <div class="doc-card">
        <div class="doc-card-top"></div>
        <div class="doc-card-body">
            <div style="display:flex;justify-content:space-between;align-items:flex-start">
                <div class="doc-avatar"><i class="fa fa-user-md"></i></div>
                <span class="doc-badge"><%=d.getDepartmentName()!=null?d.getDepartmentName():"General"%></span>
            </div>
            <div class="doc-name"><%=d.getFullName()%></div>
            <div class="doc-spec"><%=d.getSpecialization()!=null?d.getSpecialization():"Specialist"%></div>
            <div class="doc-info-row"><i class="fa fa-graduation-cap"></i> <%=d.getQualification()!=null?d.getQualification():"—"%></div>
            <div class="doc-info-row"><i class="fa fa-briefcase-medical"></i> <%=d.getExperienceYrs()%> years experience</div>
            <div class="doc-info-row"><i class="fa fa-phone"></i> <%=d.getPhone()!=null?d.getPhone():"—"%></div>
            <div class="doc-info-row"><i class="fa fa-envelope"></i> <%=d.getEmail()%></div>
            <div class="doc-fee">₹<%=String.format("%.0f",d.getConsultationFee())%> <span>/ consultation</span></div>
            <a href="/HospitalManagement/patient/bookAppointment?doctorId=<%=d.getId()%>" class="btn-book"><i class="fa fa-calendar-plus me-2"></i>Book Appointment</a>
        </div>
    </div>
    <% }} %>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
