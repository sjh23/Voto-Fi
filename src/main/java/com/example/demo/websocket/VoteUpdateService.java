package com.example.demo.websocket;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateService;
import com.example.demo.votetopic.VoteTopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class VoteUpdateService {
    
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    public void broadcastVoteUpdate(Long voteTopicId) {
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicIdOrderByVoteCount(voteTopicId);
        
        // 총 투표수 계산
        Long totalVotes = candidates.stream()
            .mapToLong(c -> c.getVoteCount() != null ? c.getVoteCount() : 0L)
            .sum();
        
        // 득표율 계산
        for (Candidate candidate : candidates) {
            if (totalVotes > 0) {
                double percentage = (candidate.getVoteCount() * 100.0) / totalVotes;
                candidate.setVotePercentage(percentage);
            } else {
                candidate.setVotePercentage(0.0);
            }
        }
        
        Map<String, Object> update = new HashMap<>();
        update.put("voteTopicId", voteTopicId);
        update.put("candidates", candidates);
        update.put("totalVotes", totalVotes);
        
        messagingTemplate.convertAndSend("/topic/vote-updates/" + voteTopicId, (Object) update);
    }
}

