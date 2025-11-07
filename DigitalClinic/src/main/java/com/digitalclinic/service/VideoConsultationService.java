package com.digitalclinic.service;

import com.digitalclinic.model.Appointment;
import com.digitalclinic.model.VideoConsultation;
import com.digitalclinic.repository.VideoConsultationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class VideoConsultationService {
    
    @Autowired
    private VideoConsultationRepository videoConsultationRepository;
    
    @Autowired
    private AppointmentService appointmentService;
    
    public VideoConsultation createVideoConsultation(Long appointmentId) {
        Optional<Appointment> appointmentOpt = appointmentService.getAppointmentById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            
            // Check if video consultation already exists
            Optional<VideoConsultation> existingConsultation = 
                videoConsultationRepository.findByAppointmentId(appointmentId);
            if (existingConsultation.isPresent()) {
                return existingConsultation.get();
            }
            
            // Create new video consultation
            VideoConsultation consultation = new VideoConsultation(appointment);
            
            // Generate meeting URLs (in real app, integrate with video service like Zoom, Jitsi, etc.)
            consultation.setMeetingUrl("/video-call/" + consultation.getRoomId());
            consultation.setPatientJoinUrl("/video-call/patient/" + consultation.getRoomId());
            consultation.setDoctorJoinUrl("/video-call/doctor/" + consultation.getRoomId());
            consultation.setAccessToken(generateAccessToken());
            
            return videoConsultationRepository.save(consultation);
        }
        throw new RuntimeException("Appointment not found");
    }
    
    public Optional<VideoConsultation> getVideoConsultation(Long id) {
        return videoConsultationRepository.findById(id);
    }
    
    public Optional<VideoConsultation> getVideoConsultationByAppointment(Long appointmentId) {
        return videoConsultationRepository.findByAppointmentId(appointmentId);
    }
    
    public Optional<VideoConsultation> getVideoConsultationByRoomId(String roomId) {
        return videoConsultationRepository.findByRoomId(roomId);
    }
    
    public VideoConsultation startConsultation(Long consultationId) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            
            if (consultation.canStart()) {
                consultation.startConsultation();
                return videoConsultationRepository.save(consultation);
            } else {
                throw new RuntimeException("Consultation cannot be started at this time");
            }
        }
        throw new RuntimeException("Video consultation not found");
    }
    
    public VideoConsultation patientJoined(Long consultationId) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            consultation.setStatus(VideoConsultation.ConsultationStatus.PATIENT_WAITING);
            return videoConsultationRepository.save(consultation);
        }
        throw new RuntimeException("Video consultation not found");
    }
    
    public VideoConsultation doctorJoined(Long consultationId) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            consultation.setStatus(VideoConsultation.ConsultationStatus.DOCTOR_JOINED);
            
            // If this is the first time doctor joins, mark as in progress
            if (consultation.getActualStartTime() == null) {
                consultation.setActualStartTime(LocalDateTime.now());
                consultation.setStatus(VideoConsultation.ConsultationStatus.IN_PROGRESS);
            }
            
            return videoConsultationRepository.save(consultation);
        }
        throw new RuntimeException("Video consultation not found");
    }
    
    public VideoConsultation completeConsultation(Long consultationId) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            consultation.completeConsultation();
            
            // Also mark the appointment as completed
            if (consultation.getAppointment() != null) {
                appointmentService.completeAppointment(
                    consultation.getAppointment().getId(), 
                    "Consultation completed via video call", 
                    "Video consultation completed successfully"
                );
            }
            
            return videoConsultationRepository.save(consultation);
        }
        throw new RuntimeException("Video consultation not found");
    }
    
    public VideoConsultation cancelConsultation(Long consultationId, String reason) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            consultation.setStatus(VideoConsultation.ConsultationStatus.CANCELLED);
            consultation.setEndTime(LocalDateTime.now());
            return videoConsultationRepository.save(consultation);
        }
        throw new RuntimeException("Video consultation not found");
    }
    
    public List<VideoConsultation> getPatientConsultations(Long patientUserId) {
        return videoConsultationRepository.findByPatientUserId(patientUserId);
    }
    
    public List<VideoConsultation> getDoctorConsultations(Long doctorUserId) {
        return videoConsultationRepository.findByDoctorUserId(doctorUserId);
    }
    
    public List<VideoConsultation> getActiveConsultations() {
        return videoConsultationRepository.findActiveConsultations();
    }
    
    public List<VideoConsultation> getUpcomingConsultations() {
        return videoConsultationRepository.findByScheduledStartTimeBetween(
            LocalDateTime.now(), LocalDateTime.now().plusDays(7)
        );
    }
    
    // Statistics
    public long getTotalConsultations() {
        return videoConsultationRepository.count();
    }
    
    public long getCompletedConsultations() {
        return videoConsultationRepository.findByStatus(VideoConsultation.ConsultationStatus.COMPLETED).size();
    }
    
    public long getActiveConsultationsCount() {
        return videoConsultationRepository.findActiveConsultations().size();
    }
    
    // Helper method to generate access token (simplified)
    private String generateAccessToken() {
        return "token_" + UUID.randomUUID().toString().substring(0, 16);
    }
    
    // Check if consultation can be joined
    public boolean canJoinConsultation(Long consultationId, String userRole) {
        Optional<VideoConsultation> consultationOpt = videoConsultationRepository.findById(consultationId);
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            
            // Check if consultation is active or scheduled to start soon
            if (consultation.isActive()) {
                return true;
            }
            
            // Allow joining 15 minutes before scheduled time
            if (consultation.getStatus() == VideoConsultation.ConsultationStatus.SCHEDULED &&
                consultation.getScheduledStartTime().isBefore(LocalDateTime.now().plusMinutes(15))) {
                return true;
            }
        }
        return false;
    }
}