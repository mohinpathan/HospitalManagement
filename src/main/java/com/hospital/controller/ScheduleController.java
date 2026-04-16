package com.hospital.controller;

import com.hospital.service.ScheduleService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/doctor/schedule")
public class ScheduleController {

    @Autowired private ScheduleService scheduleService;

    @GetMapping("")
    public String view(HttpSession session, HttpServletRequest req) {
        if (!"doctor".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        req.setAttribute("schedules", scheduleService.getByDoctor(did));
        return "forward:/docmyschedule.jsp";
    }

    @PostMapping("/save")
    public String save(
            @RequestParam("dayOfWeek")  String day,
            @RequestParam("startTime")  String start,
            @RequestParam("endTime")    String end,
            HttpSession session, RedirectAttributes ra) {
        if (!"doctor".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        scheduleService.save(did, day, start, end);
        ra.addFlashAttribute("success", "Schedule saved for " + day + ".");
        return "redirect:/doctor/schedule";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!"doctor".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        scheduleService.delete(id, did);
        ra.addFlashAttribute("success", "Schedule removed.");
        return "redirect:/doctor/schedule";
    }

    /** AJAX: get available slots for a doctor on a date */
    @GetMapping("/slots")
    @ResponseBody
    public Object slots(@RequestParam("doctorId") int doctorId,
                        @RequestParam("date")     String date) {
        return scheduleService.getAvailableSlots(doctorId, date);
    }
}
