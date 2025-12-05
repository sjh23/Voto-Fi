package com.example.demo.candidate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/candidate")
public class CandidateController {
    
    @Autowired
    private CandidateService candidateService;
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> createCandidate(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long voteTopicId = Long.parseLong(request.get("voteTopicId").toString());
            String name = (String) request.get("name");
            String description = (String) request.get("description");
            
            // API에서는 이미지 없이 생성 (null 전달)
            Candidate candidate = candidateService.createCandidate(voteTopicId, name, description, null);
            response.put("success", true);
            response.put("candidate", candidate);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping("/votetopic/{voteTopicId}")
    public ResponseEntity<List<Candidate>> getCandidatesByVoteTopicId(@PathVariable Long voteTopicId) {
        return ResponseEntity.ok(candidateService.getCandidatesByVoteTopicId(voteTopicId));
    }
    
    @GetMapping("/votetopic/{voteTopicId}/ranking")
    public ResponseEntity<List<Candidate>> getCandidatesRanking(@PathVariable Long voteTopicId) {
        return ResponseEntity.ok(candidateService.getCandidatesByVoteTopicIdOrderByVoteCount(voteTopicId));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Candidate> getCandidateById(@PathVariable Long id) {
        return candidateService.getCandidateById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateCandidate(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            String name = (String) request.get("name");
            String description = (String) request.get("description");
            
            // API에서는 이미지 없이 업데이트 (null 전달)
            Candidate candidate = candidateService.updateCandidate(id, name, description, null);
            response.put("success", true);
            response.put("candidate", candidate);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteCandidate(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            candidateService.deleteCandidate(id);
            response.put("success", true);
            response.put("message", "후보가 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}


