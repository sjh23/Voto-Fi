<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voto-Fi - 진행중인 투표</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #e3f2fd;
            min-height: 100vh;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #1976d2;
        }
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .nav-tabs {
            display: flex;
            gap: 10px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #1976d2;
            font-weight: 500;
        }
        .auth-buttons {
            display: flex;
            gap: 10px;
        }
        .auth-btn {
            padding: 8px 16px;
            border: 2px solid #1976d2;
            border-radius: 5px;
            text-decoration: none;
            color: #1976d2;
            font-size: 14px;
            transition: all 0.3s;
        }
        .auth-btn:hover {
            background: #1976d2;
            color: white;
        }
        .auth-btn.logout {
            border-color: #f44336;
            color: #f44336;
        }
        .auth-btn.logout:hover {
            background: #f44336;
            color: white;
        }
        .nav-tab {
            padding: 10px 20px;
            background: white;
            border: 2px solid #1976d2;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            color: #1976d2;
            transition: all 0.3s;
        }
        .nav-tab:hover, .nav-tab.active {
            background: #1976d2;
            color: white;
        }
        .vote-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }
        
        @media (max-width: 1024px) {
            .vote-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .vote-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 20px;
        }
        
        .pagination a, .pagination span {
            padding: 10px 15px;
            border: 2px solid #1976d2;
            border-radius: 5px;
            text-decoration: none;
            color: #1976d2;
            font-weight: 500;
            transition: all 0.3s;
            min-width: 40px;
            text-align: center;
            display: inline-block;
        }
        
        .pagination a:hover {
            background: #1976d2;
            color: white;
        }
        
        .pagination .active {
            background: #1976d2;
            color: white;
            border-color: #1976d2;
        }
        
        .pagination .disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        .vote-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .vote-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .vote-card h2 {
            color: #1976d2;
            margin-bottom: 10px;
        }
        .vote-card p {
            color: #666;
            margin-bottom: 15px;
        }
        .vote-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 14px;
            color: #555;
        }
        .vote-btn {
            width: 100%;
            padding: 12px;
            background: #ff9800;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .vote-btn:hover {
            background: #f57c00;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            color: #999;
        }
    </style>
    <script>
        function parseDeadline(deadlineStr) {
            if (!deadlineStr || deadlineStr.trim() === '') {
                return new Date(NaN);
            }
            
            // LocalDateTime 형식: "2025-12-13T11:58:00" 또는 "2025-12-13T11:58"
            // ISO 형식으로 변환
            let dateStr = deadlineStr.trim();
            
            try {
                if (dateStr.includes('T')) {
                    // 이미 ISO 형식이지만 초가 없으면 추가
                    if (dateStr.match(/T\d{2}:\d{2}$/)) {
                        dateStr = dateStr + ':00';
                    }
                    return new Date(dateStr);
                } else if (dateStr.includes(' ')) {
                    // 공백으로 구분된 형식: "2025-12-13 11:58"
                    return new Date(dateStr.replace(' ', 'T') + ':00');
                } else {
                    // 날짜만 있는 경우
                    return new Date(dateStr + 'T00:00:00');
                }
            } catch (e) {
                console.error('날짜 파싱 중 오류:', e, dateStr);
                return new Date(NaN);
            }
        }
        
        function calculateRemainingTime(deadlineStr) {
            try {
                if (!deadlineStr || deadlineStr.trim() === '') {
                    return "마감 시간 정보 없음";
                }
                
                const now = new Date();
                const end = parseDeadline(deadlineStr);
                
                if (isNaN(end.getTime())) {
                    return "마감 시간 계산 오류";
                }
                
                const diff = end - now;
                
                if (diff <= 0) return "마감됨";
                
                // 년, 월, 일, 시, 분, 초 계산
                const totalSeconds = Math.floor(diff / 1000);
                const totalMinutes = Math.floor(totalSeconds / 60);
                const totalHours = Math.floor(totalMinutes / 60);
                const totalDays = Math.floor(totalHours / 24);
                
                const years = Math.floor(totalDays / 365);
                const remainingDaysAfterYears = totalDays % 365;
                const months = Math.floor(remainingDaysAfterYears / 30);
                const days = remainingDaysAfterYears % 30;
                const hours = totalHours % 24;
                const minutes = totalMinutes % 60;
                const seconds = totalSeconds % 60;
                
                // 항상 모든 단위를 표시
                let result = "마감까지 ";
                
                if (years > 0) {
                    result = result + years + "년 ";
                }
                if (months > 0) {
                    result = result + months + "개월 ";
                }
                if (days > 0 || years > 0 || months > 0) {
                    result = result + days + "일 ";
                }
                result = result + hours + "시 ";
                result = result + minutes + "분 ";
                result = result + seconds + "초 ";
                
                result = result + "남았습니다";
                
                return result;
            } catch (e) {
                console.error('마감 시간 계산 오류:', e, deadlineStr);
                return "마감 시간 계산 오류";
            }
        }
        
        function formatDeadline(deadlineStr) {
            try {
                if (!deadlineStr || deadlineStr.trim() === '') {
                    return "날짜 정보 없음";
                }
                
                // LocalDateTime 형식을 직접 파싱 (더 안정적)
                if (deadlineStr.includes('T')) {
                    const parts = deadlineStr.split('T');
                    if (parts.length === 2) {
                        const datePart = parts[0]; // "2025-12-14"
                        const timePart = parts[1].substring(0, 5); // "19:03"
                        return datePart + ' ' + timePart;
                    }
                }
                
                // Date 객체로 파싱 시도
                const date = parseDeadline(deadlineStr);
                if (!isNaN(date.getTime())) {
                    const year = date.getFullYear();
                    const month = String(date.getMonth() + 1).padStart(2, '0');
                    const day = String(date.getDate()).padStart(2, '0');
                    const hours = String(date.getHours()).padStart(2, '0');
                    const minutes = String(date.getMinutes()).padStart(2, '0');
                    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
                }
                
                // 파싱 실패 시 원본 문자열 반환
                return deadlineStr;
            } catch (e) {
                console.error('마감일 포맷 오류:', e, deadlineStr);
                // LocalDateTime 형식 그대로 표시 시도
                if (deadlineStr && deadlineStr.includes('T')) {
                    return deadlineStr.substring(0, 16).replace('T', ' ');
                }
                return deadlineStr || "날짜 정보 없음";
            }
        }
        
        function updateRemainingTimes() {
            document.querySelectorAll('.remaining-time').forEach(function(el) {
                const deadline = el.getAttribute('data-deadline');
                if (deadline) {
                    const result = calculateRemainingTime(deadline);
                    // innerHTML 대신 textContent 사용하여 확실하게 업데이트
                    el.innerHTML = '';
                    el.textContent = result;
                }
            });
        }
        
        function updateDeadlineDisplays() {
            document.querySelectorAll('.deadline-display').forEach(function(el) {
                const deadline = el.getAttribute('data-deadline');
                if (deadline) {
                    const result = formatDeadline(deadline);
                    el.innerHTML = '';
                    el.textContent = result;
                }
            });
        }
    </script>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi</div>
        <div class="header-right">
            <div class="nav-tabs">
                <a href="/" class="nav-tab active">진행중인 투표</a>
                <a href="/closed" class="nav-tab">마감된 투표</a>
                <c:if test="${loggedIn}">
                    <a href="/my-votes" class="nav-tab">내가 만든 투표</a>
                </c:if>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin" class="nav-tab">관리자</a>
                </c:if>
            </div>
            <c:choose>
                <c:when test="${loggedIn}">
                    <div class="user-info">
                        <a href="/vote/create" class="auth-btn" style="background: #4caf50; border-color: #4caf50;">투표 생성</a>
                        <span>${username}님</span>
                        <a href="/user/logout" class="auth-btn logout">로그아웃</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="auth-buttons">
                        <a href="/login" class="auth-btn">로그인</a>
                        <a href="/register" class="auth-btn">회원가입</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- 검색 기능 -->
    <div style="max-width: 1200px; margin: 0 auto 30px auto;">
        <form action="/" method="get" style="display: flex; gap: 10px; align-items: center;">
            <input type="text" name="search" value="${searchKeyword != null ? searchKeyword : ''}" 
                   placeholder="투표 제목으로 검색..." 
                   style="flex: 1; padding: 12px; border: 2px solid #1976d2; border-radius: 5px; font-size: 16px;">
            <button type="submit" style="padding: 12px 24px; background: #1976d2; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; font-weight: 500;">검색</button>
            <c:if test="${searchKeyword != null && !empty searchKeyword}">
                <a href="/" style="padding: 12px 24px; background: #757575; color: white; border: none; border-radius: 5px; font-size: 16px; text-decoration: none; display: inline-block;">초기화</a>
            </c:if>
        </form>
    </div>

    <div class="vote-grid">
        <c:choose>
            <c:when test="${empty votes}">
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <h2>진행 중인 투표가 없습니다</h2>
                    <p>새로운 투표가 등록되면 여기에 표시됩니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="vote" items="${votes}">
                    <c:set var="isAdminCreated" value="${creatorRoleMap[vote.id] eq 'ADMIN'}" />
                    <div class="vote-card" <c:if test="${isAdminCreated}">style="border: 2px solid #1976d2; box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);"</c:if>>
                        <c:if test="${isAdminCreated}">
                            <span style="display: inline-block; background: #1976d2; color: white; padding: 4px 12px; border-radius: 15px; font-size: 12px; font-weight: bold; margin-bottom: 10px;">관리자</span>
                        </c:if>
                        <h2>${vote.title}</h2>
                        <p>${vote.description}</p>
                        <div class="vote-info">
                            <span>마감일: <strong class="deadline-display" data-deadline="${vote.deadline.toString()}"></strong></span>
                        </div>
                        <div class="vote-info">
                            <span>현재 참여: <strong>
                                <c:set var="voteId" value="${vote.id}" />
                                <c:choose>
                                    <c:when test="${totalVotesMap[voteId] != null}">
                                        <fmt:formatNumber value="${totalVotesMap[voteId]}" pattern="#,###" />명
                                    </c:when>
                                    <c:otherwise>0명</c:otherwise>
                                </c:choose>
                            </strong></span>
                        </div>
                        <div class="vote-info">
                            <span class="remaining-time" data-deadline="${vote.deadline.toString()}"></span>
                        </div>
                        <button class="vote-btn" onclick="location.href='/vote/${vote.id}'">
                            투표 참여하기
                        </button>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- 페이지네이션 -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <!-- 첫 페이지 -->
            <c:if test="${currentPage > 0}">
                <a href="/?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">« 처음</a>
            </c:if>
            
            <!-- 이전 페이지 -->
            <c:if test="${currentPage > 0}">
                <a href="/?page=${currentPage - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">‹ 이전</a>
            </c:if>
            
            <!-- 페이지 번호 -->
            <c:choose>
                <c:when test="${totalPages <= 10}">
                    <c:forEach var="i" begin="0" end="${totalPages - 1}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="active">${i + 1}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="/?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${currentPage < 5}">
                            <c:forEach var="i" begin="0" end="9">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/?page=${i}">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span>...</span>
                            <a href="/?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                        </c:when>
                        <c:when test="${currentPage >= totalPages - 5}">
                            <a href="/?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                            <span>...</span>
                            <c:forEach var="i" begin="${totalPages - 10}" end="${totalPages - 1}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a href="/?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                            <span>...</span>
                            <c:forEach var="i" begin="${currentPage - 2}" end="${currentPage + 2}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span>...</span>
                            <a href="/?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
            
            <!-- 다음 페이지 -->
            <c:if test="${currentPage < totalPages - 1}">
                <a href="/?page=${currentPage + 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">다음 ›</a>
            </c:if>
            
            <!-- 마지막 페이지 -->
            <c:if test="${currentPage < totalPages - 1}">
                <a href="/?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">마지막 »</a>
            </c:if>
        </div>
    </c:if>
    
    <script>
        // DOM이 완전히 로드된 후 실행
        (function() {
            function initDeadlineDisplay() {
                // 즉시 실행
                updateRemainingTimes();
                updateDeadlineDisplays();
                
                // 1초마다 업데이트
                setInterval(updateRemainingTimes, 1000);
                setInterval(updateDeadlineDisplays, 1000);
            }
            
            // 여러 방법으로 실행 보장
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initDeadlineDisplay);
            } else {
                // 이미 로드된 경우 즉시 실행
                setTimeout(initDeadlineDisplay, 100);
            }
            
            window.addEventListener('load', function() {
                updateRemainingTimes();
                updateDeadlineDisplays();
            });
        })();
    </script>
</body>
</html>

