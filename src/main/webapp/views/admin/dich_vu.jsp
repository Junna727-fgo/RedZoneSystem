<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Menu Dịch Vụ & Combo - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0a0a0c;
            --card-bg: #141418;
            --input-bg: #1c1c24;
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
        .cyber-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-top: 3px solid var(--red-primary);
            border-radius: 10px;
        }
        .form-control-cyber, .form-select-cyber {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: #fff;
        }
        .form-control-cyber:focus, .form-select-cyber:focus {
            background-color: #22222b;
            border-color: var(--red-primary);
            color: #fff;
            box-shadow: none;
        }
        .btn-cyber {
            background: linear-gradient(90deg, #c80d14, var(--red-primary));
            border: none;
            color: #fff;
            font-weight: 700;
            text-transform: uppercase;
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
        .nav-tabs-cyber { border-bottom: 2px solid #2a2a35; }
        .nav-tabs-cyber .nav-link {
            color: #9ca3af;
            font-family: 'Orbitron', sans-serif;
            border: none;
        }
        .nav-tabs-cyber .nav-link.active {
            color: #fff;
            background-color: rgba(255, 30, 39, 0.15);
            border-bottom: 3px solid var(--red-primary);
        }
        .modal-cyber .modal-content {
            background-color: #16161d;
            border: 1px solid var(--red-primary);
            color: #fff;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-cyber mb-4">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-fire-flame-curved text-danger me-2"></i>REDZONE <span>ADMIN</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="page-title m-0">Quản Lý Menu Dịch Vụ & Khuyến Mãi</h3>
            <a href="dashboard" class="btn btn-outline-light px-3">Quay lại Dashboard</a>
        </div>

        <ul class="nav nav-tabs nav-tabs-cyber mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-monle" type="button">
                    Thực Đơn Món Lẻ (F&B)
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-combo" type="button">
                    Combo & Khuyến Mãi
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <!-- TAB 1: MÓN LẺ -->
            <div class="tab-pane fade show active" id="tab-monle">
                <div class="cyber-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">Thêm Món Ăn / Đồ Uống Mới</h5>
                    <form action="dich-vu" method="post" class="row g-3">
                        <input type="hidden" name="type" value="add">
                        <div class="col-md-3">
                            <input type="text" name="tenMon" class="form-control form-control-cyber" placeholder="Tên món / dịch vụ" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-control-cyber" placeholder="Giá bán (VNĐ)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-control-cyber" placeholder="Số lượng tồn" required>
                        </div>
                        <div class="col-md-3">
                            <select name="danhMuc" class="form-select form-select-cyber">
                                <option value="FOOD">Đồ ăn (FOOD)</option>
                                <option value="DRINK">Nước uống (DRINK)</option>
                                <option value="CARD">Thẻ game (CARD)</option>
                            </select>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-cyber w-100 h-100">Thêm</button>
                        </div>
                    </form>
                </div>

                <div class="cyber-card overflow-hidden">
                    <table class="table table-cyber table-hover mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Món</th>
                                <th>Đơn Giá</th>
                                <th>Tồn Kho</th>
                                <th>Danh Mục</th>
                                <th class="text-end">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dv" items="${dichVuList}">
                                <tr>
                                    <td>#${dv.id}</td>
                                    <td class="fw-bold text-white">${dv.tenMon}</td>
                                    <td class="text-warning fw-bold"><fmt:formatNumber value="${dv.gia}" maxFractionDigits="0"/> VNĐ</td>
                                    <td>${dv.soLuongTon}</td>
                                    <td><span class="badge bg-secondary">${dv.danhMuc}</span></td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-outline-info btn-sm"
                                                data-id="${dv.id}" data-ten="${dv.tenMon}" data-gia="${dv.gia}"
                                                data-ton="${dv.soLuongTon}" data-dm="${dv.danhMuc}"
                                                onclick="openEditDv(this)">Sửa</button>
                                        <a href="dich-vu?action=delete&id=${dv.id}" class="btn btn-outline-danger btn-sm ms-1" onclick="return confirm('Xóa món này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- TAB 2: COMBO -->
            <div class="tab-pane fade" id="tab-combo">
                <div class="cyber-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">Tạo Gói Combo / Khuyến Mãi Mới</h5>
                    <form action="dich-vu" method="post" class="row g-3">
                        <input type="hidden" name="type" value="add">
                        <input type="hidden" name="danhMuc" value="COMBO">
                        <div class="col-md-5">
                            <input type="text" name="tenMon" class="form-control form-control-cyber" placeholder="Tên Combo (VD: Combo Đêm)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-control-cyber" placeholder="Giá ưu đãi (VNĐ)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-control-cyber" placeholder="Số suất" value="50" required>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-cyber w-100 h-100">Tạo</button>
                        </div>
                    </form>
                </div>

                <div class="cyber-card overflow-hidden">
                    <table class="table table-cyber table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Tên Gói Combo</th>
                                <th>Giá Ưu Đãi</th>
                                <th>Suất Còn</th>
                                <th>Loại</th>
                                <th class="text-end">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cb" items="${comboList}">
                                <tr>
                                    <td>#${cb.id}</td>
                                    <td class="fw-bold text-white">${cb.tenMon}</td>
                                    <td class="text-warning fw-bold"><fmt:formatNumber value="${cb.gia}" maxFractionDigits="0"/> VNĐ</td>
                                    <td>${cb.soLuongTon}</td>
                                    <td><span class="badge bg-danger">COMBO</span></td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-outline-info btn-sm"
                                                data-id="${cb.id}" data-ten="${cb.tenMon}" data-gia="${cb.gia}"
                                                data-ton="${cb.soLuongTon}" data-dm="COMBO"
                                                onclick="openEditDv(this)">Sửa</button>
                                        <a href="dich-vu?action=delete&id=${cb.id}" class="btn btn-outline-danger btn-sm ms-1" onclick="return confirm('Xóa combo này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Sửa -->
    <div class="modal fade modal-cyber" id="editDvModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="dich-vu" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger fw-bold">Cập Nhật Dịch Vụ / Combo</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="update">
                    <input type="hidden" name="id" id="editDvId">
                    <div class="mb-3">
                        <label class="form-label">Tên món / Combo</label>
                        <input type="text" name="tenMon" id="editTenMon" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn giá (VNĐ)</label>
                        <input type="number" step="1000" min="0" name="gia" id="editGiaMon" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số lượng tồn</label>
                        <input type="number" min="0" name="soLuongTon" id="editTonKho" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Danh mục</label>
                        <select name="danhMuc" id="editDanhMuc" class="form-select form-select-cyber">
                            <option value="FOOD">Đồ ăn (FOOD)</option>
                            <option value="DRINK">Nước uống (DRINK)</option>
                            <option value="CARD">Thẻ game (CARD)</option>
                            <option value="COMBO">Combo Khuyến Mãi (COMBO)</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-cyber px-4">Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditDv(btn) {
            document.getElementById('editDvId').value = btn.getAttribute('data-id');
            document.getElementById('editTenMon').value = btn.getAttribute('data-ten');
            document.getElementById('editGiaMon').value = btn.getAttribute('data-gia');
            document.getElementById('editTonKho').value = btn.getAttribute('data-ton');
            document.getElementById('editDanhMuc').value = btn.getAttribute('data-dm');
            new bootstrap.Modal(document.getElementById('editDvModal')).show();
        }
    </script>
</body>
</html>