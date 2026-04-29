<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Doctor Schedule</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a;margin:0}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:9px 18px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
/* Doctor info card */
.doc-info-card{background:linear-gradient(135deg,#2b7cff,#1a5fd4);border-radius:16px;padding:22px 26px;color:#fff;margin-bottom:24px;display:flex;align-items:center;gap:16px}
.doc-avatar{width:56px;height:56px;border-radius:14px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0}
.doc-name{font-size:18px;font-weight:800;margin-bottom:4px}
.doc-meta{font-size:13px;opacity:.85}
/* Schedule list */
.sched-list-card{background:#fff;border-radius:16px;padding:20px 24px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:24px}
.sched-list-card h5{font-weight:700;color:#0f172a;margin-bottom:16px;font-size:15px}
.day-row{display:flex;align-items:center;justify-content:space-between;padding:10px 0;border-bottom:1px solid #f8fafc}
.day-row:last-child{border-bottom:none}
.day-name{font-weight:600;color:#0f172a;min-width:100px}
.time-badge{background:#d1fae5;color:#065f46;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600}
/* Slot calendar */
.slot-calendar{background:#fff;border-radius:16px;padding:24px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5}
.slot-calendar h5{font-weight:700;color:#0f172a;margin-bottom:16px;font-size:15px}
.legend{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:16px}
.legend-item{display:flex;align-items:center;gap:7px;font-size:13px;color:#374151}
.legend-dot{width:14px;height:14px;border-radius:4px;flex-shrink:0}
.slot-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(100px,1fr));gap:10px}
.slot-pill{border-radius:10px;padding:10px 8px;text-align:center;font-size:13px;font-weight:600;border:2px solid transparent;transition:all .2s}
.slot-available{background:#f8fafc;border-color:#e5e7eb;color:#374151}
.slot-mine{background:#d1fae5;border-color:#19b37a;color:#065f46}
.slot-taken{background:#fee2e2;border-color:#fca5a5;color:#991b1b}
.slot-pill .slot-time{font-size:14px;font-weight:800;margin-bottom:2px}
.slot-pill .slot-label{font-size:10px;opacity:.8}
@media(max-width:768px){.dash-main{padding:16px}.doc-sched-grid{grid-template-columns:1fr}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <div>
            <h2><i class="fa fa-calendar-week me-2" style="color:#2b7cff"></i>Doctor Schedule</h2>
            <p>View appointment slots and availability.</p>
        </div>
        <a href="/HospitalManagement/admin/schedules" class="btn-back"><i class="fa fa-arrow-left"></i> All Schedules</a>
    </div>

    <%
        Doctor doc = (Doctor) request.getAttribute("doctor");
        List<Map<String,Object>> schedules = (List<Map<String,Object>>) request.getAttribute("schedules");
        List<Map<String,Object>> slots = (List<Map<String,Object>>) request.getAttribute("slots");
        String date = (String) request.getAttribute("date");
    %>

    <!-- Doctor Info -->
    <div class="doc-info-card">
        <div class="doc-avatar"><i class="fa fa-user-md"></i></div>
        <div>
            <div class="doc-name"><%=doc.getFullName()%></div>
            <div class="doc-meta"><%=doc.getDepartmentName()!=null?doc.getDepartmentName():""%> · <%=doc.getSpecialization()!=null?doc.getSpecialization():""%></div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Schedule List -->
        <div class="col-lg-5">
            <div class="sched-list-card">
                <h5><i class="fa fa-clock me-2" style="color:#19b37a"></i>Weekly Schedule</h5>
                <% if(schedules==null||schedules.isEmpty()){ %>
                <div style="text-align:center;color:#94a3b8;padding:20px">No schedule set for this doctor.</div>
                <% } else { for(Map<String,Object> sc : schedules) { %>
                <div class="day-row">
                    <span class="day-name"><i class="fa fa-calendar-day me-2" style="color:#2b7cff"></i><%=sc.get("day_of_week")%></span>
                    <span class="time-badge"><%=sc.get("start_time").toString().substring(0,5)%> – <%=sc.get("end_time").toString().substring(0,5)%></span>
                </div>
                <% }} %>
            </div>
        </div>

        <!-- Slot Calendar -->
        <div class="col-lg-7">
            <div class="slot-calendar">
                <h5><i class="fa fa-calendar-check me-2" style="color:#2b7cff"></i>Appointment Slots</h5>
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot" style="background:#f8fafc;border:2px solid #e5e7eb"></div> Available</div>
                    <div class="legend-item"><div class="legend-dot" style="background:#d1fae5;border:2px solid #19b37a"></div> Booked</div>
                    <div class="legend-item"><div class="legend-dot" style="background:#fee2e2;border:2px solid #fca5a5"></div> Taken</div>
                </div>
                <div class="mb-3">
                    <label style="font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block">Select Date</label>
                    <input type="date" id="slotDate" class="form-control" value="<%=date%>" style="max-width:200px"
                           onchange="window.location.href='/HospitalManagement/admin/schedules/doctor/<%=doc.getId()%>?date='+this.value">
                </div>
                <% if(slots==null||slots.isEmpty()){ %>
                <div style="text-align:center;color:#94a3b8;padding:30px">
                    <i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0;display:block"></i>
                    No schedule for this day.
                </div>
                <% } else { %>
                <div class="slot-grid">
                <% for(Map<String,Object> slot : slots) {
                    String status = (String) slot.get("status");
                    String cls = "available".equals(status) ? "slot-available"
                               : "mine".equals(status)      ? "slot-mine"
                               : "slot-taken";
                    String label = "available".equals(status) ? "Free"
                                 : "mine".equals(status)      ? "Yours"
                                 : "Booked";
                    String patName = slot.get("patientName") != null ? (String) slot.get("patientName") : "";
                %>
                <div class="slot-pill <%=cls%>" title="<%=label%><%=patName.isEmpty()?"":" - "+patName%>">
                    <div class="slot-time"><%=slot.get("time")%></div>
                    <div class="slot-label"><%=label%></div>
                </div>
                <% } %>
                </div>
                <% } %>
            </div>
        </div>
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
        const matchDay  = !day    || days.includes(day);
        card.style.display = (matchName && matchDay) ? '' : 'none';
    });
}
</script>
</body></html>
