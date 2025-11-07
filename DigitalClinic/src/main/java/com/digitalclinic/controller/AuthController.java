package com.digitalclinic.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.digitalclinic.model.Doctor;
import com.digitalclinic.model.User;
import com.digitalclinic.service.DoctorService;
import com.digitalclinic.service.PatientService;
import com.digitalclinic.service.UserService;

@Controller
@RequestMapping("/register")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private DoctorService doctorService;
    
    @GetMapping("/patient")
    public String showPatientRegister(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("title", "Patient Registration");
        return "register-patient";
    }
    
    @PostMapping("/patient")
    public String registerPatient(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            user.setRole("PATIENT");
            User savedUser = userService.registerUser(user);
            
            // Create patient profile
            patientService.createPatient(savedUser);
            
            redirectAttributes.addFlashAttribute("success", "Patient registration successful! Please login.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/register/patient";
        }
    }
    
    @GetMapping("/doctor")
    public String showDoctorRegister(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("title", "Doctor Registration");
        return "doctor/register-doctor";
    }
    
    @PostMapping("/doctor")
    public String registerDoctor(@ModelAttribute User user, 
                               @RequestParam String specialization,
                               @RequestParam String qualification,
                               @RequestParam String licenseNumber,
                               RedirectAttributes redirectAttributes) {
        try {
            user.setRole("DOCTOR");
            User savedUser = userService.registerUser(user);
            
            // Create doctor profile
            Doctor doctor = new Doctor(savedUser);
            doctor.setSpecialization(specialization);
            doctor.setQualification(qualification);
            doctor.setLicenseNumber(licenseNumber);
            doctor.setVerificationStatus("PENDING");
            doctorService.createDoctor(savedUser);
            
            redirectAttributes.addFlashAttribute("success", "Doctor registration submitted for approval! You will be notified once verified.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/register/doctor";
        }
    }
    
    // ADD ADMIN REGISTRATION METHODS
    @GetMapping("/admin")
    public String showAdminRegister(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("title", "Admin Registration - Digital Clinic");
        return "admin/admin-register"; // This should match your JSP file name
    }
    
    @PostMapping("/admin")
    public String registerAdmin(@ModelAttribute User user,
                              @RequestParam String employeeId,
                              @RequestParam String department,
                              @RequestParam String designation,
                              @RequestParam String adminLevel,
                              @RequestParam String joinDate,
                              @RequestParam(required = false) String permissions,
                              RedirectAttributes redirectAttributes) {
        try {
            user.setRole("ADMIN");
            User savedUser = userService.registerUser(user);
            
            // You can add additional admin-specific processing here
            // For example, save admin-specific details to a separate table
            // adminService.createAdminProfile(savedUser, employeeId, department, designation, adminLevel);
            
            redirectAttributes.addFlashAttribute("success", "Admin registration successful! You can now login.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Admin registration failed: " + e.getMessage());
            return "redirect:/register/admin";
        }
    }
}