<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.redzone.dao.PhongMayDAO" %>
<%@ page import="com.redzone.model.PhongMay" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Lấy số liệu thực tế trạng thái các máy trạm từ SQL Server để vẽ biểu đồ chính xác 100%
    int countAvailable = 0;
    int countInUse = 0;
    int countMaintenance = 0;
    try {
        PhongMayDAO pmDao = new PhongMayDAO();
        List<PhongMay> listMay = pmDao.getAllPhongMay();
        if (listMay != null) {
            for (PhongMay m : listMay) {
                if ("AVAILABLE".equalsIgnoreCase(m.getTrangThai())) {
                    countAvailable++;
                } else if ("IN_USE".equalsIgnoreCase(m.getTrangThai())) {
                    countInUse++;
                } else {
                    countMaintenance++;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RedZone Admin - Control Center</title>
    <!-- Bootstrap 5, FontAwesome, Google Fonts & Chart.js -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --bg-main: #060b19;
            --bg-sidebar: #081026;
            --bg-card: #0b1633;
            --bg-topbar: #070e21;
            --cyan-primary: #00d2ff;
            --blue-accent: #0077ff;
            --cyan-glow: rgba(0, 210, 255, 0.35);
            --border-color: rgba(0, 210, 255, 0.22);
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
        }

        * {
            box-sizing: border-box;
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-main);
            font-family: 'Rajdhani', sans-serif;
            margin: 0;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ================= SIDEBAR (BÊN TRÁI) ================= */
        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #091533 0%, #050b1c 100%);
            border-right: 1px solid var(--border-color);
            box-shadow: 4px 0 25px rgba(0, 0, 0, 0.6);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 1000;
        }

        .sidebar-brand {
            padding: 1.4rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
            font-family: 'Orbitron', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            color: #fff;
            text-decoration: none;
            letter-spacing: 1.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-brand i {
            color: var(--cyan-primary);
            text-shadow: 0 0 10px var(--cyan-glow);
        }

        .sidebar-brand span {
            color: var(--cyan-primary);
        }

        .sidebar-menu {
            list-style: none;
            padding: 1.2rem 0.9rem;
            margin: 0;
            flex: 1;
        }

        .sidebar-item {
            margin-bottom: 0.45rem;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 0.85rem 1.1rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 700;
            font-size: 1.02rem;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            border-radius: 8px;
            transition: all 0.25s ease;
        }

        .sidebar-link i {
            width: 22px;
            text-align: center;
            font-size: 1.15rem;
        }

        .sidebar-link:hover {
            color: #fff;
            background: rgba(0, 210, 255, 0.1);
        }

        .sidebar-link.active {
            background: linear-gradient(90deg, rgba(0, 210, 255, 0.25), rgba(0, 119, 255, 0.12));
            color: #fff;
            border-left: 4px solid var(--cyan-primary);
            box-shadow: 0 0 15px rgba(0, 210, 255, 0.15);
        }

        .sidebar-link.active i {
            color: var(--cyan-primary);
        }

        /* ================= MAIN PANEL (BÊN PHẢI) ================= */
        .main-panel {
            flex: 1;
            margin-left: 260px;
            display: flex;
            flex-direction: column;
            background-image:
                radial-gradient(circle at 80% 15%, rgba(0, 210, 255, 0.08) 0%, transparent 45%),
                radial-gradient(circle at 20% 85%, rgba(0, 119, 255, 0.08) 0%, transparent 45%);
        }

        /* Topbar */
        .topbar {
            height: 68px;
            background-color: rgba(7, 14, 33, 0.92);
            border-bottom: 1px solid var(--border-color);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
            backdrop-filter: blur(8px);
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }

        .topbar-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.15rem;
            font-weight: 700;
            margin: 0;
            color: #fff;
            letter-spacing: 1px;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }

        .btn-logout-cyber {
            border: 1px solid #ff3b5c;
            color: #ff5c77;
            font-weight: 700;
            padding: 0.35rem 0.9rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.92rem;
            transition: all 0.25s ease;
        }

        .btn-logout-cyber:hover {
            background: #ff3b5c;
            color: #fff;
            box-shadow: 0 0 12px rgba(255, 59, 92, 0.45);
        }

        /* Content Area */
        .content-wrapper {
            padding: 1.8rem 2rem;
        }

        /* Thẻ thống kê nhanh trên cùng */
        .mini-stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 1.2rem 1.4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.25s ease, border-color 0.25s ease;
        }

        .mini-stat-card:hover {
            transform: translateY(-3px);
            border-color: var(--cyan-primary);
            box-shadow: 0 6px 20px rgba(0, 210, 255, 0.15);
        }

        .mini-stat-label {
            font-size: 0.9rem;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 700;
            letter-spacing: 0.8px;
        }

        .mini-stat-val {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            color: #fff;
            margin: 0.2rem 0 0;
        }

        .mini-stat-icon {
            font-size: 2.2rem;
            color: var(--cyan-primary);
            opacity: 0.75;
        }

        /* Các Card Biểu Đồ & Danh Sách Công Việc */
        .dashboard-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.45);
        }

        .card-header-custom {
            margin-bottom: 1rem;
        }

        .card-title-custom {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.05rem;
            font-weight: 700;
            color: #fff;
            margin: 0;
        }

        .card-subtitle-custom {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        .card-footer-custom {
            margin-top: 1rem;
            padding-top: 0.75rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            font-size: 0.88rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Khối Tasks / Tác vụ quản trị */
        .task-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .task-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 0.6rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
            transition: background 0.2s;
        }

        .task-item:hover {
            background: rgba(0, 210, 255, 0.06);
            border-radius: 6px;
        }

        .task-item:last-child {
            border-bottom: none;
        }

        .task-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .task-checkbox {
            accent-color: var(--cyan-primary);
            width: 17px;
            height: 17px;
            cursor: pointer;
        }

        .task-text {
            font-size: 1rem;
            font-weight: 600;
            color: #e2e8f0;
        }

        .task-actions a {
            color: var(--cyan-primary);
            margin-left: 10px;
            font-size: 0.95rem;
            text-decoration: none;
        }

        .task-actions a:hover {
            color: #fff;
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 75px;
            }
            .sidebar-brand span, .sidebar-link span {
                display: none;
            }
            .main-panel {
                margin-left: 75px;
            }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- SIDEBAR BÊN TRÁI -->
    <aside class="sidebar">
        <a href="dashboard" class="sidebar-brand">
            <i class="fa-solid fa-terminal"></i>
            <div>REDZONE <span>ADMIN</span></div>
        </a>

        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="dashboard" class="sidebar-link active">
                    <i class="fa-solid fa-chart-pie"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="users" class="sidebar-link">
                    <i class="fa-solid fa-users-gear"></i>
                    <span>Quản Lý Tài Khoản</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="phong-may" class="sidebar-link">
                    <i class="fa-solid fa-desktop"></i>
                    <span>Phòng &amp; Máy Trạm</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="dich-vu" class="sidebar-link">
                    <i class="fa-solid fa-utensils"></i>
                    <span>Menu F&amp;B &amp; Combo</span>
                    <li class="sidebar-item">
                        <a href="tin-nhan" class="sidebar-link">
                            <i class="fa-solid fa-headset"></i>
                            <span>Tin Nhắn Khách</span>
                            <% int unreadMsg = com.redzone.util.TinNhanStore.countUnread(); %>
                            <% if (unreadMsg > 0) { %>
                                <span class="badge bg-danger ms-auto"><%= unreadMsg %></span>
                            <% } %>
                        </a>
                    </li>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="bao-cao" class="sidebar-link">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <span>Doanh Thu &amp; Báo Cáo</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/profile.jsp" class="sidebar-link">
                    <i class="fa-solid fa-id-badge"></i>
                    <span>Hồ Sơ Cá Nhân</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- MAIN PANEL BÊN PHẢI -->
    <div class="main-panel">
        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1 class="topbar-title">Dashboard</h1>
                <span class="badge bg-info text-dark fw-bold">
                    <i class="fa-solid fa-signal me-1"></i> Hệ thống Online
                </span>
            </div>

            <div class="topbar-right">
                <span class="text-light fw-semibold">
                    <i class="fa-solid fa-user-shield text-info me-1"></i>
                    Xin chào, <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Đặng Trần Gia Huy'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout-cyber">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </header>

        <!-- NỘI DUNG CHÍNH -->
        <div class="content-wrapper">

            <!-- Hàng chỉ số tổng quan nhanh -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Tổng Tài Khoản</div>
                            <div class="mini-stat-val">${totalUsers}</div>
                        </div>
                        <i class="fa-solid fa-users mini-stat-icon"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Tổng Máy / Phòng</div>
                            <div class="mini-stat-val"><%= countAvailable + countInUse + countMaintenance %></div>
                        </div>
                        <i class="fa-solid fa-computer mini-stat-icon"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Tổng Doanh Thu</div>
                            <div class="mini-stat-val text-info">
                                <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VNĐ
                            </div>
                        </div>
                        <i class="fa-solid fa-sack-dollar mini-stat-icon"></i>
                    </div>
                </div>
            </div>

            <!-- HÀNG 1: BIỂU ĐỒ TRÒN TỶ LỆ MÁY + BIỂU ĐỒ MIỀN LƯỢNG KHÁCH -->
            <div class="row g-4 mb-4">
                <!-- Khối 1 (Trái - 4 cột): Tỷ lệ trạng thái phòng máy -->
                <div class="col-lg-4">
                    <div class="dashboard-card">
                        <div class="card-header-custom">
                            <h5 class="card-title-custom">Tình Trạng Máy Trạm</h5>
                            <div class="card-subtitle-custom">Phân bổ trạng thái phòng máy hiện tại</div>
                        </div>
                        <div style="height: 230px; display: flex; justify-content: center;">
                            <canvas id="machinePieChart"></canvas>
                        </div>
                        <div class="card-footer-custom">
                            <span><i class="fa-regular fa-clock me-1"></i> Cập nhật thời gian thực</span>
                            <a href="phong-may" class="text-info text-decoration-none fw-bold">Chi tiết →</a>
                        </div>
                    </div>
                </div>

                <!-- Khối 2 (Phải - 8 cột): Lưu lượng người chơi 24h -->
                <div class="col-lg-8">
                    <div class="dashboard-card">
                        <div class="card-header-custom">
                            <h5 class="card-title-custom">Lưu Lượng Truy Cập Phòng Game</h5>
                            <div class="card-subtitle-custom">Thống kê lượt hội viên và khách vãng lai trong 24 giờ</div>
                        </div>
                        <div style="height: 230px;">
                            <canvas id="trafficAreaChart"></canvas>
                        </div>
                        <div class="card-footer-custom">
                            <span><i class="fa-solid fa-rotate me-1"></i> Dữ liệu đồng bộ từ hệ thống máy trạm</span>
                            <a href="users" class="text-info text-decoration-none fw-bold">Quản lý hội viên →</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- HÀNG 2: BIỂU ĐỒ CỘT DOANH THU + DANH SÁCH TÁC VỤ QUẢN TRỊ -->
            <div class="row g-4">
                <!-- Khối 3 (Trái - 6 cột): Biểu đồ cột doanh thu Giờ chơi & F&B -->
                <div class="col-lg-6">
                    <div class="dashboard-card">
                        <div class="card-header-custom">
                            <h5 class="card-title-custom">Doanh Thu Giờ Chơi &amp; Dịch Vụ F&amp;B</h5>
                            <div class="card-subtitle-custom">So sánh nguồn thu theo tháng (Triệu VNĐ)</div>
                        </div>
                        <div style="height: 240px;">
                            <canvas id="revenueBarChart"></canvas>
                        </div>
                        <div class="card-footer-custom">
                            <span><i class="fa-solid fa-check-circle text-info me-1"></i> Đã bao gồm gói Combo khuyến mãi</span>
                            <a href="bao-cao" class="text-info text-decoration-none fw-bold">Xuất báo cáo →</a>
                        </div>
                    </div>
                </div>

                <!-- Khối 4 (Phải - 6 cột): Tác vụ điều hành nhanh (Tasks) -->
                <div class="col-lg-6">
                    <div class="dashboard-card">
                        <div class="card-header-custom d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title-custom">Tác Vụ Quản Trị Hệ Thống</h5>
                                <div class="card-subtitle-custom">Phím tắt xử lý nhanh các nghiệp vụ Admin</div>
                            </div>
                            <span class="badge bg-primary">4 Module</span>
                        </div>

                        <ul class="task-list">
                            <li class="task-item">
                                <div class="task-left">
                                    <input type="checkbox" class="task-checkbox" checked>
                                    <span class="task-text">Duyệt tài khoản hội viên mới &amp; Phân quyền Admin / IT</span>
                                </div>
                                <div class="task-actions">
                                    <a href="users" title="Truy cập"><i class="fa-solid fa-pen-to-square"></i></a>
                                </div>
                            </li>
                            <li class="task-item">
                                <div class="task-left">
                                    <input type="checkbox" class="task-checkbox" checked>
                                    <span class="task-text">Cấu hình khu vực phòng (Standard, VIP) &amp; Đơn giá giờ chơi</span>
                                </div>
                                <div class="task-actions">
                                    <a href="phong-may" title="Truy cập"><i class="fa-solid fa-pen-to-square"></i></a>
                                </div>
                            </li>
                            <li class="task-item">
                                <div class="task-left">
                                    <input type="checkbox" class="task-checkbox">
                                    <span class="task-text">Cập nhật thực đơn F&amp;B, tồn kho và tạo Combo khuyến mãi</span>
                                </div>
                                <div class="task-actions">
                                    <a href="dich-vu" title="Truy cập"><i class="fa-solid fa-pen-to-square"></i></a>
                                </div>
                            </li>
                            <li class="task-item">
                                <div class="task-left">
                                    <input type="checkbox" class="task-checkbox">
                                    <span class="task-text">Kiểm tra đối soát doanh thu &amp; Xuất báo cáo tổng kết Excel</span>
                                </div>
                                <div class="task-actions">
                                    <a href="bao-cao" title="Truy cập"><i class="fa-solid fa-pen-to-square"></i></a>
                                </div>
                            </li>
                        </ul>

                        <div class="card-footer-custom">
                            <span><i class="fa-solid fa-shield-halved text-info me-1"></i> Quyền quản trị cao nhất (Admin)</span>
                            <a href="bao-cao" class="text-info text-decoration-none fw-bold">Xem chi tiết →</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Script vẽ 3 biểu đồ đồng bộ tông màu Xanh Dương Neon -->
<script>
    Chart.defaults.color = '#94a3b8';
    Chart.defaults.font.family = "'Rajdhani', sans-serif";

    // 1. Pie Chart: Tình trạng máy trạm (Dữ liệu thật từ Database)
    new Chart(document.getElementById('machinePieChart'), {
        type: 'pie',
        data: {
            labels: ['Sẵn sàng', 'Đang chơi', 'Bảo trì'],
            datasets: [{
                data: [<%= countAvailable %>, <%= countInUse %>, <%= countMaintenance %>],
                backgroundColor: ['#00d2ff', '#0066ff', '#ff4757'],
                borderColor: '#0b1633',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { padding: 15, font: { size: 13, weight: 'bold' } } }
            }
        }
    });

    // 2. Area Chart: Lưu lượng truy cập 24h
    new Chart(document.getElementById('trafficAreaChart'), {
        type: 'line',
        data: {
            labels: ['9:00AM', '12:00PM', '3:00PM', '6:00PM', '9:00PM', '12:00AM', '3:00AM', '6:00AM'],
            datasets: [
                {
                    label: 'Hội viên (Member)',
                    data: [25, 45, 55, 72, 88, 65, 40, 20],
                    borderColor: '#00d2ff',
                    backgroundColor: 'rgba(0, 210, 255, 0.25)',
                    fill: true,
                    tension: 0.4
                },
                {
                    label: 'Khách vãng lai',
                    data: [10, 20, 28, 35, 42, 30, 15, 8],
                    borderColor: '#0066ff',
                    backgroundColor: 'rgba(0, 102, 255, 0.25)',
                    fill: true,
                    tension: 0.4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.06)' }, beginAtZero: true },
                x: { grid: { display: false } }
            },
            plugins: {
                legend: { position: 'bottom', labels: { font: { size: 13, weight: 'bold' } } }
            }
        }
    });

    // 3. Bar Chart: Doanh thu Giờ chơi & F&B
    new Chart(document.getElementById('revenueBarChart'), {
        type: 'bar',
        data: {
            labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
            datasets: [
                {
                    label: 'Tiền giờ chơi',
                    data: [42, 38, 35, 58, 49, 44, 39, 46, 52, 56, 68, 75],
                    backgroundColor: '#00d2ff',
                    borderRadius: 4
                },
                {
                    label: 'Dịch vụ F&B',
                    data: [28, 22, 25, 40, 34, 30, 26, 32, 36, 41, 50, 58],
                    backgroundColor: '#0066ff',
                    borderRadius: 4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.06)' }, beginAtZero: true },
                x: { grid: { display: false } }
            },
            plugins: {
                legend: { position: 'bottom', labels: { font: { size: 13, weight: 'bold' } } }
            }
        }
    });
</script>

</body>
</html>