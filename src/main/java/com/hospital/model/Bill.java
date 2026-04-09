package com.hospital.model;

import java.sql.Timestamp;

public class Bill {
    private int id;
    private int appointmentId;
    private int patientId;
    private int doctorId;
    private double consultationFee;
    private double medicineCharge;
    private double otherCharge;
    private double totalAmount;
    private String paymentStatus;   // pending, confirmed, paid, cancelled
    private String paymentMethod;
    private Integer confirmedByAdmin;
    private Timestamp confirmedAt;
    private boolean receiptSent;
    private Timestamp createdAt;

    // Joined display fields
    private String patientName;
    private String patientEmail;
    private String doctorName;
    private String diagnosis;
    private String medicines;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public double getConsultationFee() { return consultationFee; }
    public void setConsultationFee(double consultationFee) { this.consultationFee = consultationFee; }

    public double getMedicineCharge() { return medicineCharge; }
    public void setMedicineCharge(double medicineCharge) { this.medicineCharge = medicineCharge; }

    public double getOtherCharge() { return otherCharge; }
    public void setOtherCharge(double otherCharge) { this.otherCharge = otherCharge; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Integer getConfirmedByAdmin() { return confirmedByAdmin; }
    public void setConfirmedByAdmin(Integer confirmedByAdmin) { this.confirmedByAdmin = confirmedByAdmin; }

    public Timestamp getConfirmedAt() { return confirmedAt; }
    public void setConfirmedAt(Timestamp confirmedAt) { this.confirmedAt = confirmedAt; }

    public boolean isReceiptSent() { return receiptSent; }
    public void setReceiptSent(boolean receiptSent) { this.receiptSent = receiptSent; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientEmail() { return patientEmail; }
    public void setPatientEmail(String patientEmail) { this.patientEmail = patientEmail; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getMedicines() { return medicines; }
    public void setMedicines(String medicines) { this.medicines = medicines; }
}
