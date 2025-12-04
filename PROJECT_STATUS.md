# Voto-Fi 프로젝트 현황

## 프로젝트 개요
Spring Boot 기반의 투표 시스템 웹 애플리케이션

## 기술 스택
- **프레임워크**: Spring Boot 4.0.0
- **언어**: Java 21
- **ORM**: JPA (Hibernate)
- **데이터베이스**: H2 (인메모리)
- **뷰**: JSP (JSTL)
- **빌드 도구**: Gradle
- **라이브러리**: Lombok, Chart.js (프론트엔드)

## 프로젝트 구조

```
src/main/
├── java/com/example/demo/
│   ├── VotoFiApplication.java          # 메인 애플리케이션
│   ├── ServletInitializer.java         # WAR 배포용
│   ├── MainController.java             # 메인 페이지 컨트롤러
│   ├── VoteController.java              # 투표 관련 컨트롤러
│   ├── UserViewController.java         # 사용자 뷰 컨트롤러
│   │
│   ├── user/                           # 사용자 도메인
│   │   ├── User.java                   # 엔티티
│   │   ├── UserRepository.java         # 리포지토리
│   │   ├── UserService.java            # 서비스
│   │   └── UserController.java         # REST API 컨트롤러
│   │
│   ├── votetopic/                      # 투표 주제 도메인
│   │   ├── VoteTopic.java              # 엔티티
│   │   ├── VoteTopicRepository.java    # 리포지토리
│   │   ├── VoteTopicService.java       # 서비스
│   │   └── VoteTopicController.java    # REST API 컨트롤러
│   │
│   ├── candidate/                      # 후보 항목 도메인
│   │   ├── Candidate.java              # 엔티티
│   │   ├── CandidateRepository.java    # 리포지토리
│   │   ├── CandidateService.java       # 서비스
│   │   └── CandidateController.java    # REST API 컨트롤러
│   │
│   ├── voterecord/                     # 투표 기록 도메인
│   │   ├── VoteRecord.java             # 엔티티
│   │   ├── VoteRecordRepository.java   # 리포지토리
│   │   ├── VoteRecordService.java      # 서비스
│   │   └── VoteRecordController.java   # REST API 컨트롤러
│   │
│   └── admin/                          # 관리자 도메인
│       ├── AdminController.java         # REST API 컨트롤러
│       └── AdminViewController.java    # 뷰 컨트롤러
│
├── resources/
│   ├── application.properties           # 설정 파일
│   └── data.sql                        # 초기 데이터
│
└── webapp/WEB-INF/views/               # JSP 뷰 파일
    ├── index.jsp                       # 진행중인 투표 목록
    ├── closed.jsp                      # 마감된 투표 목록
    ├── login.jsp                       # 로그인 페이지
    ├── register.jsp                    # 회원가입 페이지
    ├── voteDetail.jsp                  # 투표 참여 페이지
    ├── voteResult.jsp                  # 투표 결과 페이지
    └── admin/
        ├── main.jsp                    # 관리자 메인 (투표 주제 관리)
        ├── createTopic.jsp             # 투표 주제 생성
        ├── editTopic.jsp               # 투표 주제 수정
        ├── candidate.jsp               # 후보 항목 관리
        ├── records.jsp                 # 투표 기록 조회
        └── candidate/
            ├── create.jsp              # 후보 등록
            └── edit.jsp                # 후보 수정
```

## 구현된 기능

### 1. 사용자 관리
- ✅ 회원가입 (`/register`)
- ✅ 로그인/로그아웃 (`/login`, `/user/logout`)
- ✅ 세션 기반 인증
- ⚠️ 비밀번호 암호화 미구현 (평문 저장)

### 2. 투표 주제 관리
- ✅ 투표 주제 목록 조회 (진행중/마감)
- ✅ 투표 주제 생성 (관리자)
- ✅ 투표 주제 수정 (관리자)
- ✅ 투표 주제 삭제 (관리자)
- ✅ 상태 관리 (PENDING, ONGOING, CLOSED)

### 3. 후보 항목 관리
- ✅ 후보 등록 (관리자)
- ✅ 후보 수정 (관리자)
- ✅ 후보 삭제 (관리자)
- ✅ 후보 목록 조회

### 4. 투표 기능
- ✅ 투표 참여
- ✅ IP 기반 중복 투표 방지
- ✅ 사용자 기반 중복 투표 방지
- ✅ 투표 기록 저장
- ✅ 투표 결과 조회
- ✅ Chart.js를 이용한 결과 시각화 (막대 그래프, 원형 그래프)
- ✅ 순위 표시

### 5. 관리자 기능
- ✅ 관리자 로그인
- ✅ 투표 주제 관리
- ✅ 후보 항목 관리
- ✅ 투표 기록 조회
- ✅ 투표 기록 삭제
- ⚠️ 투표 기록 삭제 시 후보 voteCount 감소 미구현

## 설정 파일

