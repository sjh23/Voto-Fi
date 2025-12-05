package com.example.demo;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateService;
import com.example.demo.user.UserService;
import com.example.demo.voterecord.VoteRecordService;
import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/")
public class MainController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private VoteRecordService voteRecordService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public String index(@RequestParam(value = "page", defaultValue = "0") int page,
                        @RequestParam(value = "search", required = false) String search,
                        Model model, HttpSession session) {
        // 페이지네이션: 한 페이지에 6개씩 표시
        Pageable pageable = PageRequest.of(page, 6);
        Page<VoteTopic> votePage = voteTopicService.getOngoingVoteTopics(search, pageable);
        
        // 각 투표의 총 투표수 계산하여 Map으로 전달
        Map<Long, Long> totalVotesMap = new HashMap<>();
        Map<Long, String> creatorRoleMap = new HashMap<>(); // 생성자 역할 맵
        for (VoteTopic vote : votePage.getContent()) {
            Long totalVotes = voteTopicService.getTotalVotesByTopicId(vote.getId());
            totalVotesMap.put(vote.getId(), totalVotes);
            // 기존 방식도 유지 (하위 호환성)
            model.addAttribute("totalVotes_" + vote.getId(), totalVotes);
            
            // 생성자 역할 확인
            if (vote.getCreatedBy() != null) {
                userService.findById(vote.getCreatedBy()).ifPresent(user -> {
                    creatorRoleMap.put(vote.getId(), user.getRole());
                });
            } else {
                // createdBy가 null이면 관리자가 만든 것으로 간주
                creatorRoleMap.put(vote.getId(), "ADMIN");
            }
        }
        
        model.addAttribute("totalVotesMap", totalVotesMap);
        model.addAttribute("creatorRoleMap", creatorRoleMap);
        model.addAttribute("votes", votePage.getContent());
        model.addAttribute("votePage", votePage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", votePage.getTotalPages());
        model.addAttribute("searchKeyword", search);
        model.addAttribute("loggedIn", session.getAttribute("userId") != null);
        model.addAttribute("username", session.getAttribute("username"));
        
        // 내가 만든 투표 목록 추가
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            List<VoteTopic> myVotes = voteTopicService.getVoteTopicsByCreatedBy(userId);
            model.addAttribute("myVotes", myVotes);
        }
        
        return "index";
    }
    
    @GetMapping("/closed")
    public String closedVotes(@RequestParam(value = "page", defaultValue = "0") int page,
                             @RequestParam(value = "search", required = false) String search,
                             Model model, HttpSession session) {
        // 페이지네이션: 한 페이지에 6개씩 표시
        Pageable pageable = PageRequest.of(page, 6);
        Page<VoteTopic> votePage = voteTopicService.getClosedVoteTopics(search, pageable);
        
        // 생성자 역할 맵 생성
        Map<Long, String> creatorRoleMap = new HashMap<>();
        for (VoteTopic vote : votePage.getContent()) {
            if (vote.getCreatedBy() != null) {
                userService.findById(vote.getCreatedBy()).ifPresent(user -> {
                    creatorRoleMap.put(vote.getId(), user.getRole());
                });
            } else {
                // createdBy가 null이면 관리자가 만든 것으로 간주
                creatorRoleMap.put(vote.getId(), "ADMIN");
            }
        }
        
        model.addAttribute("creatorRoleMap", creatorRoleMap);
        model.addAttribute("votes", votePage.getContent());
        model.addAttribute("votePage", votePage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", votePage.getTotalPages());
        model.addAttribute("searchKeyword", search);
        model.addAttribute("loggedIn", session.getAttribute("userId") != null);
        model.addAttribute("username", session.getAttribute("username"));
        return "closed";
    }
    
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }
    
    @GetMapping("/vote/create")
    public String createVotePage(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        return "createVote";
    }
    
    @PostMapping("/vote/create")
    public String createVote(@RequestParam("title") String title,
                            @RequestParam("description") String description,
                            @RequestParam("deadline") String deadline,
                            @RequestParam(value = "candidateNames", required = false) String[] candidateNames,
                            @RequestParam(value = "candidateDescriptions", required = false) String[] candidateDescriptions,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        try {
            Long userId = (Long) session.getAttribute("userId");
            String role = (String) session.getAttribute("role");
            
            // 역할 정보 확인 및 기본값 설정
            if (role == null) {
                role = "USER"; // 기본값
                session.setAttribute("role", role);
            }
            boolean isAdmin = "ADMIN".equals(role);
            
            System.out.println("투표 생성 - 사용자 ID: " + userId + ", 역할: " + role + ", 관리자 여부: " + isAdmin);
            
            LocalDateTime deadlineDate = LocalDateTime.parse(deadline);
            VoteTopic voteTopic = voteTopicService.createVoteTopic(title, description, deadlineDate, userId, isAdmin);
            
            System.out.println("생성된 투표 ID: " + voteTopic.getId() + ", 상태: " + voteTopic.getStatus());
            
            // 후보자 추가 (이미지 없이)
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
            
            // 관리자는 즉시 활성화, 일반 사용자는 승인 대기 메시지
            if (isAdmin) {
                redirectAttributes.addFlashAttribute("message", "투표가 생성되었습니다. 이제 후보자 이미지를 추가할 수 있습니다.");
                return "redirect:/vote/" + voteTopic.getId() + "/add-images";
            } else {
                redirectAttributes.addFlashAttribute("message", "투표가 생성되었습니다. 관리자 승인 후 활성화됩니다. 이제 후보자 이미지를 추가할 수 있습니다.");
                return "redirect:/vote/" + voteTopic.getId() + "/add-images";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/vote/create";
        }
    }
    
    @GetMapping("/vote/{id}/add-images")
    public String addImagesPage(@PathVariable("id") Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        VoteTopic voteTopic = voteTopicService.getVoteTopicById(id)
            .orElseThrow(() -> new RuntimeException("투표를 찾을 수 없습니다."));
        
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
        
        // 디버깅: 후보자 이미지 경로 확인
        for (Candidate candidate : candidates) {
            System.out.println("후보자 ID: " + candidate.getId() + ", 이름: " + candidate.getName() + ", 이미지 경로: " + candidate.getImagePath());
        }
        
        model.addAttribute("voteTopic", voteTopic);
        model.addAttribute("candidates", candidates);
        
        return "addCandidateImages";
    }
    
    @PostMapping("/vote/{voteId}/candidate/{candidateId}/add-image")
    public String addCandidateImage(@PathVariable("voteId") Long voteId,
                                   @PathVariable("candidateId") Long candidateId,
                                   @RequestParam("imageFile") MultipartFile imageFile,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        try {
            if (imageFile == null || imageFile.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "이미지 파일을 선택해주세요.");
                return "redirect:/vote/" + voteId + "/add-images";
            }
            
            candidateService.updateCandidate(candidateId, null, null, imageFile);
            redirectAttributes.addFlashAttribute("message", "이미지가 추가되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "이미지 추가 실패: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 캐시 방지를 위해 타임스탬프 추가
        return "redirect:/vote/" + voteId + "/add-images?t=" + System.currentTimeMillis();
    }
    
    @GetMapping("/my-votes")
    public String myVotesPage(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        Long userId = (Long) session.getAttribute("userId");
        List<VoteTopic> myVotes = voteTopicService.getVoteTopicsByCreatedBy(userId);
        
        // 각 투표의 총 투표수 계산
        Map<Long, Long> totalVotesMap = new HashMap<>();
        for (VoteTopic vote : myVotes) {
            Long totalVotes = voteTopicService.getTotalVotesByTopicId(vote.getId());
            totalVotesMap.put(vote.getId(), totalVotes);
        }
        
        model.addAttribute("myVotes", myVotes);
        model.addAttribute("totalVotesMap", totalVotesMap);
        model.addAttribute("loggedIn", true);
        model.addAttribute("username", session.getAttribute("username"));
        
        return "myVotes";
    }
    
    @GetMapping("/vote/{id}/edit")
    public String editVotePage(@PathVariable("id") Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        Long userId = (Long) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        boolean isAdmin = "ADMIN".equals(role);
        
        VoteTopic voteTopic = voteTopicService.getVoteTopicById(id)
            .orElseThrow(() -> new RuntimeException("투표를 찾을 수 없습니다."));
        
        // 권한 체크: 관리자이거나 자신이 만든 투표만 수정 가능
        if (!isAdmin && (voteTopic.getCreatedBy() == null || !voteTopic.getCreatedBy().equals(userId))) {
            redirectAttributes.addFlashAttribute("error", "수정 권한이 없습니다.");
            return "redirect:/my-votes";
        }
        
        List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
        model.addAttribute("voteTopic", voteTopic);
        model.addAttribute("candidates", candidates);
        return "editVote";
    }
    
    @PostMapping("/vote/{id}/edit")
    public String updateVote(@PathVariable("id") Long id,
                           @RequestParam("title") String title,
                           @RequestParam("description") String description,
                           @RequestParam("deadline") String deadline,
                           @RequestParam(value = "existingCandidateIds", required = false) Long[] existingCandidateIds,
                           @RequestParam(value = "existingCandidateNames", required = false) String[] existingCandidateNames,
                           @RequestParam(value = "existingCandidateDescriptions", required = false) String[] existingCandidateDescriptions,
                           @RequestParam(value = "candidateNames", required = false) String[] candidateNames,
                           @RequestParam(value = "candidateDescriptions", required = false) String[] candidateDescriptions,
                           @RequestParam(value = "deleteCandidateIds", required = false) Long[] deleteCandidateIds,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        Long userId = (Long) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        boolean isAdmin = "ADMIN".equals(role);
        
        try {
            VoteTopic voteTopic = voteTopicService.getVoteTopicById(id)
                .orElseThrow(() -> new RuntimeException("투표를 찾을 수 없습니다."));
            
            // 권한 체크
            if (!isAdmin && (voteTopic.getCreatedBy() == null || !voteTopic.getCreatedBy().equals(userId))) {
                redirectAttributes.addFlashAttribute("error", "수정 권한이 없습니다.");
                return "redirect:/my-votes";
            }
            
            LocalDateTime deadlineDate = LocalDateTime.parse(deadline);
            voteTopicService.updateVoteTopic(id, title, description, deadlineDate);
            
            // 기존 후보자 삭제
            if (deleteCandidateIds != null) {
                for (Long candidateId : deleteCandidateIds) {
                    candidateService.deleteCandidate(candidateId);
                }
            }
            
            // 기존 후보자 수정
            if (existingCandidateIds != null && existingCandidateNames != null) {
                for (int i = 0; i < existingCandidateIds.length; i++) {
                    if (i < existingCandidateNames.length) {
                        String name = existingCandidateNames[i].trim();
                        String desc = (existingCandidateDescriptions != null && i < existingCandidateDescriptions.length)
                            ? existingCandidateDescriptions[i].trim() : "";
                        candidateService.updateCandidate(existingCandidateIds[i], name, desc, null);
                    }
                }
            }
            
            // 새 후보자 추가
            if (candidateNames != null && candidateNames.length > 0) {
                for (int i = 0; i < candidateNames.length; i++) {
                    String name = candidateNames[i].trim();
                    if (!name.isEmpty()) {
                        String desc = (candidateDescriptions != null && i < candidateDescriptions.length)
                            ? candidateDescriptions[i].trim() : "";
                        candidateService.createCandidate(id, name, desc, null);
                    }
                }
            }
            
            redirectAttributes.addFlashAttribute("message", "투표가 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/my-votes";
    }
    
    @PostMapping("/vote/{id}/delete")
    public String deleteVote(@PathVariable("id") Long id,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        
        Long userId = (Long) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        boolean isAdmin = "ADMIN".equals(role);
        
        try {
            VoteTopic voteTopic = voteTopicService.getVoteTopicById(id)
                .orElseThrow(() -> new RuntimeException("투표를 찾을 수 없습니다."));
            
            // 권한 체크
            if (!isAdmin && (voteTopic.getCreatedBy() == null || !voteTopic.getCreatedBy().equals(userId))) {
                redirectAttributes.addFlashAttribute("error", "삭제 권한이 없습니다.");
                return "redirect:/my-votes";
            }
            
            // 관련 투표 기록 먼저 삭제
            voteRecordService.deleteVoteRecordsByVoteTopicId(id);
            
            // 관련 후보자 삭제
            List<Candidate> candidates = candidateService.getCandidatesByVoteTopicId(id);
            for (Candidate candidate : candidates) {
                candidateService.deleteCandidate(candidate.getId());
            }
            
            // 투표 주제 삭제
            voteTopicService.deleteVoteTopic(id);
            redirectAttributes.addFlashAttribute("message", "투표가 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "삭제 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/my-votes";
    }
}


