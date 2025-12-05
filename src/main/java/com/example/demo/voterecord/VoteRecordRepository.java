package com.example.demo.voterecord;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface VoteRecordRepository extends JpaRepository<VoteRecord, Long> {
    boolean existsByIpAddressAndCandidate_VoteTopicId(String ipAddress, Long voteTopicId);
    boolean existsByUserIdAndCandidate_VoteTopicId(Long userId, Long voteTopicId);
    List<VoteRecord> findByCandidate_VoteTopicId(Long voteTopicId);
    Optional<VoteRecord> findByUserIdAndCandidate_VoteTopicId(Long userId, Long voteTopicId);
    List<VoteRecord> findAll();
    Optional<VoteRecord> findById(Long id);
}


