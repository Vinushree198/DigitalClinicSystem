package com.digitalclinic.service;

import com.digitalclinic.model.*;
import com.digitalclinic.repository.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
public class AppointmentService {
    
    @Autowired
    private AppointmentRepository appointmentRepository;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private DoctorService doctorService;
    
    @Autowired
    private HealthPodService healthPodService;
    
    public Appointment bookAppointment(Appointment appointment) {
        // Validate appointment
        if (appointment.getPatient() == null) {
            throw new RuntimeException("Patient is required");
        }
        
        if (appointment.getAppointmentDateTime() == null) {
            throw new RuntimeException("Appointment date and time is required");
        }
        
        // Set default consultation fee if not set
        if (appointment.getConsultationFee() == null && appointment.getDoctor() != null) {
            appointment.setConsultationFee(appointment.getDoctor().getConsultationFee());
        }
        
        return appointmentRepository.save(appointment);
    }
    
    public Optional<Appointment> getAppointmentById(Long id) {
        return appointmentRepository.findById(id);
    }
    
    public List<Appointment> getPatientAppointments(Long patientUserId) {
        return appointmentRepository.findByPatientUserIdOrderByAppointmentDateTimeDesc(patientUserId);
    }
    
    public List<Appointment> getPatientUpcomingAppointments(Long patientUserId) {
        return appointmentRepository.findByPatientUserIdAndAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(
            patientUserId, LocalDateTime.now());
    }
    
    public List<Appointment> getPatientPastAppointments(Long patientUserId) {
        return appointmentRepository.findByPatientUserIdAndAppointmentDateTimeBeforeOrderByAppointmentDateTimeDesc(
            patientUserId, LocalDateTime.now());
    }
    
    public List<Appointment> getDoctorAppointments(Long doctorUserId) {
        return appointmentRepository.findByDoctorUserIdOrderByAppointmentDateTimeDesc(doctorUserId);
    }
    
    public List<Appointment> getDoctorUpcomingAppointments(Long doctorUserId) {
        return appointmentRepository.findByDoctorUserIdAndAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(
            doctorUserId, LocalDateTime.now());
    }
    
    public List<Appointment> getDoctorTodayAppointments(Long doctorUserId) {
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);
        
