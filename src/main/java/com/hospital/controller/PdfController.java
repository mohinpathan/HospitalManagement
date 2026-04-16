package com.hospital.controller;

import com.hospital.model.Bill;
import com.hospital.service.BillService;
import com.hospital.service.PdfService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
public class PdfController {

    @Autowired private BillService billService;
    @Autowired private PdfService  pdfService;

    /** Patient downloads their own bill PDF */
    @GetMapping("/patient/bill/pdf/{billId}")
    public void downloadBillPdf(@PathVariable("billId") int billId,
                                 HttpSession session,
                                 HttpServletResponse response) throws Exception {
        if (!"patient".equals(session.getAttribute("role"))) {
            response.sendError(403); return;
        }
        int pid = (int) session.getAttribute("patientId");
        Bill bill = billService.getBillWithDetails(billId);
        if (bill == null || bill.getPatientId() != pid) {
            response.sendError(404); return;
        }
        byte[] pdf = pdfService.generateBillPdf(bill);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bill_" + billId + ".pdf");
        response.setContentLength(pdf.length);
        response.getOutputStream().write(pdf);
    }

    /** Admin downloads any bill PDF */
    @GetMapping("/admin/bill/pdf/{billId}")
    public void adminDownloadBillPdf(@PathVariable("billId") int billId,
                                      HttpSession session,
                                      HttpServletResponse response) throws Exception {
        if (!"admin".equals(session.getAttribute("role"))) {
            response.sendError(403); return;
        }
        Bill bill = billService.getBillWithDetails(billId);
        if (bill == null) { response.sendError(404); return; }
        byte[] pdf = pdfService.generateBillPdf(bill);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bill_" + billId + ".pdf");
        response.setContentLength(pdf.length);
        response.getOutputStream().write(pdf);
    }
}
