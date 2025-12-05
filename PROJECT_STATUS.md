# Voto-Fi 프로젝트 진행 상황

## 프로젝트 개요
Voto-Fi는 Spring Boot 기반의 온라인 투표 시스템입니다. 사용자와 관리자 역할을 구분하여 투표를 생성하고 관리할 수 있습니다.

## 주요 기능

### 1. 사용자 기능
- **회원가입/로그인**: 이메일과 비밀번호 기반 인증 (BCrypt 암호화)
- **투표 생성**: 일반 사용자는 투표를 생성하면 `PENDING` 상태로 등록되며 관리자 승인 필요
- **투표 참여**: 진행 중인 투표에 참여 가능 (IP 및 사용자 ID 기반 중복 방지)
- **내가 만든 투표**: 자신이 생성한 투표 목록 조회 및 수정/삭제 가능
- **투표 결과 확인**: 마감 시간 이후 결과 확인 가능

### 2. 관리자 기능
- **투표 주제 관리**: 모든 투표 주제 조회, 수정, 삭제 (페이지네이션: 7개/페이지)
- **승인/거부**: 일반 사용자가 생성한 `PENDING` 상태 투표 승인 또는 거부
- **거부 사유**: 거부 시 사유를 입력하고 `REJECTED` 상태로 변경 (사용자가 확인 가능)
- **후보자 관리**: 후보자 추가, 수정, 삭제 및 이미지 업로드
- **통계**: 총 투표 주제, 진행 중인 투표, 승인 대기, 총 투표 참여 수 표시
- **검색 기능**: 투표 제목으로 검색 가능

### 3. 공통 기능
- **진행중인 투표**: `ONGOING` 상태 투표 목록 (페이지네이션: 6개/페이지, 검색 기능)
- **마감된 투표**: `CLOSED` 상태 투표 목록 (페이지네이션: 6개/페이지, 검색 기능)
- **관리자 표시**: 관리자가 만든 투표는 파란색 테두리와 "관리자" 배지로 강조 표시
- **실시간 업데이트**: WebSocket을 통한 투표 결과 실시간 업데이트
- **이미지 업로드**: 후보자 이미지 업로드 (2단계 프로세스: 투표 생성 후 이미지 추가)

## 기술 스택

### Backend
- **Framework**: Spring Boot
- **Database**: H2 Database (파일 기반)
- **ORM**: Spring Data JPA
- **View**: JSP (JSTL)
- **WebSocket**: Spring WebSocket (STOMP 프로토콜)
- **Security**: BCryptPasswordEncoder (spring-security-crypto)
- **Build Tool**: Gradle

### Frontend
- **JavaScript**: Chart.js (투표 결과 차트)
- **WebSocket Client**: SockJS, STOMP.js
- **CSS**: 커스텀 스타일링

## 데이터베이스 구조

### User 테이블
- `id`: 사용자 ID (PK)
- `username`: 사용자명 (UNIQUE)
- `email`: 이메일 (UNIQUE)
- `password`: 비밀번호 (BCrypt 암호화)
- `role`: 역할 (USER, ADMIN)
- `createdAt`: 생성일시

### VoteTopic 테이블
- `id`: 투표 주제 ID (PK)
- `title`: 제목
- `description`: 설명
- `deadline`: 마감 시간
- `status`: 상태 (PENDING, ONGOING, CLOSED, REJECTED)
- `created_by`: 생성자 ID (FK, null이면 관리자)
- `reject_reason`: 거부 사유
- `created_at`: 생성일시

### Candidate 테이블
- `id`: 후보자 ID (PK)
- `vote_topic_id`: 투표 주제 ID (FK)
- `name`: 이름
- `description`: 설명
- `image_path`: 이미지 경로
- `vote_count`: 득표수

### VoteRecord 테이블
- `id`: 투표 기록 ID (PK)
- `candidate_id`: 후보자 ID (FK)
- `user_id`: 사용자 ID (FK, nullable)
- `ip_address`: IP 주소
- `created_at`: 생성일시

## 주요 파일 구조

### Controllers
- `MainController.java`: 메인 페이지, 투표 생성, 내가 만든 투표 관리
- `VoteController.java`: 투표 상세, 투표 제출, 결과 페이지
- `UserViewController.java`: 로그인, 회원가입, 로그아웃
- `AdminViewController.java`: 관리자 페이지, 투표 주제 관리, 승인/거부
- `ImageController.java`: 이미지 파일 서빙

### Services
- `VoteTopicService.java`: 투표 주제 비즈니스 로직
- `CandidateService.java`: 후보자 비즈니스 로직 (이미지 업로드 포함)
- `VoteRecordService.java`: 투표 기록 비즈니스 로직
- `UserService.java`: 사용자 비즈니스 로직 (BCrypt 암호화)
- `FileUploadService.java`: 파일 업로드/삭제
- `VoteUpdateService.java`: WebSocket 브로드캐스트

