package com.hospital.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    /** Send a plain HTML email */
    public void sendHtml(String to, String subject, String htmlBody) {
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** OTP email for forgot-password */
    public void sendOtp(String to, String otp) {
        String body = "<h2>Password Reset OTP</h2>"
                + "<p>Your OTP is: <strong style='font-size:24px;color:#2b7cff'>" + otp + "</strong></p>"
                + "<p>This OTP is valid for <strong>10 minutes</strong>.</p>"
                + "<p>If you did not request this, please ignore this email.</p>";
        sendHtml(to, "Hospital Management - Password Reset OTP", body);
    }

    /** Bill receipt + prescription email to patient */
    public void sendBillReceipt(String to, String patientName,
                                 String doctorName, String diagnosis,
                                 String medicines, double totalAmount,
                                 int billId) {
        String body = "<h2>Payment Receipt & Prescription</h2>"
                + "<p>Dear <strong>" + patientName + "</strong>,</p>"
                + "<p>Your payment has been confirmed. Below are your details:</p>"
                + "<table border='1' cellpadding='8' style='border-collapse:collapse'>"
                + "<tr><td><b>Bill ID</b></td><td>#" + billId + "</td></tr>"
                + "<tr><td><b>Doctor</b></td><td>" + doctorName + "</td></tr>"
                + "<tr><td><b>Diagnosis</b></td><td>" + diagnosis + "</td></tr>"
                + "<tr><td><b>Medicines</b></td><td>" + medicines + "</td></tr>"
                + "<tr><td><b>Total Amount</b></td><td>$" + String.format("%.2f", totalAmount) + "</td></tr>"
                + "</table>"
                + "<p>Thank you for choosing our hospital.</p>";
        sendHtml(to, "Hospital Management - Bill Receipt #" + billId, body);
    }
}
