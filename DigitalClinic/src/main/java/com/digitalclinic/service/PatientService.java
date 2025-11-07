package com.digitalclinic.service;

import com.digitalclinic.model.Patient;
import com.digitalclinic.model.User;
import com.digitalclinic.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PatientService {
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private UserService userService;
    
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }
    
    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }
    public Patient createPatient(User user) {
        Patient patient = new Patient(user);
        return patientRepository.save(patient);
    }
    
    public Optional<Patient> getPatientByEmail(String email) {
        return patientRepository.findByUserEmail(email);
    }
    
    public Patient updatePatientProfile(String email, Patient patientDetails) {
        Optional<Patient> existingPatient = patientRepository.findByUserEmail(email);
        if (existingPatient.isPresent()) {
            Patient patient = existingPatient.get();
            
            // Update patient details
            if (patientDetails.getDateOfBirth() != null) {
                patient.setDateOfBirth(patientDetails.getDateOfBirth());
            }
            if (patientDetails.getAge() != null) {
                patient.setAge(patientDetails.getAge());
            }
            if (patientDetails.getGender() != null) {
                patient.setGender(patientDetails.getGender());
            }
            if (patientDetails.getBloodGroup() != null) {
                patient.setBloodGroup(patientDetails.getBloodGroup());
            }
            if (patientDetails.getHeight() != null) {
                patient.setHeight(patientDetails.getHeight());
            }
            if (patientDetails.getWeight() != null) {
                patient.setWeight(patientDetails.getWeight());
            }
            if (patientDetails.getMedicalHistory() != null) {
                patient.setMedicalHistory(patientDetails.getMedicalHistory());
            }
            if (patientDetails.getAllergies() != null) {
                patient.setAllergies(patientDetails.getAllergies());
            }
            if (patientDetails.getCurrentMedications() != null) {
                patient.setCurrentMedications(patientDetails.getCurrentMedications());
            }
            if (patientDetails.getEmergencyContactName() != null) {
                patient.setEmergencyContactName(patientDetails.getEmergencyContactName());
            }
            if (patientDetails.getEmergencyContactPhone() != null) {
                patient.setEmergencyContactPhone(patientDetails.getEmergencyContactPhone());
            }
            
            return patientRepository.save(patient);
        }
        return null;
    }
    
    public PatientRepository getPatientRepository() {
		return patientRepository;
	}

	public void setPatientRepository(PatientRepository patientRepository) {
		this.patientRepository = patientRepository;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public long getTotalPatients() {
        return patientRepository.count();
    }
}