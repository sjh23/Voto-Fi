<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 후보 항목 관리</title>
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
        select {
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
        .photo-btn {
            padding: 5px 15px;
            background: #ddd;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
    <script>
        function changeTopic() {
            const topicId = document.getElementById('topicSelect').value;
            if (topicId) {
                window.location.href = '/admin/candidate?topicId=' + topicId;
            }
        }
    </script>
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
            <h1 style="color: #1976d2;">후보 항목 관리</h1>
        </div>

        <div class="filter-section">
            <label>투표 주제 선택:</label>
            <select id="topicSelect" onchange="changeTopic()">
                <option value="">선택하세요</option>
                <c:forEach var="topic" items="${allTopics}">
                    <option value="${topic.id}" ${topic.id == selectedTopicId ? 'selected' : ''}>
                        ${topic.title}
                    </option>
                </c:forEach>
            </select>
            <c:if test="${not empty selectedTopicId}">
                <a href="/admin/candidate/create?topicId=${selectedTopicId}" class="btn btn-primary">새 후보 항목 등록</a>
            </c:if>
            <c:if test="${empty selectedTopicId}">
                <p style="color: #999;">투표 주제를 선택하면 후보를 등록할 수 있습니다.</p>
            </c:if>
        </div>

        <c:if test="${not empty candidates}">
            <table>
                <thead>
                    <tr>
                        <th>이미지</th>
                        <th>제목</th>
                        <th>설명</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="candidate" items="${candidates}">
                        <tr>
                            <td><button class="photo-btn">사진</button></td>
                            <td>${candidate.name}</td>
                            <td>${candidate.description}</td>
                            <td>
                                <a href="/admin/candidate/${candidate.id}/edit?topicId=${selectedTopicId}" class="btn btn-edit">수정</a>
                                <form action="/admin/candidate/${candidate.id}/delete" method="post" style="display:inline;">
                                    <input type="hidden" name="topicId" value="${selectedTopicId}">
                                    <button type="submit" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</body>
</html>

