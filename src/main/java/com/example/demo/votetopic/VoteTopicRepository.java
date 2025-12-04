package com.example.demo.votetopic;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VoteTopicRepository extends JpaRepository<VoteTopic, Long> {
    List<VoteTopic> findByStatus(String status);
    List<VoteTopic> findByStatusOrderByCreatedAtDesc(String status);
}

