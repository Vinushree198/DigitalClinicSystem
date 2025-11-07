package com.digitalclinic.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "appointments")
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
    
    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;
    
    @ManyToOne
    @JoinColumn(name = "pod_id")
    private HealthPod healthPod;
    
    @Column(nullable = false)
    private LocalDateTime appointmentDateTime;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentType type; // IN_PERSON, VIDEO
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentStatus status; // SCHEDULED, CONFIRMED, COMPLETED, CANCELLED
    
    private String symptoms;
    private String notes;
    private String prescription;
    
    private Double consultationFee;
    private Boolean paymentStatus = false;
    
    private Integer rating;
    private String feedback;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Video call specific fields
    private String videoCallLink;
    private LocalDateTime videoCallStartTime;
    private LocalDateTime videoCallEndTime;
    
    // Enum definitions
    public enum AppointmentType {
        IN_PERSON, VIDEO
    }
    
    public enum AppointmentStatus {
        SCHEDULED, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED, NO_SHOW
    }
    
    // Constructors
    public Appointment() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.status = AppointmentStatus.SCHEDULED;
    }
    
    public Appointment(Patient patient, LocalDateTime appointmentDateTime, AppointmentType type) {
        this();
        this.patient = patient;
        this.appointmentDateTime = appointmentDateTime;
        this.type = type;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    
    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
    
    public HealthPod getHealthPod() { return healthPod; }
    public void setHealthPod(HealthPod healthPod) { this.healthPod = healthPod; }
    
    public LocalDateTime getAppointmentDateTime() { return appointmentDateTime; }
    public void setAppointmentDateTime(LocalDateTime appointmentDateTime) { this.appointmentDateTime = appointmentDateTime; }
    
    public AppointmentType getType() { return type; }
    public void setType(AppointmentType type) { this.type = type; }
    
    public AppointmentStatus getStatus() { return status; }
    public void setStatus(AppointmentStatus status) { this.status = status; }
    
    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getPrescription() { return prescription; }
    public void setPrescription(String prescription) { this.prescription = prescription; }
    
    public Double getConsultationFee() { return consultationFee; }
    public void setConsultationFee(Double consultationFee) { this.consultationFee = consultationFee; }
    
    public Boolean getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(Boolean paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getVideoCallLink() { return videoCallLink; }
    public void setVideoCallLink(String videoCallLink) { this.videoCallLink = videoCallLink; }
    
    public LocalDateTime getVideoCallStartTime() { return videoCallStartTime; }
    public void setVideoCallStartTime(LocalDateTime videoCallStartTime) { this.videoCallStartTime = videoCallStartTime; }
    
    public LocalDateTime getVideoCallEndTime() { return videoCallEndTime; }
    public void setVideoCallEndTime(LocalDateTime videoCallEndTime) { this.videoCallEndTime = videoCallEndTime; }
    
    // Helper methods
    public boolean isUpcoming() {
        return (status == AppointmentStatus.SCHEDULED || status == AppointmentStatus.CONFIRMED) 
               && appointmentDateTime.isAfter(LocalDateTime.now());
    }
    
    public boolean isCompleted() {
        return status == AppointmentStatus.COMPLETED;
    }
    
    public boolean canBeCancelled() {
        return (status == AppointmentStatus.SCHEDULED || status == AppointmentStatus.CONFIRMED) 
               && appointmentDateTime.isAfter(LocalDateTime.now().plusHours(2));
    }
    
    public String getFormattedDateTime() {
        return appointmentDateTime.toString(); // In real app, use DateTimeFormatter
    }
}