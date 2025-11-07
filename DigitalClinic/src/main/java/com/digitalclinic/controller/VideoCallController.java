package com.digitalclinic.controller;

import com.digitalclinic.model.*;
import com.digitalclinic.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.Optional;

@Controller
@RequestMapping("/video-call")
public class VideoCallController {
    
    @Autowired
    private VideoConsultationService videoConsultationService;
    
    @Autowired
    private AppointmentService appointmentService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private DoctorService doctorService;
    
 // VideoCallController.java - Add this method
    @GetMapping("/websocket-test")
    public String websocketTest() {
        return "video-call/websocket-test";
    }
    
    // Patient joins video call
    @GetMapping("/patient/{roomId}")
    public String patientJoinVideoCall(@PathVariable String roomId,
                                     Authentication authentication,
                                     Model model,
                                     RedirectAttributes redirectAttributes) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        if (!user.getRole().equals("PATIENT")) {
            redirectAttributes.addFlashAttribute("error", "Access denied");
            return "redirect:/dashboard";
        }
        
        Optional<VideoConsultation> consultationOpt = 
            videoConsultationService.getVideoConsultationByRoomId(roomId);
        
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            
            // Verify patient has access to this consultation
            if (!consultation.getAppointment().getPatient().getUser().getEmail().equals(email)) {
                redirectAttributes.addFlashAttribute("error", "Access denied to this consultation");
                return "redirect:/appointments";
            }
            
            // Check if consultation can be joined
            if (!videoConsultationService.canJoinConsultation(consultation.getId(), "PATIENT")) {
                redirectAttributes.addFlashAttribute("error", 
                    "Consultation cannot be joined at this time. Please check the scheduled time.");
                return "redirect:/appointments/" + consultation.getAppointment().getId();
            }
            
            // Update consultation status
            videoConsultationService.patientJoined(consultation.getId());
            
            model.addAttribute("consultation", consultation);
            model.addAttribute("user", user);
            model.addAttribute("patient", patientService.getPatientByEmail(email).orElseThrow());
            model.addAttribute("title", "Video Consultation - Waiting Room");
            
