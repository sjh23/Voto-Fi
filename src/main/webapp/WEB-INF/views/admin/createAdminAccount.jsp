<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 계정 생성 - Voto-Fi</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .form-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }
        h1 {
            color: #1976d2;
            margin-bottom: 30px;
            text-align: center;
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
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
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
            margin-top: 10px;
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
        .info {
            background: #e3f2fd;
            color: #1976d2;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>관리자 계정 생성</h1>
        
        <div class="info">
            <strong>주의:</strong> 관리자 계정은 한 번만 생성할 수 있습니다. 
            이미 관리자 계정이 존재하는 경우 생성할 수 없습니다.
        </div>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        
        <form action="/admin/account/create" method="post">
            <div class="form-group">
                <label>사용자명 *</label>
                <input type="text" name="username" required placeholder="사용자명을 입력하세요">
            </div>
            
            <div class="form-group">
                <label>이메일 *</label>
                <input type="email" name="email" required placeholder="이메일을 입력하세요">
            </div>
            
            <div class="form-group">
                <label>비밀번호 *</label>
                <input type="password" name="password" required placeholder="비밀번호를 입력하세요">
            </div>
            
            <button type="submit" class="btn btn-primary">관리자 계정 생성</button>
            <a href="/login" class="btn btn-secondary" style="text-decoration: none; display: block; text-align: center;">로그인 페이지로</a>
        </form>
    </div>
</body>
</html>

