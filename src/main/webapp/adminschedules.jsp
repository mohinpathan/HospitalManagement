<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Doctor Schedules</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.page-hdr p{font-size:14px;color:#64748b;margin:3px 0 0}
/* Doctor cards */
.doc-sched-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:20px;margin-bottom:28px}
.doc-sched-card{background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;overflow:hidden;transition:box-shadow .2s}
.doc-sched-card:hover{box-shadow:0 8px 24px rgba(0,0,0,.1)}
.doc-sched-header{background:linear-gradient(135deg,#2b7cff,#1a5fd4);padding:16px 20px;color:#fff;display:flex;align-items:center;gap:12px}
.doc-avatar{width:44px;height:44px;border-radius:12px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.doc-name{font-weight:700;font-size:15px}
.doc-dept{font-size:12px;opacity:.85;margin-top:2px}
.doc-sched-body{padding:16px 20px}
.day-slot{display:flex;align-items:center;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f8fafc;font-size:14px}
.day-slot:last-child{border-bottom:none}
.day-name{font-weight:600;color:#0f172a;min-width:90px}
.time-badge{background:#d1fae5;color:#065f46;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600}
.no-schedule{padding:20px;text-align:center;color:#94a3b8;font-size:13px}
.btn-view-cal{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border:none;border-radius:8px;padding:8px 16px;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all .2s;margin-top:12px}
.btn-view-cal:hover{opacity:.9;color:#fff}
/* Filter */
.filter-bar{background:#fff;border-radius:14px;padding:16px 20px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:20px;display:flex;gap:12px;flex-wrap:wrap;align-items:center}
.filter-bar .form-control,.filter-bar .form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 14px;font-size:14px;outline:none}
@media(max-width:768px){.dash-main{padding:16px}.doc-sched-grid{grid-template-columns:1fr}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-calendar-week me-2" style="color:#2b7cff"></i>Doctor Schedules</h2>
            <p>View and manage all doctor availability schedules.</p>
        </div>
    </div>

    <!-- Search filter -->
    <div class="filter-bar">
        <input type="text" id="searchDoc" class="form-control" placeholder="Search doctor name..." style="max-width:280px" oninput="filterCards()">
        <select id="filterDay" class="form-select" style="max-width:180px" onchange="filterCards()">
            <option value="">All Days</option>
            <% String[] days={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};
               for(String d:days){ %><option><%=d%></option><% } %>
        </select>
    </div>

    <%
        List<?> doctors = (List<?>) request.getAttribute("doctors");
        List<Map<String,Object>> allSchedules = (List<Map<String,Object>>) request.getAttribute("schedules");

        // Group schedules by doctor_id
        Map<Integer, List<Map<String,Object>>> schedByDoc = new LinkedHashMap<>();
        if(allSchedules != null) {
            for(Map<String,Object> sc : allSchedules) {
                int did = ((Number)sc.get("doctor_id")).intValue();
                schedByDoc.computeIfAbsent(did, k -> new ArrayList<>()).add(sc);
            }
        }
    %>

    <div class="doc-sched-grid" id="docGrid">
    <%
        if(doctors != null) for(Object obj : doctors) {
            com.hospital.model.Doctor doc = (com.hospital.model.Doctor) obj;
            List<Map<String,Object>> docScheds = schedByDoc.getOrDefault(doc.getId(), new ArrayList<>());
    %>
    <div class="doc-sched-card" data-name="<%=doc.getFullName().toLowerCase()%>"
         data-days="<%=docScheds.stream().map(m->m.get("day_of_week").toString().toLowerCase()).collect(java.util.stream.Collectors.joining(","))%>">
        <div class="doc-sched-header">
            <div class="doc-avatar"><i class="fa fa-user-md"></i></div>
            <div>
                <div class="doc-name"><%=doc.getFullName()%></div>
                <div class="doc-dept"><%=doc.getDepartmentName()!=null?doc.getDepartmentName():""%> · <%=doc.getSpecialization()!=null?doc.getSpecialization():""%></div>
            </div>
        </div>
        <div class="doc-sched-body">
            <% if(docScheds.isEmpty()){ %>
            <div class="no-schedule"><i class="fa fa-calendar-xmark me-2"></i>No schedule set</div>
            <% } else { for(Map<String,Object> sc : docScheds) {
                String st = sc.get("start_time").toString().substring(0,5);
                String et = sc.get("end_time").toString().substring(0,5);
                int slots = 0;
                try {
                    java.time.LocalTime s1 = java.time.LocalTime.parse(st);
                    java.time.LocalTime e1 = java.time.LocalTime.parse(et);
                    slots = (int)(java.time.Duration.between(s1,e1).toMinutes()/30);
                } catch(Exception ignored){}
            %>
            <div class="day-slot">
                <span class="day-name"><i class="fa fa-calendar-day me-2" style="color:#2b7cff"></i><%=sc.get("day_of_week")%></span>
                <span class="time-badge"><%=st%> – <%=et%></span>
                <span style="font-size:11px;color:#64748b"><%=slots%> slots</span>
            </div>
            <% }} %>
            <a href="/HospitalManagement/admin/schedules/doctor/<%=doc.getId()%>" class="btn-view-cal">
                <i class="fa fa-calendar-check"></i> View Slot Calendar
            </a>
        </div>
    </div>
    <% } %>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />
<script>
function filterCards() {
    const search = document.getElementById('searchDoc').value.toLowerCase();
    const day    = document.getElementById('filterDay').value.toLowerCase();
    document.querySelectorAll('.doc-sched-card').forEach(card => {
        const name = card.dataset.name || '';
        const days = card.dataset.days || '';
        const matchName = !search || name.includes(search);
        const matchDay  = !day   || days.includes(day);
        card.style.display = (matchName && matchDay) ? '' : 'none';
    });
}
</script>
</body></html>
