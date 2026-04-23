<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="com.hospital.model.Bill" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"ऑनलाइन भुगतान करें","Pay Online")%></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif;display:flex;flex-direction:column;min-height:100vh}
.pay-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
.pay-card{background:#fff;border-radius:22px;padding:36px;width:100%;max-width:520px;box-shadow:0 8px 32px rgba(0,0,0,.1);border:1px solid #e8edf5}
.pay-header{text-align:center;margin-bottom:28px}
.pay-icon{width:64px;height:64px;background:linear-gradient(135deg,#19b37a,#0d9668);border-radius:18px;display:flex;align-items:center;justify-content:center;font-size:28px;color:#fff;margin:0 auto 16px;box-shadow:0 8px 20px rgba(25,179,122,.3)}
.pay-header h2{font-size:22px;font-weight:800;color:#0f172a;margin-bottom:4px}
.pay-header p{font-size:14px;color:#64748b;margin:0}
/* Bill summary */
.bill-summary{background:#f8fafc;border-radius:14px;padding:18px 20px;margin-bottom:24px;border:1px solid #e8edf5}
.bill-row{display:flex;justify-content:space-between;padding:7px 0;border-bottom:1px solid #f1f5f9;font-size:14px;color:#374151}
.bill-row:last-child{border-bottom:none;font-weight:800;font-size:17px;color:#0f172a;padding-top:12px}
/* Payment methods */
.method-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-bottom:20px}
.method-btn{border:2px solid #e5e7eb;border-radius:12px;padding:14px;text-align:center;cursor:pointer;transition:all .2s;background:#fff}
.method-btn:hover{border-color:#19b37a;background:#f0fdf4}
.method-btn.selected{border-color:#19b37a;background:#f0fdf4}
.method-btn i{font-size:22px;margin-bottom:6px;display:block}
.method-btn span{font-size:13px;font-weight:600;color:#374151}
/* Form */
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s;margin-bottom:14px}
.form-control:focus{border-color:#19b37a;box-shadow:0 0 0 3px rgba(25,179,122,.1)}
.btn-pay{width:100%;background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:12px;padding:14px;font-size:16px;font-weight:700;cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-pay:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 8px 20px rgba(25,179,122,.35)}
.secure-note{text-align:center;font-size:12px;color:#94a3b8;margin-top:14px;display:flex;align-items:center;justify-content:center;gap:6px}
</style>
<script>
function selectMethod(el, method) {
    document.querySelectorAll('.method-btn').forEach(b=>b.classList.remove('selected'));
    el.classList.add('selected');
    document.getElementById('paymentMethod').value = method;
    document.getElementById('cardFields').style.display = method==='card' ? 'block' : 'none';
    document.getElementById('upiField').style.display   = method==='upi'  ? 'block' : 'none';
}
</script>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="pay-wrap">
<div class="pay-card">
    <%
        Bill bill = (Bill) request.getAttribute("bill");
        if(bill==null){
    %><div style="text-align:center;color:#ef4444">Bill not found.</div><%
    }else{%>

    <div class="pay-header">
        <div class="pay-icon"><i class="fa fa-credit-card"></i></div>
        <h2><%=L(hi,"ऑनलाइन भुगतान करें","Pay Online")%></h2>
        <p>Secure payment for Bill #<%=bill.getId()%></p>
    </div>

    <!-- Bill Summary -->
    <div class="bill-summary">
        <div class="bill-row"><span><%=L(hi,"डॉक्टर","Doctor")%></span><span><%=bill.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></span></div>
        <div class="bill-row"><span><%=L(hi,"परामर्श शुल्क","Consultation Fee")%></span><span>₹<%=String.format("%.0f",bill.getConsultationFee())%></span></div>
        <div class="bill-row"><span><%=L(hi,"दवा शुल्क","Medicine Charge")%></span><span>₹<%=String.format("%.0f",bill.getMedicineCharge())%></span></div>
        <div class="bill-row"><span><%=L(hi,"अन्य शुल्क","Other Charges")%></span><span>₹<%=String.format("%.0f",bill.getOtherCharge())%></span></div>
        <div class="bill-row"><span><%=L(hi,"कुल राशि","Total Amount")%></span><span style="color:#19b37a">₹<%=String.format("%.2f",bill.getTotalAmount())%></span></div>
    </div>

    <form action="/HospitalManagement/patient/payment/process" method="post">
        <input type="hidden" name="billId" value="<%=bill.getId()%>">
        <input type="hidden" name="paymentMethod" id="paymentMethod" value="card">

        <!-- <%=L(hi,"भुगतान विधि","Payment Method")%> -->
        <div style="font-weight:700;font-size:14px;color:#0f172a;margin-bottom:12px">Select <%=L(hi,"भुगतान विधि","Payment Method")%></div>
        <div class="method-grid">
            <div class="method-btn selected" onclick="selectMethod(this,'card')">
                <i class="fa fa-credit-card" style="color:#2b7cff"></i>
                <span><%=L(hi,"क्रेडिट/डेबिट कार्ड","Credit/Debit Card")%></span>
            </div>
            <div class="method-btn" onclick="selectMethod(this,'upi')">
                <i class="fa fa-mobile-screen" style="color:#19b37a"></i>
                <span>UPI</span>
            </div>
            <div class="method-btn" onclick="selectMethod(this,'netbanking')">
                <i class="fa fa-building-columns" style="color:#7c3aed"></i>
                <span><%=L(hi,"नेट बैंकिंग","Net Banking")%></span>
            </div>
            <div class="method-btn" onclick="selectMethod(this,'wallet')">
                <i class="fa fa-wallet" style="color:#f59e0b"></i>
                <span><%=L(hi,"वॉलेट","Wallet")%></span>
            </div>
        </div>

        <!-- Card Fields -->
        <div id="cardFields">
            <label class="form-label"><%=L(hi,"कार्डधारक का नाम","Cardholder Name")%> *</label>
            <input type="text" name="cardName" class="form-control" placeholder="Name on card" required>
            <label class="form-label"><%=L(hi,"कार्ड नंबर","Card Number")%> *</label>
            <input type="text" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19"
                   oninput="this.value=this.value.replace(/\D/g,'').replace(/(.{4})/g,'$1 ').trim()">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
                <div>
                    <label class="form-label"><%=L(hi,"समाप्ति","Expiry")%> *</label>
                    <input type="text" class="form-control" placeholder="MM/YY" maxlength="5">
                </div>
                <div>
                    <label class="form-label">CVV *</label>
                    <input type="password" class="form-control" placeholder="•••" maxlength="3">
                </div>
            </div>
        </div>

        <!-- UPI Field -->
        <div id="upiField" style="display:none">
            <label class="form-label"><%=L(hi,"UPI ID","UPI ID")%> *</label>
            <input type="text" class="form-control" placeholder="yourname@upi">
        </div>

        <button type="submit" class="btn-pay">
            <i class="fa fa-lock"></i> Pay ₹<%=String.format("%.2f",bill.getTotalAmount())%> Securely
        </button>

        <div class="secure-note">
            <i class="fa fa-shield-halved" style="color:#19b37a"></i>
            <%=L(hi,"256-बिट SSL एन्क्रिप्टेड","256-bit SSL encrypted")%>. Your payment is secure.
        </div>
    </form>

    <p style="text-align:center;margin-top:16px;font-size:14px">
        <a href="/HospitalManagement/patient/medicalRecords" style="color:#64748b">← <%=L(hi,"रद्द करें","Cancel")%> and go back</a>
    </p>
    <%}%>
</div>
</div>
<jsp:include page="/footer.jsp" />
</body></html>
