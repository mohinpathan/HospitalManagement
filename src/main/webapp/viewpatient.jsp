<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>View Patient</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main fade-in">

  <div class="page-hdr d-flex justify-content-between align-items-center">
    <div><h2>Patient Details</h2><p>Full patient information and history.</p></div>
    <a href="/HospitalManagement/admin/patients" class="btn btn-outline"><i class="fa fa-arrow-left"></i> Back</a>
  </div>

  <%
    Patient p = (Patient) request.getAttribute("patient");
    if(p == null){ %><div class="alert alert-danger">Patient not found.</div><% } else {
  %>
  <div class="row g-4 mb-4">
    <div class="col-md-4">
      <div class="form-card text-center">
        <div style="width:80px;height:80px;background:#dbeafe;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:32px;color:#2b7cff">
          <i class="fa fa-user"></i>
        </div>
        <h4 style="font-weight:700;color:#0f172a"><%=p.getFullName()%></h4>
        <p style="color:#64748b;font-size:14px"><%=p.getEmail()%></p>
        <span class="badge badge-<%="active".equals(p.getStatus())?"approved":"rejected"%>"><%=p.getStatus()%></span>
        <hr style="border-color:#f1f5f9;margin:16px 0">
        <div style="text-align:left;font-size:14px">
          <div class="mb-2"><i class="fa fa-phone me-2" style="color:#19b37a"></i><%=p.getPhone()!=null?p.getPhone():"—"%></div>
          <div class="mb-2"><i class="fa fa-venus-mars me-2" style="color:#7c3aed"></i><%=p.getGender()!=null?p.getGender():"—"%></div>
          <div class="mb-2"><i class="fa fa-calendar me-2" style="color:#f59e0b"></i>Age: <%=p.getAge()%></div>
          <div class="mb-2"><i class="fa fa-tint me-2" style="color:#ef4444"></i>Blood: <%=p.getBloodGroup()!=null?p.getBloodGroup():"—"%></div>
          <div><i class="fa fa-map-marker-alt me-2" style="color:#64748b"></i><%=p.getAddress()!=null?p.getAddress():"—"%></div>
        </div>
      </div>
    </div>

    <div class="col-md-8">
      <div class="panel">
        <div class="panel-head">Appointment History</div>
        <%
          List<?> appts=(List<?>)request.getAttribute("appointments");
          if(appts==null||appts.isEmpty()){
        %><div class="panel-empty">No appointments found.</div><%
          } else {
        %>
        <table class="table">
          <thead><tr><th>Doctor</th><th>Date</th><th>Reason</th><th>Status</th></tr></thead>
          <tbody>
          <% for(Object obj:appts){ Appointment a=(Appointment)obj; %>
          <tr>
            <td style="font-weight:600"><%=a.getDoctorName()%></td>
            <td style="font-size:13px"><%=a.getAppointmentDate()%></td>
            <td style="font-size:13px;color:#374151"><%=a.getReason()%></td>
            <td><span class="badge badge-<%=a.getStatus()%>"><%=a.getStatus().toUpperCase()%></span></td>
          </tr>
          <%}%>
          </tbody>
        </table>
        <%}%>
      </div>
    </div>
  </div>
  <%}%>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
