package com.example.demo.votetopic;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
public class VoteTopic {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(nullable = false)
    private LocalDateTime deadline;
    
    @Column(nullable = false)
    private String status; // PENDING, ONGOING, CLOSED, REJECTED
    
    @Column(name = "created_by")
    private Long createdBy; // 투표를 생성한 사용자 ID (null이면 관리자가 생성)
    
    @Column(columnDefinition = "TEXT")
    private String rejectReason; // 거부 사유
    
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        // status는 Service에서 명시적으로 설정하므로 여기서는 절대 변경하지 않음
        // @PrePersist는 저장 전에 실행되므로, 이미 설정된 status를 유지해야 함
    }
}


