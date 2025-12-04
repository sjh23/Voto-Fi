package com.example.demo.votetopic;

import com.example.demo.candidate.CandidateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class VoteTopicService {
    
    @Autowired
    private VoteTopicRepository voteTopicRepository;
    
    @Autowired
    private CandidateRepository candidateRepository;
    
    public VoteTopic createVoteTopic(String title, String description, LocalDateTime deadline) {
        VoteTopic voteTopic = new VoteTopic();
        voteTopic.setTitle(title);
        voteTopic.setDescription(description);
        voteTopic.setDeadline(deadline);
        voteTopic.setStatus("PENDING");
        return voteTopicRepository.save(voteTopic);
    }
    
    public List<VoteTopic> getAllVoteTopics() {
        return voteTopicRepository.findAll();
    }
    
    public List<VoteTopic> getOngoingVoteTopics() {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("ONGOING");
    }
    
    public Optional<VoteTopic> getVoteTopicById(Long id) {
        return voteTopicRepository.findById(id);
    }
    
    public VoteTopic updateVoteTopic(Long id, String title, String description, LocalDateTime deadline) {
        VoteTopic voteTopic = voteTopicRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        
        voteTopic.setTitle(title);
        voteTopic.setDescription(description);
        voteTopic.setDeadline(deadline);
        return voteTopicRepository.save(voteTopic);
    }
    
    public void deleteVoteTopic(Long id) {
        voteTopicRepository.deleteById(id);
    }
    
    public VoteTopic changeStatus(Long id, String status) {
        VoteTopic voteTopic = voteTopicRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        voteTopic.setStatus(status);
        return voteTopicRepository.save(voteTopic);
    }
    
    public Long getTotalVotesByTopicId(Long topicId) {
        return candidateRepository.findByVoteTopicId(topicId).stream()
            .mapToLong(c -> c.getVoteCount() != null ? c.getVoteCount() : 0L)
            .sum();
    }
    
    public List<VoteTopic> getClosedVoteTopics() {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("CLOSED");
    }
}

