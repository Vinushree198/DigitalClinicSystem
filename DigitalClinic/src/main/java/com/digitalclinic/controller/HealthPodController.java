package com.digitalclinic.controller;

import com.digitalclinic.model.HealthPod;
import com.digitalclinic.service.HealthPodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/health-pods")
public class HealthPodController {
    
    @Autowired
    private HealthPodService healthPodService;
    
    @GetMapping
    public String listHealthPods(@RequestParam(required = false) String city,
                               @RequestParam(required = false) String search,
                               Model model) {
        List<HealthPod> healthPods;
        
        if (search != null && !search.trim().isEmpty()) {
            healthPods = healthPodService.searchPods(search);
            model.addAttribute("searchTerm", search);
        } else if (city != null && !city.trim().isEmpty()) {
            healthPods = healthPodService.getPodsByCity(city);
            model.addAttribute("selectedCity", city);
        } else {
            healthPods = healthPodService.getAllActivePods();
        }
        
        model.addAttribute("healthPods", healthPods);
        model.addAttribute("cities", healthPodService.getAllCities());
        model.addAttribute("title", "Find Health Pods");
        model.addAttribute("totalPods", healthPods.size());
        
        return "health-pods/list";
    }
    
    @GetMapping("/{id}")
    public String viewHealthPod(@PathVariable Long id, Model model) {
        HealthPod healthPod = healthPodService.getPodById(id)
            .orElseThrow(() -> new RuntimeException("Health Pod not found"));
        
        model.addAttribute("healthPod", healthPod);
        model.addAttribute("title", healthPod.getName());
        
        return "health-pods/details";
    }
    
    @GetMapping("/map")
    public String healthPodsMap(Model model) {
        List<HealthPod> healthPods = healthPodService.getAllActivePods();
        model.addAttribute("healthPods", healthPods);
        model.addAttribute("title", "Health Pods Map");
        return "health-pods/map";
    }
    
    @GetMapping("/near-me")
    public String healthPodsNearMe(Model model) {
        // For now, show all pods. Later we can implement location-based filtering
        List<HealthPod> healthPods = healthPodService.getAllActivePods();
        model.addAttribute("healthPods", healthPods);
        model.addAttribute("title", "Health Pods Near You");
        return "health-pods/near-me";
    }
}