            return "video-call/patient-waiting";
        }
        
        redirectAttributes.addFlashAttribute("error", "Video consultation not found");
        return "redirect:/appointments";
    }
    
    // Doctor joins video call
    @GetMapping("/doctor/{roomId}")
    public String doctorJoinVideoCall(@PathVariable String roomId,
                                    Authentication authentication,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        if (!user.getRole().equals("DOCTOR")) {
            redirectAttributes.addFlashAttribute("error", "Access denied");
            return "redirect:/dashboard";
        }
        
        Optional<VideoConsultation> consultationOpt = 
            videoConsultationService.getVideoConsultationByRoomId(roomId);
        
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            
            // Verify doctor has access to this consultation
            if (consultation.getAppointment().getDoctor() == null || 
                !consultation.getAppointment().getDoctor().getUser().getEmail().equals(email)) {
                redirectAttributes.addFlashAttribute("error", "Access denied to this consultation");
                return "redirect:/appointments";
            }
            
            // Check if consultation can be joined
            if (!videoConsultationService.canJoinConsultation(consultation.getId(), "DOCTOR")) {
                redirectAttributes.addFlashAttribute("error", 
                    "Consultation cannot be joined at this time. Please check the scheduled time.");
                return "redirect:/appointments/" + consultation.getAppointment().getId();
            }
            
            // Update consultation status
            videoConsultationService.doctorJoined(consultation.getId());
            
            model.addAttribute("consultation", consultation);
            model.addAttribute("user", user);
            model.addAttribute("doctor", doctorService.getDoctorByEmail(email).orElseThrow());
            model.addAttribute("patient", consultation.getAppointment().getPatient());
            model.addAttribute("title", "Video Consultation - Doctor Panel");
            
            return "video-call/doctor-panel";
        }
        
        redirectAttributes.addFlashAttribute("error", "Video consultation not found");
        return "redirect:/appointments";
    }
    
    // Main video call interface
    @GetMapping("/{roomId}")
    public String videoCallInterface(@PathVariable String roomId,
                                   Authentication authentication,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        Optional<VideoConsultation> consultationOpt = 
            videoConsultationService.getVideoConsultationByRoomId(roomId);
        
        if (consultationOpt.isPresent()) {
            VideoConsultation consultation = consultationOpt.get();
            
            // Verify user has access to this consultation
            boolean hasAccess = false;
            if (user.getRole().equals("PATIENT") && 
                consultation.getAppointment().getPatient().getUser().getEmail().equals(email)) {
                hasAccess = true;
            } else if (user.getRole().equals("DOCTOR") && 
                       consultation.getAppointment().getDoctor() != null &&
                       consultation.getAppointment().getDoctor().getUser().getEmail().equals(email)) {
                hasAccess = true;
            }
            
            if (!hasAccess) {
                redirectAttributes.addFlashAttribute("error", "Access denied to this consultation");
                return "redirect:/dashboard";
            }
            
            model.addAttribute("consultation", consultation);
            model.addAttribute("user", user);
            model.addAttribute("title", "Video Consultation");
            
            if (user.getRole().equals("PATIENT")) {
                model.addAttribute("patient", patientService.getPatientByEmail(email).orElseThrow());
                return "video-call/patient-interface";
            } else {
                model.addAttribute("doctor", doctorService.getDoctorByEmail(email).orElseThrow());
                model.addAttribute("patient", consultation.getAppointment().getPatient());
                return "video-call/doctor-interface";
            }
        }
        
        redirectAttributes.addFlashAttribute("error", "Video consultation not found");
        return "redirect:/appointments";
    }
    
    // Start consultation (Doctor action)
    @PostMapping("/{consultationId}/start")
    public String startConsultation(@PathVariable Long consultationId,
                                  Authentication authentication,
                                  RedirectAttributes redirectAttributes) {
        try {
            VideoConsultation consultation = videoConsultationService.startConsultation(consultationId);
            redirectAttributes.addFlashAttribute("success", "Consultation started successfully");
            return "redirect:/video-call/" + consultation.getRoomId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to start consultation: " + e.getMessage());
            return "redirect:/appointments";
        }
    }
    
    // Complete consultation
    @PostMapping("/{consultationId}/complete")
    public String completeConsultation(@PathVariable Long consultationId,
                                     @RequestParam(required = false) String prescription,
                                     @RequestParam(required = false) String notes,
                                     Authentication authentication,
                                     RedirectAttributes redirectAttributes) {
        try {
            VideoConsultation consultation = videoConsultationService.completeConsultation(consultationId);
            
            // Update appointment with prescription if provided
            if (prescription != null && !prescription.trim().isEmpty()) {
                appointmentService.completeAppointment(
                    consultation.getAppointment().getId(),
                    prescription,
                    notes != null ? notes : "Consultation completed via video call"
                );
            }
            
            redirectAttributes.addFlashAttribute("success", "Consultation completed successfully");
            return "redirect:/appointments/" + consultation.getAppointment().getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to complete consultation: " + e.getMessage());
            return "redirect:/video-call/" + consultationId;
        }
    }
    
    // Video consultations list for patients
    @GetMapping("/patient/consultations")
    public String patientConsultations(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Patient patient = patientService.getPatientByEmail(email).orElseThrow();
        
        var consultations = videoConsultationService.getPatientConsultations(patient.getUser().getId());
        
        model.addAttribute("consultations", consultations);
        model.addAttribute("user", user);
        model.addAttribute("patient", patient);
        model.addAttribute("title", "My Video Consultations");
        
        return "video-call/patient-consultations";
    }
    
    // Video consultations list for doctors
    @GetMapping("/doctor/consultations")
    public String doctorConsultations(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Doctor doctor = doctorService.getDoctorByEmail(email).orElseThrow();
        
        var consultations = videoConsultationService.getDoctorConsultations(doctor.getUser().getId());
        
        model.addAttribute("consultations", consultations);
        model.addAttribute("user", user);
        model.addAttribute("doctor", doctor);
        model.addAttribute("title", "My Video Consultations");
        
        return "video-call/doctor-consultations";
    }
    
    // Video call test page
    @GetMapping("/test")
    public String videoTestPage(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("title", "Video Call Test");
        
        return "video-call/test";
    }
}