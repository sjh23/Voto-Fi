<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 투표 주제 관리</title>
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
        .auth-btn {
            padding: 8px 16px;
            border: 2px solid #f44336;
            border-radius: 5px;
            text-decoration: none;
            color: #f44336;
            font-size: 14px;
            transition: all 0.3s;
        }
        .auth-btn:hover {
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
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .page-title {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #ff9800;
            color: white;
        }
        .btn-primary:hover {
            background: #f57c00;
        }
        .btn-edit {
            background: #2196f3;
            color: white;
            padding: 5px 15px;
            font-size: 14px;
        }
        .btn-delete {
            background: #f44336;
            color: white;
            padding: 5px 15px;
            font-size: 14px;
        }
        table {
            width: 100%;
            background: white;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #1976d2;
            color: white;
            font-weight: 500;
        }
        tr:hover {
            background: #f5f5f5;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-box h3 {
            color: #666;
            margin-bottom: 10px;
        }
        .stat-box .number {
            font-size: 32px;
            font-weight: bold;
            color: #1976d2;
        }
        .status-ongoing {
            color: #4caf50;
            font-weight: bold;
        }
        .status-closed {
            color: #f44336;
            font-weight: bold;
        }
        .status-pending {
            color: #ff9800;
            font-weight: bold;
        }
        .status-rejected {
            color: #f44336;
            font-weight: bold;
        }
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 30px;
            padding: 20px;
        }
        .pagination a, .pagination span {
            padding: 10px 16px;
            border: 1px solid #1976d2;
            border-radius: 5px;
            text-decoration: none;
            color: #1976d2;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.2s;
            min-width: 40px;
            text-align: center;
            display: inline-block;
            background: white;
        }
        .pagination a:hover {
            background: #e3f2fd;
        }
        .pagination .active {
            background: #1976d2;
            color: white;
            border-color: #1976d2;
            font-weight: 500;
        }
        .pagination .disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi:관리자</div>
        <div class="header-right">
            <div class="nav-tabs">
                <a href="/" class="nav-tab">진행중인 투표</a>
                <a href="/closed" class="nav-tab">마감된 투표</a>
                <a href="/admin" class="nav-tab active">관리자</a>
            </div>
            <c:if test="${sessionScope.username != null}">
                <div class="user-info">
                    <span>${sessionScope.username}님</span>
                    <a href="/user/logout" class="auth-btn">로그아웃</a>
                </div>
            </c:if>
        </div>
    </div>

    <div class="container">
        <div class="page-title">
            <h1 style="color: #1976d2;">투표 주제 관리</h1>
            <a href="/admin/topic/create" class="btn btn-primary">새 투표 주제 등록</a>
        </div>
        
        <!-- 검색 기능 -->
        <div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <form action="/admin" method="get" style="display: flex; gap: 10px; align-items: center;">
                <input type="text" name="search" value="${searchKeyword != null ? searchKeyword : ''}" 
                       placeholder="투표 제목으로 검색..." 
                       style="flex: 1; padding: 12px; border: 2px solid #1976d2; border-radius: 5px; font-size: 16px;">
                <button type="submit" style="padding: 12px 24px; background: #1976d2; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; font-weight: 500;">검색</button>
                <c:if test="${searchKeyword != null && !empty searchKeyword}">
                    <a href="/admin" style="padding: 12px 24px; background: #757575; color: white; border: none; border-radius: 5px; font-size: 16px; text-decoration: none; display: inline-block;">초기화</a>
                </c:if>
            </form>
        </div>

        <div class="stats">
            <div class="stat-box">
                <h3>총 투표 주제</h3>
                <div class="number">${totalTopics}</div>
            </div>
            <div class="stat-box">
                <h3>진행 중인 투표</h3>
                <div class="number">${ongoingTopics}</div>
            </div>
            <div class="stat-box">
                <h3>승인 대기</h3>
                <div class="number">${pendingTopics.size()}</div>
            </div>
            <div class="stat-box">
                <h3>총 투표 참여</h3>
                <div class="number"><fmt:formatNumber value="${totalVotes}" pattern="#,###" /></div>
            </div>
        </div>
        
        <c:if test="${not empty pendingTopics}">
            <div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                <h2 style="color: #ff9800; margin-bottom: 15px;">승인 대기 중인 투표</h2>
                <table>
                    <thead>
                        <tr>
                            <th>제목</th>
                            <th>생성일</th>
                            <th>마감일</th>
                            <th>생성자</th>
                            <th>승인/거부</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="topic" items="${pendingTopics}">
                            <tr>
                                <td>${topic.title}</td>
                                <td>${topic.createdAt != null ? topic.createdAt.toString().substring(0, 10) : ''}</td>
                                <td>${topic.deadline.toString().substring(0, 10)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${topic.createdBy != null}">
                                            <c:set var="creatorName" value="${creatorMap[topic.id]}" />
                                            <c:choose>
                                                <c:when test="${not empty creatorName}">
                                                    ${creatorName}
                                                </c:when>
                                                <c:otherwise>
                                                    일반 사용자
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            관리자
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="/admin/topic/${topic.id}/approve" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-primary" style="padding: 5px 15px; font-size: 14px;">승인</button>
                                    </form>
                                    <a href="/admin/topic/${topic.id}/reject" class="btn btn-delete" style="padding: 5px 15px; font-size: 14px; text-decoration: none; display: inline-block;">거부</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>제목</th>
                    <th>생성자</th>
                    <th>시작일</th>
                    <th>마감일</th>
                    <th>상태</th>
                    <th>총 투표</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="topic" items="${topics}">
                    <tr>
                        <td>${topic.title}</td>
                        <td>
                            <c:set var="creatorRole" value="${creatorRoleMap[topic.id]}" />
                            <c:choose>
                                <c:when test="${creatorRole eq 'ADMIN'}">
                                    <span style="color: #1976d2; font-weight: bold;">관리자</span>
                                </c:when>
                                <c:when test="${topic.createdBy != null && creatorRole != 'ADMIN'}">
                                    <c:set var="creatorName" value="${allCreatorMap[topic.id]}" />
                                    <c:choose>
                                        <c:when test="${not empty creatorName}">
                                            ${creatorName}
                                        </c:when>
                                        <c:otherwise>
                                            일반 사용자
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #1976d2; font-weight: bold;">관리자</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${topic.createdAt != null ? topic.createdAt.toString().substring(0, 10) : ''}</td>
                        <td>${topic.deadline.toString().substring(0, 10)}</td>
                        <td>
                            <c:choose>
                                <c:when test="${topic.status == 'ONGOING'}">
                                    <span class="status-ongoing">진행중</span>
                                </c:when>
                                <c:when test="${topic.status == 'CLOSED'}">
                                    <span class="status-closed">마감</span>
                                </c:when>
                                <c:when test="${topic.status == 'REJECTED'}">
                                    <span class="status-rejected">거부됨</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pending">대기중</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${totalVotes_[topic.id]}" pattern="#,###" /></td>
                        <td>
                            <a href="/admin/topic/${topic.id}/edit" class="btn btn-edit">수정</a>
                            <form action="/admin/topic/${topic.id}/delete" method="post" style="display:inline;">
                                <button type="submit" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- 페이지네이션 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <!-- 페이지 번호 -->
                <c:choose>
                    <c:when test="${totalPages <= 10}">
                        <c:forEach var="i" begin="0" end="${totalPages - 1}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i + 1}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="/admin?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
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
                                            <a href="/admin?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span style="padding: 10px 5px; color: #1976d2;">...</span>
                                <a href="/admin?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                            </c:when>
                            <c:when test="${currentPage >= totalPages - 5}">
                                <a href="/admin?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                                <span style="padding: 10px 5px; color: #1976d2;">...</span>
                                <c:forEach var="i" begin="${totalPages - 10}" end="${totalPages - 1}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="active">${i + 1}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="/admin?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a href="/admin?page=0<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">1</a>
                                <span style="padding: 10px 5px; color: #1976d2;">...</span>
                                <c:forEach var="i" begin="${currentPage - 2}" end="${currentPage + 2}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="active">${i + 1}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="/admin?page=${i}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${i + 1}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span style="padding: 10px 5px; color: #1976d2;">...</span>
                                <a href="/admin?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
                
                <!-- 다음 페이지 -->
                <c:if test="${currentPage < totalPages - 1}">
                    <a href="/admin?page=${currentPage + 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">다음 ></a>
                </c:if>
                
                <!-- 마지막 페이지 -->
                <c:if test="${currentPage < totalPages - 1}">
                    <a href="/admin?page=${totalPages - 1}<c:if test='${searchKeyword != null && !empty searchKeyword}'>&search=${searchKeyword}</c:if>">마지막 »</a>
                </c:if>
            </div>
        </c:if>
    </div>
</body>
</html>

