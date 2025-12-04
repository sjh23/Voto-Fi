package com.example.demo.voterecord;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/voterecord")
public class VoteRecordController {
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        return request.getRemoteAddr();
    }
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> saveVoteRecord(
            @RequestBody Map<String, Object> request,
            HttpServletRequest httpRequest,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long candidateId = Long.parseLong(request.get("candidateId").toString());
            Long userId = (Long) session.getAttribute("userId");
            String ipAddress = getClientIpAddress(httpRequest);
            
            VoteRecord voteRecord = voteRecordService.saveVoteRecord(candidateId, userId, ipAddress);
            response.put("success", true);
            response.put("message", "투표가 완료되었습니다.");
            response.put("voteRecord", voteRecord);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping
    public ResponseEntity<List<VoteRecord>> getAllVoteRecords() {
        return ResponseEntity.ok(voteRecordService.getAllVoteRecords());
    }
    
    @GetMapping("/votetopic/{voteTopicId}")
    public ResponseEntity<List<VoteRecord>> getVoteRecordsByVoteTopicId(@PathVariable Long voteTopicId) {
        return ResponseEntity.ok(voteRecordService.getVoteRecordsByVoteTopicId(voteTopicId));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<VoteRecord> getVoteRecordById(@PathVariable Long id) {
        return voteRecordService.getVoteRecordById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteVoteRecord(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            voteRecordService.deleteVoteRecord(id);
            response.put("success", true);
            response.put("message", "투표 기록이 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}

