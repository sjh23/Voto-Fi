package com.example.demo.candidate;

import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class CandidateService {
    
    @Autowired
    private CandidateRepository candidateRepository;
    
    @Autowired
    private VoteTopicRepository voteTopicRepository;
    
    public Candidate createCandidate(Long voteTopicId, String name, String description) {
        VoteTopic voteTopic = voteTopicRepository.findById(voteTopicId)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        
        Candidate candidate = new Candidate();
        candidate.setVoteTopic(voteTopic);
        candidate.setName(name);
        candidate.setDescription(description);
        candidate.setVoteCount(0L);
        return candidateRepository.save(candidate);
    }
    
    public List<Candidate> getCandidatesByVoteTopicId(Long voteTopicId) {
        return candidateRepository.findByVoteTopicId(voteTopicId);
    }
    
    public List<Candidate> getCandidatesByVoteTopicIdOrderByVoteCount(Long voteTopicId) {
        return candidateRepository.findByVoteTopicIdOrderByVoteCountDesc(voteTopicId);
    }
    
    public Optional<Candidate> getCandidateById(Long id) {
        return candidateRepository.findById(id);
    }
    
    public Candidate updateCandidate(Long id, String name, String description) {
        Candidate candidate = candidateRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        
        candidate.setName(name);
        candidate.setDescription(description);
        return candidateRepository.save(candidate);
    }
    
    public void deleteCandidate(Long id) {
        candidateRepository.deleteById(id);
    }
    
    @Transactional
    public void incrementVoteCount(Long candidateId) {
        Candidate candidate = candidateRepository.findById(candidateId)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        candidate.setVoteCount(candidate.getVoteCount() + 1);
        candidateRepository.save(candidate);
    }
}

