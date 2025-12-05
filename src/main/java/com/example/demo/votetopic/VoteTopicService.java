package com.example.demo.votetopic;

import com.example.demo.candidate.CandidateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class VoteTopicService {
    
    @Autowired
    private VoteTopicRepository voteTopicRepository;
    
    @Autowired
    private CandidateRepository candidateRepository;
    
    @Transactional
    public VoteTopic createVoteTopic(String title, String description, LocalDateTime deadline) {
        VoteTopic voteTopic = new VoteTopic();
        voteTopic.setTitle(title);
        voteTopic.setDescription(description);
        voteTopic.setDeadline(deadline);
        voteTopic.setStatus("PENDING");
        return voteTopicRepository.save(voteTopic);
    }
    
    @Transactional
    public VoteTopic createVoteTopic(String title, String description, LocalDateTime deadline, Long createdBy, boolean isAdmin) {
        VoteTopic voteTopic = new VoteTopic();
        voteTopic.setTitle(title);
        voteTopic.setDescription(description);
        voteTopic.setDeadline(deadline);
        voteTopic.setCreatedBy(createdBy);
        
        // 상태를 명시적으로 설정
        if (isAdmin) {
            voteTopic.setStatus("ONGOING");
        } else {
            voteTopic.setStatus("PENDING");
        }
        
        System.out.println("투표 생성 - 상태: " + voteTopic.getStatus() + ", 관리자: " + isAdmin + ", 사용자ID: " + createdBy);
        
        VoteTopic saved = voteTopicRepository.save(voteTopic);
        
        System.out.println("투표 저장 완료 - ID: " + saved.getId() + ", 상태: " + saved.getStatus());
        
        return saved;
    }
    
    public List<VoteTopic> getAllVoteTopics() {
        return voteTopicRepository.findAll();
    }
    
    public List<VoteTopic> getOngoingVoteTopics() {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("ONGOING");
    }
    
    public Page<VoteTopic> getOngoingVoteTopics(Pageable pageable) {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("ONGOING", pageable);
    }
    
    public Page<VoteTopic> getOngoingVoteTopics(String searchKeyword, Pageable pageable) {
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            return voteTopicRepository.findByStatusAndTitleContainingIgnoreCaseOrderByCreatedAtDesc("ONGOING", searchKeyword.trim(), pageable);
        }
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("ONGOING", pageable);
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
    
    @Transactional
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
    
    public Page<VoteTopic> getClosedVoteTopics(Pageable pageable) {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("CLOSED", pageable);
    }
    
    public Page<VoteTopic> getClosedVoteTopics(String searchKeyword, Pageable pageable) {
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            return voteTopicRepository.findByStatusAndTitleContainingIgnoreCaseOrderByCreatedAtDesc("CLOSED", searchKeyword.trim(), pageable);
        }
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("CLOSED", pageable);
    }
    
    public Page<VoteTopic> getAllVoteTopics(Pageable pageable) {
        return voteTopicRepository.findAll(pageable);
    }
    
    public Page<VoteTopic> getAllVoteTopics(String searchKeyword, Pageable pageable) {
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            return voteTopicRepository.findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(searchKeyword.trim(), pageable);
        }
        return voteTopicRepository.findAll(pageable);
    }
    
    public List<VoteTopic> getPendingVoteTopics() {
        return voteTopicRepository.findByStatusOrderByCreatedAtDesc("PENDING");
    }
    
    public List<VoteTopic> getVoteTopicsByCreatedBy(Long createdBy) {
        return voteTopicRepository.findByCreatedByOrderByCreatedAtDesc(createdBy);
    }
    
    public VoteTopic updateVoteTopicWithRejectReason(Long id, String rejectReason) {
        VoteTopic voteTopic = voteTopicRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        voteTopic.setStatus("REJECTED");
        voteTopic.setRejectReason(rejectReason);
        return voteTopicRepository.save(voteTopic);
    }
}


