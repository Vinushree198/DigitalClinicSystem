package com.digitalclinic.controller;

import com.digitalclinic.model.*;
import com.digitalclinic.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/appointments")
public class AppointmentController {
    
    @Autowired
    private AppointmentService appointmentService;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private DoctorService doctorService;
    
    @Autowired
    private HealthPodService healthPodService;
    
    @Autowired
    private UserService userService;
    
    // Patient appointment management
    @GetMapping
    public String listAppointments(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        if (user.getRole().equals("PATIENT")) {
            Patient patient = patientService.getPatientByEmail(email).orElseThrow();
            List<Appointment> appointments = appointmentService.getPatientAppointments(patient.getUser().getId());
            
            model.addAttribute("appointments", appointments);
            model.addAttribute("title", "My Appointments");
            model.addAttribute("user", user);
            model.addAttribute("patient", patient);
            
            return "appointments/patient-list";
        } else if (user.getRole().equals("DOCTOR")) {
            Doctor doctor = doctorService.getDoctorByEmail(email).orElseThrow();
            List<Appointment> appointments = appointmentService.getDoctorAppointments(doctor.getUser().getId());
            
            model.addAttribute("appointments", appointments);
            model.addAttribute("title", "My Appointments");
            model.addAttribute("user", user);
            model.addAttribute("doctor", doctor);
            
            return "appointments/doctor-list";
        }
        
        return "redirect:/dashboard";
    }
    
    @GetMapping("/book")
    public String showBookAppointmentForm(@RequestParam(required = false) Long podId,
                                        @RequestParam(required = false) Long doctorId,
                                        Authentication authentication,
                                        Model model) {
        String email = authentication.getName();
        Patient patient = patientService.getPatientByEmail(email).orElseThrow();
        
        List<Doctor> doctors = doctorService.getAllVerifiedDoctors();
        List<HealthPod> healthPods = healthPodService.getAllActivePods();
        
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", doctors);
        model.addAttribute("healthPods", healthPods);
        model.addAttribute("patient", patient);
        model.addAttribute("title", "Book Appointment");
        
        // Pre-select if parameters provided
        if (podId != null) {
            HealthPod selectedPod = healthPodService.getPodById(podId).orElse(null);
            model.addAttribute("selectedPod", selectedPod);
        }
        if (doctorId != null) {
            Doctor selectedDoctor = doctorService.getDoctorById(doctorId).orElse(null);
            model.addAttribute("selectedDoctor", selectedDoctor);
        }
        
        return "appointments/book";
    }
    
