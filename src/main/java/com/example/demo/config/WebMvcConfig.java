package com.example.demo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Value("${app.upload.dir:./uploads/images}")
    private String uploadDir;
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 리소스 핸들러 제거 - ImageController가 직접 처리하도록 함
        // registry.addResourceHandler("/uploads/**")는 ImageController와 충돌할 수 있음
        System.out.println("리소스 핸들러 비활성화 - ImageController가 이미지 서빙을 처리합니다.");
    }
}

