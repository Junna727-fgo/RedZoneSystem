<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Phòng & Máy Trạm - RedZone Admin</title>
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
            background-image: radial-gradient(circle at 15% 15%, rgba(255, 30, 39, 0.08) 0%, transparent 40%);
        }
        .navbar-cyber {
            background-color: rgba(15, 15, 19, 0.95);
            border-bottom: 2px solid var(--red-primary);
            box-shadow: 0 4px 20px rgba(255, 30, 39, 0.2);
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
            letter-spacing: 1.5px;
            border-left: 4px solid var(--red-primary);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .btn-back {
            border: 1px solid #4b5563;
            color: #d1d5db;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-back:hover {
            border-color: var(--red-primary);
            color: #fff;
            background: rgba(255, 30, 39, 0.15);
        }
        .cyber-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-top: 3px solid var(--red-primary);
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
        .form-control-cyber, .form-select-cyber {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: #fff;
            font-size: 1rem;
        }
        .form-control-cyber:focus, .form-select-cyber:focus {
            background-color: #22222b;
            border-color: var(--red-primary);
            box-shadow: 0 0 10px rgba(255, 30, 39, 0.25);
            color: #fff;
        }
        .btn-cyber {
            background: linear-gradient(90deg, #c80d14, var(--red-primary));
            border: none;
            color: #fff;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s;
        }
        .btn-cyber:hover {
            box-shadow: 0 0 15px var(--red-glow);
            color: #fff;
        }
        .table-cyber {
            --bs-table-bg: #141418;
            --bs-table-color: #e5e7eb;
            --bs-table-border-color: #2a2a35;
            --bs-table-striped-bg: #191920;
            --bs-table-hover-bg: #202029;
        }
        .table-cyber thead th {
            background-color: #1c1c24;
            color: var(--red-primary);
            font-family: 'Orbitron', sans-serif;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            border-bottom: 2px solid var(--red-primary);
            padding: 1rem 0.75rem;
        }
        .table-cyber td {
            vertical-align: middle;
            padding: 0.85rem 0.75rem;
            font-size: 1.05rem;
        }
        /* Nav Tabs Cyber */
        .nav-tabs-cyber {
            border-bottom: 2px solid #2a2a35;
        }
        .nav-tabs-cyber .nav-link {
            color: #9ca3af;
            font-family: 'Orbitron', sans-serif;
            font-size: 0.9rem;
            letter-spacing: 1px;
            border: none;
            padding: 0.8rem 1.5rem;
            background: transparent;
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
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="page-title m-0">Quản Lý Phòng & Máy Trạm</h3>
            <a href="dashboard" class="btn btn-back px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <!-- Tabs chuyển đổi giữa Máy Trạm và Khu Vực Phòng -->
        <ul class="nav nav-tabs nav-tabs-cyber mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-may" type="button">
                    <i class="fa-solid fa-desktop me-2"></i>Danh Sách Máy Trạm
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-phong" type="button">
                    <i class="fa-solid fa-layer-group me-2"></i>Cài Đặt Phòng & Đơn Giá
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <!-- TAB 1: QUẢN LÝ MÁY TRẠM -->
            <div class="tab-pane fade show active" id="tab-may">
                <div class="cyber-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-plus-circle text-danger me-2"></i>Thêm Máy Trạm Mới
                    </h5>
                    <form action="phong-may" method="post" class="row g-3">
                        <input type="hidden" name="type" value="addMay">
                        <div class="col-md-4">
                            <select name="maPhong" class="form-select form-select-cyber" required>
                                <c:forEach var="p" items="${phongList}">
                                    <option value="${p.maPhong}">${p.tenPhong} (<fmt:formatNumber value="${p.donGiaCoBan}" maxFractionDigits="0"/> VNĐ/h)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="tenMay" class="form-control form-control-cyber" placeholder="Tên máy (VD: VIP-02, PRO-05)" required>
                        </div>
                        <div class="col-md-3">
                            <select name="trangThai" class="form-select form-select-cyber">
                                <option value="AVAILABLE">Sẵn sàng (Trống)</option>
                                <option value="MAINTENANCE">Bảo trì</option>
                            </select>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-cyber w-100 h-100">Thêm</button>
                        </div>
                    </form>
                </div>

                <div class="cyber-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-cyber table-striped table-hover mb-0">
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
                                        <td class="fw-bold text-secondary">#${pm.id}</td>
                                        <td class="text-white fw-semibold">${pm.tenPhong}</td>
                                        <td class="fw-bold text-danger"><i class="fa-solid fa-computer me-2"></i>${pm.tenMay}</td>
                                        <td class="fw-bold text-warning">
                                            <fmt:formatNumber value="${pm.donGia}" type="number" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pm.trangThai == 'AVAILABLE'}">
                                                    <span class="badge bg-success"><i class="fa-solid fa-circle-check me-1"></i>Sẵn sàng</span>
                                                </c:when>
                                                <c:when test="${pm.trangThai == 'IN_USE'}">
                                                    <span class="badge bg-primary"><i class="fa-solid fa-gamepad me-1"></i>Đang chơi</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger"><i class="fa-solid fa-wrench me-1"></i>Bảo trì</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    onclick="openEditMayModal('${pm.id}', '${pm.tenMay}', '${pm.trangThai}')">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="phong-may?action=deleteMay&id=${pm.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1" onclick="return confirm('Xóa máy trạm này?')">
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

            <!-- TAB 2: CÀI ĐẶT PHÒNG & ĐƠN GIÁ -->
            <div class="tab-pane fade" id="tab-phong">
                <div class="cyber-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-folder-plus text-danger me-2"></i>Thêm Khu Vực / Phòng Mới
                    </h5>
                    <form action="phong-may" method="post" class="row g-3">
                        <input type="hidden" name="type" value="addPhong">
                        <div class="col-md-4">
                            <input type="text" name="tenPhong" class="form-control form-control-cyber" placeholder="Tên phòng (VD: Khu Streamer)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" step="1000" min="0" name="donGia" class="form-control form-control-cyber" placeholder="Đơn giá giờ chơi (VNĐ)" required>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="moTa" class="form-control form-control-cyber" placeholder="Mô tả cấu hình (VD: RTX 4070, 240Hz)">
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-cyber w-100 h-100">Thêm</button>
                        </div>
                    </form>
                </div>

                <div class="cyber-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-cyber table-striped table-hover mb-0">
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
                                        <td class="fw-bold text-secondary">#${p.maPhong}</td>
                                        <td class="fw-bold text-white">${p.tenPhong}</td>
                                        <td class="fw-bold text-warning">
                                            <fmt:formatNumber value="${p.donGiaCoBan}" type="number" maxFractionDigits="0"/> VNĐ/h
                                        </td>
                                        <td class="text-muted">${p.moTa}</td>
                                        <td class="text-end">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    onclick="openEditPhongModal('${p.maPhong}', '${p.tenPhong}', '${p.donGiaCoBan}', '${p.moTa}')">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa Giá
                                            </button>
                                            <a href="phong-may?action=deletePhong&id=${p.maPhong}" class="btn btn-outline-danger btn-sm fw-bold ms-1" onclick="return confirm('Xóa phòng này? (Lưu ý: Phải xóa hết máy trong phòng trước)')">
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

    <!-- Modal Sửa Máy Trạm -->
    <div class="modal fade modal-cyber" id="editMayModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="phong-may" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-desktop me-2"></i>Cập Nhật Máy Trạm</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="updateMay">
                    <input type="hidden" name="maMay" id="editMayId">
                    <div class="mb-3">
                        <label class="form-label">Khu vực / Phòng</label>
                        <select name="maPhong" class="form-select form-select-cyber">
                            <c:forEach var="p" items="${phongList}">
                                <option value="${p.maPhong}">${p.tenPhong}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên máy trạm</label>
                        <input type="text" name="tenMay" id="editTenMay" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái hoạt động</label>
                        <select name="trangThai" id="editTrangThaiMay" class="form-select form-select-cyber">
                            <option value="AVAILABLE">Sẵn sàng (Trống)</option>
                            <option value="IN_USE">Đang sử dụng</option>
                            <option value="MAINTENANCE">Bảo trì</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-cyber px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Sửa Phòng & Đơn Giá -->
    <div class="modal fade modal-cyber" id="editPhongModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="phong-may" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-layer-group me-2"></i>Cập Nhật Phòng & Đơn Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="updatePhong">
                    <input type="hidden" name="maPhong" id="editMaPhong">
                    <div class="mb-3">
                        <label class="form-label">Tên phòng / Khu vực</label>
                        <input type="text" name="tenPhong" id="editTenPhong" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn giá giờ chơi (VNĐ/h)</label>
                        <input type="number" step="1000" min="0" name="donGia" id="editDonGiaPhong" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả cấu hình</label>
                        <input type="text" name="moTa" id="editMoTaPhong" class="form-control form-control-cyber">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-cyber px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditMayModal(id, tenMay, trangThai) {
            document.getElementById('editMayId').value = id;
            document.getElementById('editTenMay').value = tenMay;
            document.getElementById('editTrangThaiMay').value = trangThai;
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