### Repositories
- `VoteTopicRepository.java`: 투표 주제 데이터 접근
- `CandidateRepository.java`: 후보자 데이터 접근
- `VoteRecordRepository.java`: 투표 기록 데이터 접근
- `UserRepository.java`: 사용자 데이터 접근

### Config
- `WebSocketConfig.java`: WebSocket 설정
- `WebMvcConfig.java`: Spring MVC 설정
- `MultipartConfig.java`: 파일 업로드 설정

### Scheduler
- `VoteScheduler.java`: 투표 상태 자동 업데이트 (마감 시간 체크)

## 주요 설정

### application.properties
- H2 Database 파일 기반 설정
- H2 Console 활성화 (`/h2-console`)
- 파일 업로드 설정

### build.gradle
- Spring Boot Starter Web, Data JPA, WebSocket
- BCrypt 암호화 (spring-security-crypto)
- JSP 지원 (Jasper)
- 컴파일 옵션: `-parameters` (리플렉션을 위한 파라미터 이름 보존)

## 주요 기능 상세

### 1. 투표 생성 프로세스
1. **1단계**: 투표 주제와 후보자 기본 정보 입력 (이름, 설명)
2. **2단계**: 투표 생성 후 각 후보자별로 이미지 업로드

### 2. 투표 승인 프로세스
- 일반 사용자: `PENDING` → 관리자 승인 → `ONGOING`
- 관리자: 즉시 `ONGOING` 상태로 생성
- 거부 시: `REJECTED` 상태 + 거부 사유 저장

### 3. 권한 관리
- 일반 사용자: 자신이 만든 투표만 수정/삭제 가능
- 관리자: 모든 투표 수정/삭제 가능

### 4. 중복 투표 방지
- IP 주소 기반 체크
- 사용자 ID 기반 체크 (로그인한 경우)

### 5. 실시간 업데이트
- WebSocket을 통한 투표 결과 실시간 브로드캐스트
- Chart.js를 사용한 동적 차트 업데이트

## UI/UX 특징

### 디자인
- 파란색 계열 메인 컬러 (#1976d2)
- 반응형 디자인 (모바일, 태블릿, 데스크톱)
- 카드 기반 레이아웃

### 페이지네이션
- 진행중인 투표: 6개/페이지
- 마감된 투표: 6개/페이지
- 관리자 투표 주제 관리: 7개/페이지
- 검색 키워드 유지

### 관리자 표시
- 관리자가 만든 투표: 파란색 테두리 + "관리자" 배지
- 관리자 페이지 테이블: "관리자" 텍스트 (파란색, 굵게)

## 다음 작업 시 참고사항

### 1. 관리자 계정 생성
- H2 Console (`http://localhost:8081/h2-console`) 접속
- User 테이블에 직접 INSERT 또는 애플리케이션에서 수동 생성
- `role` 필드를 `'ADMIN'`으로 설정

### 2. 데이터베이스 초기화
- `application.properties`에서 `spring.sql.init.mode=never` 설정됨
- 필요 시 `data.sql` 파일 생성하여 초기 데이터 삽입 가능

### 3. 파일 업로드 경로
- 이미지 저장 경로: `src/main/webapp/uploads/images/`
- 이미지 서빙: `/uploads/images/{filename}`

### 4. 세션 관리
- 로그인 정보: `userId`, `username`, `role` 세션에 저장
- 관리자 체크: `"ADMIN".equals(session.getAttribute("role"))`

### 5. 투표 상태 전환
- 자동: `VoteScheduler`가 주기적으로 마감 시간 체크하여 `CLOSED`로 변경
- 수동: 관리자가 상태 변경 가능

## 알려진 이슈 및 개선 가능 사항

### 현재 상태
- ✅ 모든 주요 기능 구현 완료
- ✅ 페이지네이션 및 검색 기능 구현
- ✅ 관리자 표시 기능 구현
- ✅ 실시간 업데이트 기능 구현

### 향후 개선 가능 사항
- 관리자 계정 자동 생성 기능 재구현 고려
- 이미지 파일 크기 제한 및 유효성 검사 강화
- 투표 통계 및 분석 기능 추가
- 이메일 알림 기능 (승인/거부 시)
- 투표 기간 연장 기능
- 투표 결과 내보내기 (CSV, PDF)

## 실행 방법

1. **프로젝트 빌드**
   ```bash
   .\gradlew clean build -x test
   ```

2. **애플리케이션 실행**
   - IDE에서 `VotoFiApplication.java` 실행
   - 또는 `.\gradlew bootRun`

3. **접속**
   - 메인 페이지: `http://localhost:8081/`
   - H2 Console: `http://localhost:8081/h2-console`
   - 관리자 페이지: `http://localhost:8081/admin` (관리자 로그인 필요)

## 개발 환경
- **OS**: Windows 10
- **IDE**: Spring Tool Suite (STS)
- **Java Version**: (build.gradle 확인 필요)
- **Spring Boot Version**: (build.gradle 확인 필요)

---

**마지막 업데이트**: 2025년 (현재 날짜)
**프로젝트 상태**: 주요 기능 구현 완료, 운영 가능 상태
