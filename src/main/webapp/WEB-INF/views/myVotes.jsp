<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내가 만든 투표 - Voto-Fi</title>
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
        .vote-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }
        .vote-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 25px;
            transition: transform 0.2s ease-in-out;
        }
        .vote-card:hover {
            transform: translateY(-5px);
        }
        .vote-card h2 {
            color: #1976d2;
            margin-bottom: 10px;
            font-size: 22px;
        }
        .vote-card p {
            color: #555;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .vote-info {
            margin-top: 10px;
            font-size: 14px;
            color: #555;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .status-pending {
            background: #fff3e0;
            color: #f57c00;
        }
        .status-ongoing {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .status-closed {
            background: #ffebee;
            color: #c62828;
        }
        .status-rejected {
            background: #fce4ec;
            color: #c2185b;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-edit {
            background: #2196f3;
            color: white;
        }
        .btn-edit:hover {
            background: #1976d2;
        }
        .btn-delete {
            background: #f44336;
            color: white;
        }
        .btn-delete:hover {
            background: #d32f2f;
        }
        .btn-view {
            background: #4caf50;
            color: white;
        }
        .btn-view:hover {
            background: #45a049;
        }
        .reject-reason {
            background: #ffebee;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 13px;
            color: #c62828;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi</div>
        <div class="header-right">
            <div class="nav-tabs">
                <a href="/" class="nav-tab">진행중인 투표</a>
                <a href="/closed" class="nav-tab">마감된 투표</a>
                <a href="/my-votes" class="nav-tab active">내가 만든 투표</a>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin" class="nav-tab">관리자</a>
                </c:if>
            </div>
            <div class="user-info">
                <a href="/vote/create" class="auth-btn" style="background: #4caf50; border-color: #4caf50; color: white;">투표 생성</a>
                <span>${username}님</span>
                <a href="/user/logout" class="auth-btn">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="page-title">
            <h1 style="color: #1976d2;">내가 만든 투표</h1>
        </div>

        <c:choose>
            <c:when test="${empty myVotes}">
                <div class="empty-state">
                    <h2>아직 만든 투표가 없습니다</h2>
                    <p>새로운 투표를 만들어보세요!</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="vote-grid">
                    <c:forEach var="vote" items="${myVotes}">
                        <div class="vote-card">
                            <c:choose>
                                <c:when test="${vote.status == 'PENDING'}">
                                    <span class="status-badge status-pending">승인 대기</span>
                                </c:when>
                                <c:when test="${vote.status == 'ONGOING'}">
                                    <span class="status-badge status-ongoing">진행중</span>
                                </c:when>
                                <c:when test="${vote.status == 'CLOSED'}">
                                    <span class="status-badge status-closed">마감</span>
                                </c:when>
                                <c:when test="${vote.status == 'REJECTED'}">
                                    <span class="status-badge status-rejected">거부됨</span>
                                </c:when>
                            </c:choose>
                            <h2>${vote.title}</h2>
                            <p>${vote.description}</p>
                            <div class="vote-info">
                                <span>마감일: ${vote.deadline.toString().substring(0, 10)}</span>
                            </div>
                            <div class="vote-info">
                                <span>현재 참여: 
                                    <c:set var="voteId" value="${vote.id}" />
                                    <c:choose>
                                        <c:when test="${totalVotesMap[voteId] != null}">
                                            <fmt:formatNumber value="${totalVotesMap[voteId]}" pattern="#,###" />명
                                        </c:when>
                                        <c:otherwise>0명</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <c:if test="${vote.status == 'REJECTED' && not empty vote.rejectReason}">
                                <div class="reject-reason">
                                    <strong>거부 사유:</strong> ${vote.rejectReason}
                                </div>
                            </c:if>
                            <div class="action-buttons">
                                <a href="/vote/${vote.id}" class="btn btn-view">보기</a>
                                <c:if test="${vote.status == 'PENDING' || vote.status == 'ONGOING'}">
                                    <a href="/vote/${vote.id}/edit" class="btn btn-edit">수정</a>
                                    <form action="/vote/${vote.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?')">
                                        <button type="submit" class="btn btn-delete">삭제</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

