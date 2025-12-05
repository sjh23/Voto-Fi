<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 새 투표 주제 등록</title>
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
            max-width: 800px;
            margin: 0 auto;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #1976d2;
            color: white;
        }
        .btn-primary:hover {
            background: #1565c0;
        }
        .btn-secondary {
            background: #757575;
            color: white;
        }
        .btn-secondary:hover {
            background: #616161;
        }
        .btn-add {
            background: #4caf50;
            color: white;
            margin-bottom: 20px;
        }
        .btn-add:hover {
            background: #45a049;
        }
        .candidate-item {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            position: relative;
        }
        .candidate-item h4 {
            margin-bottom: 10px;
            color: #1976d2;
        }
        .btn-remove {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #f44336;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
        }
        .btn-remove:hover {
            background: #d32f2f;
        }
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi:관리자</div>
        <div class="nav-tabs">
            <a href="/" class="nav-tab">진행중인 투표</a>
            <a href="/closed" class="nav-tab">마감된 투표</a>
            <a href="/admin" class="nav-tab active">관리자</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h1 style="color: #1976d2; margin-bottom: 30px;">새 투표 주제 등록</h1>
            
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="message">${message}</div>
            </c:if>
            
            <form action="/admin/topic/create" method="post">
                <div class="form-group">
                    <label>제목 *</label>
                    <input type="text" name="title" required placeholder="투표 주제 제목을 입력하세요">
                </div>
                
                <div class="form-group">
                    <label>설명</label>
                    <textarea name="description" placeholder="투표 주제에 대한 설명을 입력하세요"></textarea>
                </div>
                
                <div class="form-group">
                    <label>마감 시간 *</label>
                    <input type="datetime-local" name="deadline" required step="60">
                </div>
                
                <div class="form-group">
                    <label>후보자 목록</label>
                    <button type="button" class="btn btn-add" onclick="addCandidate()">+ 후보자 추가</button>
                    <div id="candidates-container"></div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">등록</button>
                    <a href="/admin" class="btn btn-secondary">취소</a>
                </div>
            </form>
            
            <script>
                function updateCandidateNumbers() {
                    const container = document.getElementById('candidates-container');
                    const candidates = container.querySelectorAll('.candidate-item');
                    candidates.forEach((candidate, index) => {
                        const h4 = candidate.querySelector('h4');
                        if (h4) {
                            h4.textContent = '후보자 ' + (index + 1);
                        }
                    });
                }
                
                function removeCandidate(button) {
                    if (confirm('이 후보자를 삭제하시겠습니까?')) {
                        button.closest('.candidate-item').remove();
                        updateCandidateNumbers();
                    }
                }
                
                function addCandidate() {
                    const container = document.getElementById('candidates-container');
                    const index = container.children.length;
                    const candidateDiv = document.createElement('div');
                    candidateDiv.className = 'candidate-item';
                    candidateDiv.innerHTML = `
                        <h4>후보자 ${index + 1}</h4>
                        <button type="button" class="btn-remove" onclick="removeCandidate(this)">삭제</button>
                        <div class="form-group">
                            <label>후보자 이름 *</label>
                            <input type="text" name="candidateNames" required placeholder="후보자 이름을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label>후보자 설명</label>
                            <textarea name="candidateDescriptions" placeholder="후보자에 대한 설명을 입력하세요"></textarea>
                        </div>
                    `;
                    container.appendChild(candidateDiv);
                    updateCandidateNumbers();
                }
            </script>
        </div>
    </div>
</body>
</html>

