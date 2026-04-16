package com.hospital.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class FeedbackController {

    @Autowired private JdbcTemplate jdbc;

    /** Public contact form submit */
    @PostMapping("/feedback/submit")
    public String submit(
            @RequestParam("name")    String name,
            @RequestParam("email")   String email,
            @RequestParam("subject") String subject,
            @RequestParam("message") String message,
            RedirectAttributes ra) {
        jdbc.update("INSERT INTO feedback (name, email, subject, message) VALUES (?,?,?,?)",
                    name, email, subject, message);
        ra.addFlashAttribute("success", "Thank you! Your message has been sent.");
        return "redirect:/contact.jsp";
    }

    /** Patient feedback form */
    @PostMapping("/patient/feedback/submit")
    public String patientSubmit(
            @RequestParam("subject") String subject,
            @RequestParam("message") String message,
            HttpSession session, RedirectAttributes ra) {
        if (!"patient".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        String name  = (String) session.getAttribute("patientName");
        String email = (String) session.getAttribute("patientEmail");
        jdbc.update("INSERT INTO feedback (name, email, subject, message) VALUES (?,?,?,?)",
                    name, email, subject, message);
        ra.addFlashAttribute("success", "Feedback submitted. Thank you!");
        return "redirect:/patient/dashboard";
    }

    /** Admin views all feedback */
    @GetMapping("/admin/feedback")
    public String adminView(HttpSession session, HttpServletRequest req) {
        if (!"admin".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        req.setAttribute("feedbacks", jdbc.queryForList(
            "SELECT * FROM feedback ORDER BY submitted_at DESC"));
        return "forward:/adminfeedback.jsp";
    }

    /** Admin deletes feedback */
    @GetMapping("/admin/feedback/delete/{id}")
    public String delete(@PathVariable("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!"admin".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        jdbc.update("DELETE FROM feedback WHERE id=?", id);
        ra.addFlashAttribute("success", "Feedback deleted.");
        return "redirect:/admin/feedback";
    }
}
