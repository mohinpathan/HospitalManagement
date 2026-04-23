<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Schedules</title>


<!-- Bootstrap + Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>

body {
    background: #f5f7fb;
}

.content {
    padding: 30px;
}

.page-title {
    font-weight: 700;
}

/* ===== Doctor Card ===== */
.doc-card {
    background: white;
    border-radius: 14px;
    border: 1px solid #e5e7eb;
    padding: 20px;
    margin-bottom: 22px;
}

.doc-name {
    font-weight: 700;
    font-size: 18px;
}

.doc-dept {
    color: #64748b;
    font-size: 13px;
    margin-bottom: 15px;
}

/* ===== Schedule Block ===== */
.schedule-box {
    background: #f1f5f9;
    border-radius: 10px;
    padding: 14px;
}

.schedule-day {
    font-weight: 600;
}

.schedule-time {
    font-size: 13px;
    color: #64748b;
}

</style>
</head>

<body>

<!-- ================= HEADER ================= -->
<jsp:include page="/adminheader.jsp" />

<!-- ================= BODY ================= -->
<div class="d-flex fade-in">

    <!-- ===== Sidebar ===== -->
    <jsp:include page="/adminsidebar.jsp" />

    <!-- ===== Main Content ===== -->
    <div class="content flex-grow-1">

        <div class="mb-4">
            <h3 class="page-title">Doctor Schedules</h3>
            <small>View availability schedules for all doctors</small>
        </div>

        <!-- ================= Doctor 1 ================= -->
        <div class="doc-card">

            <div class="doc-name">Dr. Sarah Johnson</div>
            <div class="doc-dept">Cardiology - Cardiology</div>

            <div class="row g-3">

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Monday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 09:00 - 17:00
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Wednesday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 09:00 - 17:00
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Friday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 09:00 - 17:00
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- ================= Doctor 2 ================= -->
        <div class="doc-card">

            <div class="doc-name">Dr. Michael Chen</div>
            <div class="doc-dept">Neurology - Neurology</div>

            <div class="row g-3">

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Tuesday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 10:00 - 18:00
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Thursday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 10:00 - 18:00
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- ================= Doctor 3 ================= -->
        <div class="doc-card">

            <div class="doc-name">Dr. Emily Davis</div>
            <div class="doc-dept">Pediatrics - Pediatrics</div>

            <div class="row g-3">

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Monday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 08:00 - 16:00
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Tuesday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 08:00 - 16:00
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="schedule-box">
                        <div class="schedule-day">
                            <i class="fa fa-calendar text-primary"></i> Thursday
                        </div>
                        <div class="schedule-time">
                            <i class="fa fa-clock"></i> 08:00 - 16:00
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

<!-- ================= FOOTER ================= -->
<jsp:include page="/footer.jsp" />

</body>
</html>