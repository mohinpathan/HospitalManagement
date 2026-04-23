<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"डॉक्टर प्रबंधन","Manage <%=L(hi,"डॉक्टर","Doctor")%>s")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.page-hdr p{font-size:14px;color:#64748b;margin:3px 0 0}
.btn-add{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:10px;padding:10px 20px;font-size:14px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-add:hover{opacity:.9;color:#fff;transform:translateY(-1px)}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.table-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase;padding:13px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:13px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-active,.badge-approved{background:#d1fae5;color:#065f46}
.badge-inactive,.badge-rejected{background:#fee2e2;color:#991b1b}
.badge-dept{background:#ede9fe;color:#6d28d9}
.btn-edit{background:#fef3c7;color:#92400e;border:none;padding:6px 12px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.btn-edit:hover{background:#fde68a;color:#92400e}
.btn-del{background:#fee2e2;color:#991b1b;border:none;padding:6px 12px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.btn-del:hover{background:#fecaca;color:#991b1b}
.empty-state{text-align:center;padding:60px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:16px;color:#e2e8f0;display:block}
@media(max-width:768px){.dash-main{padding:16px}.tbl{font-size:12px}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-user-md me-2" style="color:#2b7cff"></i><%=L(hi,"डॉक्टर प्रबंधन","Manage <%=L(hi,"डॉक्टर","Doctor")%>s")%></h2>
            <p>Add, edit or remove doctors from the system.</p>
        </div>
        <a href="/HospitalManagement/admin/doctors/add" class="btn-add"><i class="fa fa-plus"></i> <%=L(hi,"डॉक्टर जोड़ें","Add <%=L(hi,"डॉक्टर","Doctor")%>")%></a>
    </div>

    <% String s=(String)request.getAttribute("success"); String e=(String)request.getAttribute("error");
       if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% }
       if(e!=null){ %><div class="alert-danger"><i class="fa fa-exclamation-circle"></i> <%=e%></div><% } %>

    <div class="table-card">
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th><%=L(hi,"डॉक्टर","Doctor")%></th><th>Specialization</th><th><%=L(hi,"विभाग","Department")%></th><th>Exp.</th><th>Fee</th><th>Contact</th><th><%=L(hi,"स्थिति","Status")%></th><th><%=L(hi,"कार्रवाई","Actions")%></th></tr></thead>
            <tbody>
            <%
                List<?> doctors=(List<?>)request.getAttribute("doctors");
                if(doctors==null||doctors.isEmpty()){
            %><tr><td colspan="9"><div class="empty-state"><i class="fa fa-user-md"></i><p><%=L(hi,"कोई डॉक्टर नहीं मिला","No doctors found")%>. <a href="/HospitalManagement/admin/doctors/add" style="color:#2b7cff;font-weight:600">Add one now</a></p></div></td></tr><%
            }else{ int idx=1; for(Object obj:doctors){ <%=L(hi,"डॉक्टर","Doctor")%> d=(<%=L(hi,"डॉक्टर","Doctor")%>)obj; %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td>
                    <div style="font-weight:700;color:#0f172a"><%=d.getFullName()%></div>
                    <div style="font-size:12px;color:#64748b"><%=d.getQualification()!=null?d.getQualification():""%></div>
                </td>
                <td><span class="badge badge-dept"><%=d.getSpecialization()!=null?d.getSpecialization():"—"%></span></td>
                <td style="color:#374151"><%=d.get<%=L(hi,"विभाग","Department")%>Name()!=null?d.get<%=L(hi,"विभाग","Department")%>Name():"—"%></td>
                <td style="color:#374151"><%=d.getExperienceYrs()%> yrs</td>
                <td style="font-weight:700;color:#0f172a">₹<%=String.format("%.0f",d.getConsultationFee())%></td>
                <td style="font-size:12px">
                    <div><i class="fa fa-envelope fa-xs me-1" style="color:#2b7cff"></i><%=d.getEmail()%></div>
                    <div><i class="fa fa-phone fa-xs me-1" style="color:#19b37a"></i><%=d.get<%=L(hi,"फ़ोन","Phone")%>()!=null?d.get<%=L(hi,"फ़ोन","Phone")%>():"—"%></div>
                </td>
                <td><span class="badge badge-<%=d.get<%=L(hi,"स्थिति","Status")%>()%>"><%=d.get<%=L(hi,"स्थिति","Status")%>().toUpperCase()%></span></td>
                <td>
                    <div style="display:flex;gap:6px">
                        <a href="/HospitalManagement/admin/doctors/edit?id=<%=d.getId()%>" class="btn-edit"><i class="fa fa-pen"></i> <%=L(hi,"संपादित करें","Edit")%></a>
                        <a href="/HospitalManagement/admin/doctors/delete?id=<%=d.getId()%>" class="btn-del" onclick="return confirm('Remove this doctor?')"><i class="fa fa-trash"></i> <%=L(hi,"हटाएं","Delete")%></a>
                    </div>
                </td>
            </tr>
            <%}} %>
            </tbody>
        </table>
        </div>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
