package com.example.demo.voterecord;

import com.example.demo.candidate.Candidate;
import com.example.demo.candidate.CandidateRepository;
import com.example.demo.candidate.CandidateService;
import com.example.demo.user.User;
import com.example.demo.user.UserRepository;
import com.example.demo.websocket.VoteUpdateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class VoteRecordService {
    
    @Autowired
    private VoteRecordRepository voteRecordRepository;
    
    @Autowired
    private CandidateRepository candidateRepository;
    
    @Autowired
    private CandidateService candidateService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private VoteUpdateService voteUpdateService;
    
    @Transactional
    public VoteRecord saveVoteRecord(Long candidateId, Long userId, String ipAddress) {
        Candidate candidate = candidateRepository.findById(candidateId)
            .orElseThrow(() -> new RuntimeException("후보를 찾을 수 없습니다."));
        
        Long voteTopicId = candidate.getVoteTopic().getId();
        
        // IP 기반 중복 투표 방지
        if (voteRecordRepository.existsByIpAddressAndCandidate_VoteTopicId(ipAddress, voteTopicId)) {
            throw new RuntimeException("이미 해당 투표에 참여하셨습니다.");
        }
        
        // 사용자 기반 중복 투표 방지 (로그인한 경우)
        if (userId != null && voteRecordRepository.existsByUserIdAndCandidate_VoteTopicId(userId, voteTopicId)) {
            throw new RuntimeException("이미 해당 투표에 참여하셨습니다.");
        }
        
        VoteRecord voteRecord = new VoteRecord();
        voteRecord.setCandidate(candidate);
        if (userId != null) {
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
            voteRecord.setUser(user);
        }
        voteRecord.setIpAddress(ipAddress);
        
        VoteRecord saved = voteRecordRepository.save(voteRecord);
        
        // 후보의 득표수 증가
        candidateService.incrementVoteCount(candidateId);
        
        // WebSocket으로 실시간 업데이트 브로드캐스트
        voteUpdateService.broadcastVoteUpdate(voteTopicId);
        
        return saved;
    }
    
    public List<VoteRecord> getAllVoteRecords() {
        return voteRecordRepository.findAll();
    }
    
    public List<VoteRecord> getVoteRecordsByVoteTopicId(Long voteTopicId) {
        return voteRecordRepository.findByCandidate_VoteTopicId(voteTopicId);
    }
    
    public Optional<VoteRecord> getVoteRecordById(Long id) {
        return voteRecordRepository.findById(id);
    }
    
    @Transactional
    public void deleteVoteRecord(Long id) {
        // 투표 기록 조회
        VoteRecord voteRecord = voteRecordRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("투표 기록을 찾을 수 없습니다."));
        
        // 관련 후보의 voteCount 감소
        Long candidateId = voteRecord.getCandidate().getId();
        Long voteTopicId = voteRecord.getCandidate().getVoteTopic().getId();
        candidateService.decrementVoteCount(candidateId);
        
        // 투표 기록 삭제
        voteRecordRepository.deleteById(id);
        
        // WebSocket으로 실시간 업데이트 브로드캐스트
        voteUpdateService.broadcastVoteUpdate(voteTopicId);
    }
    
    @Transactional
    public void deleteVoteRecordsByVoteTopicId(Long voteTopicId) {
        List<VoteRecord> records = voteRecordRepository.findByCandidate_VoteTopicId(voteTopicId);

        // 각 투표 기록의 후보 voteCount 감소
        for (VoteRecord record : records) {
            Long candidateId = record.getCandidate().getId();
            candidateService.decrementVoteCount(candidateId);
        }

        // 투표 기록 삭제
        voteRecordRepository.deleteAll(records);
    }
    
    public Long getSelectedCandidateIdByUserAndVoteTopic(Long userId, Long voteTopicId) {
        Optional<VoteRecord> voteRecord = voteRecordRepository.findByUserIdAndCandidate_VoteTopicId(userId, voteTopicId);
        if (voteRecord.isPresent()) {
            return voteRecord.get().getCandidate().getId();
        }
        return null;
    }
}


