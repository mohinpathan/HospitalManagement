package com.hospital.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LangController {

    /**
     * Switch language and redirect back to the referring page.
     * Usage: /changeLang?lang=hi  or  /changeLang?lang=en
     */
    @GetMapping("/changeLang")
    public String changeLang(
            @RequestParam("lang") String lang,
            HttpServletRequest request,
            HttpServletResponse response) {

        // Validate — only allow en or hi
        if (!"en".equals(lang) && !"hi".equals(lang)) lang = "en";

        // Set cookie so Spring's CookieLocaleResolver picks it up
        Cookie cookie = new Cookie("hms_lang", lang);
        cookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
        cookie.setPath("/");
        response.addCookie(cookie);

        // Redirect back to where the user came from
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) referer = "/HospitalManagement/home.jsp";
        return "redirect:" + referer;
    }
}
