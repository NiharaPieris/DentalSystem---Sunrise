package com.sunrise.dental.service;

import com.sunrise.dental.dao.PatientDAO;
import com.sunrise.dental.dao.PaymentDAO;
import com.sunrise.dental.model.Appointment;
import com.sunrise.dental.model.Patient;
import com.sunrise.dental.model.Payment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PatientService {

    private final PatientDAO patientDAO = new PatientDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public List<Patient> searchPatients(String name, String phone, String email) throws Exception {
        return patientDAO.searchPatients(name, phone, email);
    }

    public Patient getPatientById(int patientId) throws Exception {
        return patientDAO.getPatientById(patientId);
    }

    /**
     * Returns appointments of the patient + their payment status
     */
    public List<Map<String, Object>> getPatientAppointmentsWithPayment(int patientId) throws Exception {
        List<Appointment> appointments = patientDAO.getAppointmentsByPatient(patientId);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Appointment a : appointments) {
            Map<String, Object> row = new HashMap<>();
            row.put("appointment", a);

            Payment payment = paymentDAO.getPaymentByAppointment(a.getAppointmentId());
            row.put("payment", payment);   // null = unpaid

            result.add(row);
        }
        return result;
    }
}