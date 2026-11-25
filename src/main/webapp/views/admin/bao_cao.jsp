<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu &amp; Báo Cáo Tổng Hợp - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-override.css">
    <style>
        :root {
            --bg-abyss: #030a18;
            --card-bg: #07193d;
            --cyan: #00e5ff;
            --cyan-glow: rgba(0, 229, 255, 0.35);
            --border: rgba(0, 229, 255, 0.28);
            --muted: #8fb4df;
        }
        body {
            min-height: 100vh;
            background: radial-gradient(circle at 20% 15%, #0e3888 0%, #061430 48%, #020814 100%);
            color: #f4f9ff;
        }
        .navbar-p3r {
            background: rgba(4, 14, 36, 0.95);
            border-bottom: 2px solid var(--cyan);
            box-shadow: 0 4px 20px rgba(0, 229, 255, 0.18);
            padding: 0.8rem 2rem;
        }
        .brand-logo {
            font-weight: 900;
            font-style: italic;
            font-size: 1.4rem;
            color: #fff !important;
            letter-spacing: 1px;
            text-decoration: none;
        }
        .brand-logo i, .brand-logo span { color: var(--cyan); }
        .page-title {
            font-weight: 900;
            font-style: italic;
            border-left: 4px solid var(--cyan);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .btn-back { border: 1px solid var(--cyan); color: var(--cyan); font-weight: 700; }
        .btn-back:hover { background: var(--cyan); color: var(--bg-abyss); }
        .btn-p3r {
            background: linear-gradient(90deg, #00c4ff, #1858ff);
            border: none;
            color: #020a18;
            font-weight: 900;
            font-style: italic;
            text-transform: uppercase;
        }
        .btn-p3r:hover {
            background: linear-gradient(90deg, #fff, #52f2ff);
            color: #020a18;
            box-shadow: 0 0 16px var(--cyan-glow);
        }
        .p3r-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.55);
        }
        .kpi-box {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-left: 4px solid var(--cyan);
            border-radius: 8px;
            padding: 1.2rem;
            height: 100%;
        }
        .kpi-val {
            font-weight: 800;
            font-size: 1.45rem;
            margin-top: 4px;
        }
        .table-p3r {
            --bs-table-bg: #07193d;
            --bs-table-color: #e6f2ff;
            --bs-table-border-color: rgba(143, 180, 223, 0.18);
            --bs-table-striped-bg: #091f4a;
            --bs-table-hover-bg: rgba(0, 229, 255, 0.1);
        }
        .table-p3r thead th {
            background: #0d327d;
            color: var(--cyan);
            font-weight: 800;
            font-size: 0.82rem;
            text-transform: uppercase;
            border-bottom: 2px solid var(--cyan);
            padding: 0.9rem 0.75rem;
        }
        .table-p3r td { vertical-align: middle; padding: 0.85rem 0.75rem; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-p3r mb-4">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-terminal me-2"></i>REDZONE <span>ADMIN</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm fw-bold">
                <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
            <h3 class="page-title m-0">Đối Soát Doanh Thu &amp; Báo Cáo Tổng Hợp</h3>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/bao-cao?action=export" class="btn btn-p3r px-3">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Báo Cáo Excel (.CSV)
                </a>
                <a href="dashboard" class="btn btn-back px-3">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
                </a>
            </div>
        </div>

        <!-- 4 THẺ CHỈ SỐ TÀI CHÍNH THỰC TẾ -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="kpi-box">
                    <div class="small text-uppercase fw-bold" style="color: var(--muted);">Nạp Tiền Giờ Chơi</div>
                    <div class="kpi-val text-info">
                        <fmt:formatNumber value="${revTopUp}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="kpi-box">
                    <div class="small text-uppercase fw-bold" style="color: var(--muted);">Doanh Thu F&amp;B + Gear</div>
                    <div class="kpi-val text-white">
                        <fmt:formatNumber value="${revFnb + revGear}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="kpi-box" style="border-left-color: #ff4757;">
                    <div class="small text-uppercase fw-bold" style="color: var(--muted);">Chi Phí Bảo Trì (IT)</div>
                    <div class="kpi-val text-danger">
                        -<fmt:formatNumber value="${maintenanceCost}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="kpi-box" style="border-left-color: #00e676;">
                    <div class="small text-uppercase fw-bold" style="color: var(--muted);">Lợi Nhuận Ròng Thực Tế</div>
                    <div class="kpi-val text-success">
                        <fmt:formatNumber value="${netProfit}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
        </div>

        <!-- BIỂU ĐỒ CƠ CẤU NGUỒN THU + TỔNG KẾT -->
        <div class="row g-4 mb-4">
            <div class="col-lg-5">
                <div class="p3r-card p-4 h-100">
                    <h5 class="fw-bold text-white mb-3">
                        <i class="fa-solid fa-chart-pie me-2" style="color: var(--cyan);"></i>Cơ Cấu Doanh Thu Hệ Thống
                    </h5>
                    <div style="height: 220px;">
                        <canvas id="revSplitChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="p3r-card p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <h5 class="fw-bold text-white mb-3">
                            <i class="fa-solid fa-scale-balanced me-2" style="color: var(--cyan);"></i>Bảng Đối Soát Liên Thông 3 Bộ Phận
                        </h5>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item bg-transparent text-light d-flex justify-content-between border-secondary">
                                <span><i class="fa-solid fa-wallet text-info me-2"></i>1. Nạp tiền giờ chơi (Member yêu cầu &rarr; Admin duyệt):</span>
                                <strong class="text-info"><fmt:formatNumber value="${revTopUp}" maxFractionDigits="0"/> VNĐ</strong>
                            </li>
                            <li class="list-group-item bg-transparent text-light d-flex justify-content-between border-secondary">
                                <span><i class="fa-solid fa-utensils text-warning me-2"></i>2. Dịch vụ ăn uống F&amp;B (Member đặt &rarr; IT phục vụ):</span>
                                <strong class="text-warning"><fmt:formatNumber value="${revFnb}" maxFractionDigits="0"/> VNĐ</strong>
                            </li>
                            <li class="list-group-item bg-transparent text-light d-flex justify-content-between border-secondary">
                                <span><i class="fa-solid fa-headset text-primary me-2"></i>3. Cho thuê Gaming Gear (Member thuê &rarr; IT giao máy):</span>
                                <strong class="text-primary"><fmt:formatNumber value="${revGear}" maxFractionDigits="0"/> VNĐ</strong>
                            </li>
                            <li class="list-group-item bg-transparent text-light d-flex justify-content-between border-0">
                                <span><i class="fa-solid fa-screwdriver-wrench text-danger me-2"></i>4. Chi phí sửa chữa / bảo trì linh kiện (IT lập biên bản):</span>
                                <strong class="text-danger">-<fmt:formatNumber value="${maintenanceCost}" maxFractionDigits="0"/> VNĐ</strong>
                            </li>
                        </ul>
                    </div>
                    <div class="p-3 rounded mt-3 d-flex justify-content-between align-items-center" style="background: rgba(0, 229, 255, 0.1); border: 1px solid var(--cyan);">
                        <span class="fw-bold text-uppercase">Tổng Doanh Thu Thực Thu:</span>
                        <span class="fs-4 fw-bold" style="color: var(--cyan);">
                            <fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0"/> VNĐ
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- BẢNG LỊCH SỬ GIAO DỊCH CHI TIẾT -->
        <div class="p3r-card overflow-hidden">
            <div class="p-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: var(--border) !important;">
                <h5 class="fw-bold m-0 text-white">
                    <i class="fa-solid fa-clock-rotate-left me-2 text-info"></i>Nhật Ký Giao Dịch Toàn Hệ Thống
                </h5>
                <span class="small" style="color: var(--muted);">Hiển thị 50 giao dịch gần nhất</span>
            </div>
            <div class="table-responsive">
                <table class="table table-p3r table-striped table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Hội Viên</th>
                            <th>Máy Trạm</th>
                            <th>Nội Dung Giao Dịch</th>
                            <th>Phân Loại</th>
                            <th>Số Tiền</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tx" items="${transactions}">
                            <tr>
                                <td class="fw-bold text-info">#${tx.orderId}</td>
                                <td class="fw-bold text-white">${tx.customerName}</td>
                                <td><span class="badge bg-primary">${tx.machineCode}</span></td>
                                <td class="text-white">${tx.itemName} (x${tx.quantity})</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.category == 'TOPUP'}"><span class="badge bg-info text-dark">NẠP TIỀN</span></c:when>
                                        <c:when test="${tx.category == 'GEAR'}"><span class="badge bg-primary">THUÊ GEAR</span></c:when>
                                        <c:otherwise><span class="badge bg-warning text-dark">F&amp;B</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold text-success">
                                    +<fmt:formatNumber value="${tx.amount}" maxFractionDigits="0"/> VNĐ
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.status == 'APPROVED' || tx.status == 'COMPLETED'}">
                                            <span class="badge bg-success">Hoàn tất</span>
                                        </c:when>
                                        <c:when test="${tx.status == 'PENDING' || tx.status == 'SERVING'}">
                                            <span class="badge bg-warning text-dark">Đang xử lý</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${tx.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactions}">
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Chưa phát sinh giao dịch nào trong hệ thống.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        Chart.defaults.color = '#8fb4df';
        Chart.defaults.font.family = "'Plus Jakarta Sans', sans-serif";
        new Chart(document.getElementById('revSplitChart'), {
            type: 'doughnut',
            data: {
                labels: ['Nạp giờ chơi', 'Dịch vụ F&B', 'Thuê Gaming Gear'],
                datasets: [{
                    data: [${revTopUp}, ${revFnb}, ${revGear}],
                    backgroundColor: ['#00e5ff', '#ffca28', '#388bff'],
                    borderColor: '#07193d',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom', labels: { font: { size: 13, weight: 'bold' } } }
                }
            }
        });
    </script>
</body>
</html>