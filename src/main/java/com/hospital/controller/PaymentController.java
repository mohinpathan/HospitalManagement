package com.hospital.controller;

import com.hospital.model.Bill;
import com.hospital.service.BillService;
import com.hospital.service.NotificationService;
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

    @Autowired private BillService         billService;
    @Autowired private NotificationService notifService;
    @Autowired private EmailService        emailService;
    @Autowired private JdbcTemplate        jdbc;

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

    /** Process payment */
    @PostMapping("/process")
    public String processPayment(
            @RequestParam("billId")        int billId,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "cardNumber",  required = false) String cardNumber,
            @RequestParam(value = "upiId",       required = false) String upiId,
            HttpSession session, RedirectAttributes ra) {

        if (!"patient".equals(session.getAttribute("role"))) return "redirect:/login.jsp";
        int pid = (int) session.getAttribute("patientId");

        Bill bill = billService.getBillWithDetails(billId);
        if (bill == null || bill.getPatientId() != pid) {
            ra.addFlashAttribute("error", "Invalid bill.");
            return "redirect:/patient/medicalRecords";
        }

        if ("confirmed".equals(bill.getPaymentStatus()) || "paid".equals(bill.getPaymentStatus())) {
            ra.addFlashAttribute("error", "This bill has already been paid.");
            return "redirect:/patient/medicalRecords";
        }

        // Generate transaction ID
        String txnId = "TXN" + UUID.randomUUID().toString().replace("-","").substring(0,12).toUpperCase();

        // Save payment record
        jdbc.update(
            "INSERT INTO payments (bill_id, patient_id, amount, payment_method, transaction_id, status) VALUES (?,?,?,?,?,'success')",
            billId, pid, bill.getTotalAmount(), paymentMethod, txnId);

        // Update bill status to paid
        jdbc.update("UPDATE bills SET payment_status='paid', payment_method=? WHERE id=?", paymentMethod, billId);

        // Send receipt email
        emailService.sendBillReceipt(
            bill.getPatientEmail(), bill.getPatientName(),
            bill.getDoctorName(), bill.getDiagnosis(),
            bill.getMedicines(), bill.getTotalAmount(), billId);

        // Mark receipt sent
        billService.markReceiptSent(billId);

        // Notify patient
        notifService.create(pid, "patient",
            "Payment Successful ✅",
            "Your payment of ₹" + String.format("%.0f", bill.getTotalAmount()) + " was successful. TXN: " + txnId,
            "success");

        ra.addFlashAttribute("success", "Payment successful! Transaction ID: " + txnId + ". Receipt sent to your email.");
        ra.addFlashAttribute("txnId", txnId);
        return "redirect:/patient/medicalRecords";
    }
}
