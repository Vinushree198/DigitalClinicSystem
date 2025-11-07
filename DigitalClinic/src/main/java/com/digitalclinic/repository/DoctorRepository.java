package com.digitalclinic.repository;

import com.digitalclinic.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    Optional<Doctor> findByUserEmail(String email);
    List<Doctor> findByVerifiedTrue();
    List<Doctor> findBySpecialization(String specialization);
    List<Doctor> findByVerificationStatus(String status);
    
    // ADD THIS METHOD:
    long countByVerifiedTrue();
    
    @Query("SELECT DISTINCT d.specialization FROM Doctor d WHERE d.verified = true")
    List<String> findDistinctSpecializations();
    
    // Add this if you need it:
    List<Doctor> findByVerificationStatusOrderByUserFullNameAsc(String status);
}