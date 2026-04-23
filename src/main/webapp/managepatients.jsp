<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Manage Patients</title>
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
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.table-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase;padding:13px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:13px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-active{background:#d1fae5;color:#065f46}
.badge-inactive{background:#fee2e2;color:#991b1b}
.blood-badge{background:#fee2e2;color:#991b1b;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700}
.btn-view{background:#dbeafe;color:#1e40af;border:none;padding:6px 12px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.btn-view:hover{background:#bfdbfe;color:#1e40af}
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
        <h2><i class="fa fa-users me-2" style="color:#19b37a"></i>Manage Patients</h2>
        <p>View and manage all registered patients.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <div class="table-card">
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th>Patient</th><th>Age / Gender</th><th>Blood Group</th><th>Contact</th><th>Address</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
            <%
                List<?> patients=(List<?>)request.getAttribute("patients");
                if(patients==null||patients.isEmpty()){
            %><tr><td colspan="8"><div class="empty-state"><i class="fa fa-users"></i><p>No patients registered yet.</p></div></td></tr><%
            }else{ int idx=1; for(Object obj:patients){ Patient p=(Patient)obj; %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td>
                    <div style="font-weight:700;color:#0f172a"><%=p.getFullName()%></div>
                    <div style="font-size:12px;color:#64748b"><%=p.getEmail()%></div>
                </td>
                <td style="color:#374151"><%=p.getAge()%> / <%=p.getGender()!=null?p.getGender():"—"%></td>
                <td><span class="blood-badge"><%=p.getBloodGroup()!=null?p.getBloodGroup():"—"%></span></td>
                <td style="font-size:12px"><i class="fa fa-phone fa-xs me-1" style="color:#19b37a"></i><%=p.getPhone()!=null?p.getPhone():"—"%></td>
                <td style="font-size:12px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%=p.getAddress()!=null?p.getAddress():"—"%></td>
                <td><span class="badge badge-<%=p.getStatus()%>"><%=p.getStatus().toUpperCase()%></span></td>
                <td>
                    <div style="display:flex;gap:6px">
                        <a href="/HospitalManagement/admin/patients/view?id=<%=p.getId()%>" class="btn-view"><i class="fa fa-eye"></i> View</a>
                        <a href="/HospitalManagement/admin/patients/delete?id=<%=p.getId()%>" class="btn-del" onclick="return confirm('Remove this patient?')"><i class="fa fa-trash"></i></a>
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
