package com.example.demo.candidate;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CandidateRepository extends JpaRepository<Candidate, Long> {
    List<Candidate> findByVoteTopicId(Long voteTopicId);
    List<Candidate> findByVoteTopicIdOrderByVoteCountDesc(Long voteTopicId);
}


