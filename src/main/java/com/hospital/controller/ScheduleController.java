package com.hospital.controller;

import com.hospital.service.ScheduleService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

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

    /** Reschedule — edit existing slot */
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") int id,
            HttpSession session, HttpServletRequest req) {
        if (!"doctor".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        req.setAttribute("editSlot",  scheduleService.getById(id));
        req.setAttribute("schedules", scheduleService.getByDoctor((int) session.getAttribute("doctorId")));
        return "forward:/docmyschedule.jsp";
    }

    @PostMapping("/update")
    public String update(
            @RequestParam("id")         int id,
            @RequestParam("dayOfWeek")  String day,
            @RequestParam("startTime")  String start,
            @RequestParam("endTime")    String end,
            HttpSession session, RedirectAttributes ra) {
        if (!"doctor".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int did = (int) session.getAttribute("doctorId");
        scheduleService.update(id, did, day, start, end);
        ra.addFlashAttribute("success", "Schedule updated for " + day + ".");
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

    /** AJAX: get slot calendar for a doctor on a date */
    @GetMapping("/slots")
    @ResponseBody
    public Object slots(@RequestParam("doctorId") int doctorId,
                        @RequestParam("date")     String date,
                        HttpSession session) {
        int pid = session.getAttribute("patientId") != null
                  ? (int) session.getAttribute("patientId") : -1;
        return scheduleService.generateSlots(doctorId, date, pid);
    }
}
