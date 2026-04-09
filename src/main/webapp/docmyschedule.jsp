<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Schedule</title>


<!-- Bootstrap + Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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

/* ===== Schedule Card ===== */
.schedule-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 14px;
    padding: 22px;
    margin-bottom: 18px;
}

/* ===== Day Box ===== */
.day-box {
    background: #f1f5f9;
    border-radius: 12px;
    padding: 16px;
}

.day-title {
    font-weight: 600;
}

.day-time {
    font-size: 13px;
    color: #64748b;
}

/* ===== Note Box ===== */
.note-box {
    background: #e8f1ff;
    border: 1px solid #c7dcff;
    color: #1e40af;
    border-radius: 10px;
    padding: 14px 16px;
    font-size: 14px;
}

</style>
</head>

<body>

<!-- ================= HEADER ================= -->
<jsp:include page="/doctorheader.jsp" />

<!-- ================= BODY ================= -->
<div class="d-flex fade-in">

    <!-- ===== Sidebar ===== -->
    <jsp:include page="/doctorsidebar.jsp" />

    <!-- ===== Main Content ===== -->
    <div class="content flex-grow-1">

        <div class="mb-4">
            <h3 class="page-title">My Schedule</h3>
            <small class="text-muted">
                Your weekly availability schedule
            </small>
        </div>

        <!-- ===== Schedule Card ===== -->
        <div class="schedule-card">

            <div class="row g-4">

                <!-- Monday -->
                <div class="col-md-4">
                    <div class="day-box">
                        <div class="day-title">
                            <i class="fa fa-calendar text-success"></i>
                            Monday
                        </div>
                        <div class="day-time mt-2">
                            <i class="fa fa-clock"></i>
                            09:00 - 17:00
                        </div>
                    </div>
                </div>

                <!-- Wednesday -->
                <div class="col-md-4">
                    <div class="day-box">
                        <div class="day-title">
                            <i class="fa fa-calendar text-success"></i>
                            Wednesday
                        </div>
                        <div class="day-time mt-2">
                            <i class="fa fa-clock"></i>
                            09:00 - 17:00
                        </div>
                    </div>
                </div>

                <!-- Friday -->
                <div class="col-md-4">
                    <div class="day-box">
                        <div class="day-title">
                            <i class="fa fa-calendar text-success"></i>
                            Friday
                        </div>
                        <div class="day-time mt-2">
                            <i class="fa fa-clock"></i>
                            09:00 - 17:00
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <!-- ===== Info Note ===== -->
        <div class="note-box">
            <i class="fa fa-circle-info"></i>
            <strong> Note:</strong> Your schedule is managed by the admin. 
            To update your availability, please contact the hospital administration.
        </div>

    </div>
</div>

<!-- ================= FOOTER ================= -->
<jsp:include page="/footer.jsp" />

</body>
</html>