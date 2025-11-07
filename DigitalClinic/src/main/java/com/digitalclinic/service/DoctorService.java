package com.digitalclinic.service;

import com.digitalclinic.model.Doctor;
import com.digitalclinic.model.User;
import com.digitalclinic.repository.DoctorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorService {
    
    @Autowired
    private DoctorRepository doctorRepository;
    
    @Autowired
    private UserService userService;
    
    public Doctor createDoctor(User user) {
        Doctor doctor = new Doctor(user);
        return doctorRepository.save(doctor);
    }
    
    public Optional<Doctor> getDoctorByEmail(String email) {
        return doctorRepository.findByUserEmail(email);
    }
    
    public Optional<Doctor> getDoctorById(Long id) {
        return doctorRepository.findById(id);
    }
    
    public List<Doctor> getAllVerifiedDoctors() {
        return doctorRepository.findByVerifiedTrue();
    }
    
    // ADDED: Get all doctors (verified and unverified)
    public List<Doctor> getAllDoctors() {
        return doctorRepository.findAll();
    }
    
    public List<Doctor> getDoctorsBySpecialization(String specialization) {
        return doctorRepository.findBySpecialization(specialization);
    }
    
    public List<String> getAllSpecializations() {
        return doctorRepository.findDistinctSpecializations();
    }
    
    public Doctor updateDoctorProfile(String email, Doctor doctorDetails) {
        Optional<Doctor> existingDoctor = doctorRepository.findByUserEmail(email);
        if (existingDoctor.isPresent()) {
            Doctor doctor = existingDoctor.get();
            
            // Update doctor details
            if (doctorDetails.getSpecialization() != null) {
                doctor.setSpecialization(doctorDetails.getSpecialization());
            }
            if (doctorDetails.getQualification() != null) {
                doctor.setQualification(doctorDetails.getQualification());
            }
            if (doctorDetails.getLicenseNumber() != null) {
                doctor.setLicenseNumber(doctorDetails.getLicenseNumber());
            }
            if (doctorDetails.getExperienceYears() != null) {
                doctor.setExperienceYears(doctorDetails.getExperienceYears());
            }
            if (doctorDetails.getHospitalAffiliation() != null) {
                doctor.setHospitalAffiliation(doctorDetails.getHospitalAffiliation());
            }
            if (doctorDetails.getBio() != null) {
                doctor.setBio(doctorDetails.getBio());
            }
            if (doctorDetails.getConsultationFee() != null) {
                doctor.setConsultationFee(doctorDetails.getConsultationFee());
            }
            
            return doctorRepository.save(doctor);
        }
        return null;
    }
    
    public List<Doctor> getPendingVerifications() {
        return doctorRepository.findByVerificationStatus("PENDING");
    }
    
    public boolean verifyDoctor(Long doctorId) {
        Optional<Doctor> doctor = doctorRepository.findById(doctorId);
        if (doctor.isPresent()) {
            Doctor doc = doctor.get();
            doc.setVerified(true);
            doc.setVerificationStatus("APPROVED");
            doctorRepository.save(doc);
            return true;
        }
        return false;
    }
    
    // ADDED: Get total doctors count
    public long getTotalDoctors() {
        return doctorRepository.count();
    }
    
    // ADDED: Get verified doctors count
    public long getVerifiedDoctorsCount() {
        return doctorRepository.countByVerifiedTrue();
    }
}