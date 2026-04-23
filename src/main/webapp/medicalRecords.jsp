<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Medical Records</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:20px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;border-radius:10px;padding:12px 16px;margin-bottom:16px;display:flex;align-items:center;gap:8px;font-size:14px}
/* Record Card */
.record-card{background:#fff;border-radius:18px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden;margin-bottom:20px;transition:box-shadow .2s}
.record-card:hover{box-shadow:0 8px 28px rgba(0,0,0,.1)}
.record-header{padding:16px 22px;border-bottom:1px solid #f1f5f9;display:flex;justify-content:space-between;align-items:center;background:#fafbff;flex-wrap:wrap;gap:10px}
.record-header .doc-info{display:flex;align-items:center;gap:12px}
.doc-avatar{width:42px;height:42px;border-radius:10px;background:linear-gradient(135deg,#ede9fe,#ddd6fe);display:flex;align-items:center;justify-content:center;font-size:18px;color:#7c3aed}
.doc-name{font-weight:700;font-size:15px;color:#0f172a}
.doc-date{font-size:12px;color:#64748b;margin-top:2px}
.record-body{padding:22px}
.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:20px}
.info-item .info-label{font-size:11px;font-weight:700;color:#94a3b8;letter-spacing:.6px;text-transform:uppercase;margin-bottom:5px}
.info-item .info-value{font-size:14px;color:#0f172a;font-weight:500;line-height:1.5}
.medicines-box{background:#f8fafc;border:1px solid #e8edf5;border-radius:10px;padding:14px 16px;margin-bottom:16px}
.medicines-box .med-label{font-size:11px;font-weight:700;color:#94a3b8;letter-spacing:.6px;text-transform:uppercase;margin-bottom:8px}
.medicines-box .med-value{font-size:14px;color:#374151;line-height:1.6}
.bill-summary{display:flex;gap:12px;flex-wrap:wrap;margin-top:16px;padding-top:16px;border-top:1px solid #f1f5f9}
.bill-item{background:#f8fafc;border-radius:10px;padding:12px 16px;flex:1;min-width:110px;text-align:center}
.bill-item .b-label{font-size:11px;color:#64748b;font-weight:600;margin-bottom:4px}
.bill-item .b-value{font-size:16px;font-weight:800;color:#0f172a}
.bill-item.total{background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff}
.bill-item.total .b-label{color:rgba(255,255,255,.8)}
.bill-item.total .b-value{color:#fff;font-size:20px}
/* Action buttons */
.action-row{display:flex;gap:10px;flex-wrap:wrap;margin-top:16px;padding-top:16px;border-top:1px solid #f1f5f9}
.btn-pdf{background:#fee2e2;color:#991b1b;border:none;padding:9px 18px;border-radius:10px;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all .2s}
.btn-pdf:hover{background:#fecaca;color:#991b1b}
.btn-pay{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;padding:9px 18px;border-radius:10px;font-size:13px;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all .2s}
.btn-pay:hover{opacity:.9;color:#fff}
.btn-paid{background:#d1fae5;color:#065f46;border:none;padding:9px 18px;border-radius:10px;font-size:13px;font-weight:600;display:inline-flex;align-items:center;gap:6px}
/* Badges */
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-confirmed,.badge-paid{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-cancelled{background:#fee2e2;color:#991b1b}
.receipt-sent{display:inline-flex;align-items:center;gap:6px;background:#d1fae5;color:#065f46;padding:5px 12px;border-radius:8px;font-size:12px;font-weight:600}
/* Empty */
.empty-state{text-align:center;padding:80px 20px;color:#94a3b8;background:#fff;border-radius:18px;box-shadow:0 2px 16px rgba(0,0,0,.07)}
.empty-state i{font-size:56px;margin-bottom:16px;color:#e2e8f0;display:block}
@media(max-width:768px){.dash-main{padding:16px}.info-grid{grid-template-columns:1fr 1fr}.bill-summary{flex-direction:column}}
</style>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-file-medical me-2" style="color:#7c3aed"></i>Medical Records</h2>
        <p>Your complete prescription, billing history and online payments.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <%
        List<?> bills=(List<?>)request.getAttribute("bills");
        if(bills==null||bills.isEmpty()){
    %>
    <div class="empty-state">
        <i class="fa fa-file-medical-alt"></i>
        <h4 style="font-size:20px;font-weight:700;color:#374151;margin-bottom:8px">No medical records yet</h4>
        <p>Your prescriptions and bills will appear here after your consultations are completed.</p>
    </div>
    <% }else{ for(Object obj:bills){ Bill b=(Bill)obj; %>
    <div class="record-card">
        <div class="record-header">
            <div class="doc-info">
                <div class="doc-avatar"><i class="fa fa-user-md"></i></div>
                <div>
                    <div class="doc-name"><%=b.getDoctorName()%></div>
                    <div class="doc-date"><i class="fa fa-calendar fa-xs me-1"></i>Bill #<%=b.getId()%></div>
                </div>
            </div>
            <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap">
                <span class="badge badge-<%=b.getPaymentStatus()%>"><%=b.getPaymentStatus().toUpperCase()%></span>
                <% if(b.isReceiptSent()){ %><span class="receipt-sent"><i class="fa fa-envelope-circle-check"></i> Receipt Sent</span><% } %>
            </div>
        </div>
        <div class="record-body">
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Diagnosis</div>
                    <div class="info-value"><%=b.getDiagnosis()!=null?b.getDiagnosis():"—"%></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Payment Method</div>
                    <div class="info-value" style="text-transform:capitalize"><%=b.getPaymentMethod()!=null?b.getPaymentMethod():"—"%></div>
                </div>
            </div>
            <% if(b.getMedicines()!=null&&!b.getMedicines().isEmpty()){ %>
            <div class="medicines-box">
                <div class="med-label"><i class="fa fa-pills me-1"></i>Prescribed Medicines</div>
                <div class="med-value"><%=b.getMedicines()%></div>
            </div>
            <% } %>
            <div class="bill-summary">
                <div class="bill-item"><div class="b-label">Consultation</div><div class="b-value">₹<%=String.format("%.0f",b.getConsultationFee())%></div></div>
                <div class="bill-item"><div class="b-label">Medicine</div><div class="b-value">₹<%=String.format("%.0f",b.getMedicineCharge())%></div></div>
                <div class="bill-item"><div class="b-label">Other</div><div class="b-value">₹<%=String.format("%.0f",b.getOtherCharge())%></div></div>
                <div class="bill-item total"><div class="b-label">Total Amount</div><div class="b-value">₹<%=String.format("%.0f",b.getTotalAmount())%></div></div>
            </div>
            <div class="action-row">
                <a href="/HospitalManagement/patient/bill/pdf/<%=b.getId()%>" class="btn-pdf" target="_blank">
                    <i class="fa fa-file-pdf"></i> Download PDF
                </a>
                <% if("pending".equals(b.getPaymentStatus())){ %>
                <a href="/HospitalManagement/patient/payment/<%=b.getId()%>" class="btn-pay">
                    <i class="fa fa-credit-card"></i> Pay Online
                </a>
                <% }else if("paid".equals(b.getPaymentStatus())||"confirmed".equals(b.getPaymentStatus())){ %>
                <span class="btn-paid"><i class="fa fa-circle-check"></i> Payment Complete</span>
                <% } %>
            </div>
        </div>
    </div>
    <% }} %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
