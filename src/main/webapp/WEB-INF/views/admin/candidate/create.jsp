<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 새 후보 항목 등록</title>
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
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
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
            <h1 style="color: #1976d2; margin-bottom: 30px;">새 후보 항목 등록</h1>
            
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="message">${message}</div>
            </c:if>
            
            <form action="/admin/candidate/create" method="post" enctype="multipart/form-data">
                <input type="hidden" name="voteTopicId" value="${param.topicId}">
                
                <div class="form-group">
                    <label>투표 주제</label>
                    <input type="text" value="${selectedTopicTitle}" readonly style="background: #f5f5f5;">
                </div>
                
                <div class="form-group">
                    <label>후보 이름 *</label>
                    <input type="text" name="name" required placeholder="후보 이름을 입력하세요">
                </div>
                
                <div class="form-group">
                    <label>설명</label>
                    <textarea name="description" placeholder="후보에 대한 설명을 입력하세요"></textarea>
                </div>
                
                <div class="form-group">
                    <label>후보 이미지</label>
                    <input type="file" name="imageFile" accept="image/*">
                    <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">JPG, PNG, GIF 형식만 지원됩니다. (최대 10MB)</small>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">등록</button>
                    <a href="/admin/candidate?topicId=${param.topicId}" class="btn btn-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

