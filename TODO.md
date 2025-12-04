# TODO 리스트

## 🔴 필수 구현 (보안 및 데이터 일관성)

### 1. 비밀번호 암호화
- [ ] `build.gradle`에 BCrypt 의존성 추가
- [ ] `UserService.java`의 `createUser()` 메서드 수정
- [ ] `UserService.java`의 `validateUser()` 메서드 수정
- [ ] 기존 평문 비밀번호를 암호화된 비밀번호로 변경 (선택)

**파일**: `src/main/java/com/example/demo/user/UserService.java`

### 2. 투표 기록 삭제 시 voteCount 감소
- [ ] `VoteRecordService.deleteVoteRecord()` 메서드 수정
- [ ] 관련 Candidate의 voteCount를 1 감소시키는 로직 추가
- [ ] 트랜잭션 처리 확인

**파일**: `src/main/java/com/example/demo/voterecord/VoteRecordService.java`

## 🟡 선택 구현 (기능 개선)

### 3. 실시간 득표수 갱신
- [ ] WebSocket 또는 Server-Sent Events 설정
- [ ] 투표 결과 페이지에서 실시간 업데이트
- [ ] 프론트엔드 JavaScript 수정

### 4. 투표 마감 시간 자동 체크
- [ ] 스케줄러 클래스 생성 (`@Scheduled` 사용)
- [ ] 주기적으로 투표 마감 시간 체크
- [ ] 상태 자동 변경 로직 구현

### 5. 후보 이미지 업로드
- [ ] 파일 업로드 설정
- [ ] 이미지 저장 경로 설정
- [ ] Candidate 엔티티에 이미지 경로 필드 추가
- [ ] 이미지 업로드/표시 기능 구현

## 📝 코드 개선

### 6. 에러 처리 개선
- [ ] 전역 예외 처리 핸들러 추가
- [ ] 사용자 친화적인 에러 메시지
- [ ] 로깅 추가

### 7. 유효성 검증
- [ ] 입력값 유효성 검증 추가
- [ ] @Valid 어노테이션 활용
- [ ] 커스텀 검증 로직

### 8. 테스트 코드 작성
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 작성
- [ ] 컨트롤러 테스트

## 🎨 UI/UX 개선

### 9. 반응형 디자인
- [ ] 모바일 화면 최적화
- [ ] 태블릿 화면 최적화

### 10. 사용자 경험 개선
- [ ] 로딩 인디케이터 추가
- [ ] 성공/실패 메시지 개선
- [ ] 폼 유효성 검증 메시지

## 📚 문서화

### 11. API 문서화
- [ ] Swagger/OpenAPI 설정
- [ ] API 엔드포인트 문서화

### 12. 사용자 매뉴얼
- [ ] 관리자 매뉴얼 작성
- [ ] 일반 사용자 매뉴얼 작성

