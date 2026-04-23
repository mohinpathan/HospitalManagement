<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="com.hospital.model.Appointment, com.hospital.model.<%=L(hi,"डॉक्टर","Doctor")%>" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"पर्चा लिखें","Write Prescription")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.patient-info-card{background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:16px;padding:20px 24px;color:#fff;margin-bottom:24px;display:flex;align-items:center;gap:16px;flex-wrap:wrap}
.patient-info-card .pi-icon{width:48px;height:48px;border-radius:12px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.patient-info-card .pi-detail{font-size:14px;opacity:.9}
.patient-info-card .pi-name{font-size:17px;font-weight:800;margin-bottom:3px}
.form-card{background:#fff;border-radius:18px;padding:26px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:20px}
.form-card .section-title{font-size:15px;font-weight:800;color:#0f172a;margin-bottom:18px;display:flex;align-items:center;gap:8px;padding-bottom:12px;border-bottom:1px solid #f1f5f9}
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control,.form-select{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:10px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s}
.form-control:focus,.form-select:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-save{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:10px;padding:12px 28px;font-size:15px;font-weight:700;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:8px}
.btn-save:hover{opacity:.9;transform:translateY(-1px)}
.btn-back{background:#f1f5f9;color:#475569;border:1.5px solid #e5e7eb;border-radius:10px;padding:12px 22px;font-size:14px;font-weight:600;text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:all .2s}
.btn-back:hover{background:#e2e8f0;color:#374151}
.alert-danger{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
@media(max-width:768px){.dash-main{padding:16px}.form-card{padding:18px}}
</style>
</head><body>
<jsp:include page="/doctorheader.jsp" />
<div class="dash-body">
<jsp:include page="/doctorsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-file-prescription me-2" style="color:#19b37a"></i><%=L(hi,"पर्चा लिखें","Write Prescription")%> & Bill</h2>
        <p>Complete the consultation and generate a bill for the patient.</p>
    </div>

    <%
        Appointment appt=(Appointment)request.getAttribute("appointment");
        <%=L(hi,"डॉक्टर","Doctor")%> doc=(<%=L(hi,"डॉक्टर","Doctor")%>)request.getAttribute("doctor");
        if(appt==null){
    %>
    <div class="alert-danger"><i class="fa fa-exclamation-circle"></i> Appointment not found or already completed.</div>
    <a href="/HospitalManagement/doctor/appointments" class="btn-back"><i class="fa fa-arrow-left"></i> Back to <%=L(hi,"अपॉइंटमेंट","Appointments")%></a>
    <% }else{ %>

    <div class="patient-info-card">
        <div class="pi-icon"><i class="fa fa-user"></i></div>
        <div>
            <div class="pi-name"><%=appt.get<%=L(hi,"मरीज़","Patient")%>Name()%></div>
            <div class="pi-detail"><i class="fa fa-calendar fa-xs me-1"></i><%=appt.getAppointmentDate()%> &nbsp;|&nbsp; <i class="fa fa-clock fa-xs me-1"></i><%=appt.getAppointmentTime()%></div>
            <div class="pi-detail" style="margin-top:3px"><i class="fa fa-notes-medical fa-xs me-1"></i><%=appt.getReason()%></div>
        </div>
    </div>

    <form action="/HospitalManagement/createBill" method="post">
        <input type="hidden" name="appointmentId" value="<%=appt.getId()%>">
        <input type="hidden" name="patientId" value="<%=appt.get<%=L(hi,"मरीज़","Patient")%>Id()%>">
        <input type="hidden" name="doctorId" value="<%=appt.get<%=L(hi,"डॉक्टर","Doctor")%>Id()%>">

        <!-- Prescription -->
        <div class="form-card">
            <div class="section-title"><i class="fa fa-file-medical" style="color:#19b37a"></i> Prescription Details</div>
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label"><%=L(hi,"निदान","Diagnosis")%> *</label>
                    <textarea name="diagnosis" class="form-control" rows="2" placeholder="e.g. Viral fever with upper respiratory infection" required></textarea>
                </div>
                <div class="col-12">
                    <label class="form-label"><%=L(hi,"दवाइयां","Medicines")%> / Prescription *</label>
                    <textarea name="medicines" class="form-control" rows="3" placeholder="e.g. Paracetamol 500mg twice daily, Cetirizine 10mg at night..." required></textarea>
                </div>
                <div class="col-md-8">
                    <label class="form-label"><%=L(hi,"निर्देश","Instructions")%> for <%=L(hi,"मरीज़","Patient")%></label>
                    <textarea name="instructions" class="form-control" rows="2" placeholder="Rest, drink plenty of water, avoid cold food..."></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label"><%=L(hi,"फॉलो-अप तारीख","Follow-up Date")%></label>
                    <input type="date" name="followUpDate" class="form-control">
                </div>
            </div>
        </div>

        <!-- Bill -->
        <div class="form-card">
            <div class="section-title"><i class="fa fa-file-invoice-dollar" style="color:#f59e0b"></i> Bill Details</div>
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label"><%=L(hi,"परामर्श शुल्क","Consultation Fee")%> (₹) *</label>
                    <input type="number" step="0.01" name="consultationFee" class="form-control" value="<%=doc!=null?String.format("%.0f",doc.getConsultationFee()):"500"%>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label"><%=L(hi,"दवा शुल्क","Medicine Charge")%> (₹)</label>
                    <input type="number" step="0.01" name="medicineCharge" class="form-control" value="0">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Other Charge (₹)</label>
                    <input type="number" step="0.01" name="otherCharge" class="form-control" value="0">
                </div>
                <div class="col-md-3">
                    <label class="form-label"><%=L(hi,"भुगतान विधि","Payment Method")%></label>
                    <select name="paymentMethod" class="form-select">
                        <option value="cash">Cash</option>
                        <option value="card">Card</option>
                        <option value="online">Online</option>
                        <option value="insurance">Insurance</option>
                    </select>
                </div>
            </div>
        </div>

        <div style="display:flex;gap:12px;flex-wrap:wrap">
            <button type="submit" class="btn-save"><i class="fa fa-save"></i> <%=L(hi,"सहेजें","Save")%> Prescription & Generate Bill</button>
            <a href="/HospitalManagement/doctor/appointments" class="btn-back"><i class="fa fa-arrow-left"></i> <%=L(hi,"रद्द करें","Cancel")%></a>
        </div>
    </form>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
