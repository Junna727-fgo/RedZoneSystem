<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Menu Dịch Vụ &amp; Combo - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;600;700&family=Montserrat:ital,wght@0,800;1,900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-abyss: #030a18;
            --card-bg: #07193d;
            --input-bg: #041028;
            --cyan: #00e5ff;
            --cyan-glow: rgba(0, 229, 255, 0.35);
            --border: rgba(0, 229, 255, 0.28);
            --muted: #8fb4df;
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
        .nav-tabs-p3r { border-bottom: 2px solid var(--border); gap: 6px; }
        .nav-tabs-p3r .nav-link {
            color: var(--muted);
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-style: italic;
            font-size: 0.88rem;
            text-transform: uppercase;
            border: 1px solid transparent;
            padding: 0.75rem 1.4rem;
            background: transparent;
        }
        .nav-tabs-p3r .nav-link:hover { color: #fff; border-color: var(--border); }
        .nav-tabs-p3r .nav-link.active {
            color: #020a18;
            background: linear-gradient(90deg, #00c4ff, #1858ff);
            border-color: var(--cyan);
        }
        .p3r-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.55);
        }
        .form-p3r {
            background-color: var(--input-bg) !important;
            border: 1px solid var(--border) !important;
            color: #fff !important;
        }
        .form-p3r:focus {
            background-color: #09204d !important;
            border-color: var(--cyan) !important;
            box-shadow: 0 0 10px var(--cyan-glow) !important;
        }
        .form-p3r option { background: #061430; color: #fff; }
        .btn-p3r {
            background: linear-gradient(90deg, #00c4ff, #1858ff);
            border: none;
            color: #020a18;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            text-transform: uppercase;
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
        .modal-p3r .modal-content {
            background: #061636;
            border: 1px solid var(--cyan);
            border-top: 4px solid var(--cyan);
            color: #fff;
        }
        .modal-p3r .modal-header { border-bottom: 1px solid var(--border); }
        .modal-p3r .modal-footer { border-top: 1px solid var(--border); }
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="page-title m-0">Quản Lý Menu Dịch Vụ &amp; Khuyến Mãi</h3>
            <a href="dashboard" class="btn btn-back px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <ul class="nav nav-tabs nav-tabs-p3r mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-monle" type="button">
                    <i class="fa-solid fa-utensils me-2"></i>Thực Đơn Món Lẻ (F&amp;B)
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-combo" type="button">
                    <i class="fa-solid fa-tags me-2"></i>Combo &amp; Khuyến Mãi
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="tab-monle">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-plus-circle me-2" style="color: var(--cyan);"></i>Thêm Món Ăn / Đồ Uống Mới
                    </h5>
                    <form action="dich-vu" method="post" class="row g-3">
                        <input type="hidden" name="type" value="add">
                        <div class="col-md-3">
                            <input type="text" name="tenMon" class="form-control form-p3r" placeholder="Tên món / dịch vụ" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-p3r" placeholder="Giá bán (VNĐ)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-p3r" placeholder="Số lượng tồn" required>
                        </div>
                        <div class="col-md-3">
                            <select name="danhMuc" class="form-select form-p3r">
                                <option value="FOOD">Đồ ăn (FOOD)</option>
                                <option value="DRINK">Nước uống (DRINK)</option>
                                <option value="CARD">Thẻ game (CARD)</option>
                            </select>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-p3r w-100 h-100">Thêm</button>
                        </div>
                    </form>
                </div>

                <div class="p3r-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0">
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
                                        <td class="fw-bold text-info">#${dv.id}</td>
                                        <td class="fw-bold text-white">${dv.tenMon}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${dv.gia}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td class="fw-semibold">${dv.soLuongTon}</td>
                                        <td><span class="badge bg-info text-dark">${dv.danhMuc}</span></td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    data-id="${dv.id}" data-ten="${dv.tenMon}" data-gia="${dv.gia}"
                                                    data-ton="${dv.soLuongTon}" data-dm="${dv.danhMuc}"
                                                    onclick="openEditDv(this)">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="dich-vu?action=delete&id=${dv.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
                                               onclick="return confirm('Xóa món này?')">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="tab-pane fade" id="tab-combo">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-gift me-2" style="color: var(--cyan);"></i>Tạo Gói Combo / Khuyến Mãi Mới
                    </h5>
                    <form action="dich-vu" method="post" class="row g-3">
                        <input type="hidden" name="type" value="add">
                        <input type="hidden" name="danhMuc" value="COMBO">
                        <div class="col-md-5">
                            <input type="text" name="tenMon" class="form-control form-p3r" placeholder="Tên Combo (VD: Combo Đêm)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-p3r" placeholder="Giá ưu đãi (VNĐ)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-p3r" placeholder="Số suất" value="50" required>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-p3r w-100 h-100">Tạo</button>
                        </div>
                    </form>
                </div>

                <div class="p3r-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0">
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
                                        <td class="fw-bold text-info">#${cb.id}</td>
                                        <td class="fw-bold text-white">${cb.tenMon}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${cb.gia}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td class="fw-semibold">${cb.soLuongTon}</td>
                                        <td><span class="badge bg-primary">COMBO</span></td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    data-id="${cb.id}" data-ten="${cb.tenMon}" data-gia="${cb.gia}"
                                                    data-ton="${cb.soLuongTon}" data-dm="COMBO"
                                                    onclick="openEditDv(this)">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="dich-vu?action=delete&id=${cb.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
                                               onclick="return confirm('Xóa combo này?')">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade modal-p3r" id="editDvModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="dich-vu" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Cập Nhật Dịch Vụ / Combo
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="update">
                    <input type="hidden" name="id" id="editDvId">
                    <div class="mb-3">
                        <label class="form-label">Tên món / Combo</label>
                        <input type="text" name="tenMon" id="editTenMon" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn giá (VNĐ)</label>
                        <input type="number" step="1000" min="0" name="gia" id="editGiaMon" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số lượng tồn</label>
                        <input type="number" min="0" name="soLuongTon" id="editTonKho" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Danh mục</label>
                        <select name="danhMuc" id="editDanhMuc" class="form-select form-p3r">
                            <option value="FOOD">Đồ ăn (FOOD)</option>
                            <option value="DRINK">Nước uống (DRINK)</option>
                            <option value="CARD">Thẻ game (CARD)</option>
                            <option value="COMBO">Combo Khuyến Mãi (COMBO)</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-p3r px-4">Lưu</button>
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