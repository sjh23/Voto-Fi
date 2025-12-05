package com.example.demo.candidate;

import com.example.demo.file.FileUploadService;
import com.example.demo.votetopic.VoteTopic;
import com.example.demo.votetopic.VoteTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class CandidateService {
    
    @Autowired
    private CandidateRepository candidateRepository;
    
    @Autowired
    private VoteTopicRepository voteTopicRepository;
    
    @Autowired
    private FileUploadService fileUploadService;
    
    public Candidate createCandidate(Long voteTopicId, String name, String description, MultipartFile imageFile) throws IOException {
        VoteTopic voteTopic = voteTopicRepository.findById(voteTopicId)
            .orElseThrow(() -> new RuntimeException("투표 주제를 찾을 수 없습니다."));
        
        Candidate candidate = new Candidate();
        candidate.setVoteTopic(voteTopic);
        candidate.setName(name);
        candidate.setDescription(description);
        candidate.setVoteCount(0L);
        
        // 이미지 업로드
        if (imageFile != null && !imageFile.isEmpty()) {
            String imagePath = fileUploadService.saveImage(imageFile);
            candidate.setImagePath(imagePath);
        }
        
        return candidateRepository.save(candidate);
    }
    
    public List<Candidate> getCandidatesByVoteTopicId(Long voteTopicId) {
        return candidateRepository.findByVoteTopicId(voteTopicId);
    }
    
    public List<Candidate> getCandidatesByVoteTopicIdOrderByVoteCount(Long voteTopicId) {
        return candidateRepository.findByVoteTopicIdOrderByVoteCountDesc(voteTopicId);
    }
    
    public Optional<Candidate> getCandidateById(Long id) {
        return candidateRepository.findById(id);
    }
    
    public Candidate updateCandidate(Long id, String name, String description, MultipartFile imageFile) throws IOException {
        Candidate candidate = candidateRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        
        if (name != null) {
            candidate.setName(name);
        }
        if (description != null) {
            candidate.setDescription(description);
        }
        
        // 새 이미지가 업로드된 경우
        if (imageFile != null && !imageFile.isEmpty()) {
            // 기존 이미지 삭제
            if (candidate.getImagePath() != null) {
                fileUploadService.deleteImage(candidate.getImagePath());
            }
            // 새 이미지 저장
            String imagePath = fileUploadService.saveImage(imageFile);
            candidate.setImagePath(imagePath);
        }
        
        return candidateRepository.save(candidate);
    }
    
    public void deleteCandidate(Long id) {
        Candidate candidate = candidateRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        
        // 이미지 삭제
        if (candidate.getImagePath() != null) {
            fileUploadService.deleteImage(candidate.getImagePath());
        }
        
        candidateRepository.deleteById(id);
    }
    
    @Transactional
    public void incrementVoteCount(Long candidateId) {
        Candidate candidate = candidateRepository.findById(candidateId)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        candidate.setVoteCount(candidate.getVoteCount() + 1);
        candidateRepository.save(candidate);
    }
    
    @Transactional
    public void decrementVoteCount(Long candidateId) {
        Candidate candidate = candidateRepository.findById(candidateId)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        if (candidate.getVoteCount() > 0) {
            candidate.setVoteCount(candidate.getVoteCount() - 1);
            candidateRepository.save(candidate);
        }
    }
}


