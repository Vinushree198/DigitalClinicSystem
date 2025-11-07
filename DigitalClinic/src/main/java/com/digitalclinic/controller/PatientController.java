package com.digitalclinic.controller;

import com.digitalclinic.model.Patient;
import com.digitalclinic.model.User;
import com.digitalclinic.service.PatientService;
import com.digitalclinic.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/patient")
public class PatientController {
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/dashboard")
    public String patientDashboard(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Patient patient = patientService.getPatientByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("patient", patient);
        model.addAttribute("title", "Patient Dashboard");
        return "patient/dashboard";
    }
    
    @GetMapping("/profile")
    public String viewProfile(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Patient patient = patientService.getPatientByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("patient", patient);
        model.addAttribute("title", "My Profile");
        return "patient/profile";
    }
    
    @GetMapping("/profile/edit")
    public String editProfileForm(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Patient patient = patientService.getPatientByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("patient", patient);
        model.addAttribute("title", "Edit Profile");
        return "patient/edit-profile";
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(Authentication authentication,
                              @ModelAttribute Patient patientDetails,
                              @ModelAttribute User userDetails) {
        String email = authentication.getName();
        
        // Update user details
        User user = userService.findByEmail(email).orElseThrow();
        user.setFullName(userDetails.getFullName());
        user.setPhone(userDetails.getPhone());
        user.setAddress(userDetails.getAddress());
        userService.saveUser(user);
        
        // Update patient details
        patientService.updatePatientProfile(email, patientDetails);
        
        return "redirect:/patient/profile?success=true";
    }
}