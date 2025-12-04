-- 초기 관리자 계정 생성
INSERT INTO user (id, username, password, email, role, created_at) 
VALUES (1, 'admin', 'admin123', 'admin@votofi.com', 'ADMIN', CURRENT_TIMESTAMP);

-- 초기 일반 사용자 계정 생성
INSERT INTO user (id, username, password, email, role, created_at) 
VALUES (2, 'user1', 'user123', 'user1@votofi.com', 'USER', CURRENT_TIMESTAMP);

INSERT INTO user (id, username, password, email, role, created_at) 
VALUES (3, 'user2', 'user123', 'user2@votofi.com', 'USER', CURRENT_TIMESTAMP);

-- 투표 주제 생성
INSERT INTO vote_topic (id, title, description, deadline, status, created_at) 
VALUES (1, '최고의 게임 콘솔', '당신의 생각하는 최고의 콘솔 게임기에 투표하세요', 
        DATEADD('DAY', 7, CURRENT_TIMESTAMP), 'ONGOING', CURRENT_TIMESTAMP);

INSERT INTO vote_topic (id, title, description, deadline, status, created_at) 
VALUES (2, '2025년 GOTE GAME', '2025년 최고의 게임을 골라주세요', 
        DATEADD('DAY', 5, CURRENT_TIMESTAMP), 'ONGOING', CURRENT_TIMESTAMP);

INSERT INTO vote_topic (id, title, description, deadline, status, created_at) 
VALUES (3, '롤 최고의 팀', '당신의 생각하는 최고의 팀을 골라주세요', 
        DATEADD('DAY', 3, CURRENT_TIMESTAMP), 'ONGOING', CURRENT_TIMESTAMP);

INSERT INTO vote_topic (id, title, description, deadline, status, created_at) 
VALUES (4, '가장 좋아하는 게임', '투표에 나와 있는 게임 중 가장 재미있게 한 게임', 
        DATEADD('DAY', 10, CURRENT_TIMESTAMP), 'ONGOING', CURRENT_TIMESTAMP);

-- 마감된 투표 주제 (테스트용)
INSERT INTO vote_topic (id, title, description, deadline, status, created_at) 
VALUES (5, 'Best Nintendo Switch Game', '닌텐도 스위치 게임', 
        DATEADD('DAY', -1, CURRENT_TIMESTAMP), 'CLOSED', DATEADD('DAY', -10, CURRENT_TIMESTAMP));

-- 후보 항목 생성 (투표 주제 1: 최고의 게임 콘솔)
INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (1, 1, 'PlayStation 5 Pro', '차세대 플레이스테이션 콘솔', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (2, 1, 'Xbox Series X', '마이크로소프트의 차세대 콘솔', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (3, 1, 'Nintendo Switch 2', '닌텐도의 차세대 콘솔', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (4, 1, 'PC Gaming', 'PC 게이밍', 0);

-- 후보 항목 생성 (투표 주제 2: 2025년 GOTE GAME)
INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (5, 2, '게임 A', '2025년 최고의 게임 후보 1', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (6, 2, '게임 B', '2025년 최고의 게임 후보 2', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (7, 2, '게임 C', '2025년 최고의 게임 후보 3', 0);

-- 후보 항목 생성 (투표 주제 3: 롤 최고의 팀)
INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (8, 3, 'T1', 'T1 팀', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (9, 3, 'Gen.G', 'Gen.G 팀', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (10, 3, 'KT', 'KT 팀', 0);

-- 후보 항목 생성 (투표 주제 4: 가장 좋아하는 게임)
INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (11, 4, '젤다의 전설', '젤다의 전설 시리즈', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (12, 4, '마리오', '슈퍼 마리오 시리즈', 0);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (13, 4, '포켓몬', '포켓몬 시리즈', 0);

-- 후보 항목 생성 (투표 주제 5: Best Nintendo Switch Game - 마감된 투표)
INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (14, 5, 'PlayStation 6 vs Xbox Series Z', '닌텐도 스위치 게임', 1250);

INSERT INTO candidate (id, vote_topic_id, name, description, vote_count) 
VALUES (15, 5, 'Best Nintendo Switch Game', '닌텐도 스위치 게임', 3890);

