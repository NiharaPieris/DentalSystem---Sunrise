package com.sunrise.dental.model;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int appointmentId;
    private double consultationFee;
    private String otherFeeName;
    private double otherFee;
    private double totalAmount;
    private boolean paid;
    private Timestamp paidAt;

    private String treatmentName;
    private String patientName;
    private String patientEmail;
    private String patientPhone;


    // Getters and setters
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public double getConsultationFee() { return consultationFee; }
    public void setConsultationFee(double consultationFee) { this.consultationFee = consultationFee; }

    public String getOtherFeeName() { return otherFeeName; }
    public void setOtherFeeName(String otherFeeName) { this.otherFeeName = otherFeeName; }

    public double getOtherFee() { return otherFee; }
    public void setOtherFee(double otherFee) { this.otherFee = otherFee; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public boolean isPaid() { return paid; }
    public void setPaid(boolean paid) { this.paid = paid; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
}
