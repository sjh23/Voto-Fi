<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${voteTopic.title} - 최종 결과</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .title-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }
        .title-section h1 {
            color: #1976d2;
            font-size: 32px;
            margin-bottom: 10px;
        }
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        .chart-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .chart-container h2 {
            color: #1976d2;
            margin-bottom: 20px;
            text-align: center;
        }
        .ranking-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .ranking-section h2 {
            color: #1976d2;
            margin-bottom: 20px;
        }
        .ranking-item {
            display: flex;
            align-items: center;
            padding: 20px;
            margin-bottom: 15px;
            background: #f9f9f9;
            border-radius: 8px;
        }
        .rank-number {
            font-size: 24px;
            font-weight: bold;
            color: #ff9800;
            width: 50px;
            text-align: center;
        }
        .candidate-photo {
            width: 60px;
            height: 60px;
            background: #ddd;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 20px;
            color: #999;
            font-size: 12px;
        }
        .candidate-info {
            flex: 1;
        }
        .candidate-name {
            font-size: 20px;
            font-weight: 500;
            color: #333;
            margin-bottom: 5px;
        }
        .candidate-votes {
            color: #666;
            font-size: 14px;
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
        <div class="title-section">
            <h1>${voteTopic.title} 최종 결과</h1>
            <p>총 투표수: <strong>${totalVotes}</strong>표</p>
        </div>

        <div class="charts-section">
            <div class="chart-container">
                <h2>득표수 (막대 그래프)</h2>
                <canvas id="barChart"></canvas>
            </div>
            <div class="chart-container">
                <h2>득표율 (원형 그래프)</h2>
                <canvas id="pieChart"></canvas>
            </div>
        </div>

        <div class="ranking-section">
            <h2>순위</h2>
            <c:forEach var="candidate" items="${candidates}" varStatus="status">
                <div class="ranking-item">
                    <div class="rank-number">${status.count}</div>
                    <div class="candidate-photo">사진</div>
                    <div class="candidate-info">
                        <div class="candidate-name">${candidate.name}</div>
                        <div class="candidate-votes">
                            ${candidate.voteCount}표 
                            (<fmt:formatNumber value="${candidate.votePercentage}" pattern="#.##" />%)
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script>
        // 차트 데이터 준비
        const candidates = [
            <c:forEach var="candidate" items="${candidates}" varStatus="status">
            {
                name: '${candidate.name}',
                votes: ${candidate.voteCount},
                percentage: ${candidate.votePercentage}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const labels = candidates.map(c => c.name);
        const votes = candidates.map(c => c.votes);
        const percentages = candidates.map(c => c.percentage);

        // 막대 그래프
        const barCtx = document.getElementById('barChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '득표수',
                    data: votes,
                    backgroundColor: [
                        'rgba(25, 118, 210, 0.8)',
                        'rgba(76, 175, 80, 0.8)',
                        'rgba(255, 152, 0, 0.8)',
                        'rgba(156, 39, 176, 0.8)'
                    ],
                    borderColor: [
                        'rgba(25, 118, 210, 1)',
                        'rgba(76, 175, 80, 1)',
                        'rgba(255, 152, 0, 1)',
                        'rgba(156, 39, 176, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // 원형 그래프
        const pieCtx = document.getElementById('pieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: percentages,
                    backgroundColor: [
                        'rgba(25, 118, 210, 0.8)',
                        'rgba(76, 175, 80, 0.8)',
                        'rgba(255, 152, 0, 0.8)',
                        'rgba(156, 39, 176, 0.8)'
                    ],
                    borderColor: [
                        'rgba(25, 118, 210, 1)',
                        'rgba(76, 175, 80, 1)',
                        'rgba(255, 152, 0, 1)',
                        'rgarta(156, 39, 176, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.parsed + '%';
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>

