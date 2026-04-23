<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Read language — session takes priority over cookie for immediate effect
    String _swLang = "en";
    if (session.getAttribute("hms_lang") != null) {
        _swLang = (String) session.getAttribute("hms_lang");
    } else if (request.getCookies() != null) {
        for (jakarta.servlet.http.Cookie _c : request.getCookies()) {
            if ("hms_lang".equals(_c.getName())) { _swLang = _c.getValue(); break; }
        }
    }
    boolean _swHi = "hi".equals(_swLang);
%>
<style>
.lang-sw{display:inline-flex;align-items:center;gap:3px;background:#f8fafc;border:1.5px solid #e5e7eb;border-radius:30px;padding:3px 5px;margin-left:8px}
.lang-sw a{padding:5px 12px;border-radius:20px;font-size:12px;font-weight:700;text-decoration:none;color:#64748b;transition:all .2s;white-space:nowrap}
.lang-sw a.on{background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;box-shadow:0 2px 8px rgba(43,124,255,.3)}
.lang-sw a:hover:not(.on){background:#f1f5f9;color:#374151}
</style>
<div class="lang-sw">
    <a href="/HospitalManagement/changeLang?lang=en" class="<%=!_swHi?"on":""%>">🇬🇧 EN</a>
    <a href="/HospitalManagement/changeLang?lang=hi" class="<%=_swHi?"on":""%>">🇮🇳 हि</a>
</div>
