<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Hospital Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- ✅ NAVBAR -->
<nav class="navbar">
    <div class="logo">
        <span class="logo-box">H+</span>
        <span class="logo-text">Hospital Management</span>
    </div>

    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
        <a href="login.jsp">Login</a>
        <a href="login.jsp" class="register-btn">Register</a>
    </div>
</nav>

<!-- ✅ HERO SECTION -->
<section class="hero">

    <div class="hero-left">
        <h1>Your Health, Our Priority</h1>

        <p>
            Experience world-class healthcare with our team of expert doctors 
            and state-of-the-art facilities. Book your appointment today.
        </p>

        <div class="hero-buttons">
            <a href="login.jsp">
                <button class="primary-btn">Get Started →</button>
            </a>

            <button class="secondary-btn">Learn More</button>
        </div>
    </div>

    <div class="hero-right">
        <img src="https://images.unsplash.com/photo-1769147555720-71fc71bfc216?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxob3NwaXRhbCUyMG1vZGVybiUyMGJ1aWxkaW5nJTIwZXh0ZXJpb3J8ZW58MXx8fHwxNzcwMDA5NTA2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
                alt="Hospital Building">
    </div>

</section>

<!-- ✅ STATISTICS SECTION -->
<section class="stats">

    <div class="stat-box">
        <div class="stat-icon">👨‍⚕️</div>
        <h2>50+</h2>
        <p>Expert Doctors</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">💙</div>
        <h2>10k+</h2>
        <p>Happy Patients</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">🏆</div>
        <h2>25+</h2>
        <p>Awards Won</p>
    </div>

    <div class="stat-box">
        <div class="stat-icon">⏰</div>
        <h2>24/7</h2>
        <p>Emergency Care</p>
    </div>

</section>

<!-- ✅ SERVICES TITLE -->
<section class="services-title">
    <h1>Our Medical Services</h1>
    <p>Comprehensive healthcare services tailored to your needs</p>
</section>
<!-- ✅ MEDICAL SERVICES CARDS -->
<section class="services">

    <div class="service-card">
        <div class="service-icon cardio">💙</div>
        <h2>Cardiology</h2>
        <p>
            Advanced cardiac care with state-of-the-art equipment 
            and experienced cardiologists.
        </p>
        <a href="login.jsp">Find Specialists →</a>
    </div>

    <div class="service-card">
        <div class="service-icon neuro">🧠</div>
        <h2>Neurology</h2>
        <p>
            Expert neurological care for disorders of the brain, 
            spine, and nervous system.
        </p>
        <a href="login.jsp">Find Specialists →</a>
    </div>

    <div class="service-card">
        <div class="service-icon pediatric">🩺</div>
        <h2>Pediatrics</h2>
        <p>
            Compassionate care for infants, children, and adolescents 
            with experienced pediatricians.
        </p>
        <a href="login.jsp">Find Specialists →</a>
    </div>

</section>

</body>
</html>