    @PostMapping("/book")
    public String bookAppointment(@RequestParam String appointmentDate,
                                @RequestParam String appointmentTime,
                                @RequestParam String type,
                                @RequestParam(required = false) String symptoms,
                                @RequestParam Long patientId,
                                @RequestParam(required = false) Long doctorId,
                                @RequestParam(required = false) Long podId,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {
        try {
            // Combine date and time to create LocalDateTime
            LocalDateTime appointmentDateTime = LocalDateTime.of(
                LocalDate.parse(appointmentDate),
                LocalTime.parse(appointmentTime)
            );
            
            // Convert String type to AppointmentType enum
            Appointment.AppointmentType appointmentType = Appointment.AppointmentType.valueOf(type);
            
            // Create new Appointment object
            Appointment appointment = new Appointment();
            appointment.setAppointmentDateTime(appointmentDateTime);
            appointment.setType(appointmentType);
            appointment.setSymptoms(symptoms);
            appointment.setStatus(Appointment.AppointmentStatus.SCHEDULED);
            
            Patient patient = patientService.getPatientById(patientId).orElseThrow();
            appointment.setPatient(patient);
            
            if (doctorId != null) {
                Doctor doctor = doctorService.getDoctorById(doctorId).orElseThrow();
                appointment.setDoctor(doctor);
                // Set consultation fee from doctor
                if (appointment.getConsultationFee() == null) {
                    appointment.setConsultationFee(doctor.getConsultationFee());
                }
            }
            
            if (podId != null) {
                HealthPod healthPod = healthPodService.getPodById(podId).orElseThrow();
                appointment.setHealthPod(healthPod);
            }
            
            // Validate appointment time
            if (appointment.getAppointmentDateTime().isBefore(LocalDateTime.now().plusHours(1))) {
                throw new RuntimeException("Appointment must be scheduled at least 1 hour in advance");
            }
            
            Appointment savedAppointment = appointmentService.bookAppointment(appointment);
            
            redirectAttributes.addFlashAttribute("success", 
                "Appointment booked successfully! Your appointment ID: " + savedAppointment.getId());
            return "redirect:/appointments";
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Invalid appointment type");
            return "redirect:/appointments/book";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to book appointment: " + e.getMessage());
            return "redirect:/appointments/book";
        }
    }
    
    @GetMapping("/{id}")
    public String viewAppointment(@PathVariable Long id, Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Appointment appointment = appointmentService.getAppointmentById(id).orElseThrow();
        
        // Check if user has access to this appointment
        if (user.getRole().equals("PATIENT") && 
            !appointment.getPatient().getUser().getEmail().equals(email)) {
            throw new RuntimeException("Access denied");
        }
        if (user.getRole().equals("DOCTOR") && 
            (appointment.getDoctor() == null || !appointment.getDoctor().getUser().getEmail().equals(email))) {
            throw new RuntimeException("Access denied");
        }
        
        model.addAttribute("appointment", appointment);
        model.addAttribute("title", "Appointment Details");
        model.addAttribute("user", user);
        
        if (user.getRole().equals("PATIENT")) {
            model.addAttribute("patient", patientService.getPatientByEmail(email).orElseThrow());
            return "appointments/patient-details";
        } else {
            model.addAttribute("doctor", doctorService.getDoctorByEmail(email).orElseThrow());
            return "appointments/doctor-details";
        }
    }
    
    @PostMapping("/{id}/cancel")
    public String cancelAppointment(@PathVariable Long id,
                                  @RequestParam String reason,
                                  Authentication authentication,
                                  RedirectAttributes redirectAttributes) {
        try {
            appointmentService.cancelAppointment(id, reason);
            redirectAttributes.addFlashAttribute("success", "Appointment cancelled successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to cancel appointment: " + e.getMessage());
        }
        return "redirect:/appointments/" + id;
    }
    
    @PostMapping("/{id}/reschedule")
    public String rescheduleAppointment(@PathVariable Long id,
                                      @RequestParam String newDateTime,
                                      Authentication authentication,
                                      RedirectAttributes redirectAttributes) {
        try {
            LocalDateTime newAppointmentDateTime = LocalDateTime.parse(newDateTime);
            appointmentService.rescheduleAppointment(id, newAppointmentDateTime);
            redirectAttributes.addFlashAttribute("success", "Appointment rescheduled successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to reschedule appointment: " + e.getMessage());
        }
        return "redirect:/appointments/" + id;
    }
    
    // Doctor-specific actions
    @PostMapping("/{id}/confirm")
    public String confirmAppointment(@PathVariable Long id,
                                   Authentication authentication,
                                   RedirectAttributes redirectAttributes) {
        try {
            appointmentService.updateAppointmentStatus(id, Appointment.AppointmentStatus.CONFIRMED);
            redirectAttributes.addFlashAttribute("success", "Appointment confirmed");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to confirm appointment: " + e.getMessage());
        }
        return "redirect:/appointments/" + id;
    }
    
    @PostMapping("/{id}/complete")
    public String completeAppointment(@PathVariable Long id,
                                    @RequestParam String prescription,
                                    @RequestParam String notes,
                                    Authentication authentication,
                                    RedirectAttributes redirectAttributes) {
        try {
            appointmentService.completeAppointment(id, prescription, notes);
            redirectAttributes.addFlashAttribute("success", "Appointment completed successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to complete appointment: " + e.getMessage());
        }
        return "redirect:/appointments/" + id;
    }
    
    // Feedback
    @PostMapping("/{id}/feedback")
    public String addFeedback(@PathVariable Long id,
                            @RequestParam Integer rating,
                            @RequestParam String feedback,
                            Authentication authentication,
                            RedirectAttributes redirectAttributes) {
        try {
            appointmentService.addFeedback(id, rating, feedback);
            redirectAttributes.addFlashAttribute("success", "Thank you for your feedback!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to submit feedback: " + e.getMessage());
        }
        return "redirect:/appointments/" + id;
    }
}