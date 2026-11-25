<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phòng &amp; Máy Trạm - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-override.css">
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
        .nav-tabs-p3r { border-bottom: 2px solid var(--border); gap: 6px; }
        .nav-tabs-p3r .nav-link {
            color: var(--muted);
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
            font-weight: 800;
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
            <h3 class="page-title m-0">Quản Lý Phòng &amp; Máy Trạm</h3>
            <a href="dashboard" class="btn btn-back px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <ul class="nav nav-tabs nav-tabs-p3r mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-may" type="button">
                    <i class="fa-solid fa-desktop me-2"></i>Danh Sách Máy Trạm
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-phong" type="button">
                    <i class="fa-solid fa-layer-group me-2"></i>Cài Đặt Phòng &amp; Đơn Giá
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="tab-may">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-plus-circle me-2" style="color: var(--cyan);"></i>Thêm Máy Trạm Mới
                    </h5>
                    <form action="${pageContext.request.contextPath}/admin/phong-may" method="post" class="row g-3">
                        <input type="hidden" name="type" value="addMay">
                        <div class="col-md-4">
                            <select name="maPhong" class="form-select form-p3r" required>
                                <c:forEach var="p" items="${phongList}">
                                    <option value="${p.maPhong}">${p.tenPhong} (<fmt:formatNumber value="${p.donGiaCoBan}" maxFractionDigits="0"/> VNĐ/h)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="tenMay" class="form-control form-p3r" placeholder="Tên máy (VD: VIP-02, PRO-05)" required>
                        </div>
                        <div class="col-md-3">
                            <select name="trangThai" class="form-select form-p3r">
                                <option value="AVAILABLE">Sẵn sàng (Trống)</option>
                                <option value="MAINTENANCE">Bảo trì</option>
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
                                    <th>Khu Vực / Phòng</th>
                                    <th>Tên Máy Trạm</th>
                                    <th>Đơn Giá (VNĐ/h)</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pm" items="${phongMayList}">
                                    <tr>
                                        <td class="fw-bold text-info">#${pm.id}</td>
                                        <td class="text-white fw-semibold">${pm.tenPhong}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <i class="fa-solid fa-computer me-2"></i>${pm.tenMay}
                                        </td>
                                        <td class="fw-bold text-success">
                                            <fmt:formatNumber value="${pm.donGia}" type="number" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pm.trangThai == 'AVAILABLE'}">
                                                    <span class="badge bg-success"><i class="fa-solid fa-circle-check me-1"></i>Sẵn sàng</span>
                                                </c:when>
                                                <c:when test="${pm.trangThai == 'IN_USE'}">
                                                    <span class="badge bg-info text-dark"><i class="fa-solid fa-gamepad me-1"></i>Đang chơi</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger"><i class="fa-solid fa-wrench me-1"></i>Bảo trì</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    onclick="openEditMayModal('${pm.id}', '${pm.tenPhong}', '${pm.tenMay}', '${pm.trangThai}')">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/phong-may?action=deleteMay&id=${pm.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
                                               onclick="return confirm('Xóa máy trạm này?')">
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

            <div class="tab-pane fade" id="tab-phong">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-folder-plus me-2" style="color: var(--cyan);"></i>Thêm Khu Vực / Phòng Mới
                    </h5>
                    <form action="${pageContext.request.contextPath}/admin/phong-may" method="post" class="row g-3">
                        <input type="hidden" name="type" value="addPhong">
                        <div class="col-md-4">
                            <input type="text" name="tenPhong" class="form-control form-p3r" placeholder="Tên phòng (VD: Khu Streamer)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="donGia" class="form-control form-p3r" placeholder="Đơn giá giờ chơi (VNĐ)" required>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="moTa" class="form-control form-p3r" placeholder="Mô tả cấu hình (VD: RTX 4070, 240Hz)">
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
                                    <th>Mã Phòng</th>
                                    <th>Tên Phòng / Khu Vực</th>
                                    <th>Đơn Giá Cơ Bản</th>
                                    <th>Mô Tả Cấu Hình</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${phongList}">
                                    <tr>
                                        <td class="fw-bold text-info">#${p.maPhong}</td>
                                        <td class="fw-bold text-white">${p.tenPhong}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${p.donGiaCoBan}" type="number" maxFractionDigits="0"/> VNĐ/h
                                        </td>
                                        <td style="color: var(--muted);">${p.moTa}</td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    onclick="openEditPhongModal('${p.maPhong}', '${p.tenPhong}', '${p.donGiaCoBan}', '${p.moTa}')">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa Giá
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/phong-may?action=deletePhong&id=${p.maPhong}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
                                               onclick="return confirm('Xóa phòng này? (Lưu ý: Phải xóa hết máy trong phòng trước)')">
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

    <div class="modal fade modal-p3r" id="editMayModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/phong-may" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);"><i class="fa-solid fa-desktop me-2"></i>Cập Nhật Máy Trạm</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="updateMay">
                    <input type="hidden" name="maMay" id="editMayId">
                    <div class="mb-3">
                        <label class="form-label">Khu vực / Phòng</label>
                        <select name="maPhong" id="editMaPhongMay" class="form-select form-p3r" required>
                            <c:forEach var="p" items="${phongList}">
                                <option value="${p.maPhong}">${p.tenPhong}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên máy trạm</label>
                        <input type="text" name="tenMay" id="editTenMay" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái hoạt động</label>
                        <select name="trangThai" id="editTrangThaiMay" class="form-select form-p3r">
                            <option value="AVAILABLE">Sẵn sàng (Trống)</option>
                            <option value="IN_USE">Đang sử dụng</option>
                            <option value="MAINTENANCE">Bảo trì</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-p3r px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal fade modal-p3r" id="editPhongModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/phong-may" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);"><i class="fa-solid fa-layer-group me-2"></i>Cập Nhật Phòng &amp; Đơn Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="updatePhong">
                    <input type="hidden" name="maPhong" id="editMaPhong">
                    <div class="mb-3">
                        <label class="form-label">Tên phòng / Khu vực</label>
                        <input type="text" name="tenPhong" id="editTenPhong" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn giá giờ chơi (VNĐ/h)</label>
                        <input type="number" step="1000" min="0" name="donGia" id="editDonGiaPhong" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả cấu hình</label>
                        <input type="text" name="moTa" id="editMoTaPhong" class="form-control form-p3r">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-p3r px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditMayModal(id, tenPhong, tenMay, trangThai) {
            document.getElementById('editMayId').value = id;
            document.getElementById('editTenMay').value = tenMay;
            document.getElementById('editTrangThaiMay').value = trangThai;

            // Tự động chọn đúng phòng theo tên phòng hiện tại của máy
            const selectPhong = document.getElementById('editMaPhongMay');
            for (let i = 0; i < selectPhong.options.length; i++) {
                if (selectPhong.options[i].text.trim() === tenPhong.trim()) {
                    selectPhong.selectedIndex = i;
                    break;
                }
            }
            new bootstrap.Modal(document.getElementById('editMayModal')).show();
        }

        function openEditPhongModal(id, tenPhong, donGia, moTa) {
            document.getElementById('editMaPhong').value = id;
            document.getElementById('editTenPhong').value = tenPhong;
            document.getElementById('editDonGiaPhong').value = donGia;
            document.getElementById('editMoTaPhong').value = moTa;
            new bootstrap.Modal(document.getElementById('editPhongModal')).show();
        }
    </script>
</body>
</html>