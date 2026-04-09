package com.hospital.controller;

import com.hospital.model.Appointment;
import com.hospital.model.Patient;
import com.hospital.service.AppointmentService;
import com.hospital.service.BillService;
import com.hospital.service.DepartmentService;
import com.hospital.service.UserService;
import com.hospital.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.Date;
import java.sql.Time;

@Controller
@RequestMapping("/patient")
public class PatientController {

    @Autowired private UserService        userService;
    @Autowired private AppointmentService apptService;
    @Autowired private DepartmentService  deptService;
    @Autowired private BillService        billService;

    private boolean isPatient(HttpSession s) { return "patient".equals(s.getAttribute("role")); }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");
        req.setAttribute("totalAppts",     apptService.countByPatient(pid));
        req.setAttribute("upcomingAppts",  apptService.countByPatientAndStatus(pid, "approved"));
        req.setAttribute("completedAppts", apptService.countByPatientAndStatus(pid, "completed"));
        req.setAttribute("recentAppts",    apptService.getByPatient(pid));
        req.setAttribute("bills",          billService.getBillsByPatient(pid));
        return "forward:/patientDashboard.jsp";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        req.setAttribute("appointments", apptService.getByPatient((int) session.getAttribute("patientId")));
        return "forward:/patientAppointments.jsp";
    }

    @GetMapping("/bookAppointment")
    public String bookForm(
            @RequestParam(value = "doctorId", required = false, defaultValue = "0") int preselectedDoctorId,
            HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        req.setAttribute("departments", deptService.getAll());
        req.setAttribute("doctors",     userService.getAllDoctors());
        req.setAttribute("preselectedDoctorId", preselectedDoctorId);
        return "forward:/bookAppointment.jsp";
    }

    @PostMapping("/bookAppointment")
    public String bookSubmit(
            @RequestParam("doctorId")     int doctorId,
            @RequestParam("departmentId") int departmentId,
            @RequestParam("date")         String date,
            @RequestParam("time")         String time,
            @RequestParam("reason")       String reason,
            HttpSession session, RedirectAttributes ra) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        Appointment a = new Appointment();
        a.setPatientId((int) session.getAttribute("patientId"));
        a.setDoctorId(doctorId);
        a.setDepartmentId(departmentId);
        a.setAppointmentDate(Date.valueOf(date));
        a.setAppointmentTime(Time.valueOf(time + ":00"));
        a.setReason(reason);
        apptService.book(a);
        ra.addFlashAttribute("success", "Appointment booked! Waiting for approval.");
        return "redirect:/patient/appointments";
    }

    @GetMapping("/cancelAppointment")
    public String cancelAppointment(@RequestParam("id") int id, HttpSession session, RedirectAttributes ra) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        apptService.updateStatus(id, "cancelled");
        ra.addFlashAttribute("success", "Appointment cancelled.");
        return "redirect:/patient/appointments";
    }

    @GetMapping("/findDoctors")
    public String findDoctors(
            @RequestParam(value = "dept",    required = false, defaultValue = "0") int deptId,
            @RequestParam(value = "search",  required = false, defaultValue = "") String search,
            @RequestParam(value = "maxFee",  required = false, defaultValue = "0") double maxFee,
            @RequestParam(value = "sort",    required = false, defaultValue = "") String sort,
            HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        req.setAttribute("departments", deptService.getAll());
        req.setAttribute("doctors", userService.searchDoctors(deptId, search, maxFee, sort));
        return "forward:/findDoctors.jsp";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        req.setAttribute("patient", userService.getPatientById((int) session.getAttribute("patientId")));
        return "forward:/patientProfile.jsp";
    }

    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam("name")       String name,
            @RequestParam("phone")      String phone,
            @RequestParam("bloodGroup") String bloodGroup,
            @RequestParam("address")    String address,
            @RequestParam("age")        int age,
            HttpSession session, RedirectAttributes ra) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");
        userService.updatePatientFull(pid, name, phone, bloodGroup, address, age);
        session.setAttribute("patientName", name);
        ra.addFlashAttribute("success", "Profile updated successfully.");
        return "redirect:/patient/profile";
    }

    @PostMapping("/changePassword")
    public String changePassword(
            @RequestParam("currentPass")  String currentPass,
            @RequestParam("newPass")      String newPass,
            @RequestParam("confirmPass")  String confirmPass,
            HttpSession session, RedirectAttributes ra) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");
        Patient p = userService.getPatientById(pid);
        if (!PasswordUtil.verify(currentPass, p.getPassword())) {
            ra.addFlashAttribute("pwError", "Current password is incorrect.");
            return "redirect:/patient/profile";
        }
        if (!newPass.equals(confirmPass)) {
            ra.addFlashAttribute("pwError", "Passwords do not match.");
            return "redirect:/patient/profile";
        }
        userService.updatePassword(p.getEmail(), "patient", PasswordUtil.hash(newPass));
        ra.addFlashAttribute("success", "Password changed successfully.");
        return "redirect:/patient/profile";
    }

    @GetMapping("/medicalRecords")
    public String medicalRecords(HttpSession session, HttpServletRequest req) {
        if (!isPatient(session)) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");
        req.setAttribute("bills", billService.getBillsByPatient(pid));
        return "forward:/medicalRecords.jsp";
    }
}
