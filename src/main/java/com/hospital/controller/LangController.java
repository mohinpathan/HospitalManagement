package com.hospital.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LangController {

    @GetMapping("/changeLang")
    public String changeLang(
            @RequestParam("lang") String lang,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session) {

        // Validate
        if (!"en".equals(lang) && !"hi".equals(lang)) lang = "en";

        // 1. Set persistent cookie (30 days)
        Cookie cookie = new Cookie("hms_lang", lang);
        cookie.setMaxAge(60 * 60 * 24 * 30);
        cookie.setPath("/");
        cookie.setHttpOnly(false); // must be readable by JSP
        response.addCookie(cookie);

        // 2. Also store in session for IMMEDIATE effect on same request
        session.setAttribute("hms_lang", lang);

        // 3. Redirect back to referer
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) {
            referer = "/HospitalManagement/home.jsp";
        }
        // Avoid redirect loop
        if (referer.contains("/changeLang")) {
            referer = "/HospitalManagement/home.jsp";
        }
        return "redirect:" + referer;
    }
}