        return appointmentRepository.findDoctorAppointmentsBetweenDates(doctorUserId, startOfDay, endOfDay);
    }
    
    public Appointment updateAppointmentStatus(Long appointmentId, Appointment.AppointmentStatus status) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            appointment.setStatus(status);
            return appointmentRepository.save(appointment);
        }
        throw new RuntimeException("Appointment not found");
    }
    
    public Appointment cancelAppointment(Long appointmentId, String reason) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            
            if (!appointment.getCanBeCancelled()) {
                throw new RuntimeException("Appointment cannot be cancelled. Minimum 2 hours notice required.");
            }
            
            appointment.setStatus(Appointment.AppointmentStatus.CANCELLED);
            appointment.setNotes((appointment.getNotes() != null ? appointment.getNotes() + "\n" : "") + 
                               "Cancelled: " + reason);
            return appointmentRepository.save(appointment);
        }
        throw new RuntimeException("Appointment not found");
    }
    
    public Appointment completeAppointment(Long appointmentId, String prescription, String notes) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            appointment.setStatus(Appointment.AppointmentStatus.COMPLETED);
            appointment.setPrescription(prescription);
            appointment.setNotes(notes);
            appointment.setPaymentStatus(true); // Auto-mark as paid for completed appointments
            
            return appointmentRepository.save(appointment);
        }
        throw new RuntimeException("Appointment not found");
    }
    
    public Appointment rescheduleAppointment(Long appointmentId, LocalDateTime newDateTime) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            
            if (!appointment.getCanBeCancelled()) {
                throw new RuntimeException("Appointment cannot be rescheduled. Minimum 2 hours notice required.");
            }
            
            appointment.setAppointmentDateTime(newDateTime);
            appointment.setStatus(Appointment.AppointmentStatus.SCHEDULED);
            appointment.setNotes((appointment.getNotes() != null ? appointment.getNotes() + "\n" : "") + 
                               "Rescheduled to: " + newDateTime);
            
            return appointmentRepository.save(appointment);
        }
        throw new RuntimeException("Appointment not found");
    }
    
    public void addFeedback(Long appointmentId, Integer rating, String feedback) {
        Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
        if (appointmentOpt.isPresent()) {
            Appointment appointment = appointmentOpt.get();
            
            if (!appointment.isCompleted()) {
                throw new RuntimeException("Feedback can only be added for completed appointments");
            }
            
            appointment.setRating(rating);
            appointment.setFeedback(feedback);
            appointmentRepository.save(appointment);
        } else {
            throw new RuntimeException("Appointment not found");
        }
    }
    
    // Statistics - FIXED: Using correct repository methods
    public long getTotalAppointmentsCount() {
        return appointmentRepository.count();
    }
    
    public long getCompletedAppointmentsCount() {
        return appointmentRepository.countByStatus(Appointment.AppointmentStatus.COMPLETED);
    }
    
    public long getUpcomingAppointmentsCount() {
        // FIX: Using the method we just added to repository
        return appointmentRepository.findByAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(
            LocalDateTime.now()).size();
    }
    
    public long getPatientAppointmentsCount(Long patientUserId) {
        return appointmentRepository.countByPatientUserId(patientUserId);
    }
    
    public long getDoctorCompletedAppointmentsCount(Long doctorUserId) {
        return appointmentRepository.countCompletedAppointmentsByDoctor(doctorUserId);
    }
    
    // Get today's appointments for patient dashboard
    public List<Appointment> getPatientTodayAppointments(Long patientUserId) {
        return appointmentRepository.findTodayAppointmentsByPatient(patientUserId);
    }
    
    // Initialize sample appointments
    public void initializeSampleAppointments() {
        if (appointmentRepository.count() == 0) {
            // Get sample patients and doctors
            Optional<Patient> patient1 = patientService.getPatientByEmail("patient1@example.com");
            Optional<Patient> patient2 = patientService.getPatientByEmail("patient2@example.com");
            Optional<Doctor> doctor1 = doctorService.getDoctorByEmail("doctor1@example.com");
            Optional<Doctor> doctor2 = doctorService.getDoctorByEmail("doctor2@example.com");
            List<HealthPod> pods = healthPodService.getAllActivePods();
            
            if (patient1.isPresent() && doctor1.isPresent() && !pods.isEmpty()) {
                // Sample appointment 1 - Upcoming
                Appointment app1 = new Appointment(patient1.get(), 
                    LocalDateTime.now().plusDays(1).withHour(10).withMinute(0), 
                    Appointment.AppointmentType.IN_PERSON);
                app1.setDoctor(doctor1.get());
                app1.setHealthPod(pods.get(0));
                app1.setSymptoms("Fever and cough for 2 days");
                app1.setConsultationFee(500.0);
                appointmentRepository.save(app1);
                
                // Sample appointment 2 - Completed
                Appointment app2 = new Appointment(patient1.get(), 
                    LocalDateTime.now().minusDays(2).withHour(14).withMinute(0), 
                    Appointment.AppointmentType.VIDEO);
                app2.setDoctor(doctor2.get());
                app2.setStatus(Appointment.AppointmentStatus.COMPLETED);
                app2.setSymptoms("Regular health checkup");
                app2.setPrescription("Multivitamins once daily for 30 days");
                app2.setConsultationFee(300.0);
                app2.setPaymentStatus(true);
                appointmentRepository.save(app2);
                
                // Sample appointment 3 - Today's appointment
                Appointment app3 = new Appointment(patient1.get(), 
                    LocalDateTime.now().withHour(16).withMinute(0), 
                    Appointment.AppointmentType.VIDEO);
                app3.setDoctor(doctor1.get());
                app3.setStatus(Appointment.AppointmentStatus.CONFIRMED);
                app3.setSymptoms("Follow-up consultation");
                app3.setConsultationFee(300.0);
                appointmentRepository.save(app3);
            }
        }
    }
}