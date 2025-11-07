package com.digitalclinic.controller;

import com.digitalclinic.model.Doctor;
import com.digitalclinic.model.User;
import com.digitalclinic.service.DoctorService;
import com.digitalclinic.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/doctor")
public class DoctorController {
    
    @Autowired
    private DoctorService doctorService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/dashboard")
    public String doctorDashboard(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Doctor doctor = doctorService.getDoctorByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("doctor", doctor);
        model.addAttribute("title", "Doctor Dashboard");
        return "doctor/dashboard";
    }
    
    @GetMapping("/profile")
    public String viewProfile(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Doctor doctor = doctorService.getDoctorByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("doctor", doctor);
        model.addAttribute("title", "My Profile");
        return "doctor/profile";
    }
    
    @GetMapping("/profile/edit")
    public String editProfileForm(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElseThrow();
        Doctor doctor = doctorService.getDoctorByEmail(email).orElseThrow();
        
        model.addAttribute("user", user);
        model.addAttribute("doctor", doctor);
        model.addAttribute("specializations", doctorService.getAllSpecializations());
        model.addAttribute("title", "Edit Profile");
        return "doctor/edit-profile";
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(Authentication authentication,
                              @ModelAttribute Doctor doctorDetails,
                              @ModelAttribute User userDetails) {
        String email = authentication.getName();
        
        // Update user details
        User user = userService.findByEmail(email).orElseThrow();
        user.setFullName(userDetails.getFullName());
        user.setPhone(userDetails.getPhone());
        user.setAddress(userDetails.getAddress());
        userService.saveUser(user);
        
        // Update doctor details
        doctorService.updateDoctorProfile(email, doctorDetails);
        
        return "redirect:/doctor/profile?success=true";
    }
}