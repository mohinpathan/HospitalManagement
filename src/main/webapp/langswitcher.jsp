<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Reusable language switcher — include this in any header --%>
<%
    String currentLang = "en";
    if (request.getCookies() != null) {
        for (jakarta.servlet.http.Cookie c : request.getCookies()) {
            if ("hms_lang".equals(c.getName())) { currentLang = c.getValue(); break; }
        }
    }
    boolean isHindi = "hi".equals(currentLang);
    String currentUrl = request.getRequestURI();
%>
<style>
.lang-switcher{display:flex;align-items:center;gap:6px;background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:30px;padding:4px 6px}
.lang-btn{padding:5px 12px;border-radius:20px;font-size:12px;font-weight:700;text-decoration:none;transition:all .2s;color:#64748b;display:flex;align-items:center;gap:5px}
.lang-btn.active{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;box-shadow:0 2px 8px rgba(43,124,255,.3)}
.lang-btn:hover:not(.active){background:#f1f5f9;color:#374151}
</style>
<div class="lang-switcher">
    <a href="/HospitalManagement/changeLang?lang=en"
       class="lang-btn <%=!isHindi?"active":""%>">
        🇬🇧 EN
    </a>
    <a href="/HospitalManagement/changeLang?lang=hi"
       class="lang-btn <%=isHindi?"active":""%>">
        🇮🇳 हि
    </a>
</div>
