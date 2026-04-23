<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Reports</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<style>
body{background:#f0f4f8;margin:0;font-family:'Segoe UI',Arial,sans-serif}
.dash-body{display:flex;min-height:calc(100vh - 62px)}
.dash-main{flex:1;padding:24px 28px;overflow-y:auto}
.page-hdr{margin-bottom:24px}
.page-hdr h2{font-size:22px;font-weight:800;color:#0f172a}
.page-hdr p{font-size:14px;color:#64748b;margin-top:3px}
.chart-card{background:#fff;border-radius:16px;padding:24px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5;margin-bottom:24px}
.chart-card h5{font-size:15px;font-weight:700;color:#0f172a;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.top-doc-card{background:#fff;border-radius:16px;padding:22px;box-shadow:0 2px 16px rgba(0,0,0,.07);border:1px solid #e8edf5}
.top-doc-card h5{font-size:15px;font-weight:700;color:#0f172a;margin-bottom:16px}
.doc-row{display:flex;align-items:center;gap:14px;padding:12px 0;border-bottom:1px solid #f8fafc}
.doc-row:last-child{border-bottom:none}
.doc-rank{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;flex-shrink:0}
.stars{color:#f59e0b;font-size:13px}
@media(max-width:768px){.dash-main{padding:16px}}
</style>
</head><body>
<jsp:include page="/adminheader.jsp" />
<div class="dash-body">
<jsp:include page="/adminsidebar.jsp" />
<div class="dash-main">

    <div class="page-hdr">
        <h2><i class="fa fa-chart-line me-2" style="color:#2b7cff"></i><%=L(hi,"रिपोर्ट और विश्लेषण","Reports & Analytics")%></h2>
        <p>Hospital performance overview and statistics.</p>
    </div>

    <div class="row g-4">
        <!-- Revenue Chart -->
        <div class="col-lg-8">
            <div class="chart-card">
                <h5><i class="fa fa-indian-rupee-sign" style="color:#19b37a"></i> <%=L(hi,"मासिक राजस्व","Monthly Revenue")%></h5>
                <canvas id="revenueChart" height="100"></canvas>
            </div>
        </div>

        <!-- Dept Stats -->
        <div class="col-lg-4">
            <div class="chart-card">
                <h5><i class="fa fa-hospital" style="color:#7c3aed"></i> <%=L(hi,"अपॉइंटमेंट","Appointments")%> by Dept</h5>
                <canvas id="deptChart" height="200"></canvas>
            </div>
        </div>

        <!-- <%=L(hi,"अपॉइंटमेंट ट्रेंड","Appointment Trend")%> -->
        <div class="col-lg-8">
            <div class="chart-card">
                <h5><i class="fa fa-calendar-check" style="color:#2b7cff"></i> <%=L(hi,"अपॉइंटमेंट ट्रेंड","Appointment Trend")%></h5>
                <canvas id="trendChart" height="100"></canvas>
            </div>
        </div>

        <!-- Top <%=L(hi,"डॉक्टर","Doctor")%>s -->
        <div class="col-lg-4">
            <div class="top-doc-card">
                <h5><i class="fa fa-trophy" style="color:#f59e0b"></i> <%=L(hi,"शीर्ष रेटेड डॉक्टर","Top Rated <%=L(hi,"डॉक्टर","Doctor")%>s")%></h5>
                <%
                    List<Map<String,Object>> topDocs=(List<Map<String,Object>>)request.getAttribute("top<%=L(hi,"डॉक्टर","Doctor")%>s");
                    int rank=1;
                    if(topDocs!=null)for(Map<String,Object> d:topDocs){
                        double avg=d.get("avg_rating")!=null?((Number)d.get("avg_rating")).doubleValue():0;
                        int cnt=d.get("review_count")!=null?((Number)d.get("review_count")).intValue():0;
                %>
                <div class="doc-row">
                    <div class="doc-rank"><%=rank++%></div>
                    <div style="flex:1">
                        <div style="font-weight:700;font-size:14px;color:#0f172a"><%=d.get("full_name")%></div>
                        <div style="font-size:12px;color:#64748b"><%=d.get("specialization")%></div>
                        <div class="stars">
                            <%for(int i=1;i<=5;i++){%><i class="fa fa-star<%=i<=avg?"":" fa-regular"%>"></i><%}%>
                            <span style="color:#64748b;font-size:11px;margin-left:4px"><%=String.format("%.1f",avg)%> (<%=cnt%>)</span>
                        </div>
                    </div>
                </div>
                <%}%>
            </div>
        </div>
    </div>
</div></div>
<jsp:include page="/footer.jsp" />

<script>
<%
    List<Map<String,Object>> revenue=(List<Map<String,Object>>)request.getAttribute("monthlyRevenue");
    List<Map<String,Object>> trend=(List<Map<String,Object>>)request.getAttribute("apptTrend");
    List<Map<String,Object>> dept=(List<Map<String,Object>>)request.getAttribute("deptStats");

    StringBuilder revLabels=new StringBuilder("[");
    StringBuilder revData=new StringBuilder("[");
    if(revenue!=null){Collections.reverse(revenue);for(Map<String,Object> r:revenue){revLabels.append("'").append(r.get("month")).append("',");revData.append(r.get("revenue")).append(",");}}
    revLabels.append("]"); revData.append("]");

    StringBuilder trendLabels=new StringBuilder("[");
    StringBuilder trendData=new StringBuilder("[");
    if(trend!=null){Collections.reverse(trend);for(Map<String,Object> t:trend){trendLabels.append("'").append(t.get("month")).append("',");trendData.append(t.get("count")).append(",");}}
    trendLabels.append("]"); trendData.append("]");

    StringBuilder deptLabels=new StringBuilder("[");
    StringBuilder deptData=new StringBuilder("[");
    if(dept!=null)for(Map<String,Object> d:dept){deptLabels.append("'").append(d.get("name")).append("',");deptData.append(d.get("count")).append(",");}
    deptLabels.append("]"); deptData.append("]");
%>
new Chart(document.getElementById('revenueChart'),{type:'bar',data:{labels:<%=revLabels%>,datasets:[{label:'Revenue (₹)',data:<%=revData%>,backgroundColor:'rgba(43,124,255,.7)',borderRadius:6}]},options:{plugins:{legend:{display:false}},scales:{y:{beginAtZero:true}}}});
new Chart(document.getElementById('trendChart'),{type:'line',data:{labels:<%=trendLabels%>,datasets:[{label:'<%=L(hi,"अपॉइंटमेंट","Appointments")%>',data:<%=trendData%>,borderColor:'#19b37a',backgroundColor:'rgba(25,179,122,.1)',fill:true,tension:.4,pointRadius:4}]},options:{plugins:{legend:{display:false}},scales:{y:{beginAtZero:true}}}});
new Chart(document.getElementById('deptChart'),{type:'doughnut',data:{labels:<%=deptLabels%>,datasets:[{data:<%=deptData%>,backgroundColor:['#2b7cff','#19b37a','#7c3aed','#f59e0b','#ef4444','#64748b']}]},options:{plugins:{legend:{position:'bottom'}}}});
</script>
</body></html>
