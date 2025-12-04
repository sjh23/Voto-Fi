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
        .vote-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
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
        <div class="logo">로고</div>
        <div class="nav-tabs">
            <a href="/" class="nav-tab">진행중인 투표</a>
            <a href="/closed" class="nav-tab active">마감된 투표</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="/admin" class="nav-tab">관리자</a>
            </c:if>
        </div>
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
                    <div class="vote-card">
                        <span class="closed-badge">마감됨</span>
                        <h2>${vote.title}</h2>
                        <p>${vote.description}</p>
                        <div class="vote-info">
                            <span>마감일: <strong><fmt:formatDate value="${vote.deadline}" pattern="yyyy-MM-dd" /></strong></span>
                        </div>
                        <a href="/vote/${vote.id}/result" class="result-btn">결과 보기</a>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

