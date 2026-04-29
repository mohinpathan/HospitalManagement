<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Schedule</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.form-card{background:#fff;border-radius:16px;padding:24px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:24px}
.form-card h5{font-weight:700;color:#0f172a;margin-bottom:16px;font-size:15px}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s}
.form-control:focus,.form-select:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-save{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-save:hover{opacity:.9;transform:translateY(-1px)}
.btn-update{background:linear-gradient(135deg,#f59e0b,#d97706);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}
.btn-update:hover{opacity:.9}
/* Schedule grid */
.sched-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:16px;margin-bottom:28px}
.sched-card{background:#fff;border-radius:14px;padding:18px 20px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;position:relative;transition:box-shadow .2s}
.sched-card:hover{box-shadow:0 6px 20px rgba(0,0,0,.1)}
.sched-card .day-badge{display:inline-block;background:linear-gradient(135deg,#d1fae5,#a7f3d0);color:#065f46;font-size:12px;font-weight:700;padding:4px 12px;border-radius:20px;margin-bottom:10px}
.sched-card .time-range{font-size:16px;font-weight:800;color:#0f172a;margin-bottom:6px}
.sched-card .time-range i{color:#19b37a;margin-right:6px}
.sched-card .slot-count{font-size:12px;color:#64748b}
.sched-actions{display:flex;gap:8px;margin-top:12px}
.btn-edit-slot{background:#fef3c7;color:#92400e;border:none;padding:6px 12px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.btn-edit-slot:hover{background:#fde68a;color:#92400e}
.btn-del-slot{background:#fee2e2;color:#991b1b;border:none;padding:6px 12px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:all .2s}
.btn-del-slot:hover{background:#fecaca;color:#991b1b}
/* Alerts */
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
.alert-info{background:#dbeafe;color:#1e40af;border:1px solid #bfdbfe;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
/* Slot calendar */
.slot-section{background:#fff;border-radius:16px;padding:24px;box-shadow:0 2px 12px rgba(0,0,0,.06);border:1px solid #e8edf5;margin-bottom:24px}
.slot-section h5{font-weight:700;color:#0f172a;margin-bottom:16px;font-size:15px}
.slot-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(100px,1fr));gap:10px}
.slot-pill{border-radius:10px;padding:10px 8px;text-align:center;font-size:13px;font-weight:600;cursor:pointer;transition:all .2s;border:2px solid transparent}
.slot-available{background:#f8fafc;border-color:#e5e7eb;color:#374151}
.slot-available:hover{background:#d1fae5;border-color:#19b37a;color:#065f46}
.slot-mine{background:#d1fae5;border-color:#19b37a;color:#065f46}
.slot-taken{background:#fee2e2;border-color:#fca5a5;color:#991b1b}
.legend{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:16px}
.legend-item{display:flex;align-items:center;gap:7px;font-size:13px;color:#374151}
.legend-dot{width:14px;height:14px;border-radius:4px;flex-shrink:0}
@media(max-width:768px){.dash-main{padding:16px}.sched-grid{grid-template-columns:1fr 1fr}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-clock me-2" style="color:#19b37a"></i>My Schedule</h2>
        <p>Set, edit and manage your available appointment slots.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <%
        Map<String,Object> editSlot = (Map<String,Object>) request.getAttribute("editSlot");
        boolean isEditing = editSlot != null;
    %>

    <!-- Add / Edit Schedule Form -->
    <div class="form-card">
        <h5><i class="fa <%=isEditing?"fa-pen":"fa-plus-circle"%> me-2" style="color:#19b37a"></i>
            <%=isEditing?"Reschedule Slot":"Add New Availability"%></h5>
        <% if(isEditing){ %>
        <div class="alert-info"><i class="fa fa-info-circle"></i> Editing slot: <strong><%=editSlot.get("day_of_week")%></strong> <%=editSlot.get("start_time")%> – <%=editSlot.get("end_time")%></div>
        <form action="/HospitalManagement/doctor/schedule/update" method="post">
            <input type="hidden" name="id" value="<%=editSlot.get("id")%>">
        <% } else { %>
        <form action="/HospitalManagement/doctor/schedule/save" method="post">
        <% } %>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Day of Week *</label>
                    <select name="dayOfWeek" class="form-select" required>
                        <option value="">Select Day</option>
                        <% String[] days={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"};
                           for(String d:days){
                               String sel = isEditing && d.equals(editSlot.get("day_of_week")) ? "selected" : "";
                        %><option <%=sel%>><%=d%></option><% } %>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Start Time *</label>
                    <input type="time" name="startTime" class="form-control" required
                           value="<%=isEditing?editSlot.get("start_time").toString().substring(0,5):""%>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">End Time *</label>
                    <input type="time" name="endTime" class="form-control" required
                           value="<%=isEditing?editSlot.get("end_time").toString().substring(0,5):""%>">
                </div>
                <div class="col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="<%=isEditing?"btn-update":"btn-save"%> w-100">
                        <i class="fa <%=isEditing?"fa-save":"fa-plus"%>"></i> <%=isEditing?"Update":"Add"%>
                    </button>
                </div>
            </div>
            <% if(isEditing){ %>
            <div style="margin-top:12px">
                <a href="/HospitalManagement/doctor/schedule" style="color:#64748b;font-size:13px"><i class="fa fa-times me-1"></i>Cancel editing</a>
            </div>
            <% } %>
        </form>
    </div>

    <!-- Current Schedule Cards -->
    <h5 style="font-weight:700;color:#0f172a;margin-bottom:14px">
        <i class="fa fa-calendar-week me-2" style="color:#19b37a"></i>Current Schedule
    </h5>
    <%
        List<Map<String,Object>> schedules=(List<Map<String,Object>>)request.getAttribute("schedules");
        if(schedules==null||schedules.isEmpty()){
    %>
    <div style="background:#fff;border-radius:14px;padding:40px;text-align:center;color:#94a3b8;box-shadow:0 2px 12px rgba(0,0,0,.06);margin-bottom:24px">
        <i class="fa fa-calendar-xmark fa-2x mb-3" style="color:#e2e8f0;display:block"></i>
        No schedule set yet. Add your availability above.
    </div>
    <%}else{%>
    <div class="sched-grid">
    <%for(Map<String,Object> sc:schedules){
        // Calculate slot count (30-min slots)
        String st = sc.get("start_time").toString().substring(0,5);
        String et = sc.get("end_time").toString().substring(0,5);
        int slots = 0;
        try {
            java.time.LocalTime s1 = java.time.LocalTime.parse(st);
            java.time.LocalTime e1 = java.time.LocalTime.parse(et);
            slots = (int)(java.time.Duration.between(s1,e1).toMinutes() / 30);
        } catch(Exception ignored){}
    %>
    <div class="sched-card">
        <div class="day-badge"><%=sc.get("day_of_week")%></div>
        <div class="time-range"><i class="fa fa-clock"></i><%=st%> – <%=et%></div>
        <div class="slot-count"><i class="fa fa-grid-2 me-1"></i><%=slots%> slots (30 min each)</div>
        <div class="sched-actions">
            <a href="/HospitalManagement/doctor/schedule/edit/<%=sc.get("id")%>" class="btn-edit-slot"><i class="fa fa-pen"></i> Reschedule</a>
            <a href="/HospitalManagement/doctor/schedule/delete/<%=sc.get("id")%>" class="btn-del-slot" onclick="return confirm('Remove this slot?')"><i class="fa fa-trash"></i> Remove</a>
        </div>
    </div>
    <%}%>
    </div>
    <%}%>

    <!-- Slot Calendar Preview -->
    <div class="slot-section">
        <h5><i class="fa fa-calendar-day me-2" style="color:#19b37a"></i>Appointment Slot Calendar</h5>
        <div class="legend">
            <div class="legend-item"><div class="legend-dot" style="background:#f8fafc;border:2px solid #e5e7eb"></div> Available</div>
            <div class="legend-item"><div class="legend-dot" style="background:#d1fae5;border:2px solid #19b37a"></div> Your Appointment</div>
            <div class="legend-item"><div class="legend-dot" style="background:#fee2e2;border:2px solid #fca5a5"></div> Booked by Patient</div>
        </div>
        <div class="row g-3 mb-3">
            <div class="col-md-4">
                <label class="form-label">Select Date</label>
                <input type="date" id="slotDate" class="form-control"
                       value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                       onchange="loadSlots()">
            </div>
        </div>
        <div id="slotContainer">
            <div style="text-align:center;color:#94a3b8;padding:30px">Select a date to view slots.</div>
        </div>
    </div>

</div></div>
<jsp:include page="/footer.jsp" />
<script>
const doctorId = <%=(int)session.getAttribute("doctorId")%>;

function loadSlots() {
    const date = document.getElementById('slotDate').value;
    if (!date) return;
    fetch('/HospitalManagement/doctor/schedule/slots?doctorId=' + doctorId + '&date=' + date)
    .then(r => r.json())
    .then(slots => renderSlots(slots, date))
    .catch(() => {
        document.getElementById('slotContainer').innerHTML =
            '<div style="text-align:center;color:#94a3b8;padding:30px">Could not load slots.</div>';
    });
}

function renderSlots(slots, date) {
    const container = document.getElementById('slotContainer');
    if (!slots || slots.length === 0) {
        container.innerHTML = '<div style="text-align:center;color:#94a3b8;padding:30px"><i class="fa fa-calendar-xmark fa-2x" style="color:#e2e8f0;display:block;margin-bottom:10px"></i>No schedule set for this day.</div>';
        return;
    }
    let html = '<div class="slot-grid">';
    slots.forEach(slot => {
        let cls = 'slot-available', icon = '', title = 'Available';
        if (slot.status === 'mine') {
            cls = 'slot-mine'; icon = '✓'; title = 'Your appointment';
        } else if (slot.status === 'taken') {
            cls = 'slot-taken'; icon = '✗'; title = 'Booked: ' + (slot.patientName || 'Patient');
        }
        html += `<div class="slot-pill ${cls}" title="${title}">
            <div style="font-size:15px;font-weight:800">${slot.time}</div>
            <div style="font-size:11px;margin-top:3px">${icon || (slot.status === 'available' ? 'Free' : '')}</div>
        </div>`;
    });
    html += '</div>';
    container.innerHTML = html;
}

// Load today's slots on page load
window.onload = loadSlots;
</script>
</body></html>
