package com.digitalclinic.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "video_consultations")
public class VideoConsultation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne
    @JoinColumn(name = "appointment_id")
    private Appointment appointment;
    
    private String roomId;
    private String meetingUrl;
    private String accessToken;
    
    @Enumerated(EnumType.STRING)
    private ConsultationStatus status;
    
    private LocalDateTime scheduledStartTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime endTime;
    
    private Integer durationMinutes;
    private Boolean recordingEnabled = false;
    private String recordingUrl;
    
    private String patientJoinUrl;
    private String doctorJoinUrl;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    public enum ConsultationStatus {
        SCHEDULED, STARTED, IN_PROGRESS, COMPLETED, CANCELLED, PATIENT_WAITING, DOCTOR_JOINED
    }
    
    // Constructors
    public VideoConsultation() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.status = ConsultationStatus.SCHEDULED;
    }
    
    public VideoConsultation(Appointment appointment) {
        this();
        this.appointment = appointment;
        this.scheduledStartTime = appointment.getAppointmentDateTime();
        generateRoomId();
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    private void generateRoomId() {
        // Generate a unique room ID
        this.roomId = "room_" + System.currentTimeMillis() + "_" + 
                     (appointment != null ? appointment.getId() : "0");
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Appointment getAppointment() { return appointment; }
    public void setAppointment(Appointment appointment) { this.appointment = appointment; }
    
    public String getRoomId() { return roomId; }
    public void setRoomId(String roomId) { this.roomId = roomId; }
    
    public String getMeetingUrl() { return meetingUrl; }
    public void setMeetingUrl(String meetingUrl) { this.meetingUrl = meetingUrl; }
    
    public String getAccessToken() { return accessToken; }
    public void setAccessToken(String accessToken) { this.accessToken = accessToken; }
    
    public ConsultationStatus getStatus() { return status; }
    public void setStatus(ConsultationStatus status) { this.status = status; }
    
    public LocalDateTime getScheduledStartTime() { return scheduledStartTime; }
    public void setScheduledStartTime(LocalDateTime scheduledStartTime) { this.scheduledStartTime = scheduledStartTime; }
    
    public LocalDateTime getActualStartTime() { return actualStartTime; }
    public void setActualStartTime(LocalDateTime actualStartTime) { this.actualStartTime = actualStartTime; }
    
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    
    public Boolean getRecordingEnabled() { return recordingEnabled; }
    public void setRecordingEnabled(Boolean recordingEnabled) { this.recordingEnabled = recordingEnabled; }
    
    public String getRecordingUrl() { return recordingUrl; }
    public void setRecordingUrl(String recordingUrl) { this.recordingUrl = recordingUrl; }
    
    public String getPatientJoinUrl() { return patientJoinUrl; }
    public void setPatientJoinUrl(String patientJoinUrl) { this.patientJoinUrl = patientJoinUrl; }
    
    public String getDoctorJoinUrl() { return doctorJoinUrl; }
    public void setDoctorJoinUrl(String doctorJoinUrl) { this.doctorJoinUrl = doctorJoinUrl; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // Helper methods
    public boolean isActive() {
        return status == ConsultationStatus.STARTED || 
               status == ConsultationStatus.IN_PROGRESS || 
               status == ConsultationStatus.DOCTOR_JOINED ||
               status == ConsultationStatus.PATIENT_WAITING;
    }
    
    public boolean canStart() {
        return status == ConsultationStatus.SCHEDULED && 
               scheduledStartTime.isBefore(LocalDateTime.now().plusMinutes(30));
    }
    
    public void startConsultation() {
        this.status = ConsultationStatus.STARTED;
        this.actualStartTime = LocalDateTime.now();
    }
    
    public void completeConsultation() {
        this.status = ConsultationStatus.COMPLETED;
        this.endTime = LocalDateTime.now();
        
        if (this.actualStartTime != null && this.endTime != null) {
            this.durationMinutes = (int) java.time.Duration.between(actualStartTime, endTime).toMinutes();
        }
    }
}