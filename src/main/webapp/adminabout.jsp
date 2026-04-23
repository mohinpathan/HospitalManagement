<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About Us</title>
<style>
/* ===== FACILITIES SECTION ===== */

.facilities-section {
    width: 85%;
    margin: 50px auto;
    align-items: center;
    text-align: center;
}

.section-title {
    font-size: 28px;
    color: #0d1b2a;
    margin : auto;
    width: fit-content;
    margin-bottom: 30px;
    margin-top:100px;
}

/* Grid Layout */
.facilities-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
    margin: auto;
    width: 80%;
}

/* Facility Cards */
.facility-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    transition: 0.3s;
    cursor: pointer;
}

.facility-card:hover {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 8px 25px rgba(0,0,0,0.12);
}

.facility-card h3 {
    font-size: 18px;
    margin-bottom: 8px;
    color: #0d1b2a;
}

.facility-card p {
    color: gray;
    font-size: 14px;
}

</style>
</head>
<body>

<!-- ✅ Header -->
<jsp:include page="/adminheader.jsp" />

<!-- ✅ ABOUT SECTION -->
<section class="about-values fade-in">

    <div class="about-container">

        <h1 class="values-title">About Our Hospital</h1>

        <p class="value-sub">
            Committed to providing exceptional healthcare services with compassion,
            innovation, and excellence since 1995.
        </p>

        <!-- Image -->
        <div class="about-image">
            <img src="https://cdn.lecturio.com/assets/Featured-image-Student-Blog-Hospital-Team.jpg" 
                 alt="Hospital Team">
        </div>

        <!-- Mission & Vision -->
        <div class="mission-vision">

            <div class="info-card hover-card">
                <div class="icon-circle">🎯</div>
                <h2>Our Mission</h2>
                <p>
                    To deliver patient-centered healthcare of the highest quality,
                    combining advanced medical technology with compassionate care.
                    We strive to improve health outcomes and enhance the well-being
                    of every individual we serve.
                </p>
            </div>

            <div class="info-card hover-card">
                <div class="icon-circle">👁️</div>
                <h2>Our Vision</h2>
                <p>
                    To be recognized as a leading healthcare institution, known for
                    excellence in patient care, medical innovation, and community
                    service. We envision a healthier future where quality healthcare
                    is accessible to all.
                </p>
            </div>

        </div>

        <!-- Core Values -->
        <h1 class="values-title">Our Core Values</h1>

        <div class="values-container">

            <div class="value-card hover-card">
                <div class="value-icon">❤️</div>
                <h3>Compassion</h3>
                <p>Caring for patients with empathy and kindness</p>
            </div>

            <div class="value-card hover-card">
                <div class="value-icon">🏅</div>
                <h3>Excellence</h3>
                <p>Striving for the highest standards in everything we do</p>
            </div>

            <div class="value-card hover-card">
                <div class="value-icon">👥</div>
                <h3>Teamwork</h3>
                <p>Collaborating to provide comprehensive care</p>
            </div>

            <div class="value-card hover-card">
                <div class="value-icon">📜</div>
                <h3>Integrity</h3>
                <p>Upholding honesty and ethical practices</p>
            </div>

        </div>

    </div>

</section>

<!-- ✅ JOURNEY SECTION -->
<section class="journey-section">

    <div class="journey-container">

        <h2 class="journey-title">Our Journey</h2>

        <div class="timeline">

            <div class="timeline-item">
                <div class="timeline-year">1995</div>
                <div class="timeline-content">
                    <h3>Foundation</h3>
                    <p>Hospital established with 50 beds and basic medical services</p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-year">2005</div>
                <div class="timeline-content">
                    <h3>Expansion</h3>
                    <p>Added specialized departments and increased capacity to 200 beds</p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-year">2015</div>
                <div class="timeline-content">
                    <h3>Modernization</h3>
                    <p>Introduced advanced medical technology and digital health records</p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-year">2026</div>
                <div class="timeline-content">
                    <h3>Digital Transformation</h3>
                    <p>Launched online appointment system and telemedicine services</p>
                </div>
            </div>

        </div>

    </div>
 <h2 class="section-title">Our Facilities</h2>

    <div class="facilities-grid">

        <div class="facility-card">
            <h3>Advanced ICU</h3>
            <p>24/7 intensive care with state-of-the-art monitoring systems</p>
        </div>

        <div class="facility-card">
            <h3>Modern Operation Theaters</h3>
            <p>Equipped with the latest surgical technology and equipment</p>
        </div>

        <div class="facility-card">
            <h3>Diagnostic Center</h3>
            <p>Complete diagnostic services including MRI, CT, and lab facilities</p>
        </div>

        <div class="facility-card">
            <h3>Emergency Department</h3>
            <p>Round-the-clock emergency care with rapid response team</p>
        </div>

        <div class="facility-card">
            <h3>Pharmacy</h3>
            <p>In-house pharmacy with comprehensive medication availability</p>
        </div>

        <div class="facility-card">
            <h3>Patient Rooms</h3>
            <p>Comfortable private and semi-private rooms with modern amenities</p>
        </div>

    </div>

</section>

<jsp:include page="/footer.jsp" />

<!-- ✅ Navbar Script -->
<script>
function toggleMenu() {
    document.getElementById("navMenu").classList.toggle("show");
}
</script>

</body>
</html>
