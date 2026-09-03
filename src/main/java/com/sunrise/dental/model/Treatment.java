package com.sunrise.dental.model;

public class Treatment {
    private int treatmentId;
    private String name;
    private String description;
    private java.math.BigDecimal cost;
    private int durationMinutes;
    private String activeStart;   // store as HH:mm
    private String activeEnd;     // store as HH:mm
    private String activeDays;    // comma-separated days
    private int dentistId;

    // Getters and setters
    public int getTreatmentId() { return treatmentId; }
    public void setTreatmentId(int treatmentId) { this.treatmentId = treatmentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public java.math.BigDecimal getCost() { return cost; }
    public void setCost(java.math.BigDecimal cost) { this.cost = cost; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public String getActiveStart() { return activeStart; }
    public void setActiveStart(String activeStart) { this.activeStart = activeStart; }

    public String getActiveEnd() { return activeEnd; }
    public void setActiveEnd(String activeEnd) { this.activeEnd = activeEnd; }

    public String getActiveDays() { return activeDays; }
    public void setActiveDays(String activeDays) { this.activeDays = activeDays; }

    public int getDentistId() { return dentistId; }
    public void setDentistId(int dentistId) { this.dentistId = dentistId; }
}
