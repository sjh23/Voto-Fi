package com.example.demo.admin;

import com.example.demo.user.User;
import com.example.demo.user.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/account")
public class AdminAccountController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/create")
    public String createAdminPage() {
        return "admin/createAdminAccount";
    }
    
    @PostMapping("/create")
    public String createAdmin(@RequestParam("username") String username,
                             @RequestParam("password") String password,
                             @RequestParam("email") String email,
                             RedirectAttributes redirectAttributes) {
        try {
            // 관리자 계정 생성
            User admin = userService.createAdminUser(username, password, email);
            redirectAttributes.addFlashAttribute("message", 
                "관리자 계정이 생성되었습니다. 이메일: " + email + ", 사용자명: " + username);
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/account/create";
        }
    }
}

