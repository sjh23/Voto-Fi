<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${voteTopic.title} - 투표 참여</title>
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
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }
        .vote-info {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .vote-info h1 {
            color: #1976d2;
            margin-bottom: 15px;
        }
        .vote-info p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        .vote-period {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .candidates-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .candidate-item {
            display: flex;
            align-items: center;
            padding: 20px;
            margin-bottom: 15px;
            background: #f9f9f9;
            border-radius: 8px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
        }
        .candidate-item:hover {
            border-color: #1976d2;
            background: #e3f2fd;
        }
        .candidate-item input[type="radio"] {
            margin-right: 15px;
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        .candidate-item.selected {
            border-color: #ff9800;
            background: #fff3e0;
        }
        .candidate-photo {
            width: 60px;
            height: 60px;
            background: #ddd;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #999;
            font-size: 12px;
        }
        .candidate-name {
            flex: 1;
            font-size: 18px;
            font-weight: 500;
            color: #333;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #ff9800;
            color: white;
        }
        .btn-primary:hover {
            background: #f57c00;
        }
        .btn-secondary {
            background: white;
            color: #ff9800;
            border: 2px solid #ff9800;
        }
        .btn-secondary:hover {
            background: #fff3e0;
        }
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">로고</div>
        <div class="nav-tabs">
            <a href="/" class="nav-tab">진행중인 투표</a>
            <a href="/closed" class="nav-tab">마감된 투표</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="/admin" class="nav-tab">관리자</a>
            </c:if>
        </div>
    </div>

    <div class="container">
        <div class="vote-info">
            <h1>${voteTopic.title}</h1>
            <p>${voteTopic.description}</p>
            <div class="vote-period">
                <strong>투표기간:</strong> 
                <fmt:formatDate value="${voteTopic.createdAt}" pattern="yyyy-MM-dd" /> ~ 
                <fmt:formatDate value="${voteTopic.deadline}" pattern="yyyy-MM-dd" />
            </div>
        </div>

        <div class="candidates-section">
            <h2 style="margin-bottom: 20px; color: #1976d2;">후보 선택</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <form id="voteForm" action="/vote/${voteTopic.id}/submit" method="post">
                <c:forEach var="candidate" items="${candidates}">
                    <label class="candidate-item" onclick="selectCandidate(${candidate.id})">
                        <input type="radio" name="candidateId" value="${candidate.id}" required>
                        <div class="candidate-photo">사진</div>
                        <div class="candidate-name">${candidate.name}</div>
                    </label>
                </c:forEach>
                
                <div class="action-buttons">
                    <button type="submit" class="btn btn-primary">투표 선택 완료</button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='/vote/${voteTopic.id}/result'">결과 보기</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function selectCandidate(candidateId) {
            document.querySelectorAll('.candidate-item').forEach(item => {
                item.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
        }
        
        document.getElementById('voteForm').addEventListener('submit', function(e) {
            const selected = document.querySelector('input[name="candidateId"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('후보를 선택해주세요.');
            }
        });
    </script>
</body>
</html>

