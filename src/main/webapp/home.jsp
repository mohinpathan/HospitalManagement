<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>HealthCare Connect - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="/HospitalManagement/responsive.css">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f4f8;color:#1e293b;display:flex;flex-direction:column;min-height:100vh}
a{text-decoration:none}
/* HERO */
.hero-section{background:linear-gradient(135deg,#1e3a8a 0%,#2b7cff 55%,#06b6d4 100%);color:#fff;padding:90px 80px;display:flex;align-items:center;gap:70px;flex-wrap:wrap}
.hero-section .hero-text{flex:1;min-width:280px}
.hero-section .hero-text h1{font-size:52px;font-weight:900;line-height:1.12;margin-bottom:20px;letter-spacing:-1px}
.hero-section .hero-text h1 span{color:#93c5fd}
.hero-section .hero-text p{font-size:18px;opacity:.9;line-height:1.75;margin-bottom:36px}
.hero-section .hero-btns{display:flex;gap:14px;flex-wrap:wrap}
.hero-section .btn-hero-primary{background:#fff;color:#2b7cff;padding:14px 30px;border-radius:12px;font-size:15px;font-weight:700;border:none;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:8px}
.hero-section .btn-hero-primary:hover{box-shadow:0 8px 24px rgba(0,0,0,.2);transform:translateY(-2px)}
.hero-section .btn-hero-outline{background:transparent;color:#fff;border:2px solid rgba(255,255,255,.6);padding:12px 28px;border-radius:12px;font-size:15px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:8px}
.hero-section .btn-hero-outline:hover{background:rgba(255,255,255,.12)}
.hero-section .hero-img{flex:1;min-width:280px;max-width:500px}
.hero-section .hero-img img{width:100%;border-radius:20px;box-shadow:0 24px 64px rgba(0,0,0,.3)}
/* STATS */
.stats-bar{background:#fff;display:flex;justify-content:space-around;padding:44px 60px;flex-wrap:wrap;gap:24px;box-shadow:0 4px 20px rgba(0,0,0,.06)}
.stat-item{text-align:center;flex:1;min-width:140px}
.stat-item .stat-num{font-size:36px;font-weight:900;color:#0f172a;line-height:1}
.stat-item .stat-label{font-size:14px;color:#64748b;margin-top:6px}
.stat-item .stat-icon{font-size:32px;margin-bottom:10px}
/* SERVICES */
.section-header{text-align:center;padding:60px 20px 10px;background:#f0f4f8}
.section-header h2{font-size:34px;font-weight:800;color:#0f172a}
.section-header p{color:#64748b;font-size:16px;margin-top:8px}
.services-grid{background:#f0f4f8;display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:24px;padding:32px 80px 64px;max-width:1200px;margin:0 auto;width:100%}
.svc-card{background:#fff;border-radius:18px;padding:30px;box-shadow:0 4px 20px rgba(0,0,0,.07);transition:all .25s;border:1px solid #e8edf5}
.svc-card:hover{transform:translateY(-6px);box-shadow:0 16px 40px rgba(0,0,0,.12)}
.svc-card .svc-icon{width:60px;height:60px;border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:26px;margin-bottom:18px}
.svc-card .svc-icon.cardio{background:#dbeafe;color:#2b7cff}
.svc-card .svc-icon.neuro{background:#d1fae5;color:#19b37a}
.svc-card .svc-icon.peds{background:#ede9fe;color:#7c3aed}
.svc-card .svc-icon.ortho{background:#fef3c7;color:#d97706}
.svc-card h3{font-size:18px;font-weight:700;color:#0f172a;margin-bottom:10px}
.svc-card p{color:#64748b;font-size:14px;line-height:1.65;margin-bottom:16px}
.svc-card a{color:#2b7cff;font-weight:600;font-size:14px;display:inline-flex;align-items:center;gap:6px}
.svc-card a:hover{gap:10px}
/* HOW IT WORKS */
.how-section{background:#fff;padding:72px 40px;text-align:center}
.how-section h2{font-size:34px;font-weight:800;color:#0f172a;margin-bottom:8px}
.how-section .sub{color:#64748b;font-size:16px;margin-bottom:52px}
.how-grid{display:flex;justify-content:center;gap:48px;flex-wrap:wrap;max-width:900px;margin:0 auto}
.how-step{max-width:240px;text-align:center}
.how-step .step-num{width:72px;height:72px;background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:26px;font-weight:800;margin:0 auto 18px;box-shadow:0 8px 20px rgba(43,124,255,.3)}
.how-step h3{font-size:17px;font-weight:700;color:#0f172a;margin-bottom:8px}
.how-step p{color:#64748b;font-size:14px;line-height:1.65}
/* CTA */
.cta-section{background:linear-gradient(135deg,#1e3a8a,#2b7cff);color:#fff;text-align:center;padding:88px 20px}
.cta-section h2{font-size:38px;font-weight:900;margin-bottom:14px}
.cta-section p{font-size:17px;opacity:.9;margin-bottom:36px;max-width:600px;margin-left:auto;margin-right:auto}
.cta-section .btn-cta{background:#fff;color:#2b7cff;padding:14px 40px;border-radius:30px;font-weight:700;font-size:16px;display:inline-block;transition:all .2s}
.cta-section .btn-cta:hover{box-shadow:0 10px 28px rgba(0,0,0,.2);transform:translateY(-2px)}
@media(max-width:992px){.hero-section{padding:60px 32px;flex-direction:column}.hero-section .hero-text h1{font-size:38px}.services-grid{padding:32px 24px 48px}}
@media(max-width:576px){.stats-bar{padding:32px 20px}.how-grid{flex-direction:column;align-items:center}}
</style>
</head><body>
<jsp:include page="/header.jsp" />

<!-- HERO -->
<section class="hero-section">
    <div class="hero-text">
        <h1>Your Health,<br><span>Our Priority</span></h1>
        <p>Experience world-class healthcare with our team of expert doctors and state-of-the-art facilities. Book your appointment today and take the first step toward better health.</p>
        <div class="hero-btns">
            <a href="/HospitalManagement/register.jsp" class="btn-hero-primary"><i class="fa fa-user-plus"></i> Get Started</a>
            <a href="/HospitalManagement/about.jsp" class="btn-hero-outline"><i class="fa fa-info-circle"></i> Learn More</a>
        </div>
    </div>
    <div class="hero-img">
        <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800" alt="Hospital">
    </div>
</section>

<!-- STATS -->
<section class="stats-bar">
    <div class="stat-item"><div class="stat-icon">👨‍⚕️</div><div class="stat-num">50+</div><div class="stat-label">Expert Doctors</div></div>
    <div class="stat-item"><div class="stat-icon">💙</div><div class="stat-num">10k+</div><div class="stat-label">Happy Patients</div></div>
    <div class="stat-item"><div class="stat-icon">🏆</div><div class="stat-num">25+</div><div class="stat-label">Awards Won</div></div>
    <div class="stat-item"><div class="stat-icon">⏰</div><div class="stat-num">24/7</div><div class="stat-label">Emergency Care</div></div>
</section>

<!-- SERVICES -->
<div class="section-header"><h2>Our Medical Services</h2><p>Comprehensive healthcare services tailored to your needs</p></div>
<div style="background:#f0f4f8;padding:32px 0 64px">
<div class="services-grid">
    <div class="svc-card"><div class="svc-icon cardio"><i class="fa fa-heart-pulse"></i></div><h3>Cardiology</h3><p>Advanced cardiac care with experienced cardiologists using cutting-edge technology.</p><a href="/HospitalManagement/register.jsp">Find Specialists <i class="fa fa-arrow-right"></i></a></div>
    <div class="svc-card"><div class="svc-icon neuro"><i class="fa fa-brain"></i></div><h3>Neurology</h3><p>Expert neurological care for brain, spine and nervous system disorders.</p><a href="/HospitalManagement/register.jsp">Find Specialists <i class="fa fa-arrow-right"></i></a></div>
    <div class="svc-card"><div class="svc-icon peds"><i class="fa fa-baby"></i></div><h3>Pediatrics</h3><p>Compassionate and specialized care for infants, children and adolescents.</p><a href="/HospitalManagement/register.jsp">Find Specialists <i class="fa fa-arrow-right"></i></a></div>
    <div class="svc-card"><div class="svc-icon ortho"><i class="fa fa-bone"></i></div><h3>Orthopedics</h3><p>Comprehensive bone, joint and muscle care with advanced surgical options.</p><a href="/HospitalManagement/register.jsp">Find Specialists <i class="fa fa-arrow-right"></i></a></div>
</div>
</div>

<!-- HOW IT WORKS -->
<section class="how-section">
    <h2>How It Works</h2>
    <p class="sub">Simple steps to get the care you need</p>
    <div class="how-grid">
        <div class="how-step"><div class="step-num">1</div><h3>Register</h3><p>Create your account and complete your health profile in minutes.</p></div>
        <div class="how-step"><div class="step-num">2</div><h3>Find a Doctor</h3><p>Search doctors by specialization, department or availability.</p></div>
        <div class="how-step"><div class="step-num">3</div><h3>Book & Consult</h3><p>Schedule your appointment and receive expert medical care.</p></div>
    </div>
</section>

<!-- CTA -->
<section class="cta-section">
    <h2>Ready to Get Started?</h2>
    <p>Join thousands of patients who trust HealthCare Connect for their medical needs.</p>
    <a href="/HospitalManagement/register.jsp" class="btn-cta">Create Free Account</a>
</section>

<jsp:include page="/footer.jsp" />
</body></html>
