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
        .container {
            max-width: 1400px;
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
            grid-template-columns: repeat(3, 1fr);
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
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">로고 : 관리자</div>
        <div class="nav-tabs">
            <a href="/" class="nav-tab">진행중인 투표</a>
            <a href="/closed" class="nav-tab">마감된 투표</a>
            <a href="/admin" class="nav-tab active">관리자</a>
        </div>
    </div>

    <div class="container">
        <div class="page-title">
            <h1 style="color: #1976d2;">투표 주제 관리</h1>
            <a href="/admin/topic/create" class="btn btn-primary">새 투표 주제 등록</a>
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
                <h3>총 투표 참여</h3>
                <div class="number"><fmt:formatNumber value="${totalVotes}" pattern="#,###" /></div>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>제목</th>
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
                        <td><fmt:formatDate value="${topic.createdAt}" pattern="yyyy-MM-dd" /></td>
                        <td><fmt:formatDate value="${topic.deadline}" pattern="yyyy-MM-dd" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${topic.status == 'ONGOING'}">
                                    <span class="status-ongoing">진행중</span>
                                </c:when>
                                <c:when test="${topic.status == 'CLOSED'}">
                                    <span class="status-closed">마감</span>
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
    </div>
</body>
</html>

