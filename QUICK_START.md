# 빠른 시작 가이드

## 프로젝트 실행 방법

### 1. 프로젝트 열기
- IDE (STS/Eclipse)에서 프로젝트 Import
- Gradle 프로젝트로 Import

### 2. 서버 실행
**방법 1: IDE에서 실행**
- `VotoFiApplication.java` 우클릭 → Run As → Spring Boot App

**방법 2: Gradle 명령어**
```bash
./gradlew bootRun
```

### 3. 접속
- 메인 페이지: `http://localhost:8081`
- H2 콘솔: `http://localhost:8081/h2-console`
  - JDBC URL: `jdbc:h2:mem:testdb`
  - Username: `sa`
  - Password: (비워두기)

## 테스트 계정

### 관리자 계정
- 사용자명: `admin`
- 비밀번호: `admin123`
- 권한: ADMIN

### 일반 사용자 계정
- 사용자명: `user1`
- 비밀번호: `user123`
- 권한: USER

## 주요 기능 테스트 순서

### 1. 일반 사용자 테스트
1. 메인 페이지 접속 (`http://localhost:8081`)
2. 진행중인 투표 목록 확인
3. "투표 참여하기" 클릭
4. 후보 선택 후 "투표 선택 완료"
5. 결과 페이지에서 Chart.js 시각화 확인

### 2. 관리자 테스트
1. 로그인 페이지에서 관리자 계정으로 로그인
2. 관리자 메뉴 접속 (`http://localhost:8081/admin`)
3. 투표 주제 관리 기능 테스트
4. 후보 항목 관리 기능 테스트
5. 투표 기록 조회 기능 테스트

## 문제 해결

### 포트 충돌
- 현재 포트: `8081` (application.properties에서 설정)
- 포트 변경: `application.properties`의 `server.port` 수정

### 데이터베이스 초기화
- 서버 재시작 시 `data.sql`이 자동 실행됨
- 초기 데이터가 자동으로 삽입됨

### JSP 페이지가 보이지 않을 때
- IDE에서 프로젝트 새로고침 (F5)
- Gradle 프로젝트 새로고침
- 서버 재시작

## 다음 단계

1. **비밀번호 암호화 구현** (필수)
   - `PROJECT_STATUS.md` 참고
   - `TODO.md`의 항목 1번 확인

2. **투표 기록 삭제 시 voteCount 감소** (필수)
   - `VoteRecordService.java` 수정 필요
   - `TODO.md`의 항목 2번 확인

3. **기타 기능 개선**
   - `TODO.md` 참고

## 유용한 명령어

### Gradle 빌드
```bash
./gradlew build
```

### Gradle 클린
```bash
./gradlew clean
```

### 의존성 확인
```bash
./gradlew dependencies
```

## 파일 구조 핵심 경로

- **JSP 파일**: `src/main/webapp/WEB-INF/views/`
- **Java 소스**: `src/main/java/com/example/demo/`
- **설정 파일**: `src/main/resources/application.properties`
- **초기 데이터**: `src/main/resources/data.sql`

## 참고 문서

- `PROJECT_STATUS.md` - 프로젝트 전체 현황
- `TODO.md` - 구현해야 할 기능 목록

