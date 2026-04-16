package com.hospital.controller;

import com.hospital.service.NotificationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/notifications")
public class NotificationController {

    @Autowired private NotificationService notifService;

    @GetMapping("")
    public String view(HttpSession session, HttpServletRequest req) {
        Integer uid  = getUserId(session);
        String  role = (String) session.getAttribute("role");
        if (uid == null) return "redirect:/login.jsp";
        req.setAttribute("notifications", notifService.getAll(uid, role));
        notifService.markAllRead(uid, role);
        return "forward:/notifications.jsp";
    }

    @GetMapping("/count")
    @ResponseBody
    public Map<String, Integer> count(HttpSession session) {
        Integer uid  = getUserId(session);
        String  role = (String) session.getAttribute("role");
        Map<String, Integer> map = new HashMap<>();
        map.put("count", uid != null ? notifService.countUnread(uid, role) : 0);
        return map;
    }

    @GetMapping("/markRead/{id}")
    @ResponseBody
    public String markRead(@PathVariable("id") int id) {
        notifService.markRead(id);
        return "ok";
    }

    private Integer getUserId(HttpSession s) {
        String role = (String) s.getAttribute("role");
        if ("patient".equals(role)) return (Integer) s.getAttribute("patientId");
        if ("doctor".equals(role))  return (Integer) s.getAttribute("doctorId");
        if ("admin".equals(role))   return (Integer) s.getAttribute("adminId");
        return null;
    }
}
