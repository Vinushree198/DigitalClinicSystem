package com.digitalclinic.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("title", "Digital Clinic - Rural Healthcare");
        return "index";
    }
    
    @GetMapping("/home")
    public String homePage(Model model) {
        model.addAttribute("title", "Digital Clinic - Rural Healthcare");
        return "index";
    }
    
    // ADD THIS LOGIN MAPPING
    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("title", "Login - Digital Clinic");
        return "login";
    }
    
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        String email = authentication.getName();
        
        // Check user role and redirect accordingly
        if (authentication.getAuthorities().stream()
            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_PATIENT"))) {
            return "redirect:/patient/dashboard";
        } else if (authentication.getAuthorities().stream()
            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_DOCTOR"))) {
            return "redirect:/doctor/dashboard";
        } else if (authentication.getAuthorities().stream()
            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        }
        
        return "redirect:/login";
    }
}