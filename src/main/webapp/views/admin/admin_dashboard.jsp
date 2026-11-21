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
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;600;700&family=Montserrat:ital,wght@0,800;1,900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-abyss: #030a18;
            --card-bg: #07193d;
            --card-hover: #0b2454;
            --cyan: #00e5ff;
            --cyan-glow: rgba(0, 229, 255, 0.35);
            --border: rgba(0, 229, 255, 0.28);
            --text-main: #f4f9ff;
            --text-muted: #8fb4df;
            --danger: #ff2a55;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            background: radial-gradient(circle at 20% 15%, #0e3888 0%, #061430 48%, #020814 100%);
            color: var(--text-main);
            font-family: 'Chakra Petch', sans-serif;
        }
        .navbar-p3r {
            background: rgba(4, 14, 36, 0.95);
            border-bottom: 2px solid var(--cyan);
            box-shadow: 0 4px 20px rgba(0, 229, 255, 0.18);
            padding: 0.8rem 2rem;
        }
        .brand-logo {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 1.45rem;
            color: #fff !important;
            letter-spacing: 1.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }
        .brand-logo i, .brand-logo span { color: var(--cyan); text-shadow: 0 0 10px var(--cyan-glow); }
        .btn-logout {
            border: 1px solid var(--danger);
            color: #ff8ca3;
            font-weight: 700;
            letter-spacing: 1px;
            transition: 0.2s;
        }
        .btn-logout:hover { background: var(--danger); color: #fff; box-shadow: 0 0 14px rgba(255, 42, 85, 0.45); }
        .section-header {
            border-left: 4px solid var(--cyan);
            padding-left: 12px;
            margin-bottom: 1.5rem;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 1.1rem;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #fff;
        }
        .stat-card {
            background: linear-gradient(145deg, #0b2454, #05122b);
            border: 1px solid var(--border);
            border-left: 4px solid var(--cyan);
            border-radius: 6px;
            padding: 1.5rem;
            height: 100%;
            position: relative;
            overflow: hidden;
            transition: 0.25s;
        }
        .stat-card:hover { transform: translateY(-4px); border-color: var(--cyan); box-shadow: 0 8px 24px rgba(0, 229, 255, 0.18); }
        .stat-title { font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); font-weight: 700; margin-bottom: 0.5rem; }
        .stat-value { font-family: 'Montserrat', sans-serif; font-size: 2rem; font-weight: 900; font-style: italic; color: #fff; margin: 0; position: relative; z-index: 2; }
        .stat-value.highlight-cyan { color: var(--cyan); text-shadow: 0 0 12px var(--cyan-glow); }
        .stat-icon { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); font-size: 3.2rem; color: rgba(0, 229, 255, 0.14); pointer-events: none; transition: 0.25s; }
        .stat-card:hover .stat-icon { color: rgba(0, 229, 255, 0.28); transform: translateY(-50%) scale(1.08); }
        .btn-report-link { position: relative; z-index: 2; border: 1px solid var(--cyan); color: var(--cyan); font-size: 0.85rem; transition: 0.2s; }
        .btn-report-link:hover { background: var(--cyan); color: var(--bg-abyss); box-shadow: 0 0 12px var(--cyan-glow); }
        .module-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            padding: 2rem 1.5rem;
            text-align: center;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: 0.25s;
        }
        .module-card:hover { background: var(--card-hover); border-color: var(--cyan); transform: translateY(-5px); box-shadow: 0 10px 28px rgba(0, 0, 0, 0.55), 0 0 16px rgba(0, 229, 255, 0.2); }
        .module-icon-box {
            width: 64px; height: 64px; margin: 0 auto 1.2rem;
            background: rgba(0, 229, 255, 0.1); border: 1px solid rgba(0, 229, 255, 0.35);
            border-radius: 10px; display: flex; align-items: center; justify-content: center;
            font-size: 1.75rem; color: var(--cyan); transition: 0.25s;
        }
        .module-card:hover .module-icon-box { background: var(--cyan); color: var(--bg-abyss); box-shadow: 0 0 18px var(--cyan-glow); }
        .module-title { font-family: 'Montserrat', sans-serif; font-size: 1.15rem; font-weight: 800; font-style: italic; text-transform: uppercase; color: #fff; margin-bottom: 0.6rem; }
        .module-desc { color: var(--text-muted); font-size: 0.96rem; margin-bottom: 1.5rem; }
        .btn-p3r {
            background: linear-gradient(90deg, #00c4ff, #1858ff);
            border: none; color: #020a18; font-family: 'Montserrat', sans-serif; font-weight: 900; font-style: italic;
            letter-spacing: 1.2px; text-transform: uppercase; padding: 0.65rem 1.5rem; border-radius: 4px; width: 100%; transition: 0.2s;
        }
        .btn-p3r:hover { background: linear-gradient(90deg, #ffffff, #52f2ff); color: #020a18; box-shadow: 0 0 18px var(--cyan-glow); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-p3r">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-terminal"></i>
                REDZONE <span>ADMIN</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-light fw-semibold">
                    <i class="fa-solid fa-user-shield me-1" style="color: var(--cyan);"></i>
                    Xin chào, <strong class="text-white">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm px-3">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <h5 class="section-header">Tổng Quan Hệ Thống</h5>
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Tài Khoản</div>
                    <h2 class="stat-value">${totalUsers}</h2>
                    <i class="fa-solid fa-users stat-icon"></i>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Máy / Phòng</div>
                    <h2 class="stat-value">${totalPhong}</h2>
                    <i class="fa-solid fa-desktop stat-icon"></i>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card d-flex flex-column justify-content-center">
                    <div class="stat-title">Tổng Doanh Thu</div>
                    <h2 class="stat-value highlight-cyan">
                        <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VNĐ
                    </h2>
                    <div class="mt-2">
                        <a href="bao-cao" class="btn btn-sm btn-report-link fw-bold px-3">
                            <i class="fa-solid fa-chart-line me-1"></i> Xem chi tiết &amp; Xuất báo cáo
                        </a>
                    </div>
                    <i class="fa-solid fa-sack-dollar stat-icon"></i>
                </div>
            </div>
        </div>

        <h5 class="section-header">Trung Tâm Điều Khiển</h5>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box"><i class="fa-solid fa-user-gear"></i></div>
                        <h4 class="module-title">Quản Lý Tài Khoản</h4>
                        <p class="module-desc">Phân quyền Admin/IT, duyệt thành viên mới, khóa, mở khóa hoặc cấp lại mật khẩu.</p>
                    </div>
                    <a href="users" class="btn btn-p3r">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box"><i class="fa-solid fa-server"></i></div>
                        <h4 class="module-title">Quản Lý Phòng &amp; Máy</h4>
                        <p class="module-desc">Thêm, sửa, xóa máy trạm, cài đặt khu vực phòng và cập nhật đơn giá giờ chơi.</p>
                    </div>
                    <a href="phong-may" class="btn btn-p3r">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="module-card">
                    <div>
                        <div class="module-icon-box"><i class="fa-solid fa-utensils"></i></div>
                        <h4 class="module-title">Quản Lý Menu F&amp;B</h4>
                        <p class="module-desc">Quản lý thực đơn đồ ăn, thức uống, gói Combo khuyến mãi và số lượng tồn kho.</p>
                    </div>
                    <a href="dich-vu" class="btn btn-p3r">
                        Truy cập <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>