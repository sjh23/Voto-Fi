package com.example.demo.config;

import jakarta.servlet.MultipartConfigElement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

@Configuration
public class MultipartConfig {

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        // 파일 크기: 10MB, 요청 크기: 100MB, 임계값: 1MB
        // 위치: "", 최대 파일 크기: 10MB, 최대 요청 크기: 100MB
        return new MultipartConfigElement("", 10 * 1024 * 1024L, 100 * 1024 * 1024L, 1 * 1024 * 1024);
    }

    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
}

