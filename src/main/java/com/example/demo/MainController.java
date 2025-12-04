package com.example.demo;

import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/")
public class MainController {
    
    @Autowired
    private VoteTopicService voteTopicService;
    
    @GetMapping
    public String index(Model model, HttpSession session) {
        List<VoteTopic> ongoingVotes = voteTopicService.getOngoingVoteTopics();
        // 각 투표의 총 투표수 계산하여 모델에 추가
        for (VoteTopic vote : ongoingVotes) {
            Long totalVotes = voteTopicService.getTotalVotesByTopicId(vote.getId());
            model.addAttribute("totalVotes_" + vote.getId(), totalVotes);
        }
        model.addAttribute("votes", ongoingVotes);
        model.addAttribute("loggedIn", session.getAttribute("userId") != null);
        model.addAttribute("username", session.getAttribute("username"));
        return "index";
    }
    
    @GetMapping("/closed")
    public String closedVotes(Model model, HttpSession session) {
        List<VoteTopic> closedVotes = voteTopicService.getClosedVoteTopics();
        model.addAttribute("votes", closedVotes);
        model.addAttribute("loggedIn", session.getAttribute("userId") != null);
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
}

