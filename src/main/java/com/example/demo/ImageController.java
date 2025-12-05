package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/uploads")
public class ImageController {
    
    @Value("${app.upload.dir:uploads/images}")
    private String uploadDir;
    
    public ImageController() {
        System.out.println("ImageController 초기화됨");
    }
    
    @GetMapping("/images/{filename:.+}")
    public ResponseEntity<Resource> getImage(@PathVariable("filename") String filename) {
        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Path filePath = uploadPath.resolve(filename).normalize();
            
            System.out.println("이미지 요청:");
            System.out.println("  파일명: " + filename);
            System.out.println("  업로드 디렉토리: " + uploadPath.toString());
            System.out.println("  파일 경로: " + filePath.toString());
            System.out.println("  파일 존재: " + filePath.toFile().exists());
            
            // 보안: 상위 디렉토리 접근 방지
            if (!filePath.startsWith(uploadPath)) {
                System.out.println("  보안 오류: 상위 디렉토리 접근 시도");
                return ResponseEntity.notFound().build();
            }
            
            File file = filePath.toFile();
            if (!file.exists()) {
                System.out.println("  파일을 찾을 수 없음: " + filePath.toString());
                return ResponseEntity.notFound().build();
            }
            
            if (!file.isFile()) {
                System.out.println("  파일이 아님: " + filePath.toString());
                return ResponseEntity.notFound().build();
            }
            
            Resource resource = new FileSystemResource(file);
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                // 확장자 기반으로 Content-Type 추정
                String lowerFilename = filename.toLowerCase();
                if (lowerFilename.endsWith(".png")) {
                    contentType = "image/png";
                } else if (lowerFilename.endsWith(".jpg") || lowerFilename.endsWith(".jpeg")) {
                    contentType = "image/jpeg";
                } else if (lowerFilename.endsWith(".gif")) {
                    contentType = "image/gif";
                } else {
                    contentType = "application/octet-stream";
                }
            }
            
            System.out.println("  Content-Type: " + contentType);
            System.out.println("  파일 크기: " + file.length() + " bytes");
            
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
                    .body(resource);
        } catch (Exception e) {
            System.err.println("이미지 로드 오류: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
}

