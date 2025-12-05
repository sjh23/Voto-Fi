package com.example.demo.file;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileUploadService {
    
    @Value("${app.upload.dir:./uploads/images}")
    private String uploadDir;
    
    public String saveImage(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        // 업로드 디렉토리 생성
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // 원본 파일명에서 확장자 추출
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        
        // UUID를 사용한 고유한 파일명 생성
        String filename = UUID.randomUUID().toString() + extension;
        Path filePath = uploadPath.resolve(filename);
        
        // 파일 저장
        Files.copy(file.getInputStream(), filePath);
        
        // 저장된 파일 경로 확인
        System.out.println("이미지 저장됨: " + filePath.toAbsolutePath().toString());
        System.out.println("웹 접근 경로: /uploads/images/" + filename);
        
        // 웹에서 접근 가능한 경로 반환
        return "/uploads/images/" + filename;
    }
    
    public void deleteImage(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return;
        }
        
        try {
            // /uploads/images/filename 형식에서 filename 추출
            String filename = imagePath.substring(imagePath.lastIndexOf("/") + 1);
            Path filePath = Paths.get(uploadDir, filename);
            
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (IOException e) {
            System.err.println("이미지 삭제 실패: " + e.getMessage());
        }
    }
}

