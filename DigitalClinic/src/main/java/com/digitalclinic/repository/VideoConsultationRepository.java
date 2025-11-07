package com.digitalclinic.repository;

import com.digitalclinic.model.VideoConsultation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface VideoConsultationRepository extends JpaRepository<VideoConsultation, Long> {
    
    Optional<VideoConsultation> findByAppointmentId(Long appointmentId);
    Optional<VideoConsultation> findByRoomId(String roomId);
    
    List<VideoConsultation> findByStatus(VideoConsultation.ConsultationStatus status);
    List<VideoConsultation> findByScheduledStartTimeBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT vc FROM VideoConsultation vc WHERE vc.appointment.patient.user.id = :patientUserId " +
           "ORDER BY vc.scheduledStartTime DESC")
    List<VideoConsultation> findByPatientUserId(Long patientUserId);
    
    @Query("SELECT vc FROM VideoConsultation vc WHERE vc.appointment.doctor.user.id = :doctorUserId " +
           "ORDER BY vc.scheduledStartTime DESC")
    List<VideoConsultation> findByDoctorUserId(Long doctorUserId);
    
    @Query("SELECT vc FROM VideoConsultation vc WHERE vc.status IN ('STARTED', 'IN_PROGRESS', 'PATIENT_WAITING', 'DOCTOR_JOINED')")
    List<VideoConsultation> findActiveConsultations();
    
    @Query("SELECT COUNT(vc) FROM VideoConsultation vc WHERE vc.appointment.doctor.user.id = :doctorUserId " +
           "AND vc.status = 'COMPLETED'")
    long countCompletedConsultationsByDoctor(Long doctorUserId);
    
    @Query("SELECT vc FROM VideoConsultation vc WHERE vc.appointment.doctor.user.id = :doctorUserId " +
           "AND vc.scheduledStartTime BETWEEN :start AND :end")
    List<VideoConsultation> findDoctorConsultationsBetweenDates(Long doctorUserId, LocalDateTime start, LocalDateTime end);
}