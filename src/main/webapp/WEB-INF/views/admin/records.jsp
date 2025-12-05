<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 투표 기록 조회</title>
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
        }
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        select, input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
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
    </style>
    <script>
        function filterByTopic() {
            const topicId = document.getElementById('topicFilter').value;
            if (topicId) {
                window.location.href = '/admin/records?topicId=' + topicId;
            } else {
                window.location.href = '/admin/records';
            }
        }
    </script>
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
            <h1 style="color: #1976d2;">투표 기록 조회</h1>
        </div>

        <div class="filter-section">
            <label>검색:</label>
            <input type="text" placeholder="검색어 입력" style="border: 2px solid #ff9800; padding: 10px;">
            <label>투표 주제별 필터:</label>
            <select id="topicFilter" onchange="filterByTopic()" style="border: 2px solid #ff9800; padding: 10px;">
                <option value="">전체</option>
                <c:forEach var="topic" items="${allTopics}">
                    <option value="${topic.id}" ${topic.id == selectedTopicId ? 'selected' : ''}>
                        ${topic.title}
                    </option>
                </c:forEach>
            </select>
        </div>

        <table>
            <thead>
                <tr>
                    <th>기록 ID</th>
                    <th>투표일시</th>
                    <th>투표 주제</th>
                    <th>선택 후보</th>
                    <th>투표 IP</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="record" items="${records}">
                    <tr>
                        <td>#${record.id}</td>
                        <td>${record.votedAt != null ? record.votedAt.toString().substring(0, 19).replace('T', ' ') : ''}</td>
                        <td>${record.candidate.voteTopic.title}</td>
                        <td>${record.candidate.name}</td>
                        <td>${record.ipAddress}</td>
                        <td>
                            <form action="/admin/records/${record.id}/delete" method="post" style="display:inline;">
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

