package com.sunrise.dental.model;

import java.math.BigDecimal;

public class Report {
    private BigDecimal income;
    private int appointments;
    private int patients;

    public Report(BigDecimal income, int appointments, int patients) {
        this.income = (income != null) ? income : BigDecimal.ZERO;
        this.appointments = appointments;
        this.patients = patients;
    }

    // Convenient zero report
    public static Report empty() {
        return new Report(BigDecimal.ZERO, 0, 0);
    }

    public BigDecimal getIncome() { return income; }
    public int getAppointments() { return appointments; }
    public int getPatients() { return patients; }
}