package com.example.demo.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    public User createUser(String username, String password, String email) {
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("이미 존재하는 사용자명입니다.");
        }
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("이미 존재하는 이메일입니다.");
        }
        
        User user = new User();
        user.setUsername(username);
        // 비밀번호 암호화
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRole("USER");
        
        return userRepository.save(user);
    }
    
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public boolean validateUser(String username, String password) {
        Optional<User> user = userRepository.findByUsername(username);
        if (user.isPresent()) {
            // BCrypt를 사용한 비밀번호 검증
            return passwordEncoder.matches(password, user.get().getPassword());
        }
        return false;
    }
    
    public boolean validateUserByEmail(String email, String password) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isPresent()) {
            // BCrypt를 사용한 비밀번호 검증
            return passwordEncoder.matches(password, user.get().getPassword());
        }
        return false;
    }
    
    public User createAdminUser(String username, String password, String email) {
        if (userRepository.existsByUsername(username)) {
            // 이미 존재하면 업데이트하지 않고 기존 사용자 반환
            return userRepository.findByUsername(username).orElse(null);
        }
        if (userRepository.existsByEmail(email)) {
            // 이미 존재하면 업데이트하지 않고 기존 사용자 반환
            return userRepository.findByEmail(email).orElse(null);
        }
        
        User user = new User();
        user.setUsername(username);
        // 비밀번호 암호화
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRole("ADMIN");
        
        return userRepository.save(user);
    }
    
    public boolean adminExists() {
        return userRepository.existsByRole("ADMIN");
    }
    
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }
}


