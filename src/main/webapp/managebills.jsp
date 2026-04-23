<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*, com.hospital.model.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=L(hi,"बिल और भुगतान","Bills & Payments")%></title>
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
.table-card{background:#fff;border-radius:16px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;overflow:hidden}
.tbl{width:100%;border-collapse:collapse}
.tbl thead th{background:#f8fafc;font-size:11px;font-weight:700;color:#64748b;letter-spacing:.6px;text-transform:uppercase;padding:13px 16px;border-bottom:1px solid #e8edf5;white-space:nowrap}
.tbl tbody td{padding:13px 16px;font-size:14px;vertical-align:middle;border-bottom:1px solid #f8fafc;color:#374151}
.tbl tbody tr:last-child td{border-bottom:none}
.tbl tbody tr:hover{background:#fafbff}
.badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700}
.badge-confirmed,.badge-paid{background:#d1fae5;color:#065f46}
.badge-pending{background:#fef3c7;color:#92400e}
.badge-cancelled{background:#fee2e2;color:#991b1b}
.btn-confirm{background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;border:none;padding:7px 14px;border-radius:9px;font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:5px}
.btn-confirm:hover{opacity:.9}
.receipt-sent{display:inline-flex;align-items:center;gap:5px;background:#d1fae5;color:#065f46;padding:4px 10px;border-radius:8px;font-size:11px;font-weight:600}
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
        <h2><i class="fa fa-file-invoice-dollar me-2" style="color:#f59e0b"></i><%=L(hi,"बिल और भुगतान","Bills & Payments")%></h2>
        <p>Confirm patient bills and send payment receipts via email.</p>
    </div>

    <% String s=(String)request.getAttribute("success"); if(s!=null){ %><div class="alert-success"><i class="fa fa-check-circle"></i> <%=s%></div><% } %>

    <div class="table-card">
        <div style="overflow-x:auto">
        <table class="tbl">
            <thead><tr><th>#</th><th><%=L(hi,"मरीज़","Patient")%></th><th><%=L(hi,"डॉक्टर","Doctor")%></th><th>Consult.</th><th>Medicine</th><th>Other</th><th>Total</th><th>Method</th><th><%=L(hi,"स्थिति","Status")%></th><th>Receipt</th><th>Action</th></tr></thead>
            <tbody>
            <%
                List<?> bills=(List<?>)request.getAttribute("bills");
                if(bills==null||bills.isEmpty()){
            %><tr><td colspan="11"><div class="empty-state"><i class="fa fa-file-invoice"></i><p><%=L(hi,"कोई बिल नहीं मिला","No bills found")%>.</p></div></td></tr><%
            }else{ int idx=1; for(Object obj:bills){ Bill b=(Bill)obj; %>
            <tr>
                <td style="color:#94a3b8;font-size:12px"><%=idx++%></td>
                <td style="font-weight:700;color:#0f172a"><%=b.get<%=L(hi,"मरीज़","Patient")%>Name()%></td>
                <td style="color:#374151"><%=b.get<%=L(hi,"डॉक्टर","Doctor")%>Name()%></td>
                <td>₹<%=String.format("%.0f",b.getConsultationFee())%></td>
                <td>₹<%=String.format("%.0f",b.getMedicineCharge())%></td>
                <td>₹<%=String.format("%.0f",b.getOtherCharge())%></td>
                <td style="font-weight:800;color:#0f172a">₹<%=String.format("%.0f",b.getTotalAmount())%></td>
                <td style="text-transform:capitalize;font-size:13px"><%=b.getPaymentMethod()%></td>
                <td><span class="badge badge-<%=b.getPayment<%=L(hi,"स्थिति","Status")%>()%>"><%=b.getPayment<%=L(hi,"स्थिति","Status")%>().toUpperCase()%></span></td>
                <td><%if(b.isReceiptSent()){%><span class="receipt-sent"><i class="fa fa-check"></i> Sent</span><%}else{%><span style="color:#94a3b8;font-size:12px">Not sent</span><%}%></td>
                <td>
                    <%if("pending".equals(b.getPayment<%=L(hi,"स्थिति","Status")%>())){%>
                    <form action="/HospitalManagement/admin/confirmBill" method="post" style="margin:0">
                        <input type="hidden" name="billId" value="<%=b.getId()%>">
                        <button class="btn-confirm"><i class="fa fa-check"></i> <%=L(hi,"पुष्टि करें और ईमेल करें","Confirm & Email")%></button>
                    </form>
                    <%}else{%><span style="color:#94a3b8;font-size:12px">Done</span><%}%>
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
