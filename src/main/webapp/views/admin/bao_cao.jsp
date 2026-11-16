<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Doanh Thu Chi Tiết - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0a0a0c;
            --card-bg: #141418;
            --red-primary: #ff1e27;
            --red-glow: rgba(255, 30, 39, 0.35);
            --border-color: #2a2a35;
        }
        body {
            background-color: var(--bg-dark);
            color: #f1f1f1;
            font-family: 'Rajdhani', sans-serif;
            min-height: 100vh;
        }
        .navbar-cyber {
            background-color: #0f0f13;
            border-bottom: 2px solid var(--red-primary);
            padding: 0.8rem 2rem;
        }
        .brand-logo {
            font-family: 'Orbitron', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: #fff !important;
            letter-spacing: 2px;
        }
        .brand-logo span { color: var(--red-primary); }
        .page-title {
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            border-left: 4px solid var(--red-primary);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .stat-card {
            background: linear-gradient(145deg, #16161c, #101014);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--red-primary);
            border-radius: 10px;
            padding: 1.5rem;
        }
        .stat-value {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
        }
        .cyber-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-top: 3px solid var(--red-primary);
            border-radius: 10px;
        }
        .btn-cyber {
            background: linear-gradient(90deg, #c80d14, var(--red-primary));
            border: none;
            color: #fff;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .btn-cyber:hover {
            box-shadow: 0 0 15px var(--red-glow);
            color: #fff;
        }
        .table-cyber {
            --bs-table-bg: #141418;
            --bs-table-color: #e5e7eb;
            --bs-table-border-color: #2a2a35;
        }
        .table-cyber thead th {
            background-color: #1c1c24;
            color: var(--red-primary);
            font-family: 'Orbitron', sans-serif;
            font-size: 0.85rem;
            border-bottom: 2px solid var(--red-primary);
        }
        @media print {
            .no-print { display: none !important; }
            body { background: #fff !important; color: #000 !important; }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-cyber mb-4 no-print">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-fire-flame-curved text-danger me-2"></i>REDZONE <span>ADMIN</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <h3 class="page-title m-0">Báo Cáo Doanh Thu Tổng Kết</h3>
            <div class="no-print d-flex gap-2">
                <button onclick="exportTableToCSV('BaoCaoDoanhThu_RedZone.csv')" class="btn btn-success fw-bold">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel (CSV)
                </button>
                <button onclick="window.print()" class="btn btn-cyber fw-bold">
                    <i class="fa-solid fa-print me-1"></i> In Báo Cáo
                </button>
                <a href="dashboard" class="btn btn-outline-light">Quay lại Dashboard</a>
            </div>
        </div>

        <!-- 3 Thẻ phân tích cơ cấu doanh thu -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="text-secondary fw-bold text-uppercase mb-1">Doanh Thu Giờ Chơi / Nạp Ví</div>
                    <div class="stat-value text-info">
                        <fmt:formatNumber value="${doanhThuNap}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="text-secondary fw-bold text-uppercase mb-1">Doanh Thu Dịch Vụ F&B</div>
                    <div class="stat-value text-warning">
                        <fmt:formatNumber value="${doanhThuFnB}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="text-secondary fw-bold text-uppercase mb-1">Tổng Doanh Thu Thực Nhận</div>
                    <div class="stat-value text-danger">
                        <fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng chi tiết các giao dịch doanh thu -->
        <div class="cyber-card overflow-hidden">
            <div class="p-3 border-bottom border-secondary d-flex justify-content-between align-items-center">
                <h5 class="m-0 fw-bold text-white"><i class="fa-solid fa-list-check text-danger me-2"></i>Chi Tiết Giao Dịch & Hóa Đơn</h5>
            </div>
            <div class="table-responsive">
                <table id="reportTable" class="table table-cyber table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Khách Hàng</th>
                            <th>Nguồn Doanh Thu</th>
                            <th>Số Tiền</th>
                            <th>Thời Gian</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="gd" items="${listGiaoDich}">
                            <tr>
                                <td class="fw-bold text-secondary">#${gd.maGD}</td>
                                <td class="fw-bold text-white">${gd.khachHang}</td>
                                <td>
                                    <span class="badge ${gd.loaiDoanhThu == 'Dịch vụ F&B' ? 'bg-warning text-dark' : 'bg-info text-dark'}">
                                        ${gd.loaiDoanhThu}
                                    </span>
                                </td>
                                <td class="fw-bold text-success">+<fmt:formatNumber value="${gd.soTien}" maxFractionDigits="0"/> VNĐ</td>
                                <td class="text-muted">${gd.thoiGian}</td>
                                <td><span class="badge bg-success">${gd.trangThai}</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listGiaoDich}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Chưa có phát sinh giao dịch doanh thu nào trong hệ thống.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function exportTableToCSV(filename) {
            var csv = [];
            var rows = document.querySelectorAll("#reportTable tr");
            for (var i = 0; i < rows.length; i++) {
                var row = [], cols = rows[i].querySelectorAll("td, th");
                for (var j = 0; j < cols.length; j++) {
                    row.push('"' + cols[j].innerText.replace(/(\r\n|\n|\r)/gm, "").trim() + '"');
                }
                csv.push(row.join(","));
            }
            var csvFile = new Blob(["\uFEFF" + csv.join("\n")], {type: "text/csv;charset=utf-8;"});
            var downloadLink = document.createElement("a");
            downloadLink.download = filename;
            downloadLink.href = window.URL.createObjectURL(csvFile);
            downloadLink.style.display = "none";
            document.body.appendChild(downloadLink);
            downloadLink.click();
        }
    </script>
</body>
</html>