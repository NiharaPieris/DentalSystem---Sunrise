package com.sunrise.dental.service;

import com.sunrise.dental.dao.TreatmentDAO;
import com.sunrise.dental.model.Treatment;
import java.util.List;

public class TreatmentService {
    private TreatmentDAO dao = new TreatmentDAO();

    public void addTreatment(Treatment t) { dao.addTreatment(t); }
    public void updateTreatment(Treatment t) { dao.updateTreatment(t); }
    public void deleteTreatment(int id) { dao.deleteTreatment(id); }
    public List<Treatment> getAllTreatments() { return dao.getAllTreatments(); }
}
