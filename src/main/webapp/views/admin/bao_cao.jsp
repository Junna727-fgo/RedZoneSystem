<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu Chi Tiết - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;600;700&family=Montserrat:ital,wght@0,800;1,900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-abyss: #030a18;
            --card-bg: #07193d;
            --cyan: #00e5ff;
            --cyan-glow: rgba(0, 229, 255, 0.35);
            --border: rgba(0, 229, 255, 0.28);
            --muted: #8fb4df;
            --success: #00f5a0;
        }
        body {
            min-height: 100vh;
            background: radial-gradient(circle at 20% 15%, #0e3888 0%, #061430 48%, #020814 100%);
            color: #f4f9ff;
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
            font-size: 1.4rem;
            color: #fff !important;
            letter-spacing: 1.5px;
            text-decoration: none;
        }
        .brand-logo i, .brand-logo span { color: var(--cyan); }
        .page-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            letter-spacing: 1.5px;
            border-left: 4px solid var(--cyan);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .btn-back { border: 1px solid var(--cyan); color: var(--cyan); font-weight: 700; }
        .btn-back:hover { background: var(--cyan); color: var(--bg-abyss); }
        .stat-card {
            background: linear-gradient(145deg, #0b2454, #05122b);
            border: 1px solid var(--border);
            border-left: 4px solid var(--cyan);
            border-radius: 8px;
            padding: 1.5rem;
            height: 100%;
            transition: 0.25s;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            border-color: var(--cyan);
            box-shadow: 0 8px 24px rgba(0, 229, 255, 0.16);
        }
        .stat-label {
            color: var(--muted);
            font-size: 0.9rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-value {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.85rem;
            font-weight: 900;
            font-style: italic;
        }
        .p3r-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.55);
        }
        .btn-p3r {
            background: linear-gradient(90deg, #00c4ff, #1858ff);
            border: none;
            color: #020a18;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        .btn-p3r:hover {
            background: linear-gradient(90deg, #fff, #52f2ff);
            color: #020a18;
            box-shadow: 0 0 16px var(--cyan-glow);
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
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-style: italic;
            font-size: 0.82rem;
            text-transform: uppercase;
            border-bottom: 2px solid var(--cyan);
            padding: 0.9rem 0.75rem;
        }
        .table-p3r td { vertical-align: middle; padding: 0.85rem 0.75rem; }
        @media print {
            .no-print { display: none !important; }
            body, .stat-card, .p3r-card, .table-p3r {
                background: #fff !important;
                color: #000 !important;
                box-shadow: none !important;
            }
            .table-p3r thead th, .table-p3r td, .stat-value, .stat-label {
                color: #000 !important;
                background: #fff !important;
                border-color: #ccc !important;
            }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-p3r mb-4 no-print">
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
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <h3 class="page-title m-0">Báo Cáo Doanh Thu Tổng Kết</h3>
            <div class="no-print d-flex flex-wrap gap-2">
                <button onclick="exportTableToCSV('BaoCaoDoanhThu_RedZone.csv')" class="btn btn-success fw-bold">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel (CSV)
                </button>
                <button onclick="window.print()" class="btn btn-p3r fw-bold">
                    <i class="fa-solid fa-print me-1"></i> In Báo Cáo
                </button>
                <a href="dashboard" class="btn btn-back px-3">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
                </a>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-label mb-1">Doanh Thu Giờ Chơi / Nạp Ví</div>
                    <div class="stat-value text-info">
                        <fmt:formatNumber value="${doanhThuNap}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-label mb-1">Doanh Thu Dịch Vụ F&amp;B</div>
                    <div class="stat-value text-warning">
                        <fmt:formatNumber value="${doanhThuFnB}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-label mb-1">Tổng Doanh Thu Thực Nhận</div>
                    <div class="stat-value" style="color: var(--cyan); text-shadow: 0 0 12px var(--cyan-glow);">
                        <fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0"/> VNĐ
                    </div>
                </div>
            </div>
        </div>

        <div class="p3r-card overflow-hidden">
            <div class="p-3 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border);">
                <h5 class="m-0 fw-bold text-white">
                    <i class="fa-solid fa-list-check me-2" style="color: var(--cyan);"></i>Chi Tiết Giao Dịch &amp; Hóa Đơn
                </h5>
            </div>
            <div class="table-responsive">
                <table id="reportTable" class="table table-p3r table-striped table-hover mb-0">
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
                                <td class="fw-bold text-info">#${gd.maGD}</td>
                                <td class="fw-bold text-white">${gd.khachHang}</td>
                                <td>
                                    <span class="badge ${gd.loaiDoanhThu == 'Dịch vụ F&B' ? 'bg-warning text-dark' : 'bg-info text-dark'}">
                                        ${gd.loaiDoanhThu}
                                    </span>
                                </td>
                                <td class="fw-bold" style="color: var(--success);">
                                +<fmt:formatNumber value="${gd.soTien}" maxFractionDigits="0"/> VNĐ

</td>
                                <td style="color: var(--muted);">${gd.thoiGian}</td>
                                <td><span class="badge bg-success">${gd.trangThai}</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listGiaoDich}">
                            <tr>
                                <td colspan="6" class="text-center py-4" style="color: var(--muted);">
                                    Chưa có phát sinh giao dịch doanh thu nào trong hệ thống.
                                </td>
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