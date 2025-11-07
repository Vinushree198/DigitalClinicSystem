package com.digitalclinic;

import com.digitalclinic.model.User;
import com.digitalclinic.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class DigitalClinicApplication implements CommandLineRunner {

    @Autowired
    private HealthPodService healthPodService;

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public static void main(String[] args) {
        SpringApplication.run(DigitalClinicApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        // Initialize sample data
        healthPodService.initializeSampleData();
        appointmentService.initializeSampleAppointments();
        createAdminUser();
    }

    private void createAdminUser() {
        // Check if admin user already exists
        if (!userService.findByEmail("admin@digitalclinic.com").isPresent()) {
            User admin = new User();
            admin.setEmail("admin@digitalclinic.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole("ADMIN");
            admin.setFullName("System Administrator");
            admin.setPhone("9876543210");
            admin.setAddress("Digital Clinic Headquarters");
            
            userService.registerUser(admin);
            System.out.println("Admin user created: admin@digitalclinic.com / admin123");
        }
    }
}