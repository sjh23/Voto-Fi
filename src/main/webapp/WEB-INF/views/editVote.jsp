<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표 수정 - Voto-Fi</title>
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
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1976d2;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="datetime-local"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            font-family: inherit;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
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
                const candidateItem = button.closest('.candidate-item');
                const candidateIdInput = candidateItem.querySelector('input[name="existingCandidateIds"]');
                
                // 기존 후보자인 경우 삭제 목록에 추가
                if (candidateIdInput && candidateIdInput.value) {
                    let deleteInput = document.querySelector(`input[name="deleteCandidateIds"][value="${candidateIdInput.value}"]`);
                    if (!deleteInput) {
                        deleteInput = document.createElement('input');
                        deleteInput.type = 'hidden';
                        deleteInput.name = 'deleteCandidateIds';
                        deleteInput.value = candidateIdInput.value;
                        document.querySelector('form').appendChild(deleteInput);
                    }
                }
                
                candidateItem.remove();
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
        
        window.addEventListener('DOMContentLoaded', function() {
            updateCandidateNumbers();
        });
    </script>
</head>
<body>
    <div class="container">
        <h1>투표 수정</h1>
        
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <form action="/vote/${voteTopic.id}/edit" method="post">
            <div class="form-group">
                <label>투표 제목 *</label>
                <input type="text" name="title" value="${voteTopic.title}" required>
            </div>
            
            <div class="form-group">
                <label>투표 설명</label>
                <textarea name="description">${voteTopic.description}</textarea>
            </div>
            
            <div class="form-group">
                <label>마감 시간 *</label>
                <input type="datetime-local" name="deadline" 
                       value="${voteTopic.deadline.toString().substring(0, 16)}" 
                       required step="60">
            </div>
            
            <div class="form-group">
                <label>후보자 목록</label>
                <button type="button" class="btn btn-add" onclick="addCandidate()">+ 후보자 추가</button>
                <div id="candidates-container">
                    <c:forEach var="candidate" items="${candidates}" varStatus="status">
                        <div class="candidate-item">
                            <h4>후보자 ${status.index + 1}</h4>
                            <button type="button" class="btn-remove" onclick="removeCandidate(this)">삭제</button>
                            <input type="hidden" name="existingCandidateIds" value="${candidate.id}">
                            <div class="form-group">
                                <label>후보자 이름 *</label>
                                <input type="text" name="existingCandidateNames" value="${candidate.name}" required>
                            </div>
                            <div class="form-group">
                                <label>후보자 설명</label>
                                <textarea name="existingCandidateDescriptions">${candidate.description}</textarea>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <a href="/my-votes" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</body>
</html>

