package com.example.demo.votetopic;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VoteTopicRepository extends JpaRepository<VoteTopic, Long> {
    List<VoteTopic> findByStatus(String status);
    List<VoteTopic> findByStatusOrderByCreatedAtDesc(String status);
    Page<VoteTopic> findByStatusOrderByCreatedAtDesc(String status, Pageable pageable);
    Page<VoteTopic> findByStatusAndTitleContainingIgnoreCaseOrderByCreatedAtDesc(String status, String title, Pageable pageable);
    Page<VoteTopic> findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(String title, Pageable pageable);
    List<VoteTopic> findByCreatedByOrderByCreatedAtDesc(Long createdBy);
    Page<VoteTopic> findAll(Pageable pageable);
}


