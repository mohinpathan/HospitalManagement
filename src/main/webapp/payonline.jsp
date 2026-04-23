<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Bill" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Pay Online</title>
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
/* Bill summary */
.bill-summary{background:linear-gradient(135deg,#1e3a8a,#2b7cff);border-radius:18px;padding:24px 28px;color:#fff;margin-bottom:24px}
.bill-summary .bs-title{font-size:13px;opacity:.8;margin-bottom:4px;text-transform:uppercase;letter-spacing:.5px}
.bill-summary .bs-amount{font-size:42px;font-weight:900;margin-bottom:8px}
.bill-summary .bs-meta{font-size:13px;opacity:.85;display:flex;gap:20px;flex-wrap:wrap}
/* Payment card */
.pay-card{background:#fff;border-radius:18px;padding:28px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;max-width:560px}
/* Method tabs */
.method-tabs{display:flex;gap:10px;margin-bottom:24px;flex-wrap:wrap}
.method-tab{flex:1;min-width:100px;padding:14px 10px;border-radius:12px;border:2px solid #e5e7eb;cursor:pointer;text-align:center;transition:all .2s;background:#fff}
.method-tab:hover{border-color:#2b7cff;background:#eff6ff}
.method-tab.active{border-color:#2b7cff;background:#eff6ff}
.method-tab i{font-size:22px;display:block;margin-bottom:6px}
.method-tab span{font-size:12px;font-weight:600;color:#374151}
.method-tab.active span{color:#2b7cff}
/* Form fields */
.form-label{font-weight:600;font-size:13px;color:#374151;margin-bottom:6px;display:block}
.form-control{background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:10px;padding:11px 14px;font-size:14px;width:100%;outline:none;transition:border-color .2s,box-shadow .2s;margin-bottom:16px}
.form-control:focus{border-color:#2b7cff;box-shadow:0 0 0 3px rgba(43,124,255,.1)}
.input-group{display:flex;gap:12px}
.input-group .form-control{flex:1}
/* Pay button */
.btn-pay{width:100%;background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;border-radius:12px;padding:14px;font-size:16px;font-weight:700;cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:10px;margin-top:8px}
.btn-pay:hover{opacity:.92;transform:translateY(-1px);box-shadow:0 8px 20px rgba(25,179,122,.35)}
.secure-note{text-align:center;font-size:12px;color:#94a3b8;margin-top:12px;display:flex;align-items:center;justify-content:center;gap:6px}
/* Bill breakdown */
.breakdown{background:#f8fafc;border-radius:12px;padding:16px 20px;margin-bottom:20px}
.breakdown-row{display:flex;justify-content:space-between;padding:6px 0;font-size:14px;color:#374151;border-bottom:1px solid #f1f5f9}
.breakdown-row:last-child{border-bottom:none;font-weight:800;font-size:16px;color:#0f172a;padding-top:10px}
/* Payment fields */
.pay-fields{display:none}
.pay-fields.show{display:block}
</style>
<script>
function selectMethod(method) {
    document.querySelectorAll('.method-tab').forEach(t => t.classList.remove('active'));
    document.getElementById('tab_' + method).classList.add('active');
    document.getElementById('methodInput').value = method;
    document.querySelectorAll('.pay-fields').forEach(f => f.classList.remove('show'));
    const f = document.getElementById('fields_' + method);
    if (f) f.classList.add('show');
}
// Format card number
function formatCard(el) {
    let v = el.value.replace(/\D/g,'').substring(0,16);
    el.value = v.replace(/(.{4})/g,'$1 ').trim();
}
</script>
</head><body>
<jsp:include page="/patientheader.jsp" />
<div class="dash-body">
<jsp:include page="/patientsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-credit-card me-2" style="color:#19b37a"></i>Pay Online</h2>
        <p>Secure payment for your hospital bill.</p>
    </div>

    <%
        Bill bill = (Bill) request.getAttribute("bill");
        if (bill == null) {
    %><div style="background:#fee2e2;color:#991b1b;border:1px solid #fecaca;border-radius:12px;padding:16px">Bill not found.</div><%
    } else { %>

    <!-- Bill Summary -->
    <div class="bill-summary">
        <div class="bs-title">Amount Due</div>
        <div class="bs-amount">₹<%=String.format("%.2f", bill.getTotalAmount())%></div>
        <div class="bs-meta">
            <span><i class="fa fa-user me-1"></i><%=bill.getPatientName()%></span>
            <span><i class="fa fa-user-md me-1"></i><%=bill.getDoctorName()%></span>
            <span><i class="fa fa-file-invoice me-1"></i>Bill #<%=bill.getId()%></span>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="pay-card">
                <h5 style="font-weight:800;color:#0f172a;margin-bottom:20px">Select Payment Method</h5>

                <!-- Method Tabs -->
                <div class="method-tabs">
                    <div class="method-tab active" id="tab_card" onclick="selectMethod('card')">
                        <i class="fa fa-credit-card" style="color:#2b7cff"></i>
                        <span>Card</span>
                    </div>
                    <div class="method-tab" id="tab_upi" onclick="selectMethod('upi')">
                        <i class="fa fa-mobile-screen" style="color:#7c3aed"></i>
                        <span>UPI</span>
                    </div>
                    <div class="method-tab" id="tab_netbanking" onclick="selectMethod('netbanking')">
                        <i class="fa fa-building-columns" style="color:#19b37a"></i>
                        <span>Net Banking</span>
                    </div>
                    <div class="method-tab" id="tab_wallet" onclick="selectMethod('wallet')">
                        <i class="fa fa-wallet" style="color:#f59e0b"></i>
                        <span>Wallet</span>
                    </div>
                </div>

                <form action="/HospitalManagement/patient/payment/process" method="post">
                    <input type="hidden" name="billId" value="<%=bill.getId()%>">
                    <input type="hidden" name="paymentMethod" id="methodInput" value="card">

                    <!-- Card Fields -->
                    <div class="pay-fields show" id="fields_card">
                        <label class="form-label">Card Number</label>
                        <input type="text" name="cardNumber" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)">
                        <div class="input-group">
                            <div style="flex:1">
                                <label class="form-label">Expiry Date</label>
                                <input type="text" class="form-control" placeholder="MM/YY" maxlength="5">
                            </div>
                            <div style="flex:1">
                                <label class="form-label">CVV</label>
                                <input type="password" class="form-control" placeholder="•••" maxlength="3">
                            </div>
                        </div>
                        <label class="form-label">Cardholder Name</label>
                        <input type="text" class="form-control" placeholder="Name on card">
                    </div>

                    <!-- UPI Fields -->
                    <div class="pay-fields" id="fields_upi">
                        <label class="form-label">UPI ID</label>
                        <input type="text" name="upiId" class="form-control" placeholder="yourname@upi">
                        <div style="background:#eff6ff;border-radius:10px;padding:12px 16px;font-size:13px;color:#1e40af;margin-bottom:16px">
                            <i class="fa fa-info-circle me-2"></i>Enter your UPI ID and confirm payment in your UPI app.
                        </div>
                    </div>

                    <!-- Net Banking Fields -->
                    <div class="pay-fields" id="fields_netbanking">
                        <label class="form-label">Select Bank</label>
                        <select class="form-control" style="margin-bottom:16px">
                            <option value="">Select your bank</option>
                            <option>State Bank of India</option>
                            <option>HDFC Bank</option>
                            <option>ICICI Bank</option>
                            <option>Axis Bank</option>
                            <option>Kotak Mahindra Bank</option>
                            <option>Punjab National Bank</option>
                            <option>Other</option>
                        </select>
                    </div>

                    <!-- Wallet Fields -->
                    <div class="pay-fields" id="fields_wallet">
                        <label class="form-label">Select Wallet</label>
                        <select class="form-control" style="margin-bottom:16px">
                            <option value="">Select wallet</option>
                            <option>Paytm</option>
                            <option>PhonePe</option>
                            <option>Google Pay</option>
                            <option>Amazon Pay</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-pay">
                        <i class="fa fa-lock"></i>
                        Pay ₹<%=String.format("%.2f", bill.getTotalAmount())%> Securely
                    </button>
                    <div class="secure-note">
                        <i class="fa fa-shield-halved" style="color:#19b37a"></i>
                        256-bit SSL encrypted. Your payment is secure.
                    </div>
                </form>
            </div>
        </div>

        <!-- Bill Breakdown -->
        <div class="col-lg-5">
            <div class="pay-card">
                <h5 style="font-weight:800;color:#0f172a;margin-bottom:16px">Bill Breakdown</h5>
                <div class="breakdown">
                    <div class="breakdown-row"><span>Consultation Fee</span><span>₹<%=String.format("%.2f",bill.getConsultationFee())%></span></div>
                    <div class="breakdown-row"><span>Medicine Charge</span><span>₹<%=String.format("%.2f",bill.getMedicineCharge())%></span></div>
                    <div class="breakdown-row"><span>Other Charges</span><span>₹<%=String.format("%.2f",bill.getOtherCharge())%></span></div>
                    <div class="breakdown-row"><span>Total Amount</span><span>₹<%=String.format("%.2f",bill.getTotalAmount())%></span></div>
                </div>
                <% if (bill.getDiagnosis() != null) { %>
                <div style="font-size:13px;color:#374151;margin-bottom:8px"><strong>Diagnosis:</strong> <%=bill.getDiagnosis()%></div>
                <% } %>
                <% if (bill.getMedicines() != null) { %>
                <div style="font-size:13px;color:#374151"><strong>Medicines:</strong> <%=bill.getMedicines()%></div>
                <% } %>
            </div>
        </div>
    </div>
    <% } %>
</div></div>
<jsp:include page="/footer.jsp" />
</body></html>
