<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표 거부 - 관리자</title>
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
            color: #f44336;
            margin-bottom: 20px;
        }
        .vote-info {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .vote-info h3 {
            color: #333;
            margin-bottom: 10px;
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
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            font-family: inherit;
            min-height: 120px;
            resize: vertical;
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
            background: #f44336;
            color: white;
        }
        .btn-primary:hover {
            background: #d32f2f;
        }
        .btn-secondary {
            background: #757575;
            color: white;
        }
        .btn-secondary:hover {
            background: #616161;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>투표 거부</h1>
        
        <div class="vote-info">
            <h3>${topic.title}</h3>
            <p>${topic.description}</p>
        </div>
        
        <form action="/admin/topic/${topic.id}/reject" method="post">
            <div class="form-group">
                <label for="rejectReason">거부 사유 *</label>
                <textarea id="rejectReason" name="rejectReason" required placeholder="투표를 거부하는 사유를 입력해주세요."></textarea>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">거부하기</button>
                <a href="/admin" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</body>
</html>

