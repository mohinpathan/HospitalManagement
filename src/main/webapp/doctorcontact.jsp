<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/lang.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Contact Us</title>

<style>

/* Page Animation */
.fade-in {
    animation: fadeIn 0.8s ease-in-out;
}

.slide-up {
    animation: slideUp 0.8s ease-in-out;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideUp {
    from { transform: translateY(30px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

/* Contact Layout */
.contact-container {
    width: 85%;
    margin: auto;
    padding: 40px 0;
}

.contact-header {
    text-align: center;
    margin-bottom: 40px;
}

.contact-header h1 {
    font-size: 32px;
    color: #0d1b2a;
}

.contact-header p {
    color: gray;
}

/* Grid */
.contact-grid {
    display: flex;
    gap: 30px;
}

/* Cards */
.contact-card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    transition: 0.3s;
}

.contact-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.12);
}

/* Left Panel */
.contact-info {
    flex: 1;
}

.info-item {
    display: flex;
    gap: 15px;
    margin-bottom: 20px;
    transition: 0.3s;
}

.info-item:hover {
    transform: translateX(5px);
}

.info-icon {
    font-size: 22px;
    color: #1d4ed8;
}

/* Map Placeholder */
.map-box {
    margin-top: 20px;
    height: 160px;
    background: #f1f5f9;
    border-radius: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: gray;
    transition: 0.3s;
}

.map-box:hover {
    background: #e2e8f0;
}

/* Form Panel */
.contact-form {
    flex: 1;
}

.contact-form input,
.contact-form textarea {
    width: 100%;
    padding: 10px;
    margin-top: 8px;
    margin-bottom: 15px;
    border-radius: 6px;
    border: 1px solid #ddd;
    transition: 0.3s;
}

.contact-form input:focus,
.contact-form textarea:focus {
    border-color: #1d4ed8;
    box-shadow: 0 0 5px rgba(29,78,216,0.3);
    outline: none;
}

.send-btn {
    width: 100%;
    background: #1d4ed8;
    color: white;
    border: none;
    padding: 12px;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.3s;
}

.send-btn:hover {
    background: #2563eb;
    transform: scale(1.02);
}

</style>
</head>

<body class="fade-in">

<jsp:include page="/doctorheader.jsp" />
<section class="about-values fade-in">
<div class="contact-container">

    <div class="contact-header slide-up">
        <h1>Contact Us</h1>
        <p>Have questions? We're here to help.</p>
    </div>

    <div class="contact-grid">

        <!-- LEFT INFO -->
        <div class="contact-card contact-info slide-up">

            <h3>Get In Touch</h3>

            <div class="info-item">
                <div class="info-icon">📍</div>
                <div>
                    <b>Address</b>
                    <p>123 Medical Center Drive<br>New York, NY 10001</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">📞</div>
                <div>
                    <b>Phone</b>
                    <p>Emergency: +1 555 123 4567<br>Appointment: +1 555 987 6543</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">✉️</div>
                <div>
                    <b>Email</b>
                    <p>info@hospital.com<br>support@hospital.com</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">⏰</div>
                <div>
                    <b>Hours of Operation</b>
                    <p>Mon – Sat: 8:00 AM – 8:00 PM</p>
                </div>
            </div>

        </div>

        <!-- RIGHT FORM -->
        <div class="contact-card contact-form slide-up">

            <h3>Send Us a Message</h3>

            <form action="ContactServlet" method="post">

                <label>Full Name</label>
                <input type="text" name="name" required>

                <label>Email Address</label>
                <input type="email" name="email" required>

                <label>Phone Number</label>
                <input type="text" name="phone">

                <label>Subject</label>
                <input type="text" name="subject">

                <label>Message</label>
                <textarea name="message" rows="4" required></textarea>

                <button class="send-btn">Send Message</button>

            </form>

        </div>

    </div>
</div>
</section>
<jsp:include page="/footer.jsp" />

</body>
</html>
