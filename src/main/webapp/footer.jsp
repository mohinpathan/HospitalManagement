<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.site-footer{background:linear-gradient(160deg,#0f172a 0%,#1e293b 100%);color:#cbd5e1;padding:60px 0 0;margin-top:auto}
.site-footer .f-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1.4fr;gap:44px;max-width:1200px;margin:0 auto;padding:0 48px 48px}
.site-footer .f-brand .f-logo{display:flex;align-items:center;gap:10px;margin-bottom:14px}
.site-footer .f-brand .f-logo-box{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;padding:7px 12px;border-radius:10px;font-weight:900;font-size:15px}
.site-footer .f-brand .f-logo-text{color:#fff;font-weight:700;font-size:18px}
.site-footer .f-brand p{font-size:14px;line-height:1.75;color:#94a3b8}
.site-footer .f-socials{display:flex;gap:10px;margin-top:18px}
.site-footer .f-socials a{width:38px;height:38px;border-radius:9px;background:rgba(255,255,255,.07);display:flex;align-items:center;justify-content:center;color:#94a3b8;font-size:15px;transition:all .2s}
.site-footer .f-socials a:hover{background:#2b7cff;color:#fff;transform:translateY(-2px)}
.site-footer .f-col h4{color:#fff;font-size:15px;font-weight:700;margin-bottom:18px;padding-bottom:8px;border-bottom:2px solid rgba(255,255,255,.07)}
.site-footer .f-col a{display:flex;align-items:center;gap:7px;color:#94a3b8;font-size:14px;margin-bottom:10px;transition:all .2s}
.site-footer .f-col a:hover{color:#fff;transform:translateX(4px)}
.site-footer .f-col .f-contact-item{display:flex;align-items:flex-start;gap:10px;margin-bottom:12px;font-size:14px;color:#94a3b8}
.site-footer .f-col .f-contact-item i{color:#2b7cff;margin-top:2px;width:16px}
.site-footer .f-bottom{border-top:1px solid rgba(255,255,255,.07);text-align:center;padding:18px;font-size:13px;color:#64748b}
@media(max-width:992px){.site-footer .f-grid{grid-template-columns:1fr 1fr;padding:0 24px 32px}}
@media(max-width:576px){.site-footer .f-grid{grid-template-columns:1fr;padding:0 20px 24px}}
</style>
<footer class="site-footer">
    <div class="f-grid">
        <div class="f-brand">
            <div class="f-logo">
                <span class="f-logo-box">H+</span>
                <span class="f-logo-text">HealthCare Connect</span>
            </div>
            <p>Providing quality healthcare with advanced medical technology and experienced professionals since 2010.</p>
            <div class="f-socials">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
        <div class="f-col">
            <h4>Quick Links</h4>
            <a href="/HospitalManagement/home.jsp"><i class="fa fa-chevron-right fa-xs"></i>Home</a>
            <a href="/HospitalManagement/about.jsp"><i class="fa fa-chevron-right fa-xs"></i>About Us</a>
            <a href="/HospitalManagement/contact.jsp"><i class="fa fa-chevron-right fa-xs"></i>Contact</a>
            <a href="/HospitalManagement/login.jsp"><i class="fa fa-chevron-right fa-xs"></i>Login</a>
            <a href="/HospitalManagement/register.jsp"><i class="fa fa-chevron-right fa-xs"></i>Register</a>
        </div>
        <div class="f-col">
            <h4>Departments</h4>
            <a href="#"><i class="fa fa-chevron-right fa-xs"></i>Cardiology</a>
            <a href="#"><i class="fa fa-chevron-right fa-xs"></i>Neurology</a>
            <a href="#"><i class="fa fa-chevron-right fa-xs"></i>Pediatrics</a>
            <a href="#"><i class="fa fa-chevron-right fa-xs"></i>Orthopedics</a>
            <a href="#"><i class="fa fa-chevron-right fa-xs"></i>Emergency Care</a>
        </div>
        <div class="f-col">
            <h4>Contact Us</h4>
            <div class="f-contact-item"><i class="fa fa-map-marker-alt"></i><span>RK University Road, Rajkot, Gujarat</span></div>
            <div class="f-contact-item"><i class="fa fa-phone"></i><span>+91 98765 43210</span></div>
            <div class="f-contact-item"><i class="fa fa-envelope"></i><span>support@hospital.com</span></div>
            <div class="f-contact-item"><i class="fa fa-clock"></i><span>Mon–Sat: 8:00 AM – 8:00 PM</span></div>
        </div>
    </div>
    <div class="f-bottom">
        &copy; 2026 HealthCare Connect. All rights reserved. &nbsp;|&nbsp; Made with <i class="fa fa-heart" style="color:#ef4444"></i> for better healthcare
    </div>
</footer>
