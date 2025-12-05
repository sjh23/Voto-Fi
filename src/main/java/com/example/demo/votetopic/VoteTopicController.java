package com.example.demo.votetopic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/votetopic")
public class VoteTopicController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> createVoteTopic(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            String title = (String) request.get("title");
            String description = (String) request.get("description");
            LocalDateTime deadline = LocalDateTime.parse((String) request.get("deadline"));
            
            VoteTopic voteTopic = voteTopicService.createVoteTopic(title, description, deadline);
            response.put("success", true);
            response.put("voteTopic", voteTopic);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping
    public ResponseEntity<List<VoteTopic>> getAllVoteTopics() {
        return ResponseEntity.ok(voteTopicService.getAllVoteTopics());
    }
    
    @GetMapping("/ongoing")
    public ResponseEntity<List<VoteTopic>> getOngoingVoteTopics() {
        return ResponseEntity.ok(voteTopicService.getOngoingVoteTopics());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<VoteTopic> getVoteTopicById(@PathVariable Long id) {
        return voteTopicService.getVoteTopicById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateVoteTopic(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            String title = (String) request.get("title");
            String description = (String) request.get("description");
            LocalDateTime deadline = LocalDateTime.parse((String) request.get("deadline"));
            
            VoteTopic voteTopic = voteTopicService.updateVoteTopic(id, title, description, deadline);
            response.put("success", true);
            response.put("voteTopic", voteTopic);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteVoteTopic(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            voteTopicService.deleteVoteTopic(id);
            response.put("success", true);
            response.put("message", "투표 주제가 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PutMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> changeStatus(@PathVariable Long id, @RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            String status = request.get("status");
            VoteTopic voteTopic = voteTopicService.changeStatus(id, status);
            response.put("success", true);
            response.put("voteTopic", voteTopic);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}


