<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>후보자 이미지 추가</title>
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
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1976d2;
            margin-bottom: 10px;
        }
        .vote-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .vote-info h2 {
            color: #1976d2;
            margin-bottom: 5px;
        }
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .candidate-card {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            background: #f9f9f9;
        }
        .candidate-card h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .candidate-image-preview {
            width: 100%;
            height: 200px;
            background: #ddd;
            border-radius: 5px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .candidate-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
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
        .btn-success {
            background: #4caf50;
            color: white;
        }
        .btn-success:hover {
            background: #45a049;
        }
        .message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            justify-content: center;
        }
        .image-uploaded {
            border-color: #4caf50;
            background: #e8f5e9;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Voto-Fi</div>
        <div>
            <a href="/" class="btn btn-secondary" style="text-decoration: none;">메인으로</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h1>후보자 이미지 추가</h1>
            
            <div class="vote-info">
                <h2>${voteTopic.title}</h2>
                <p>${voteTopic.description}</p>
            </div>
            
            <c:if test="${not empty message}">
                <div class="message">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            
            <div class="candidates-grid">
                <c:forEach var="candidate" items="${candidates}">
                    <div class="candidate-card <c:if test='${not empty candidate.imagePath}'>image-uploaded</c:if>">
                        <h3>${candidate.name}</h3>
                        <div class="candidate-image-preview" id="preview-${candidate.id}">
                            <c:if test="${not empty candidate.imagePath}">
                                <c:choose>
                                    <c:when test="${candidate.imagePath.startsWith('/')}">
                                        <img src="${candidate.imagePath}" alt="${candidate.name}" onerror="console.error('이미지 로드 실패: ${candidate.imagePath}'); this.parentElement.innerHTML='<span style=\\'color: #999;\\'>이미지 로드 실패</span>'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/uploads/images/${candidate.imagePath}" alt="${candidate.name}" onerror="console.error('이미지 로드 실패: /uploads/images/${candidate.imagePath}'); this.parentElement.innerHTML='<span style=\\'color: #999;\\'>이미지 로드 실패</span>'">
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${empty candidate.imagePath}">
                                <span style="color: #999;">이미지 없음</span>
                            </c:if>
                        </div>
                        <form action="/vote/${voteTopic.id}/candidate/${candidate.id}/add-image" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label>이미지 선택</label>
                                <input type="file" name="imageFile" accept="image/*" onchange="previewImage(this, ${candidate.id})">
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%;">이미지 업로드</button>
                        </form>
                    </div>
                </c:forEach>
            </div>
            
            <div class="action-buttons">
                <a href="/vote/${voteTopic.id}" class="btn btn-success" style="text-decoration: none;">투표 상세 보기</a>
                <a href="/" class="btn btn-secondary" style="text-decoration: none;">완료</a>
            </div>
        </div>
    </div>

    <script>
        function previewImage(input, candidateId) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = input.closest('.candidate-card').querySelector('.candidate-image-preview');
                    preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // 페이지 로드 시 이미지 새로고침 (캐시 방지)
        window.addEventListener('load', function() {
            document.querySelectorAll('.candidate-image-preview img').forEach(img => {
                if (img.src && !img.src.includes('data:')) {
                    img.src = img.src.split('?')[0] + '?t=' + new Date().getTime();
                }
            });
        });
    </script>
</body>
</html>

