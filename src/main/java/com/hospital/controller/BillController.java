package com.hospital.controller;

import com.hospital.model.Bill;
import com.hospital.service.BillService;
import com.hospital.util.EmailService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class BillController {

    @Autowired private BillService  billService;
    @Autowired private EmailService emailService;

    /**
     * Doctor creates a bill after writing prescription.
     * POST /createBill
     */
    @PostMapping("/createBill")
    public String createBill(
            @RequestParam("appointmentId")   int    appointmentId,
            @RequestParam("patientId")       int    patientId,
            @RequestParam("doctorId")        int    doctorId,
            @RequestParam("consultationFee") double consultationFee,
            @RequestParam(value = "medicineCharge", defaultValue = "0") double medicineCharge,
            @RequestParam(value = "otherCharge",    defaultValue = "0") double otherCharge,
            @RequestParam("paymentMethod")   String paymentMethod,
            @RequestParam("diagnosis")       String diagnosis,
            @RequestParam("medicines")       String medicines,
            @RequestParam(value = "instructions", required = false) String instructions,
            @RequestParam(value = "followUpDate",  required = false) String followUpDate,
            RedirectAttributes ra) {

        billService.createBillWithPrescription(
                appointmentId, patientId, doctorId,
                consultationFee, medicineCharge, otherCharge, paymentMethod,
                diagnosis, medicines, instructions, followUpDate);

        ra.addFlashAttribute("success", "Prescription and bill saved successfully.");
        return "redirect:/doctor/appointments";
    }

    /**
     * Admin confirms a bill and sends receipt + prescription email to patient.
     * POST /admin/confirmBill
     */
    @PostMapping("/admin/confirmBill")
    public String confirmBill(
            @RequestParam("billId") int billId,
            HttpSession session,
            RedirectAttributes ra) {

        if (!"admin".equals(session.getAttribute("role"))) return "redirect:/login.jsp";

        int adminId = (int) session.getAttribute("adminId");
        Bill bill   = billService.confirmBill(billId, adminId);

        if (bill != null) {
            emailService.sendBillReceipt(
                    bill.getPatientEmail(),
                    bill.getPatientName(),
                    bill.getDoctorName(),
                    bill.getDiagnosis(),
                    bill.getMedicines(),
                    bill.getTotalAmount(),
                    bill.getId());
            billService.markReceiptSent(billId);
            ra.addFlashAttribute("success", "Bill confirmed and receipt emailed to patient.");
        }

        return "redirect:/admin/bills";
    }
}
