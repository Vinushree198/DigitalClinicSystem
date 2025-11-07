package com.digitalclinic.service;

import com.digitalclinic.model.HealthPod;
import com.digitalclinic.repository.HealthPodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class HealthPodService {
    
    @Autowired
    private HealthPodRepository healthPodRepository;
    
    public List<HealthPod> getAllActivePods() {
        return healthPodRepository.findByIsActiveTrue();
    }
    
    public List<HealthPod> getPodsByCity(String city) {
        return healthPodRepository.findByCityAndIsActiveTrue(city);
    }
    
    public List<String> getAllCities() {
        return healthPodRepository.findDistinctCities();
    }
    
    public List<HealthPod> searchPods(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllActivePods();
        }
        return healthPodRepository.searchActivePods(searchTerm.trim());
    }
    
    public Optional<HealthPod> getPodById(Long id) {
        return healthPodRepository.findById(id);
    }
    
    public HealthPod savePod(HealthPod healthPod) {
        return healthPodRepository.save(healthPod);
    }
    
    public HealthPod updatePod(Long id, HealthPod podDetails) {
        Optional<HealthPod> existingPod = healthPodRepository.findById(id);
        if (existingPod.isPresent()) {
            HealthPod pod = existingPod.get();
            
            // Update fields
            if (podDetails.getName() != null) pod.setName(podDetails.getName());
            if (podDetails.getAddress() != null) pod.setAddress(podDetails.getAddress());
            if (podDetails.getCity() != null) pod.setCity(podDetails.getCity());
            if (podDetails.getState() != null) pod.setState(podDetails.getState());
            if (podDetails.getPincode() != null) pod.setPincode(podDetails.getPincode());
            if (podDetails.getPhone() != null) pod.setPhone(podDetails.getPhone());
            if (podDetails.getEmail() != null) pod.setEmail(podDetails.getEmail());
            if (podDetails.getInchargeName() != null) pod.setInchargeName(podDetails.getInchargeName());
            if (podDetails.getOpeningTime() != null) pod.setOpeningTime(podDetails.getOpeningTime());
            if (podDetails.getClosingTime() != null) pod.setClosingTime(podDetails.getClosingTime());
            if (podDetails.getStaffCount() != null) pod.setStaffCount(podDetails.getStaffCount());
            if (podDetails.getHasPharmacy() != null) pod.setHasPharmacy(podDetails.getHasPharmacy());
            if (podDetails.getHasLab() != null) pod.setHasLab(podDetails.getHasLab());
            if (podDetails.getLatitude() != null) pod.setLatitude(podDetails.getLatitude());
            if (podDetails.getLongitude() != null) pod.setLongitude(podDetails.getLongitude());
            if (podDetails.getImageUrl() != null) pod.setImageUrl(podDetails.getImageUrl());
            if (podDetails.getDescription() != null) pod.setDescription(podDetails.getDescription());
            
            // Update facilities and equipment if provided
            if (podDetails.getFacilities() != null && !podDetails.getFacilities().isEmpty()) {
                pod.setFacilities(podDetails.getFacilities());
            }
            if (podDetails.getEquipment() != null && !podDetails.getEquipment().isEmpty()) {
                pod.setEquipment(podDetails.getEquipment());
            }
            
            return healthPodRepository.save(pod);
        }
        return null;
    }
    
    public boolean deactivatePod(Long id) {
        Optional<HealthPod> pod = healthPodRepository.findById(id);
        if (pod.isPresent()) {
            HealthPod healthPod = pod.get();
            healthPod.setIsActive(false);
            healthPodRepository.save(healthPod);
            return true;
        }
        return false;
    }
    
    public long getActivePodsCount() {
        return healthPodRepository.countByIsActiveTrue();
    }
    
    // Initialize sample data
    public void initializeSampleData() {
        if (healthPodRepository.count() == 0) {
            // Sample Health Pod 1
            HealthPod pod1 = new HealthPod("Village Health Pod - Kamalpur", 
                "Near Primary School, Kamalpur Village", "Kamalpur", "9876543210");
            pod1.setState("Rajasthan");
            pod1.setPincode("302001");
            pod1.setInchargeName("Dr. Sharma");
            pod1.setEmail("kamalpur@digitalclinic.com");
            pod1.setOpeningTime(java.time.LocalTime.of(8, 0));
            pod1.setClosingTime(java.time.LocalTime.of(20, 0));
            pod1.setStaffCount(3);
            pod1.setHasPharmacy(true);
            pod1.setHasLab(false);
            pod1.setLatitude(26.9124);
            pod1.setLongitude(75.7873);
            pod1.setDescription("Basic healthcare services for Kamalpur village and surrounding areas. Equipped for basic checkups and telemedicine consultations.");
            
            pod1.addFacility("Basic Health Checkups");
            pod1.addFacility("BP Monitoring");
            pod1.addFacility("Sugar Testing");
            pod1.addFacility("Telemedicine Booth");
            pod1.addFacility("First Aid");
            
            pod1.addEquipment("BP Monitor");
            pod1.addEquipment("Glucometer");
            pod1.addEquipment("Weighing Scale");
            pod1.addEquipment("Thermometer");
            pod1.addEquipment("Computer with Webcam");
            
            healthPodRepository.save(pod1);
            
            // Sample Health Pod 2
            HealthPod pod2 = new HealthPod("Community Health Center - Sundarpur", 
                "Sundarpur Gram Panchayat Building", "Sundarpur", "9876543211");
            pod2.setState("Rajasthan");
            pod2.setPincode("302002");
            pod2.setInchargeName("Dr. Gupta");
            pod2.setEmail("sundarpur@digitalclinic.com");
            pod2.setOpeningTime(java.time.LocalTime.of(9, 0));
            pod2.setClosingTime(java.time.LocalTime.of(18, 0));
            pod2.setStaffCount(5);
            pod2.setHasPharmacy(true);
            pod2.setHasLab(true);
            pod2.setLatitude(26.9224);
            pod2.setLongitude(75.7973);
            pod2.setDescription("Comprehensive healthcare center serving multiple villages. Offers basic lab tests and specialist consultations via telemedicine.");
            
            pod2.addFacility("Health Checkups");
            pod2.addFacility("Vaccination Services");
            pod2.addFacility("Maternal Care");
            pod2.addFacility("Lab Tests");
            pod2.addFacility("Tele-specialist Consultations");
            pod2.addFacility("Medicine Dispensing");
            
            pod2.addEquipment("BP Monitor");
            pod2.addEquipment("Glucometer");
            pod2.addEquipment("ECG Machine");
            pod2.addEquipment("Microscope");
            pod2.addEquipment("Centrifuge");
            pod2.addEquipment("Telemedicine Setup");
            
            healthPodRepository.save(pod2);
            
            // Sample Health Pod 3
            HealthPod pod3 = new HealthPod("Rural Health Pod - Devgarh", 
                "Devgarh Block, Near Community Hall", "Devgarh", "9876543212");
            pod3.setState("Rajasthan");
            pod3.setPincode("302003");
            pod3.setInchargeName("Dr. Patel");
            pod3.setEmail("devgarh@digitalclinic.com");
            pod3.setOpeningTime(java.time.LocalTime.of(8, 30));
            pod3.setClosingTime(java.time.LocalTime.of(17, 30));
            pod3.setStaffCount(4);
            pod3.setHasPharmacy(true);
            pod3.setHasLab(true);
            pod3.setLatitude(26.9324);
            pod3.setLongitude(75.8073);
            pod3.setDescription("Advanced rural health pod with diagnostic facilities and emergency care services. Serves as a hub for multiple villages.");
            
            pod3.addFacility("Comprehensive Health Screening");
            pod3.addFacility("Chronic Disease Management");
            pod3.addFacility("Emergency Care");
            pod3.addFacility("Diagnostic Services");
            pod3.addFacility("Specialist Video Consultations");
            pod3.addFacility("Health Education");
            
            pod3.addEquipment("Digital BP Monitor");
            pod3.addEquipment("Advanced Glucometer");
            pod3.addEquipment("Pulse Oximeter");
            pod3.addEquipment("ECG Machine");
            pod3.addEquipment("Basic Lab Equipment");
            pod3.addEquipment("Emergency Kit");
            
            healthPodRepository.save(pod3);
        }
    }
}