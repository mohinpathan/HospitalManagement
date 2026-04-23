package com.hospital.controller;

import com.hospital.model.Bill;
import com.hospital.service.BillService;
import com.hospital.util.EmailService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/patient/payment")
public class PaymentController {

    @Autowired private JdbcTemplate  jdbc;
    @Autowired private BillService   billService;
    @Autowired private EmailService  emailService;

    /** Show payment page for a bill */
    @GetMapping("/{billId}")
    public String paymentPage(@PathVariable("billId") int billId,
            HttpSession session, HttpServletRequest req) {
        if (!"patient".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");
        Bill bill = billService.getBillWithDetails(billId);
        if (bill == null || bill.getPatientId() != pid) return "redirect:/patient/medicalRecords";
        req.setAttribute("bill", bill);
        return "forward:/payonline.jsp";
    }

    /** Process online payment */
    @PostMapping("/process")
    public String processPayment(
            @RequestParam("billId")        int    billId,
            @RequestParam("paymentMethod") String method,
            @RequestParam("cardName")      String cardName,
            HttpSession session, RedirectAttributes ra) {

        if (!"patient".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");

        Bill bill = billService.getBillWithDetails(billId);
        if (bill == null || bill.getPatientId() != pid) {
            ra.addFlashAttribute("error", "Invalid bill.");
            return "redirect:/patient/medicalRecords";
        }

        if ("paid".equals(bill.getPaymentStatus()) || "confirmed".equals(bill.getPaymentStatus())) {
            ra.addFlashAttribute("error", "This bill has already been paid.");
            return "redirect:/patient/medicalRecords";
        }

        // Generate transaction ID
        String txnId = "TXN" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0,6).toUpperCase();

        // Save payment record
        try {
            jdbc.update(
                "INSERT INTO payments (bill_id, patient_id, amount, payment_method, transaction_id, status) VALUES (?,?,?,?,?,'success')",
                billId, pid, bill.getTotalAmount(), method, txnId);
        } catch (Exception ignored) {}

        // Update bill status to paid
        jdbc.update("UPDATE bills SET payment_status='paid', payment_method=? WHERE id=?", method, billId);

        // Send confirmation email
        String patientName  = (String) session.getAttribute("patientName");
        String patientEmail = (String) session.getAttribute("patientEmail");
        emailService.sendPaymentConfirmation(patientEmail, patientName,
                bill.getDoctorName(), bill.getTotalAmount(), txnId, method);

        ra.addFlashAttribute("success", "Payment successful! Transaction ID: " + txnId);
        ra.addFlashAttribute("txnId", txnId);
        return "redirect:/patient/medicalRecords";
    }
}