### application.properties
```properties
spring.application.name=Voto-Fi
server.port=8081

# JPA & H2 Database
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# JPA 설정
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.defer-datasource-initialization=true
spring.sql.init.mode=always

# H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# JSP View Resolver 설정
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

## 초기 데이터 (data.sql)

### 테스트 계정
- **관리자**: `admin` / `admin123` (ADMIN 권한)
- **일반 사용자**: `user1` / `user123`
- **일반 사용자**: `user2` / `user123`

### 초기 투표 주제
- 진행중인 투표 4개
- 마감된 투표 1개

## 주요 엔드포인트

### 사용자 페이지
- `GET /` - 진행중인 투표 목록
- `GET /closed` - 마감된 투표 목록
- `GET /login` - 로그인 페이지
- `GET /register` - 회원가입 페이지
- `GET /vote/{id}` - 투표 참여 페이지
- `GET /vote/{id}/result` - 투표 결과 페이지

### 관리자 페이지
- `GET /admin` - 관리자 메인 (투표 주제 관리)
- `GET /admin/topic/create` - 투표 주제 생성 페이지
- `GET /admin/topic/{id}/edit` - 투표 주제 수정 페이지
- `GET /admin/candidate` - 후보 항목 관리 페이지
- `GET /admin/candidate/create` - 후보 등록 페이지
- `GET /admin/candidate/{id}/edit` - 후보 수정 페이지
- `GET /admin/records` - 투표 기록 조회 페이지

### REST API
- `POST /user/register` - 회원가입
- `POST /user/login` - 로그인
- `GET /user/logout` - 로그아웃
- `POST /vote/{id}/submit` - 투표 제출
- `POST /admin/topic/create` - 투표 주제 생성
- `POST /admin/topic/{id}/edit` - 투표 주제 수정
- `POST /admin/topic/{id}/delete` - 투표 주제 삭제
- `POST /admin/candidate/create` - 후보 등록
- `POST /admin/candidate/{id}/edit` - 후보 수정
- `POST /admin/candidate/{id}/delete` - 후보 삭제
- `POST /admin/records/{id}/delete` - 투표 기록 삭제

## 아직 구현하지 않은 기능

### 필수 기능
1. **비밀번호 암호화**
   - 현재 평문 저장 중
   - BCrypt 사용 필요
   - `UserService.java`에 TODO 주석 있음

2. **투표 기록 삭제 시 voteCount 감소**
   - `VoteRecordService.deleteVoteRecord()` 메서드 수정 필요
   - 트랜잭션 처리 필요
   - 스토리보드 요구사항: "투표 기록 삭제 시 관련 Candidate의 voteCount를 1 감소"

### 선택 기능
3. **실시간 득표수 갱신**
   - WebSocket 또는 Server-Sent Events 사용
   - 투표 결과 페이지에서 실시간 업데이트

4. **투표 마감 시간 자동 체크**
   - 스케줄러를 이용한 자동 상태 변경
   - `@Scheduled` 어노테이션 사용

5. **후보 이미지 업로드**
   - 파일 업로드 기능
   - 이미지 저장 및 표시

## 명명 규칙

### 클래스/인터페이스 명명
- **Entity**: `{도메인명}` (예: `User`, `VoteTopic`)
- **Repository**: `{도메인명}Repository` (예: `UserRepository`, `VoteTopicRepository`)
- **Service**: `{도메인명}Service` (예: `UserService`, `VoteTopicService`)
- **Controller**: `{도메인명}Controller` 또는 `{도메인명}ViewController` (예: `UserController`, `AdminViewController`)

### 패키지 구조
- 도메인별로 패키지 분리
- `com.example.demo.{도메인명}` 형식

## 실행 방법

1. **서버 실행**
   ```bash
   ./gradlew bootRun
   ```
   또는 IDE에서 `VotoFiApplication.java` 실행

2. **접속**
   - 메인 페이지: `http://localhost:8081`
   - H2 콘솔: `http://localhost:8081/h2-console`
   - JDBC URL: `jdbc:h2:mem:testdb`

3. **테스트 계정**
   - 관리자: `admin` / `admin123`
   - 일반 사용자: `user1` / `user123`

## 다음 작업 우선순위

1. **비밀번호 암호화 구현** (보안 필수)
   - `build.gradle`에 `spring-boot-starter-security` 또는 BCrypt 의존성 추가
   - `UserService`에서 비밀번호 암호화/검증 로직 구현

2. **투표 기록 삭제 시 voteCount 감소**
   - `VoteRecordService.deleteVoteRecord()` 메서드 수정
   - 트랜잭션 처리 추가

3. **실시간 기능** (선택)
   - WebSocket 설정
   - 실시간 득표수 업데이트

4. **스케줄러** (선택)
   - 투표 마감 시간 자동 체크
   - 상태 자동 변경

## 주의사항

- 포트 8080이 사용 중일 수 있음 (현재 8081로 설정됨)
- H2는 인메모리 DB이므로 서버 재시작 시 데이터 초기화됨
- 세션 기반 인증 사용 중 (서버 재시작 시 세션 소멸)

## 참고사항

- 모든 JSP 파일은 `src/main/webapp/WEB-INF/views/` 경로에 있음
- REST API와 뷰 컨트롤러가 분리되어 있음
- 스토리보드에 따라 기능 구현됨

