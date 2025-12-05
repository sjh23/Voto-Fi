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
        .container {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            max-width: 1200px;
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
        .candidate-item.voted {
            border-color: #4caf50;
            background: #e8f5e9;
            border-width: 3px;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
            transform: scale(1.02);
        }
        .candidate-item.voted::after {
            content: "✓ 투표 완료";
            position: absolute;
            top: 10px;
            right: 10px;
            background: #4caf50;
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        .candidate-item {
            position: relative;
        }
        .selected-candidate-info {
            background: #e8f5e9;
            border: 2px solid #4caf50;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            display: none;
        }
        .selected-candidate-info.show {
            display: block;
        }
        .selected-candidate-info h3 {
            color: #4caf50;
            margin-bottom: 10px;
            font-size: 18px;
        }
        .selected-candidate-info p {
            color: #666;
            margin: 0;
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
        <div class="logo">Voto-Fi</div>
        <div class="header-right">
            <div class="nav-tabs">
                <a href="/" class="nav-tab">진행중인 투표</a>
                <a href="/closed" class="nav-tab">마감된 투표</a>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin" class="nav-tab">관리자</a>
                </c:if>
            </div>
            <c:choose>
                <c:when test="${loggedIn}">
                    <div class="user-info">
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

    <div class="container">
        <div class="vote-info">
            <h1>${voteTopic.title}</h1>
            <p>${voteTopic.description}</p>
            <div class="vote-period">
                <strong>투표기간:</strong> 
                ${voteTopic.deadline.toString().substring(0, 10)}
            </div>
        </div>

        <div class="candidates-section">
            <h2 style="margin-bottom: 20px; color: #1976d2;">후보 선택</h2>
            
            <c:if test="${not empty message}">
                <div style="background: #e8f5e9; color: #2e7d32; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 2px solid #4caf50;">
                    ${message}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <c:if test="${not empty selectedCandidateId}">
                <c:forEach var="candidate" items="${candidates}">
                    <c:if test="${candidate.id eq selectedCandidateId}">
                        <div class="selected-candidate-info show">
                            <h3>✓ 투표 완료</h3>
                            <p>선택하신 후보: <strong>${candidate.name}</strong></p>
                        </div>
                    </c:if>
                </c:forEach>
            </c:if>
            
            <c:choose>
                <c:when test="${loggedIn}">
                    <form id="voteForm" action="/vote/${voteTopic.id}/submit" method="post">
                        <c:forEach var="candidate" items="${candidates}">
                            <label class="candidate-item <c:if test='${candidate.id eq selectedCandidateId}'>voted</c:if>" 
                                   onclick="selectCandidate(${candidate.id})" 
                                   data-candidate-id="${candidate.id}">
                                <input type="radio" name="candidateId" value="${candidate.id}" required
                                       <c:if test='${candidate.id eq selectedCandidateId}'>checked disabled</c:if>>
                                <div class="candidate-photo">
                            <c:if test="${not empty candidate.imagePath}">
                                <img src="${candidate.imagePath}" alt="${candidate.name}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 5px;">
                            </c:if>
                            <c:if test="${empty candidate.imagePath}">
                                사진
                            </c:if>
                        </div>
                                <div class="candidate-name">${candidate.name}</div>
                            </label>
                        </c:forEach>
                        
                        <div class="action-buttons">
                            <c:if test="${empty selectedCandidateId}">
                                <button type="submit" class="btn btn-primary">투표 선택 완료</button>
                            </c:if>
                            <c:if test="${not empty selectedCandidateId}">
                                <button type="button" class="btn btn-primary" disabled style="opacity: 0.6; cursor: not-allowed;">투표 완료</button>
                            </c:if>
                            <button type="button" class="btn btn-secondary" onclick="location.href='/vote/${voteTopic.id}/result'">결과 보기</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; background: #fff3e0; border-radius: 10px; border: 2px solid #ff9800;">
                        <h3 style="color: #f57c00; margin-bottom: 20px;">로그인이 필요합니다</h3>
                        <p style="color: #666; margin-bottom: 30px;">투표에 참여하려면 로그인해주세요.</p>
                        <div style="display: flex; gap: 15px; justify-content: center;">
                            <a href="/login" class="btn btn-primary" style="text-decoration: none; display: inline-block;">로그인</a>
                            <a href="/register" class="btn btn-secondary" style="text-decoration: none; display: inline-block;">회원가입</a>
                        </div>
                    </div>
                    <div style="margin-top: 20px; text-align: center;">
                        <button type="button" class="btn btn-secondary" onclick="location.href='/vote/${voteTopic.id}/result'">결과 보기</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function selectCandidate(candidateId) {
            // 이미 투표한 경우 선택 불가
            const votedItems = document.querySelectorAll('.candidate-item.voted');
            if (votedItems.length > 0) {
                return;
            }
            
            document.querySelectorAll('.candidate-item').forEach(item => {
                item.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
        }
        
        const voteForm = document.getElementById('voteForm');
        if (voteForm) {
            voteForm.addEventListener('submit', function(e) {
                const selected = document.querySelector('input[name="candidateId"]:checked');
                if (!selected) {
                    e.preventDefault();
                    alert('후보를 선택해주세요.');
                    return;
                }
                
                // 선택한 후보 강조 애니메이션
                const selectedCandidateId = selected.value;
                const selectedItem = document.querySelector(`.candidate-item[data-candidate-id="${selectedCandidateId}"]`);
                if (selectedItem) {
                    selectedItem.classList.add('selected');
                    
                    // 제출 전 잠시 강조 효과
                    setTimeout(() => {
                        selectedItem.style.transition = 'all 0.5s ease';
                        selectedItem.style.transform = 'scale(1.05)';
                        selectedItem.style.boxShadow = '0 6px 20px rgba(255, 152, 0, 0.4)';
                    }, 100);
                }
                
                // 폼이 정상적으로 제출되도록 함 (리다이렉트 방지 안 함)
                console.log('투표 제출: 후보 ID =', selectedCandidateId);
            });
        }
        
        // 페이지 로드 시 이미 투표한 경우 강조 표시
        window.addEventListener('DOMContentLoaded', function() {
            const votedItems = document.querySelectorAll('.candidate-item.voted');
            votedItems.forEach(item => {
                item.style.animation = 'pulse 0.5s ease-in-out';
            });
        });
        
        // 펄스 애니메이션 추가
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.03); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>

