 package com.digitalclinic.model;

import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "health_pods")
public class HealthPod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String address;
    
    private String city;
    private String state;
    private String pincode;
    
    @Column(unique = true)
    private String phone;
    
    private String email;
    private String inchargeName;
    
    @ElementCollection
    @CollectionTable(name = "pod_facilities", joinColumns = @JoinColumn(name = "pod_id"))
    @Column(name = "facility")
    private List<String> facilities = new ArrayList<>();
    
    @ElementCollection
    @CollectionTable(name = "pod_equipment", joinColumns = @JoinColumn(name = "pod_id"))
    @Column(name = "equipment")
    private List<String> equipment = new ArrayList<>();
    
    private LocalTime openingTime;
    private LocalTime closingTime;
    
    private Integer staffCount;
    private Boolean hasPharmacy = false;
    private Boolean hasLab = false;
    private Boolean isActive = true;
    
    private Double latitude;
    private Double longitude;
    
    private String imageUrl;
    
    @Column(length = 1000)
    private String description;
    
    // Constructors
    public HealthPod() {}
    
    public HealthPod(String name, String address, String city, String phone) {
        this.name = name;
        this.address = address;
        this.city = city;
        this.phone = phone;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getInchargeName() { return inchargeName; }
    public void setInchargeName(String inchargeName) { this.inchargeName = inchargeName; }
    
    public List<String> getFacilities() { return facilities; }
    public void setFacilities(List<String> facilities) { this.facilities = facilities; }
    
    public List<String> getEquipment() { return equipment; }
    public void setEquipment(List<String> equipment) { this.equipment = equipment; }
    
    public LocalTime getOpeningTime() { return openingTime; }
    public void setOpeningTime(LocalTime openingTime) { this.openingTime = openingTime; }
    
    public LocalTime getClosingTime() { return closingTime; }
    public void setClosingTime(LocalTime closingTime) { this.closingTime = closingTime; }
    
    public Integer getStaffCount() { return staffCount; }
    public void setStaffCount(Integer staffCount) { this.staffCount = staffCount; }
    
    public Boolean getHasPharmacy() { return hasPharmacy; }
    public void setHasPharmacy(Boolean hasPharmacy) { this.hasPharmacy = hasPharmacy; }
    
    public Boolean getHasLab() { return hasLab; }
    public void setHasLab(Boolean hasLab) { this.hasLab = hasLab; }
    
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    // Helper methods
    public void addFacility(String facility) {
        if (this.facilities == null) {
            this.facilities = new ArrayList<>();
        }
        this.facilities.add(facility);
    }
    
    public void addEquipment(String equipmentItem) {
        if (this.equipment == null) {
            this.equipment = new ArrayList<>();
        }
        this.equipment.add(equipmentItem);
    }
    
    public String getFullAddress() {
        return String.format("%s, %s, %s - %s", address, city, state, pincode);
    }
    
    public String getOperatingHours() {
        if (openingTime != null && closingTime != null) {
            return String.format("%s - %s", openingTime, closingTime);
        }
        return "Not specified";
    }
}