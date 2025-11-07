// entity/ConsultationMessage.java
package com.digitalclinic.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "consultation_messages")
public class ConsultationMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "consultation_id")
    private VideoConsultation consultation;
    
    @Column(name = "sender_id")
    private Long senderId;
    
    @Column(name = "sender_type") // DOCTOR or PATIENT
    private String senderType;
    
    @Column(name = "sender_name")
    private String senderName;
    
    @Column(columnDefinition = "TEXT")
    private String content;
    
    private LocalDateTime timestamp;
    
    @Enumerated(EnumType.STRING)
    private MessageType messageType;
    
    public enum MessageType {
        TEXT, SYSTEM, PRESCRIPTION, DIAGNOSIS
    }
    
    // Constructors
    public ConsultationMessage() {
        this.timestamp = LocalDateTime.now();
        this.messageType = MessageType.TEXT;
    }
    
    public ConsultationMessage(VideoConsultation consultation, Long senderId, 
                              String senderType, String senderName, String content) {
        this();
        this.consultation = consultation;
        this.senderId = senderId;
        this.senderType = senderType;
        this.senderName = senderName;
        this.content = content;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public VideoConsultation getConsultation() { return consultation; }
    public void setConsultation(VideoConsultation consultation) { this.consultation = consultation; }
    
    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }
    
    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }
    
    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    
    public MessageType getMessageType() { return messageType; }
    public void setMessageType(MessageType messageType) { this.messageType = messageType; }
}