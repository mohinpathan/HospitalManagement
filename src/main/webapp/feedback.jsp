<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Feedback</title>


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

/* ===== Card ===== */
.form-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 16px;
    padding: 24px;
}

/* ===== Inputs ===== */
.form-label {
    font-weight: 600;
    font-size: 14px;
}

.form-control,
.form-select {
    background: #f8fafc;
    border-radius: 10px;
}

/* ===== Rating Stars ===== */
.rating i {
    font-size: 22px;
    color: #cbd5e1;
    cursor: pointer;
    margin-right: 6px;
}

.rating i.active {
    color: #f59e0b;
}

/* ===== Note Box ===== */
.note-green {
    background: #e7f8ee;
    border: 1px solid #b7e4c7;
    color: #1f9254;
    border-radius: 10px;
    padding: 14px;
    font-size: 14px;
}

/* ===== Purple Button ===== */
.btn-purple {
    background: linear-gradient(135deg,#7c3aed,#8b5cf6);
    border: none;
    color: white;
    font-weight: 600;
    padding: 12px;
    border-radius: 12px;
}

.btn-purple:hover {
    opacity: .92;
    color: white;
}

</style>

<script>
function setRating(n){
    document.getElementById("ratingValue").value = n;
    const stars = document.querySelectorAll(".rating i");
    stars.forEach((s,idx)=>{
        if(idx < n){ s.classList.add("active"); }
        else { s.classList.remove("active"); }
    });
}
</script>

</head>

<body>

<!-- ================= HEADER ================= -->
<jsp:include page="/patientheader.jsp" />

<!-- ================= BODY ================= -->
<div class="d-flex">

    <!-- ===== Sidebar ===== -->
    <jsp:include page="/patientsidebar.jsp" />

    <!-- ===== Main Content ===== -->
    <div class="content flex-grow-1">

        <div class="mb-4">
            <h3 class="page-title">Patient Feedback</h3>
            <small class="text-muted">
                Help us improve our services by sharing your experience
            </small>
        </div>

        <!-- ===== Form ===== -->
        <div class="form-card">

            <form action="submitFeedback" method="post">

                <!-- Rating -->
                <label class="form-label">Rate Your Experience *</label>
                <div class="rating mb-3">
                    <i class="fa fa-star" onclick="setRating(1)"></i>
                    <i class="fa fa-star" onclick="setRating(2)"></i>
                    <i class="fa fa-star" onclick="setRating(3)"></i>
                    <i class="fa fa-star" onclick="setRating(4)"></i>
                    <i class="fa fa-star" onclick="setRating(5)"></i>
                </div>
                <input type="hidden" name="rating" id="ratingValue" required>

                <!-- Category -->
                <div class="mb-3">
                    <label class="form-label">Feedback Category *</label>
                    <select name="category" class="form-select" required>
                        <option value="">Select Category</option>
                        <option>Doctor</option>
                        <option>Staff</option>
                        <option>Facilities</option>
                        <option>Appointment Process</option>
                        <option>Billing</option>
                    </select>
                </div>

                <!-- Subject -->
                <div class="mb-3">
                    <label class="form-label">Subject *</label>
                    <input type="text" name="subject"
                           class="form-control"
                           placeholder="Brief description of your feedback"
                           required>
                </div>

                <!-- Feedback -->
                <div class="mb-3">
                    <label class="form-label">Your Feedback *</label>
                    <textarea name="message"
                              rows="5"
                              class="form-control"
                              placeholder="Please share your detailed feedback..."
                              required></textarea>
                </div>

                <!-- Note -->
                <div class="note-green mb-4">
                    Your feedback is valuable to us and will help improve our healthcare services.
                </div>

                <!-- Submit -->
                <button type="submit" class="btn btn-purple w-100">
                    <i class="fa fa-paper-plane"></i>
                    Submit Feedback
                </button>

            </form>

        </div>

    </div>
</div>

<!-- ================= FOOTER ================= -->
<jsp:include page="/footer.jsp" />

</body>
</html>