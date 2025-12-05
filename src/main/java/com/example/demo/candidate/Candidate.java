package com.example.demo.candidate;

import com.example.demo.votetopic.VoteTopic;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Candidate {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "vote_topic_id", nullable = false)
    private VoteTopic voteTopic;
    
    @Column(nullable = false)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Long voteCount = 0L;
    
    @Column(name = "image_path")
    private String imagePath;
    
    @Transient
    private Double votePercentage;
}


