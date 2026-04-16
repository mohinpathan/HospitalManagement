package com.hospital.controller;

import com.hospital.service.NotificationService;
import com.hospital.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/patient/review")
public class ReviewController {

    @Autowired private ReviewService      reviewService;
    @Autowired private NotificationService notifService;

    @PostMapping("/submit")
    public String submit(
            @RequestParam("doctorId")       int doctorId,
            @RequestParam("appointmentId")  int appointmentId,
            @RequestParam("rating")         int rating,
            @RequestParam(value = "comment", required = false, defaultValue = "") String comment,
            HttpSession session,
            RedirectAttributes ra) {

        if (!"patient".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int patientId = (int) session.getAttribute("patientId");

        if (reviewService.hasReviewed(patientId, appointmentId)) {
            ra.addFlashAttribute("error", "You have already reviewed this appointment.");
        } else {
            reviewService.addReview(patientId, doctorId, appointmentId, rating, comment);
            // Notify doctor
            notifService.create(doctorId, "doctor",
                "New Review Received ⭐",
                session.getAttribute("patientName") + " gave you a " + rating + "-star review.",
                "info");
            ra.addFlashAttribute("success", "Thank you for your review!");
        }
        return "redirect:/patient/appointments";
    }
}
