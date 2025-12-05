<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voto-Fi - 마감된 투표</title>
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
        
        body {
            overflow-x: hidden;
        }
        .vote-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            opacity: 0.8;
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
        .result-btn {
            width: 100%;
            padding: 12px;
            background: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        .result-btn:hover {
            background: #45a049;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            color: #999;
        }
        .closed-badge {
            display: inline-block;
            padding: 5px 10px;
            background: #f44336;
            color: white;
            border-radius: 3px;
            font-size: 12px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi</div>
        <div class="header-right">
            <div class="nav-tabs">
                <a href="/" class="nav-tab">진행중인 투표</a>
                <a href="/closed" class="nav-tab active">마감된 투표</a>
                <c:if test="${sessionScope.userId != null}">
                    <a href="/my-votes" class="nav-tab">내가 만든 투표</a>
                </c:if>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin" class="nav-tab">관리자</a>
                </c:if>
            </div>
            <c:choose>
                <c:when test="${loggedIn}">
                    <div class="user-info">
                        <a href="/vote/create" class="auth-btn" style="background: #4caf50; border-color: #4caf50; color: white;">투표 생성</a>
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
        <form action="/closed" method="get" style="display: flex; gap: 10px; align-items: center;">
            <input type="text" name="search" value="${searchKeyword != null ? searchKeyword : ''}" 
                   placeholder="투표 제목으로 검색..." 
                   style="flex: 1; padding: 12px; border: 2px solid #1976d2; border-radius: 5px; font-size: 16px;">
            <button type="submit" style="padding: 12px 24px; background: #1976d2; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer;">검색</button>
            <c:if test="${searchKeyword != null && !empty searchKeyword}">
                <a href="/closed" style="padding: 12px 24px; background: #757575; color: white; border: none; border-radius: 5px; font-size: 16px; text-decoration: none;">초기화</a>
            </c:if>
        </form>
    </div>

    <div class="vote-grid">
        <c:choose>
            <c:when test="${empty votes}">
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <h2>마감된 투표가 없습니다</h2>
                    <p>마감된 투표가 있으면 여기에 표시됩니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="vote" items="${votes}">
                    <c:set var="isAdminCreated" value="${creatorRoleMap[vote.id] eq 'ADMIN'}" />
                    <div class="vote-card" <c:if test="${isAdminCreated}">style="border: 2px solid #1976d2; box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);"</c:if>>
                        <span class="closed-badge">마감됨</span>
                        <c:if test="${isAdminCreated}">
                            <span style="display: inline-block; background: #1976d2; color: white; padding: 4px 12px; border-radius: 15px; font-size: 12px; font-weight: bold; margin-bottom: 10px;">관리자</span>
                        </c:if>
                        <h2>${vote.title}</h2>
                        <p>${vote.description}</p>
                        <div class="vote-info">
                            <span>마감일: <strong>${vote.deadline.toString().substring(0, 10)}</strong></span>
                        </div>
                        <a href="/vote/${vote.id}/result" class="result-btn">결과 보기</a>
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
                <a href="/closed?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">« 처음</a>
            </c:if>
            
            <!-- 이전 페이지 -->
            <c:if test="${currentPage > 0}">
                <a href="/closed?page=${currentPage - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">‹ 이전</a>
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
                                <a href="/closed?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
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
                                        <a href="/closed?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span>...</span>
                            <a href="/closed?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                        </c:when>
                        <c:when test="${currentPage >= totalPages - 5}">
                            <a href="/closed?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                            <span>...</span>
                            <c:forEach var="i" begin="${totalPages - 10}" end="${totalPages - 1}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/closed?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a href="/closed?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                            <span>...</span>
                            <c:forEach var="i" begin="${currentPage - 2}" end="${currentPage + 2}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/closed?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span>...</span>
                            <a href="/closed?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
            
            <!-- 다음 페이지 -->
            <c:if test="${currentPage < totalPages - 1}">
                <a href="/closed?page=${currentPage + 1}">다음 ›</a>
            </c:if>
            
            <!-- 마지막 페이지 -->
            <c:if test="${currentPage < totalPages - 1}">
                <a href="/closed?page=${totalPages - 1}">마지막 »</a>
            </c:if>
        </div>
    </c:if>
</body>
</html>

