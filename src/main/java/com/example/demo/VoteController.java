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
    public String voteDetail(@PathVariable Long id, Model model, HttpSession session) {
        Optional<VoteTopic> voteTopicOpt = voteTopicService.getVoteTopicById(id);
        if (voteTopicOpt.isEmpty()) {
            return "redirect:/";
        }
        
        VoteTopic voteTopic = voteTopicOpt.get();
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
        
        model.addAttribute("voteTopic", voteTopic);
        model.addAttribute("candidates", candidates);
        model.addAttribute("loggedIn", session.getAttribute("userId") != null);
        
        return "voteDetail";
    }
    
    @PostMapping("/{id}/submit")
    public String submitVote(@PathVariable Long id, 
                            @RequestParam Long candidateId,
                            HttpServletRequest request,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        try {
            String ipAddress = getClientIpAddress(request);
            Long userId = (Long) session.getAttribute("userId");
            
            voteRecordService.saveVoteRecord(candidateId, userId, ipAddress);
            redirectAttributes.addFlashAttribute("message", "투표가 완료되었습니다!");
            return "redirect:/vote/" + id + "/result";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/vote/" + id;
        }
    }
    
    @GetMapping("/{id}/result")
    public String voteResult(@PathVariable Long id, Model model) {
        Optional<VoteTopic> voteTopicOpt = voteTopicService.getVoteTopicById(id);
        if (voteTopicOpt.isEmpty()) {
            return "redirect:/";
        }
        
        VoteTopic voteTopic = voteTopicOpt.get();
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

