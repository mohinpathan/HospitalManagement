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

    // ── Core send method ─────────────────────────────────────
    public void sendHtml(String to, String subject, String htmlBody) {
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setTo(to);
            helper.setFrom("mohinkhan1118@gmail.com", "HealthCare Connect");
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Send HTML email WITH file attachment ──────────────────
    public void sendHtmlWithAttachment(String to, String subject, String htmlBody,
                                        java.io.File attachmentFile, String attachmentName) {
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setTo(to);
            helper.setFrom("mohinkhan1118@gmail.com", "HealthCare Connect");
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            // Attach the file
            helper.addAttachment(attachmentName, attachmentFile);
            mailSender.send(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Shared email wrapper ──────────────────────────────────
    private String wrap(String accentColor, String iconEmoji, String title, String body) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body style='margin:0;padding:0;background:#f0f4f8;font-family:Segoe UI,Arial,sans-serif'>"
            + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f0f4f8;padding:40px 0'>"
            + "<tr><td align='center'>"
            + "<table width='580' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:18px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,.10)'>"
            // Header
            + "<tr><td style='background:linear-gradient(135deg," + accentColor + ");padding:36px 40px;text-align:center'>"
            + "<div style='font-size:42px;margin-bottom:10px'>" + iconEmoji + "</div>"
            + "<h1 style='color:#fff;margin:0;font-size:24px;font-weight:800;letter-spacing:-0.5px'>" + title + "</h1>"
            + "<p style='color:rgba(255,255,255,.85);margin:8px 0 0;font-size:14px'>HealthCare Connect</p>"
            + "</td></tr>"
            // Body
            + "<tr><td style='padding:36px 40px'>" + body + "</td></tr>"
            // Footer
            + "<tr><td style='background:#f8fafc;padding:20px 40px;text-align:center;border-top:1px solid #e8edf5'>"
            + "<p style='color:#94a3b8;font-size:12px;margin:0'>© 2026 HealthCare Connect &nbsp;|&nbsp; RK University Road, Rajkot &nbsp;|&nbsp; support@hospital.com</p>"
            + "<p style='color:#94a3b8;font-size:11px;margin:6px 0 0'>This is an automated email. Please do not reply.</p>"
            + "</td></tr>"
            + "</table></td></tr></table></body></html>";
    }

    // ── Welcome / Registration email ─────────────────────────
    public void sendWelcome(String to, String name, String role) {
        String roleLabel = role.substring(0, 1).toUpperCase() + role.substring(1);
        String accent = "patient".equals(role) ? "#7c3aed,#8b5cf6"
                      : "doctor".equals(role)  ? "#19b37a,#0d9668"
                      : "#2b7cff,#1a5fd4";
        String icon = "patient".equals(role) ? "🧑" : "doctor".equals(role) ? "👨‍⚕️" : "🛡️";

        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Dear <strong>" + name + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>Welcome to <strong>HealthCare Connect</strong>! Your account has been successfully created as a <strong>" + roleLabel + "</strong>.</p>"
            + "<div style='background:#f8fafc;border-radius:12px;padding:20px 24px;margin:0 0 24px;border-left:4px solid #2b7cff'>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 8px'><strong>Account Details:</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>📧 Email: <strong>" + to + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0'>🏷️ Role: <strong>" + roleLabel + "</strong></p>"
            + "</div>"
            + "<p style='color:#374151;font-size:14px;line-height:1.7;margin:0 0 24px'>You can now log in to your portal and access all features available to you.</p>"
            + "<div style='text-align:center;margin:28px 0'>"
            + "<a href='http://localhost:8080/HospitalManagement/login.jsp' style='background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;padding:14px 32px;border-radius:10px;text-decoration:none;font-weight:700;font-size:15px;display:inline-block'>Go to Login →</a>"
            + "</div>"
            + "<p style='color:#94a3b8;font-size:13px;margin:0'>If you did not create this account, please contact us immediately at support@hospital.com</p>";

        sendHtml(to, "Welcome to HealthCare Connect! 🎉", wrap(accent, icon, "Welcome, " + name + "!", body));
    }

    // ── Login notification email ──────────────────────────────
    public void sendLoginNotification(String to, String name, String role) {
        String roleLabel = role.substring(0, 1).toUpperCase() + role.substring(1);
        String now = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());

        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Hello <strong>" + name + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>A successful login was detected on your <strong>HealthCare Connect</strong> account.</p>"
            + "<div style='background:#f8fafc;border-radius:12px;padding:20px 24px;margin:0 0 24px;border-left:4px solid #19b37a'>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 8px'><strong>Login Details:</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>📧 Email: <strong>" + to + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>🏷️ Role: <strong>" + roleLabel + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0'>🕐 Time: <strong>" + now + "</strong></p>"
            + "</div>"
            + "<div style='background:#fef3c7;border-radius:10px;padding:14px 18px;margin:0 0 20px'>"
            + "<p style='color:#92400e;font-size:13px;margin:0'>⚠️ If this was not you, please change your password immediately and contact support.</p>"
            + "</div>"
            + "<div style='text-align:center;margin:24px 0'>"
            + "<a href='http://localhost:8080/HospitalManagement/login.jsp' style='background:linear-gradient(135deg,#19b37a,#0d9668);color:#fff;padding:13px 28px;border-radius:10px;text-decoration:none;font-weight:700;font-size:14px;display:inline-block'>Go to Dashboard →</a>"
            + "</div>";

        sendHtml(to, "Login Alert - HealthCare Connect 🔐", wrap("#19b37a,#0d9668", "🔐", "Login Successful", body));
    }

    // ── OTP / Forgot Password email ───────────────────────────
    public void sendOtp(String to, String otp) {
        String body = "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>We received a request to reset your password. Use the OTP below to proceed.</p>"
            + "<div style='text-align:center;margin:28px 0'>"
            + "<div style='display:inline-block;background:linear-gradient(135deg,#7c3aed,#8b5cf6);border-radius:16px;padding:24px 48px'>"
            + "<p style='color:rgba(255,255,255,.8);font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;margin:0 0 8px'>Your OTP Code</p>"
            + "<p style='color:#fff;font-size:42px;font-weight:900;letter-spacing:10px;margin:0;font-family:monospace'>" + otp + "</p>"
            + "</div></div>"
            + "<div style='background:#f8fafc;border-radius:12px;padding:16px 20px;margin:0 0 20px;text-align:center'>"
            + "<p style='color:#374151;font-size:14px;margin:0'>⏱️ This OTP is valid for <strong>10 minutes</strong> only.</p>"
            + "</div>"
            + "<p style='color:#374151;font-size:14px;line-height:1.7;margin:0 0 8px'>Steps to reset your password:</p>"
            + "<ol style='color:#374151;font-size:14px;line-height:1.9;margin:0 0 20px;padding-left:20px'>"
            + "<li>Enter the OTP code above on the verification page</li>"
            + "<li>Set your new password</li>"
            + "<li>Login with your new credentials</li>"
            + "</ol>"
            + "<div style='background:#fee2e2;border-radius:10px;padding:14px 18px;margin:0 0 20px'>"
            + "<p style='color:#991b1b;font-size:13px;margin:0'>🚫 If you did not request a password reset, please ignore this email. Your account is safe.</p>"
            + "</div>";

        sendHtml(to, "Password Reset OTP - HealthCare Connect 🔑", wrap("#7c3aed,#8b5cf6", "🔑", "Reset Your Password", body));
    }

    // ── Password reset success email ──────────────────────────
    public void sendPasswordResetSuccess(String to, String name) {
        String now = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());

        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Hello <strong>" + name + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>Your password has been successfully reset. You can now log in with your new password.</p>"
            + "<div style='background:#d1fae5;border-radius:12px;padding:18px 22px;margin:0 0 24px;border-left:4px solid #19b37a'>"
            + "<p style='color:#065f46;font-size:14px;margin:0'>✅ Password changed on: <strong>" + now + "</strong></p>"
            + "</div>"
            + "<div style='background:#fef3c7;border-radius:10px;padding:14px 18px;margin:0 0 24px'>"
            + "<p style='color:#92400e;font-size:13px;margin:0'>⚠️ If you did not make this change, contact support immediately at support@hospital.com</p>"
            + "</div>"
            + "<div style='text-align:center;margin:24px 0'>"
            + "<a href='http://localhost:8080/HospitalManagement/login.jsp' style='background:linear-gradient(135deg,#2b7cff,#1a5fd4);color:#fff;padding:14px 32px;border-radius:10px;text-decoration:none;font-weight:700;font-size:15px;display:inline-block'>Login Now →</a>"
            + "</div>";

        sendHtml(to, "Password Reset Successful ✅ - HealthCare Connect", wrap("#19b37a,#0d9668", "✅", "Password Reset Successful", body));
    }

    // ── Report upload notification (no attachment) ───────────
    public void sendReportNotification(String to, String patientName, String doctorName,
                                        String reportType, String description) {
        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>Dr. <strong>" + doctorName + "</strong> has uploaded a new medical report for you.</p>"
            + "<div style='background:#f8fafc;border-radius:12px;padding:20px 24px;margin:0 0 24px;border-left:4px solid #7c3aed'>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 8px'><strong>Report Details:</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>📋 Type: <strong style='text-transform:capitalize'>" + reportType + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0'>📝 Description: <strong>" + (description != null && !description.isEmpty() ? description : "—") + "</strong></p>"
            + "</div>"
            + "<p style='color:#374151;font-size:14px;line-height:1.7;margin:0 0 20px'>Please log in to your patient portal to view and download your report.</p>"
            + "<div style='text-align:center;margin:24px 0'>"
            + "<a href='http://localhost:8081/HospitalManagement/patient/medicalRecords' style='background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;padding:13px 28px;border-radius:10px;text-decoration:none;font-weight:700;font-size:14px;display:inline-block'>View My Reports →</a>"
            + "</div>";
        sendHtml(to, "New Medical Report Available 📋 - HealthCare Connect",
                 wrap("#7c3aed,#8b5cf6", "📋", "New Report Uploaded", body));
    }

    // ── Report email WITH file attached ───────────────────────
    public void sendReportWithFile(String to, String patientName, String doctorName,
                                    String reportType, String description,
                                    java.io.File file, String originalFileName) {
        String typeLabel = reportType.substring(0, 1).toUpperCase() + reportType.substring(1);
        String now = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());

        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>"
            + "Dr. <strong>" + doctorName + "</strong> has uploaded a medical report for you. "
            + "The report is <strong>attached to this email</strong> for your convenience.</p>"

            + "<div style='background:#f8fafc;border-radius:12px;padding:20px 24px;margin:0 0 20px;border-left:4px solid #7c3aed'>"
            + "<p style='color:#374151;font-size:14px;font-weight:700;margin:0 0 12px'>📋 Report Details</p>"
            + "<table width='100%' cellpadding='0' cellspacing='0'>"
            + "<tr><td style='padding:6px 0;font-size:13px;color:#64748b;width:120px'>Report Type</td>"
            + "<td style='padding:6px 0;font-size:14px;color:#0f172a;font-weight:600'>" + typeLabel + "</td></tr>"
            + "<tr><td style='padding:6px 0;font-size:13px;color:#64748b'>Doctor</td>"
            + "<td style='padding:6px 0;font-size:14px;color:#0f172a;font-weight:600'>Dr. " + doctorName + "</td></tr>"
            + "<tr><td style='padding:6px 0;font-size:13px;color:#64748b'>Description</td>"
            + "<td style='padding:6px 0;font-size:14px;color:#374151'>" + (description != null && !description.isEmpty() ? description : "—") + "</td></tr>"
            + "<tr><td style='padding:6px 0;font-size:13px;color:#64748b'>File Name</td>"
            + "<td style='padding:6px 0;font-size:14px;color:#374151'>" + originalFileName + "</td></tr>"
            + "<tr><td style='padding:6px 0;font-size:13px;color:#64748b'>Date</td>"
            + "<td style='padding:6px 0;font-size:14px;color:#374151'>" + now + "</td></tr>"
            + "</table></div>"

            + "<div style='background:#d1fae5;border-radius:10px;padding:14px 18px;margin:0 0 20px;display:flex;align-items:center;gap:10px'>"
            + "<p style='color:#065f46;font-size:13px;margin:0'>📎 <strong>The report file is attached to this email.</strong> Please save it for your records.</p>"
            + "</div>"

            + "<p style='color:#374151;font-size:14px;line-height:1.7;margin:0 0 20px'>"
            + "You can also log in to your patient portal to view all your medical records online.</p>"

            + "<div style='text-align:center;margin:24px 0'>"
            + "<a href='http://localhost:8081/HospitalManagement/patient/medicalRecords' "
            + "style='background:linear-gradient(135deg,#7c3aed,#8b5cf6);color:#fff;padding:13px 28px;"
            + "border-radius:10px;text-decoration:none;font-weight:700;font-size:14px;display:inline-block'>"
            + "View All My Reports →</a>"
            + "</div>"

            + "<p style='color:#94a3b8;font-size:12px;margin:0'>If you have any questions about this report, "
            + "please contact your doctor or call us at +91 98765 43210.</p>";

        String htmlEmail = wrap("#7c3aed,#8b5cf6", "📋", "Medical Report from Dr. " + doctorName, body);

        // Send with attachment
        if (file != null && file.exists()) {
            sendHtmlWithAttachment(to,
                typeLabel + " Report from Dr. " + doctorName + " - HealthCare Connect",
                htmlEmail, file, originalFileName);
        } else {
            // Fallback: send without attachment if file not found
            sendHtml(to,
                typeLabel + " Report from Dr. " + doctorName + " - HealthCare Connect",
                htmlEmail);
        }
    }

    // ── Appointment Reminder email ────────────────────────────
    public void sendAppointmentReminder(String to, String patientName, String doctorName,
                                         String dept, String date, String time, String reason) {
        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>This is a friendly reminder that you have an appointment <strong>tomorrow</strong>.</p>"
            + "<div style='background:#f8fafc;border-radius:12px;padding:20px 24px;margin:0 0 24px;border-left:4px solid #2b7cff'>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 8px'><strong>Appointment Details:</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>👨‍⚕️ Doctor: <strong>" + doctorName + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>🏥 Department: <strong>" + dept + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>📅 Date: <strong>" + date + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0 0 4px'>🕐 Time: <strong>" + time + "</strong></p>"
            + "<p style='color:#374151;font-size:14px;margin:0'>📋 Reason: <strong>" + reason + "</strong></p>"
            + "</div>"
            + "<div style='background:#fef3c7;border-radius:10px;padding:14px 18px;margin:0 0 20px'>"
            + "<p style='color:#92400e;font-size:13px;margin:0'>⏰ Please arrive 10 minutes early. Bring any previous medical records if available.</p>"
            + "</div>";
        sendHtml(to, "Appointment Reminder for Tomorrow 📅 - HealthCare Connect",
                 wrap("#2b7cff,#1a5fd4", "📅", "Appointment Reminder", body));
    }

    // ── Bill receipt + prescription email ────────────────────
    public void sendBillReceipt(String to, String patientName,
                                 String doctorName, String diagnosis,
                                 String medicines, double totalAmount,
                                 int billId) {
        String body = "<p style='color:#374151;font-size:16px;margin:0 0 16px'>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p style='color:#374151;font-size:15px;line-height:1.7;margin:0 0 20px'>Your payment has been confirmed. Please find your prescription and bill details below.</p>"
            + "<table width='100%' cellpadding='0' cellspacing='0' style='border-radius:12px;overflow:hidden;margin:0 0 24px'>"
            + "<tr style='background:#f8fafc'><td style='padding:12px 16px;font-size:13px;font-weight:700;color:#64748b;border-bottom:1px solid #e8edf5'>BILL ID</td><td style='padding:12px 16px;font-size:14px;font-weight:700;color:#0f172a;border-bottom:1px solid #e8edf5'>#" + billId + "</td></tr>"
            + "<tr><td style='padding:12px 16px;font-size:13px;font-weight:700;color:#64748b;border-bottom:1px solid #e8edf5'>DOCTOR</td><td style='padding:12px 16px;font-size:14px;color:#374151;border-bottom:1px solid #e8edf5'>" + doctorName + "</td></tr>"
            + "<tr style='background:#f8fafc'><td style='padding:12px 16px;font-size:13px;font-weight:700;color:#64748b;border-bottom:1px solid #e8edf5'>DIAGNOSIS</td><td style='padding:12px 16px;font-size:14px;color:#374151;border-bottom:1px solid #e8edf5'>" + diagnosis + "</td></tr>"
            + "<tr><td style='padding:12px 16px;font-size:13px;font-weight:700;color:#64748b;border-bottom:1px solid #e8edf5'>MEDICINES</td><td style='padding:12px 16px;font-size:14px;color:#374151;border-bottom:1px solid #e8edf5'>" + medicines + "</td></tr>"
            + "<tr style='background:#f8fafc'><td style='padding:12px 16px;font-size:13px;font-weight:700;color:#64748b'>TOTAL AMOUNT</td><td style='padding:12px 16px;font-size:18px;font-weight:800;color:#0f172a'>₹" + String.format("%.2f", totalAmount) + "</td></tr>"
            + "</table>"
            + "<p style='color:#374151;font-size:14px;line-height:1.7;margin:0'>Thank you for choosing <strong>HealthCare Connect</strong>. We wish you a speedy recovery! 💙</p>";

        sendHtml(to, "Payment Receipt & Prescription #" + billId + " - HealthCare Connect", wrap("#2b7cff,#1a5fd4", "🧾", "Payment Confirmed", body));
    }
}
