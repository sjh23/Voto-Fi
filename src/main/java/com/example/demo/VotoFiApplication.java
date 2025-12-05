package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class VotoFiApplication {

	public static void main(String[] args) {
		// Tomcat의 파일/파라미터 개수 제한을 늘리기 위한 시스템 속성 설정
		// 기본값은 10개인데, 이를 1000개로 증가시킴
		System.setProperty("org.apache.tomcat.util.http.Parameters.MAX_COUNT", "1000");
		System.setProperty("org.apache.tomcat.util.http.Parameters.MAX_COUNT_POST", "1000");
		
		SpringApplication.run(VotoFiApplication.class, args);
	}

}
