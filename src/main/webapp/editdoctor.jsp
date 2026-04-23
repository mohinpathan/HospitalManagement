<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Edit Doctor</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main fade-in">
  <div class="page-hdr"><h2>Edit Doctor</h2><p>Update doctor information.</p></div>
  <%
    Doctor doc = (Doctor) request.getAttribute("doctor");
    if(doc == null){ %><div class="alert alert-danger">Doctor not found.</div><% } else {
  %>
  <div class="form-card" style="max-width:800px">
    <form action="/HospitalManagement/admin/doctors/edit" method="post">
      <input type="hidden" name="id" value="<%=doc.getId()%>">
      <div class="row g-3">
        <div class="col-md-6">
          <label class="form-label">Full Name *</label>
          <input type="text" name="fullName" class="form-control" value="<%=doc.getFullName()%>" required>
        </div>
        <div class="col-md-6">
          <label class="form-label">Phone</label>
          <input type="text" name="phone" class="form-control" value="<%=doc.getPhone()!=null?doc.getPhone():""%>">
        </div>
        <div class="col-md-6">
          <label class="form-label">Gender</label>
          <select name="gender" class="form-select">
            <option <%="Male".equals(doc.getGender())?"selected":""%>>Male</option>
            <option <%="Female".equals(doc.getGender())?"selected":""%>>Female</option>
            <option <%="Other".equals(doc.getGender())?"selected":""%>>Other</option>
          </select>
        </div>
        <div class="col-md-6">
          <label class="form-label">Qualification</label>
          <input type="text" name="qualification" class="form-control" value="<%=doc.getQualification()!=null?doc.getQualification():""%>">
        </div>
        <div class="col-md-6">
          <label class="form-label">Specialization</label>
          <input type="text" name="specialization" class="form-control" value="<%=doc.getSpecialization()!=null?doc.getSpecialization():""%>">
        </div>
        <div class="col-md-6">
          <label class="form-label">Department</label>
          <select name="departmentId" class="form-select">
            <% List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
               if(depts!=null) for(Map<String,Object> dept:depts){
                 boolean sel = String.valueOf(dept.get("id")).equals(String.valueOf(doc.getDepartmentId())); %>
            <option value="<%=dept.get("id")%>" <%=sel?"selected":""%>><%=dept.get("name")%></option>
            <%}%>
          </select>
        </div>
        <div class="col-md-4">
          <label class="form-label">Experience (Years)</label>
          <input type="number" name="experienceYrs" class="form-control" value="<%=doc.getExperienceYrs()%>" min="0">
        </div>
        <div class="col-md-4">
          <label class="form-label">Consultation Fee (₹)</label>
          <input type="number" step="0.01" name="consultationFee" class="form-control" value="<%=doc.getConsultationFee()%>">
        </div>
        <div class="col-md-4">
          <label class="form-label">Address</label>
          <input type="text" name="address" class="form-control" value="<%=doc.getAddress()!=null?doc.getAddress():""%>">
        </div>
      </div>
      <div class="d-flex gap-3 mt-4">
        <button type="submit" class="btn btn-success"><i class="fa fa-save"></i> Update Doctor</button>
        <a href="/HospitalManagement/admin/doctors" class="btn btn-outline"><i class="fa fa-arrow-left"></i> Cancel</a>
      </div>
    </form>
  </div>
  <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
