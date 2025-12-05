package com.example.demo.admin;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateService;
import com.example.demo.user.User;
import com.example.demo.user.UserService;
import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import com.example.demo.voterecord.VoteRecord;
import com.example.demo.voterecord.VoteRecordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminViewController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    @Autowired
    private UserService userService;
    
    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return "ADMIN".equals(role);
    }
    
    @GetMapping
    public String adminMain(@RequestParam(value = "page", defaultValue = "0") int page,
                           @RequestParam(value = "search", required = false) String search,
                           HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        // 페이지네이션: 한 페이지에 7개씩 표시
        Pageable pageable = PageRequest.of(page, 7);
        Page<VoteTopic> topicPage = voteTopicService.getAllVoteTopics(search, pageable);
        
        List<VoteTopic> pendingTopics = voteTopicService.getPendingVoteTopics();
        
        // 전체 통계 계산 (페이지네이션과 무관하게 전체 데이터 기준)
        long totalTopics = voteTopicService.getAllVoteTopics().size();
        long ongoingTopics = voteTopicService.getOngoingVoteTopics().size();
        
        // 전체 투표 주제에 대한 총 투표 수 계산
        long totalVotes = 0;
        List<VoteTopic> allTopics = voteTopicService.getAllVoteTopics();
        for (VoteTopic topic : allTopics) {
            totalVotes += voteTopicService.getTotalVotesByTopicId(topic.getId());
        }
        
        // 각 투표의 총 투표수 계산하여 모델에 추가
        for (VoteTopic topic : topicPage.getContent()) {
            Long topicTotalVotes = voteTopicService.getTotalVotesByTopicId(topic.getId());
            model.addAttribute("totalVotes_" + topic.getId(), topicTotalVotes);
        }
        
        // 생성자 정보 맵 생성 (승인 대기 중인 투표용)
        Map<Long, String> creatorMap = new HashMap<>();
        for (VoteTopic topic : pendingTopics) {
            if (topic.getCreatedBy() != null) {
                userService.findById(topic.getCreatedBy()).ifPresent(user -> {
                    creatorMap.put(topic.getId(), user.getUsername());
                });
            }
        }
        
        // 모든 투표 주제에 대한 생성자 정보 및 관리자 여부 맵 생성
        Map<Long, String> allCreatorMap = new HashMap<>();
        Map<Long, String> creatorRoleMap = new HashMap<>(); // 역할을 저장하는 맵으로 변경
        for (VoteTopic topic : topicPage.getContent()) {
            if (topic.getCreatedBy() != null) {
                userService.findById(topic.getCreatedBy()).ifPresent(user -> {
                    allCreatorMap.put(topic.getId(), user.getUsername());
                    String role = user.getRole();
                    creatorRoleMap.put(topic.getId(), role); // 역할 저장
                    System.out.println("투표 ID: " + topic.getId() + ", 생성자: " + user.getUsername() + ", 역할: " + role);
                });
            } else {
                // createdBy가 null이면 관리자가 만든 것으로 간주
                creatorRoleMap.put(topic.getId(), "ADMIN");
                System.out.println("투표 ID: " + topic.getId() + ", createdBy가 null - 관리자로 설정");
            }
        }
        
        model.addAttribute("topics", topicPage.getContent());
        model.addAttribute("topicPage", topicPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", topicPage.getTotalPages());
        model.addAttribute("searchKeyword", search);
        model.addAttribute("pendingTopics", pendingTopics);
        model.addAttribute("creatorMap", creatorMap);
        model.addAttribute("allCreatorMap", allCreatorMap);
        model.addAttribute("creatorRoleMap", creatorRoleMap);
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
    public String createTopic(@RequestParam("title") String title,
                              @RequestParam("description") String description,
                              @RequestParam("deadline") String deadline,
                              @RequestParam(value = "candidateNames", required = false) String[] candidateNames,
                              @RequestParam(value = "candidateDescriptions", required = false) String[] candidateDescriptions,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            Long userId = (Long) session.getAttribute("userId");
            LocalDateTime deadlineDate = LocalDateTime.parse(deadline);
            // 관리자는 즉시 ONGOING 상태로 생성
            VoteTopic voteTopic = voteTopicService.createVoteTopic(title, description, deadlineDate, userId, true);
            
            // 후보자 추가
            if (candidateNames != null && candidateNames.length > 0) {
                for (int i = 0; i < candidateNames.length; i++) {
                    String name = candidateNames[i].trim();
                    if (!name.isEmpty()) {
                        String desc = (candidateDescriptions != null && i < candidateDescriptions.length)
                            ? candidateDescriptions[i].trim() : "";
                        candidateService.createCandidate(voteTopic.getId(), name, desc, null);
                    }
                }
            }
            
            redirectAttributes.addFlashAttribute("message", "투표 주제가 생성되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/admin";
    }
    
    @GetMapping("/topic/{id}/edit")
    public String editTopicPage(@PathVariable("id") Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        VoteTopic topic = voteTopicService.getVoteTopicById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        model.addAttribute("topic", topic);
        return "admin/editTopic";
    }
    
    @PostMapping("/topic/{id}/edit")
    public String updateTopic(@PathVariable("id") Long id,
                             @RequestParam("title") String title,
                             @RequestParam("description") String description,
                             @RequestParam("deadline") String deadline,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            // datetime-local 형식 파싱 (T로 구분된 형식)
            LocalDateTime deadlineDate;
            if (deadline.contains("T")) {
                deadlineDate = LocalDateTime.parse(deadline);
            } else {
                // 공백으로 구분된 형식인 경우
                deadlineDate = LocalDateTime.parse(deadline.replace(" ", "T"));
            }
            voteTopicService.updateVoteTopic(id, title, description, deadlineDate);
            redirectAttributes.addFlashAttribute("message", "투표 주제가 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "수정 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/admin";
    }
    
    @PostMapping("/topic/{id}/delete")
    public String deleteTopic(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            // 투표 주제 존재 확인
            VoteTopic topic = voteTopicService.getVoteTopicById(id)
                .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
            
            // 관련 투표 기록 먼저 삭제
            try {
                voteRecordService.deleteVoteRecordsByVoteTopicId(id);
            } catch (Exception e) {
                System.out.println("투표 기록 삭제 중 오류 (무시): " + e.getMessage());
            }
            
            // 관련 후보자 삭제
            try {
                List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
                for (Candidate candidate : candidates) {
                    try {
                        candidateService.deleteCandidate(candidate.getId());
                    } catch (Exception e) {
                        System.out.println("후보자 삭제 중 오류 (무시): " + candidate.getId() + " - " + e.getMessage());
                    }
                }
            } catch (Exception e) {
                System.out.println("후보자 목록 조회 중 오류 (무시): " + e.getMessage());
            }
            
            // 투표 주제 삭제
            voteTopicService.deleteVoteTopic(id);
            redirectAttributes.addFlashAttribute("message", "투표 주제가 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "삭제 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/admin";
    }
    
    @GetMapping("/candidate")
    public String candidateManagement(@RequestParam(value = "topicId", required = false) Long topicId, 
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
    public String createCandidatePage(@RequestParam("topicId") Long topicId, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        VoteTopic topic = voteTopicService.getVoteTopicById(topicId)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        model.addAttribute("selectedTopicTitle", topic.getTitle());
        return "admin/candidate/create";
    }
    
    @PostMapping("/candidate/create")
    public String createCandidate(@RequestParam("voteTopicId") Long voteTopicId,
                                 @RequestParam("name") String name,
                                 @RequestParam("description") String description,
                                 @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            candidateService.createCandidate(voteTopicId, name, description, imageFile);
            redirectAttributes.addFlashAttribute("message", "후보가 등록되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/candidate?topicId=" + voteTopicId;
    }
    
    @GetMapping("/candidate/{id}/edit")
    public String editCandidatePage(@PathVariable("id") Long id,
                                   @RequestParam("topicId") Long topicId,
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
    public String updateCandidate(@PathVariable("id") Long id,
                                 @RequestParam("topicId") Long topicId,
                                 @RequestParam("name") String name,
                                 @RequestParam("description") String description,
                                 @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            candidateService.updateCandidate(id, name, description, imageFile);
            redirectAttributes.addFlashAttribute("message", "후보가 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin/candidate?topicId=" + topicId;
    }
    
    @PostMapping("/candidate/{id}/delete")
    public String deleteCandidate(@PathVariable("id") Long id,
                                 @RequestParam("topicId") Long topicId,
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
    public String voteRecords(@RequestParam(value = "topicId", required = false) Long topicId,
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
    public String deleteRecord(@PathVariable("id") Long id,
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
    
    @PostMapping("/topic/{id}/approve")
    public String approveTopic(@PathVariable("id") Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            voteTopicService.changeStatus(id, "ONGOING");
            redirectAttributes.addFlashAttribute("message", "투표가 승인되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/admin";
    }
    
    @GetMapping("/topic/{id}/reject")
    public String rejectTopicPage(@PathVariable("id") Long id,
                                  HttpSession session,
                                  Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        VoteTopic topic = voteTopicService.getVoteTopicById(id)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        model.addAttribute("topic", topic);
        return "admin/rejectTopic";
    }
    
    @PostMapping("/topic/{id}/reject")
    public String rejectTopic(@PathVariable("id") Long id,
                             @RequestParam("rejectReason") String rejectReason,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        try {
            // 투표 주제 가져오기
            VoteTopic topic = voteTopicService.getVoteTopicById(id)
                .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
            
            // 거부 사유 저장하고 REJECTED 상태로 변경 (삭제하지 않음 - 사용자가 거부 사유를 볼 수 있도록)
            voteTopicService.updateVoteTopicWithRejectReason(id, rejectReason);
            
            redirectAttributes.addFlashAttribute("message", "투표가 거부되었습니다. 거부 사유: " + rejectReason);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "거부 처리 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/admin";
    }
}


