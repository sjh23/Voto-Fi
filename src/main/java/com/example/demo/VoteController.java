package com.example.demo;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateService;
import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import com.example.demo.voterecord.VoteRecordService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/vote")
public class VoteController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    @GetMapping("/{id}")
    public String voteDetail(@PathVariable("id") Long id, Model model, HttpSession session) {
        Optional<VoteTopic> voteTopicOpt = voteTopicService.getVoteTopicById(id);
        if (voteTopicOpt.isEmpty()) {
            return "redirect:/";
        }
        
        VoteTopic voteTopic = voteTopicOpt.get();
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
        
        boolean loggedIn = session.getAttribute("userId") != null;
        
        // 사용자가 이 투표에 이미 투표했는지 확인
        Long userId = (Long) session.getAttribute("userId");
        Long selectedCandidateId = null;
        if (userId != null) {
            // 데이터베이스에서 실제 투표 기록 조회
            try {
                selectedCandidateId = voteRecordService.getSelectedCandidateIdByUserAndVoteTopic(userId, id);
                System.out.println("투표 상세 페이지 로드 - 투표 ID: " + id + ", 사용자 ID: " + userId + ", 선택한 후보 ID: " + selectedCandidateId);
            } catch (Exception e) {
                // 투표 기록이 없으면 null 유지
                System.out.println("투표 기록 조회 오류: " + e.getMessage());
            }
        }
        
        model.addAttribute("voteTopic", voteTopic);
        model.addAttribute("candidates", candidates);
        model.addAttribute("loggedIn", loggedIn);
        model.addAttribute("selectedCandidateId", selectedCandidateId);
        
        // 로그인하지 않은 경우 로그인 페이지로 리다이렉트하지 않고, 페이지는 보여주되 투표는 불가능하게 함
        // JSP에서 로그인 체크를 통해 투표 폼을 숨김
        
        return "voteDetail";
    }
    
    @PostMapping("/{id}/submit")
    public String submitVote(@PathVariable("id") Long id, 
                            @RequestParam("candidateId") Long candidateId,
                            HttpServletRequest request,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        // 로그인 체크
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "투표하려면 로그인이 필요합니다.");
            return "redirect:/login";
        }
        
        try {
            String ipAddress = getClientIpAddress(request);
            voteRecordService.saveVoteRecord(candidateId, userId, ipAddress);
            
            System.out.println("투표 제출 성공 - 투표 ID: " + id + ", 후보 ID: " + candidateId + ", 사용자 ID: " + userId);
            redirectAttributes.addFlashAttribute("message", "투표가 완료되었습니다!");
            return "redirect:/vote/" + id;
        } catch (Exception e) {
            // 이미 투표한 경우에도 선택한 후보를 표시하기 위해 리다이렉트
            System.out.println("투표 제출 오류: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/vote/" + id;
        }
    }
    
    @GetMapping("/{id}/result")
    public String voteResult(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<VoteTopic> voteTopicOpt = voteTopicService.getVoteTopicById(id);
        if (voteTopicOpt.isEmpty()) {
            return "redirect:/";
        }
        
        VoteTopic voteTopic = voteTopicOpt.get();
        
        // 마감 시간 체크 - 마감 시간이 지나지 않았으면 결과를 볼 수 없음
        if (voteTopic.getDeadline().isAfter(LocalDateTime.now()) && !"CLOSED".equals(voteTopic.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "투표가 아직 마감되지 않았습니다. 마감 시간 이후에 결과를 확인할 수 있습니다.");
            return "redirect:/vote/" + id;
        }
        
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicIdOrderByVoteCount(id);
        
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
        
        model.addAttribute("voteTopic", voteTopic);
        model.addAttribute("candidates", candidates);
        model.addAttribute("totalVotes", totalVotes);
        
        return "voteResult";
    }
    
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
}


