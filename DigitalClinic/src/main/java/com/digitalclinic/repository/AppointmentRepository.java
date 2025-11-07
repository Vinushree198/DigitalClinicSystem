package com.digitalclinic.repository;

import com.digitalclinic.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    
    // Patient appointments
    List<Appointment> findByPatientUserIdOrderByAppointmentDateTimeDesc(Long patientUserId);
    
    // FIX: Added missing method
    List<Appointment> findByPatientUserIdAndAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(Long patientUserId, LocalDateTime dateTime);
    
    List<Appointment> findByPatientUserIdAndAppointmentDateTimeBeforeOrderByAppointmentDateTimeDesc(Long patientUserId, LocalDateTime dateTime);
    List<Appointment> findByPatientUserIdAndStatusOrderByAppointmentDateTimeAsc(Long patientUserId, Appointment.AppointmentStatus status);
    
    // Doctor appointments
    List<Appointment> findByDoctorUserIdOrderByAppointmentDateTimeDesc(Long doctorUserId);
    List<Appointment> findByDoctorUserIdAndAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(Long doctorUserId, LocalDateTime dateTime);
    List<Appointment> findByDoctorUserIdAndAppointmentDateTimeBeforeOrderByAppointmentDateTimeDesc(Long doctorUserId, LocalDateTime dateTime);
    List<Appointment> findByDoctorUserIdAndStatusOrderByAppointmentDateTimeAsc(Long doctorUserId, Appointment.AppointmentStatus status);
    
    // Health Pod appointments
    List<Appointment> findByHealthPodIdOrderByAppointmentDateTimeDesc(Long podId);
    
    // General queries - FIX: Added missing methods
    List<Appointment> findByAppointmentDateTimeBetweenOrderByAppointmentDateTimeAsc(LocalDateTime start, LocalDateTime end);
    List<Appointment> findByStatusOrderByAppointmentDateTimeAsc(Appointment.AppointmentStatus status);
    
    // FIX: Added this method that was missing
    List<Appointment> findByAppointmentDateTimeAfterOrderByAppointmentDateTimeAsc(LocalDateTime dateTime);
    
    // Count queries
    long countByPatientUserId(Long patientUserId);
    long countByDoctorUserId(Long doctorUserId);
    long countByStatus(Appointment.AppointmentStatus status);
    
    @Query("SELECT a FROM Appointment a WHERE a.doctor.user.id = :doctorUserId AND a.appointmentDateTime BETWEEN :start AND :end ORDER BY a.appointmentDateTime ASC")
    List<Appointment> findDoctorAppointmentsBetweenDates(Long doctorUserId, LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.doctor.user.id = :doctorUserId AND a.status = 'COMPLETED'")
    long countCompletedAppointmentsByDoctor(Long doctorUserId);
    
    // FIX: Added method for today's appointments
    @Query("SELECT a FROM Appointment a WHERE a.patient.user.id = :patientUserId AND DATE(a.appointmentDateTime) = CURRENT_DATE ORDER BY a.appointmentDateTime ASC")
    List<Appointment> findTodayAppointmentsByPatient(Long patientUserId);
}