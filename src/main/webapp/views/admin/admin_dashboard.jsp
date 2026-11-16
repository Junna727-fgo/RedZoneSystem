<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RedZone Cyber - Admin Control Center</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-dark: #0a0a0c;
            --card-bg: #141418;
            --card-hover: #1b1b22;
            --red-primary: #ff1e27;
            --red-glow: rgba(255, 30, 39, 0.35);
            --border-color: #2a2a35;
            --text-main: #f1f1f1;
            --text-muted: #9ca3af;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            font-family: 'Rajdhani', sans-serif;
            background-image:
                radial-gradient(circle at 15% 15%, rgba(255, 30, 39, 0.08) 0%, transparent 40%),
                radial-gradient(circle at 85% 85%, rgba(255, 30, 39, 0.06) 0%, transparent 40%);
            min-height: 100vh;
        }

        /* Navbar Styling */
        .navbar-cyber {
            background-color: rgba(15, 15, 19, 0.95);
            border-bottom: 2px solid var(--red-primary);
            box-shadow: 0 4px 20px rgba(255, 30, 39, 0.2);
            padding: 0.8rem 2rem;
        }

        .brand-logo {
            font-family: 'Orbitron', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: #fff !important;
            letter-spacing: 2px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .brand-logo span {
            color: var(--red-primary);
            text-shadow: 0 0 10px var(--red-glow);
        }

        .btn-logout {
            border: 1px solid var(--red-primary);
            color: var(--red-primary);
            font-weight: 600;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            background-color: var(--red-primary);
            color: #fff;
            box-shadow: 0 0 15px var(--red-glow);
        }

        /* Section Titles */
        .section-header {
            border-left: 4px solid var(--red-primary);
            padding-left: 12px;
            margin-bottom: 1.5rem;
            font-family: 'Orbitron', sans-serif;
            font-size: 1.1rem;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #fff;
        }

        /* Stat Cards (Hàng 1) */
        .stat-card {
            background: linear-gradient(145deg, #16161c, #101014);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--red-primary);
            border-radius: 10px;
            padding: 1.5rem;
            height: 100%;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(255, 30, 39, 0.18);
            border-color: var(--red-primary);
        }

        .stat-title {
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-family: 'Orbitron', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: #fff;
            margin: 0;
        }

        .stat-value.highlight-red {
            color: var(--red-primary);
            text-shadow: 0 0 12px var(--red-glow);
        }

        .stat-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 3.2rem;
            color: rgba(255, 30, 39, 0.12);
            transition: all 0.3s ease;
            pointer-events: none;
        }

        .stat-card:hover .stat-icon {
            color: rgba(255, 30, 39, 0.25);
            transform: translateY(-50%) scale(1.1);
        }

        .btn-report-link {
            position: relative;
            z-index: 2;
            border: 1px solid var(--red-primary);
            color: var(--red-primary);
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .btn-report-link:hover {
            background-color: var(--red-primary);
            color: #fff;
            box-shadow: 0 0 12px var(--red-glow);
        }

        /* Module Action Cards (Hàng 2) */
        .module-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 2rem 1.5rem;
            text-align: center;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease;
        }

        .module-card:hover {
            background-color: var(--card-hover);
            border-color: var(--red-primary);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6), 0 0 15px rgba(255, 30, 39, 0.2);
            transform: translateY(-5px);
        }

        .module-icon-box {
            width: 65px;
            height: 65px;
            margin: 0 auto 1.2rem;
            background: rgba(255, 30, 39, 0.1);
            border: 1px solid rgba(255, 30, 39, 0.3);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--red-primary);
            transition: all 0.3s ease;
        }

        .module-card:hover .module-icon-box {
            background: var(--red-primary);
            color: #fff;
            box-shadow: 0 0 20px var(--red-glow);
        }

        .module-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.2rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 0.6rem;
        }

        .module-desc {
            color: var(--text-muted);
            font-size: 0.98rem;
            margin-bottom: 1.5rem;
        }

        .btn-cyber {
            background: linear-gradient(90deg, #d90429, #ff1e27);
            border: none;
            color: #fff;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 0.65rem 1.5rem;
            border-radius: 6px;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-cyber:hover {
            background: linear-gradient(90deg, #ff1e27, #ff4d54);
            color: #fff;
            box-shadow: 0 0 20px var(--red-glow);
        }
    </style>
</head>
<body>

    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-cyber">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-fire-flame-curved text-danger"></i>
                REDZONE <span>ADMIN</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-light fw-semibold">
                    <i class="fa-solid fa-user-shield text-danger me-1"></i>
                    Xin chào, <strong class="text-white">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm px-3">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container py-5">

        <!-- HÀNG 1: THỐNG KÊ TỔNG QUAN -->
        <h5 class="section-header">Tổng Quan Hệ Thống</h5>
        <div class="row g-4 mb-5">
            <!-- Cột 1: Tổng Tài Khoản -->
            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Tài Khoản</div>
                    <h2 class="stat-value">${totalUsers}</h2>
                    <i class="fa-solid fa-users stat-icon"></i>
                </div>
            </div>

            <!-- Cột 2: Tổng Máy / Phòng -->
            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Máy / Phòng</div>
                    <h2 class="stat-value">${totalPhong}</h2>
                    <i class="fa-solid fa-desktop stat-icon"></i>
                </div>
            </div>

            <!-- Cột 3: Tổng Doanh Thu + Nút mở Báo cáo chi tiết -->
            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Doanh Thu</div>
                    <h2 class="stat-value highlight-red">
                        <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VNĐ
                    </h2>
                    <div class="mt-2">
                        <a href="bao-cao" class="btn btn-sm btn-report-link fw-bold px-3">
                            <i class="fa-solid fa-chart-line me-1"></i> Xem chi tiết & Xuất báo cáo
                        </a>
                    </div>
                    <i class="fa-solid fa-sack-dollar stat-icon"></i>
                </div>
            </div>
        </div>

        <!-- HÀNG 2: CÁC CHỨC NĂNG QUẢN TRỊ -->
        <h5 class="section-header">Trung Tâm Điều Khiển</h5>
        <div class="row g-4">
            <!-- Module 1: Quản lý Tài Khoản -->
            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box">
                            <i class="fa-solid fa-user-gear"></i>
                        </div>
                        <h4 class="module-title">Quản Lý Tài Khoản</h4>
                        <p class="module-desc">Phân quyền Admin/IT, duyệt thành viên mới, khóa, mở khóa hoặc cấp lại mật khẩu.</p>
                    </div>
                    <a href="users" class="btn btn-cyber">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Module 2: Quản lý Phòng & Máy -->
            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box">
                            <i class="fa-solid fa-server"></i>
                        </div>
                        <h4 class="module-title">Quản Lý Phòng & Máy</h4>
                        <p class="module-desc">Thêm, sửa, xóa máy trạm, cài đặt khu vực phòng và cập nhật đơn giá giờ chơi.</p>
                    </div>
                    <a href="phong-may" class="btn btn-cyber">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Module 3: Quản lý Menu F&B & Combo -->
            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box">
                            <i class="fa-solid fa-utensils"></i>
                        </div>
                        <h4 class="module-title">Quản Lý Menu F&B</h4>
                        <p class="module-desc">Quản lý thực đơn đồ ăn, thức uống, gói Combo khuyến mãi và số lượng tồn kho.</p>
                    </div>
                    <a href="dich-vu" class="btn btn-cyber">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>