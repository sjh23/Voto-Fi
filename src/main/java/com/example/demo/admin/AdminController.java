package com.example.demo.admin;

import com.example.demo.user.User;
import com.example.demo.user.UserRepository;
import com.example.demo.voterecord.VoteRecord;
import com.example.demo.voterecord.VoteRecordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
    
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> adminLogin(@RequestBody Map<String, String> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            String username = request.get("username");
            String password = request.get("password");
            
            User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("관리자를 찾을 수 없습니다."));
            
            if (!"ADMIN".equals(user.getRole())) {
                response.put("success", false);
                response.put("message", "관리자 권한이 없습니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            if (!user.getPassword().equals(password)) {
                response.put("success", false);
                response.put("message", "비밀번호가 잘못되었습니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            response.put("success", true);
            response.put("message", "관리자 로그인 성공");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> adminLogout(HttpSession session) {
        if (!isAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "관리자 권한이 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }
        
        session.invalidate();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "로그아웃되었습니다.");
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/voterecords")
    public ResponseEntity<Map<String, Object>> getAllVoteRecords(HttpSession session) {
        if (!isAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "관리자 권한이 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }
        
        List<VoteRecord> records = voteRecordService.getAllVoteRecords();
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("records", records);
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/voterecords/{id}")
    public ResponseEntity<Map<String, Object>> deleteVoteRecord(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "관리자 권한이 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }
        
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
    
    @DeleteMapping("/voterecords/votetopic/{voteTopicId}")
    public ResponseEntity<Map<String, Object>> deleteVoteRecordsByVoteTopicId(@PathVariable Long voteTopicId, HttpSession session) {
        if (!isAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "관리자 권한이 필요합니다.");
            return ResponseEntity.badRequest().body(response);
        }
        
        Map<String, Object> response = new HashMap<>();
        try {
            voteRecordService.deleteVoteRecordsByVoteTopicId(voteTopicId);
            response.put("success", true);
            response.put("message", "투표 기록이 초기화되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}


