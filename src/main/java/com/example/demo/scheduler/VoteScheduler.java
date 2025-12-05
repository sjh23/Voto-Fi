package com.example.demo.scheduler;

import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
public class VoteScheduler {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    // 매 분마다 실행
    @Scheduled(fixedRate = 60000) // 60000ms = 1분
    public void checkVoteDeadlines() {
        List<VoteTopic> ongoingVotes = voteTopicService.getOngoingVoteTopics();
        LocalDateTime now = LocalDateTime.now();
        
        for (VoteTopic vote : ongoingVotes) {
            if (vote.getDeadline().isBefore(now) && "ONGOING".equals(vote.getStatus())) {
                voteTopicService.changeStatus(vote.getId(), "CLOSED");
                System.out.println("투표가 자동으로 마감되었습니다: " + vote.getTitle());
            }
        }
    }
}

