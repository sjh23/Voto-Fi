package com.example.demo.admin;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateService;
import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import com.example.demo.voterecord.VoteRecord;
import com.example.demo.voterecord.VoteRecordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminViewController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
    
    @GetMapping
    public String adminMain(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<VoteTopic> allTopics = voteTopicService.getAllVoteTopics();
        long totalTopics = allTopics.size();
        long ongoingTopics = allTopics.stream().filter(t -> "ONGOING".equals(t.getStatus())).count();
        long totalVotes = allTopics.stream()
            .mapToLong(t -> voteTopicService.getTotalVotesByTopicId(t.getId()))
            .sum();
        
        // 각 투표의 총 투표수 계산하여 모델에 추가
        for (VoteTopic topic : allTopics) {
            Long topicTotalVotes = voteTopicService.getTotalVotesByTopicId(topic.getId());
            model.addAttribute("totalVotes_" + topic.getId(), topicTotalVotes);
        }
        
        model.addAttribute("topics", allTopics);
        model.addAttribute("totalTopics", totalTopics);
        model.addAttribute("ongoingTopics", ongoingTopics);
        model.addAttribute("totalVotes", totalVotes);
        
        return "admin/main";
    }
    
    @GetMapping("/topic/create")
    public String createTopicPage(HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        return "admin/createTopic";
    }
    
    @PostMapping("/topic/create")
    public String createTopic(@RequestParam String title,
                              @RequestParam String description,
                              @RequestParam String deadline,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            LocalDateTime deadlineDate = LocalDateTime.parse(deadline);
            voteTopicService.createVoteTopic(title, description, deadlineDate);
            redirectAttributes.addFlashAttribute("message", "투표 주제가 생성되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin";
    }
    
    @GetMapping("/topic/{id}/edit")
    public String editTopicPage(@PathVariable Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        VoteTopic topic = voteTopicService.getVoteTopicById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        model.addAttribute("topic", topic);
        return "admin/editTopic";
    }
    
    @PostMapping("/topic/{id}/edit")
    public String updateTopic(@PathVariable Long id,
                             @RequestParam String title,
                             @RequestParam String description,
                             @RequestParam String deadline,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            LocalDateTime deadlineDate = LocalDateTime.parse(deadline);
            voteTopicService.updateVoteTopic(id, title, description, deadlineDate);
            redirectAttributes.addFlashAttribute("message", "투표 주제가 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin";
    }
    
    @PostMapping("/topic/{id}/delete")
    public String deleteTopic(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            voteTopicService.deleteVoteTopic(id);
            redirectAttributes.addFlashAttribute("message", "투표 주제가 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin";
    }
    
    @GetMapping("/candidate")
    public String candidateManagement(@RequestParam(required = false) Long topicId, 
                                     HttpSession session, 
                                     Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<VoteTopic> allTopics = voteTopicService.getAllVoteTopics();
        model.addAttribute("allTopics", allTopics);
        
        if (topicId != null) {
            List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(topicId);
            model.addAttribute("selectedTopicId", topicId);
            model.addAttribute("candidates", candidates);
        }
        
        return "admin/candidate";
    }
    
    @GetMapping("/candidate/create")
    public String createCandidatePage(@RequestParam Long topicId, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        VoteTopic topic = voteTopicService.getVoteTopicById(topicId)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        model.addAttribute("selectedTopicTitle", topic.getTitle());
        return "admin/candidate/create";
    }
    
    @PostMapping("/candidate/create")
    public String createCandidate(@RequestParam Long voteTopicId,
                                 @RequestParam String name,
                                 @RequestParam String description,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            candidateService.createCandidate(voteTopicId, name, description);
            redirectAttributes.addFlashAttribute("message", "후보가 등록되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/candidate?topicId=" + voteTopicId;
    }
    
    @GetMapping("/candidate/{id}/edit")
    public String editCandidatePage(@PathVariable Long id,
                                   @RequestParam Long topicId,
                                   HttpSession session,
                                   Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Candidate candidate = candidateService.getCandidateById(id)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        model.addAttribute("candidate", candidate);
        return "admin/candidate/edit";
    }
    
    @PostMapping("/candidate/{id}/edit")
    public String updateCandidate(@PathVariable Long id,
                                 @RequestParam Long topicId,
                                 @RequestParam String name,
                                 @RequestParam String description,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            candidateService.updateCandidate(id, name, description);
            redirectAttributes.addFlashAttribute("message", "후보가 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/candidate?topicId=" + topicId;
    }
    
    @PostMapping("/candidate/{id}/delete")
    public String deleteCandidate(@PathVariable Long id,
                                 @RequestParam Long topicId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            candidateService.deleteCandidate(id);
            redirectAttributes.addFlashAttribute("message", "후보가 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/candidate?topicId=" + topicId;
    }
    
    @GetMapping("/records")
    public String voteRecords(@RequestParam(required = false) Long topicId,
                             HttpSession session,
                             Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<VoteRecord> records;
        if (topicId != null) {
            records = voteRecordService.getVoteRecordsByVoteTopicId(topicId);
        } else {
            records = voteRecordService.getAllVoteRecords();
        }
        
        List<VoteTopic> allTopics = voteTopicService.getAllVoteTopics();
        model.addAttribute("records", records);
        model.addAttribute("allTopics", allTopics);
        model.addAttribute("selectedTopicId", topicId);
        
        return "admin/records";
    }
    
    @PostMapping("/records/{id}/delete")
    public String deleteRecord(@PathVariable Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            voteRecordService.deleteVoteRecord(id);
            redirectAttributes.addFlashAttribute("message", "투표 기록이 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/records";
    }
}

