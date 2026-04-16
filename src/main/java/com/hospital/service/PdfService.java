package com.hospital.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.hospital.model.Bill;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;

@Service
public class PdfService {

    private static final BaseColor BLUE   = new BaseColor(43, 124, 255);
    private static final BaseColor LIGHT  = new BaseColor(240, 244, 248);
    private static final BaseColor DARK   = new BaseColor(15, 23, 42);
    private static final BaseColor GRAY   = new BaseColor(100, 116, 139);

    public byte[] generateBillPdf(Bill bill) throws Exception {
        Document doc = new Document(PageSize.A4, 50, 50, 60, 60);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfWriter.getInstance(doc, out);
        doc.open();

        // ── Header ──────────────────────────────────────────
        Font titleFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, BLUE);
        Font subFont    = FontFactory.getFont(FontFactory.HELVETICA, 11, GRAY);
        Font boldFont   = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, DARK);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11, DARK);
        Font smallGray  = FontFactory.getFont(FontFactory.HELVETICA, 9, GRAY);
        Font whiteFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, BaseColor.WHITE);

        Paragraph title = new Paragraph("HealthCare Connect", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        doc.add(title);

        Paragraph sub = new Paragraph("RK University Road, Rajkot | support@hospital.com | +91 98765 43210", subFont);
        sub.setAlignment(Element.ALIGN_CENTER);
        sub.setSpacingAfter(6);
        doc.add(sub);

        // Divider
        LineSeparator line = new LineSeparator(1, 100, BLUE, Element.ALIGN_CENTER, -2);
        doc.add(new Chunk(line));

        // Bill title
        Paragraph billTitle = new Paragraph("\nPAYMENT RECEIPT", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, DARK));
        billTitle.setAlignment(Element.ALIGN_CENTER);
        billTitle.setSpacingAfter(4);
        doc.add(billTitle);

        Paragraph billId = new Paragraph("Bill #" + bill.getId() + "  |  Status: " + bill.getPaymentStatus().toUpperCase(), subFont);
        billId.setAlignment(Element.ALIGN_CENTER);
        billId.setSpacingAfter(16);
        doc.add(billId);

        // ── Patient & Doctor Info ────────────────────────────
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(16);

        addInfoCell(infoTable, "Patient", bill.getPatientName(), boldFont, normalFont);
        addInfoCell(infoTable, "Doctor",  bill.getDoctorName(),  boldFont, normalFont);
        addInfoCell(infoTable, "Payment Method", bill.getPaymentMethod(), boldFont, normalFont);
        addInfoCell(infoTable, "Date", bill.getCreatedAt() != null ? bill.getCreatedAt().toString().substring(0,10) : "—", boldFont, normalFont);
        doc.add(infoTable);

        // ── Prescription ─────────────────────────────────────
        if (bill.getDiagnosis() != null) {
            PdfPTable rxTable = new PdfPTable(1);
            rxTable.setWidthPercentage(100);
            rxTable.setSpacingAfter(16);

            PdfPCell rxHeader = new PdfPCell(new Phrase("PRESCRIPTION DETAILS", whiteFont));
            rxHeader.setBackgroundColor(BLUE);
            rxHeader.setPadding(10);
            rxHeader.setBorder(Rectangle.NO_BORDER);
            rxTable.addCell(rxHeader);

            addRxRow(rxTable, "Diagnosis",  bill.getDiagnosis(),  boldFont, normalFont);
            addRxRow(rxTable, "Medicines",  bill.getMedicines(),  boldFont, normalFont);
            doc.add(rxTable);
        }

        // ── Bill Breakdown ───────────────────────────────────
        PdfPTable billTable = new PdfPTable(2);
        billTable.setWidthPercentage(100);
        billTable.setSpacingAfter(20);

        PdfPCell billHeader = new PdfPCell(new Phrase("BILL BREAKDOWN", whiteFont));
        billHeader.setColspan(2);
        billHeader.setBackgroundColor(BLUE);
        billHeader.setPadding(10);
        billHeader.setBorder(Rectangle.NO_BORDER);
        billTable.addCell(billHeader);

        addBillRow(billTable, "Consultation Fee", "₹" + String.format("%.2f", bill.getConsultationFee()), normalFont, normalFont, false);
        addBillRow(billTable, "Medicine Charge",  "₹" + String.format("%.2f", bill.getMedicineCharge()),  normalFont, normalFont, false);
        addBillRow(billTable, "Other Charges",    "₹" + String.format("%.2f", bill.getOtherCharge()),     normalFont, normalFont, false);

        Font totalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, BaseColor.WHITE);
        addBillRow(billTable, "TOTAL AMOUNT", "₹" + String.format("%.2f", bill.getTotalAmount()), totalFont, totalFont, true);
        doc.add(billTable);

        // ── Footer ───────────────────────────────────────────
        Paragraph footer = new Paragraph("Thank you for choosing HealthCare Connect. We wish you a speedy recovery!", smallGray);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(10);
        doc.add(footer);

        Paragraph gen = new Paragraph("Generated on: " + new java.util.Date(), smallGray);
        gen.setAlignment(Element.ALIGN_CENTER);
        doc.add(gen);

        doc.close();
        return out.toByteArray();
    }

    private void addInfoCell(PdfPTable t, String label, String value, Font lf, Font vf) {
        PdfPCell c = new PdfPCell();
        c.addElement(new Phrase(label, lf));
        c.addElement(new Phrase(value != null ? value : "—", vf));
        c.setPadding(10); c.setBorderColor(new BaseColor(232, 237, 245));
        t.addCell(c);
    }

    private void addRxRow(PdfPTable t, String label, String value, Font lf, Font vf) {
        PdfPCell c = new PdfPCell();
        c.addElement(new Phrase(label + ": ", lf));
        c.addElement(new Phrase(value != null ? value : "—", vf));
        c.setPadding(10); c.setBorderColor(new BaseColor(232, 237, 245));
        t.addCell(c);
    }

    private void addBillRow(PdfPTable t, String label, String value, Font lf, Font vf, boolean highlight) {
        BaseColor bg = highlight ? BLUE : (t.getRows().size() % 2 == 0 ? LIGHT : BaseColor.WHITE);
        PdfPCell lc = new PdfPCell(new Phrase(label, lf));
        PdfPCell vc = new PdfPCell(new Phrase(value, vf));
        lc.setBackgroundColor(bg); vc.setBackgroundColor(bg);
        lc.setPadding(10); vc.setPadding(10);
        vc.setHorizontalAlignment(Element.ALIGN_RIGHT);
        lc.setBorderColor(new BaseColor(232, 237, 245));
        vc.setBorderColor(new BaseColor(232, 237, 245));
        t.addCell(lc); t.addCell(vc);
    }
}
