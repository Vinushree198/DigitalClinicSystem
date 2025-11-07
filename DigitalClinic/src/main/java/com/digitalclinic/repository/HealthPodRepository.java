package com.digitalclinic.repository;

import com.digitalclinic.model.HealthPod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface HealthPodRepository extends JpaRepository<HealthPod, Long> {
    
    List<HealthPod> findByIsActiveTrue();
    List<HealthPod> findByCity(String city);
    List<HealthPod> findByCityAndIsActiveTrue(String city);
    
    @Query("SELECT DISTINCT h.city FROM HealthPod h WHERE h.isActive = true ORDER BY h.city")
    List<String> findDistinctCities();
    
    @Query("SELECT h FROM HealthPod h WHERE h.isActive = true AND (" +
           "LOWER(h.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(h.city) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(h.address) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<HealthPod> searchActivePods(String search);
    
    long countByIsActiveTrue();
    
    Optional<HealthPod> findByNameAndCity(String name, String city);
}