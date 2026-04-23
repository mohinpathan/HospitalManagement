<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Manage <%=L(hi,"विभाग","<%=L(hi,"विभाग","Department")%>s")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.page-hdr p{font-size:14px;color:#64748b;margin:3px 0 0}
.btn-add{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:10px;padding:10px 20px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-add:hover{opacity:.9;color:#fff;transform:translateY(-1px)}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
/* Add form */
.add-form-card{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:24px;display:none}
.add-form-card.show{display:block}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.form-control:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.1)}
.btn-save{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:10px;padding:10px 20px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-save:hover{opacity:.9}
/* Dept grid */
.dept-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:18px}
.dept-card{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;transition:all .2s;position:relative}
.dept-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(0,0,0,.1)}
.dept-card .dept-icon{width:48px;height:48px;border-radius:12px;background:linear-gradient(135deg,#eff6ff,#dbeafe);display:flex;align-items:center;justify-content:center;font-size:20px;color:#2b7cff;margin-bottom:14px}
.dept-card h5{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:6px}
.dept-card p{font-size:13px;color:#64748b;margin-bottom:12px;line-height:1.5}
.dept-card .doc-count{font-size:13px;font-weight:600;color:#2b7cff;display:flex;align-items:center;gap:6px}
.dept-card .btn-del{position:absolute;top:16px;right:16px;background:#fee2e2;color:#991b1b;border:none;padding:6px 10px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.dept-card .btn-del:hover{background:#fecaca;color:#991b1b}
@media(max-width:768px){.dash-main{padding:16px}.dept-grid{grid-template-columns:1fr 1fr}}
@media(max-width:480px){.dept-grid{grid-template-columns:1fr}}
</style>
<script>
function toggleAddForm(){
    const f=document.getElementById('addForm');
    f.classList.toggle('show');
}
</script>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-hospital me-2" style="color:#2b7cff"></i>Manage <%=L(hi,"विभाग","<%=L(hi,"विभाग","Department")%>s")%></h2>
            <p>Organize hospital departments and their information.</p>
        </div>
        <button class="btn-add" onclick="toggleAddForm()"><i class="fa fa-plus"></i> Add <%=L(hi,"विभाग","Department")%></button>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <!-- Add Form -->
    <div class="add-form-card" id="addForm">
        <h5 style="font-weight:800;color:#0f172a;margin-bottom:16px">New <%=L(hi,"विभाग","Department")%></h5>
        <form action="/HospitalManagement/admin/departments/add" method="post">
            <div class="row g-3">
                <div class="col-md-4"><label class="form-label"><%=L(hi,"विभाग","Department")%> Name *</label><input type="text" name="name" class="form-control" placeholder="e.g. Cardiology" required></div>
                <div class="col-md-6"><label class="form-label">Description</label><input type="text" name="description" class="form-control" placeholder="Brief description"></div>
                <div class="col-md-2 d-flex align-items-end"><button type="submit" class="btn-save w-100"><i class="fa fa-save"></i> <%=L(hi,"सहेजें","Save")%></button></div>
            </div>
        </form>
    </div>

    <!-- <%=L(hi,"विभाग","Department")%> Cards -->
    <div class="dept-grid">
    <%
        List<Map<String,Object>> depts=(List<Map<String,Object>>)request.getAttribute("departments");
        String[] icons={"fa-heart-pulse","fa-brain","fa-baby","fa-bone","fa-spa","fa-stethoscope","fa-eye","fa-tooth"};
        int iconIdx=0;
        if(depts!=null)for(Map<String,Object> dept:depts){
            String icon=icons[iconIdx%icons.length]; iconIdx++;
    %>
    <div class="dept-card">
        <a href="/HospitalManagement/admin/departments/delete?id=<%=dept.get("id")%>" class="btn-del" onclick="return confirm('<%=L(hi,"हटाएं","Delete")%> this department?')"><i class="fa fa-trash"></i></a>
        <div class="dept-icon"><i class="fa <%=icon%>"></i></div>
        <h5><%=dept.get("name")%></h5>
        <p><%=dept.get("description")!=null&&!dept.get("description").toString().isEmpty()?dept.get("description"):"No description provided"%></p>
        <div class="doc-count"><i class="fa fa-user-md"></i> <%=dept.get("doctor_count")%> <%=L(hi,"डॉक्टर","Doctor")%>s</div>
    </div>
    <% } %>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
