<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Menu F&amp;B, Thuê Gear &amp; Đơn Khách - RedZone Admin</title>
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
        .food-thumb {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 8px;
            border: 1.5px solid var(--cyan);
            box-shadow: 0 0 10px rgba(0, 229, 255, 0.25);
            background-color: #041028;
        }
        .filter-pill {
            border: 1px solid var(--border);
            color: var(--muted);
            background: #041028;
            font-weight: 700;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .filter-pill:hover, .filter-pill.active {
            background: var(--cyan);
            color: #020a18;
            border-color: var(--cyan);
            box-shadow: 0 0 12px var(--cyan-glow);
        }
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
            <h3 class="page-title m-0">Quản Lý Menu F&amp;B, Thuê Gear &amp; Đơn Khách</h3>
            <a href="dashboard" class="btn btn-back px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <ul class="nav nav-tabs nav-tabs-p3r mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link ${param.tab == null || param.tab == 'food' ? 'active' : ''}" data-bs-toggle="tab" data-bs-target="#tab-monle" type="button">
                    <i class="fa-solid fa-utensils me-2"></i>Thực Đơn Món Lẻ (F&amp;B)
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${param.tab == 'gear' ? 'active' : ''}" data-bs-toggle="tab" data-bs-target="#tab-gear" type="button">
                    <i class="fa-solid fa-headset me-2"></i>Quản Lý Thuê Gear
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${param.tab == 'combo' ? 'active' : ''}" data-bs-toggle="tab" data-bs-target="#tab-combo" type="button">
                    <i class="fa-solid fa-tags me-2"></i>Combo &amp; Khuyến Mãi
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${param.tab == 'orders' ? 'active' : ''}" data-bs-toggle="tab" data-bs-target="#tab-orders" type="button">
                    <i class="fa-solid fa-bell-concierge me-2"></i>Đơn Khách Đặt
                    <c:if test="${servingCount > 0}">
                        <span class="badge bg-danger ms-1">${servingCount}</span>
                    </c:if>
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <!-- TAB 1: THỰC ĐƠN MÓN LẺ -->
            <div class="tab-pane fade ${param.tab == null || param.tab == 'food' ? 'show active' : ''}" id="tab-monle">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-plus-circle me-2" style="color: var(--cyan);"></i>Thêm Món Ăn / Đồ Uống Mới (Lưu trực tiếp vào SQL Server)
                    </h5>
                    <form action="${pageContext.request.contextPath}/admin/dich-vu" method="post" class="row g-2 align-items-center">
                        <input type="hidden" name="type" value="add">
                        <div class="col-md-3">
                            <input type="text" name="tenMon" class="form-control form-p3r" placeholder="Tên món (VD: Cơm gà xối mỡ)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-p3r" placeholder="Giá bán (VNĐ)" required>
                        </div>
                        <div class="col-md-1">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-p3r" placeholder="SL" value="20" required>
                        </div>
                        <div class="col-md-2">
                            <select name="danhMuc" class="form-select form-p3r" required>
                                <option value="Cơm">Cơm</option>
                                <option value="Đồ ăn vặt">Đồ ăn vặt</option>
                                <option value="Nước">Nước</option>
                                <option value="Mì trộn">Mì trộn</option>
                                <option value="Mì nước">Mì nước</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <input type="text" name="hinhAnh" id="addFoodImg" class="form-control form-p3r" placeholder="Link ảnh hoặc chọn file ->">
                                <label class="btn btn-outline-info mb-0" title="Chọn ảnh từ máy tính">
                                    <i class="fa-solid fa-image"></i>
                                    <input type="file" accept="image/*" hidden onchange="encodeImageToInput(this, 'addFoodImg')">
                                </label>
                            </div>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-p3r w-100 py-2">Thêm</button>
                        </div>
                    </form>
                </div>

                <!-- THANH LỌC NHANH THEO 5 DANH MỤC -->
                <div class="d-flex flex-wrap gap-2 mb-3 align-items-center">
                    <span class="text-info fw-bold me-2"><i class="fa-solid fa-filter me-1"></i>Lọc danh mục:</span>
                    <button type="button" class="filter-pill active" onclick="filterMenu('ALL', this)">Tất cả</button>
                    <button type="button" class="filter-pill" onclick="filterMenu('Cơm', this)">Cơm</button>
                    <button type="button" class="filter-pill" onclick="filterMenu('Đồ ăn vặt', this)">Đồ ăn vặt</button>
                    <button type="button" class="filter-pill" onclick="filterMenu('Nước', this)">Nước</button>
                    <button type="button" class="filter-pill" onclick="filterMenu('Mì trộn', this)">Mì trộn</button>
                    <button type="button" class="filter-pill" onclick="filterMenu('Mì nước', this)">Mì nước</button>
                </div>

                <div class="p3r-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0" id="menuTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Hình Ảnh</th>
                                    <th>Tên Món</th>
                                    <th>Đơn Giá</th>
                                    <th>Tồn Kho</th>
                                    <th>Danh Mục</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dv" items="${dichVuList}">
                                    <tr class="menu-row" data-category="${dv.danhMuc}" data-name="${dv.tenMon}">
                                        <td class="fw-bold text-info">#${dv.id}</td>
                                        <td>
                                            <img class="food-thumb" src="${dv.hinhAnh}" data-dbimg="${dv.hinhAnh}" alt="${dv.tenMon}">
                                        </td>
                                        <td class="fw-bold text-white">${dv.tenMon}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${dv.gia}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td class="fw-semibold text-white">${dv.soLuongTon}</td>
                                        <td>
                                            <span class="badge bg-info text-dark category-label">${dv.danhMuc}</span>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    data-id="${dv.id}" data-ten="${dv.tenMon}" data-gia="${dv.gia}"
                                                    data-ton="${dv.soLuongTon}" data-dm="${dv.danhMuc}" data-img="${dv.hinhAnh}"
                                                    onclick="openEditDv(this)">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/dich-vu?action=delete&id=${dv.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
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

            <!-- TAB 2: QUẢN LÝ THUÊ GAMING GEAR -->
            <div class="tab-pane fade ${param.tab == 'gear' ? 'show active' : ''}" id="tab-gear">
                <div class="p3r-card p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="text-white fw-bold m-0">
                            <i class="fa-solid fa-computer-mouse me-2" style="color: var(--cyan);"></i>Thêm Thiết Bị Gaming Gear Cho Thuê
                        </h5>
                        <c:if test="${empty gearList}">
                            <a href="${pageContext.request.contextPath}/admin/dich-vu?action=seedGear" class="btn btn-outline-info btn-sm fw-bold">
                                <i class="fa-solid fa-wand-magic-sparkles me-1"></i> Nạp nhanh 6 Gear mặc định của quán
                            </a>
                        </c:if>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/dich-vu" method="post" class="row g-2 align-items-center">
                        <input type="hidden" name="type" value="add">
                        <input type="hidden" name="danhMuc" value="GEAR">
                        <div class="col-md-4">
                            <input type="text" name="tenMon" class="form-control form-p3r" placeholder="Tên Gear (VD: Chuột Logitech G Pro X)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-p3r" placeholder="Giá / giờ (VNĐ)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-p3r" placeholder="SL sẵn có" value="10" required>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <input type="text" name="hinhAnh" id="addGearImg" class="form-control form-p3r" placeholder="Link ảnh hoặc chọn file ->">
                                <label class="btn btn-outline-info mb-0" title="Chọn ảnh từ máy tính">
                                    <i class="fa-solid fa-image"></i>
                                    <input type="file" accept="image/*" hidden onchange="encodeImageToInput(this, 'addGearImg')">
                                </label>
                            </div>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-p3r w-100 py-2">Thêm</button>
                        </div>
                    </form>
                </div>

                <div class="p3r-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Mã Gear</th>
                                    <th>Hình Ảnh</th>
                                    <th>Tên Thiết Bị Gaming Gear</th>
                                    <th>Giá Thuê / Giờ</th>
                                    <th>Số Lượng Sẵn Có</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="g" items="${gearList}">
                                    <tr class="menu-row" data-category="GEAR" data-name="${g.tenMon}">
                                        <td class="fw-bold text-info">#${g.id}</td>
                                        <td>
                                            <img class="food-thumb" src="${g.hinhAnh}" data-dbimg="${g.hinhAnh}" alt="${g.tenMon}">
                                        </td>
                                        <td class="fw-bold text-white">${g.tenMon}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${g.gia}" maxFractionDigits="0"/> VNĐ / giờ
                                        </td>
                                        <td class="fw-bold text-white">${g.soLuongTon} bộ</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${g.soLuongTon > 0}">
                                                    <span class="badge bg-success">Sẵn sàng cho thuê</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Đã thuê hết</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    data-id="${g.id}" data-ten="${g.tenMon}" data-gia="${g.gia}"
                                                    data-ton="${g.soLuongTon}" data-dm="GEAR" data-img="${g.hinhAnh}"
                                                    onclick="openEditDv(this)">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/dich-vu?action=delete&id=${g.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
                                               onclick="return confirm('Xóa thiết bị gear này?')">
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

            <!-- TAB 3: COMBO & KHUYẾN MÃI -->
            <div class="tab-pane fade ${param.tab == 'combo' ? 'show active' : ''}" id="tab-combo">
                <div class="p3r-card p-4 mb-4">
                    <h5 class="text-white fw-bold mb-3">
                        <i class="fa-solid fa-gift me-2" style="color: var(--cyan);"></i>Tạo Gói Combo / Khuyến Mãi Mới
                    </h5>
                    <form action="${pageContext.request.contextPath}/admin/dich-vu" method="post" class="row g-2 align-items-center">
                        <input type="hidden" name="type" value="add">
                        <input type="hidden" name="danhMuc" value="COMBO">
                        <div class="col-md-4">
                            <input type="text" name="tenMon" class="form-control form-p3r" placeholder="Tên Combo (VD: Combo Cày Đêm Mì + Sting)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" step="1000" min="0" name="gia" class="form-control form-p3r" placeholder="Giá ưu đãi (VNĐ)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" min="0" name="soLuongTon" class="form-control form-p3r" placeholder="Số suất" value="50" required>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <input type="text" name="hinhAnh" id="addComboImg" class="form-control form-p3r" placeholder="Link ảnh hoặc chọn file ->">
                                <label class="btn btn-outline-info mb-0" title="Chọn ảnh từ máy tính">
                                    <i class="fa-solid fa-image"></i>
                                    <input type="file" accept="image/*" hidden onchange="encodeImageToInput(this, 'addComboImg')">
                                </label>
                            </div>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-p3r w-100 py-2">Tạo</button>
                        </div>
                    </form>
                </div>

                <div class="p3r-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Mã</th>
                                    <th>Hình Ảnh</th>
                                    <th>Tên Gói Combo</th>
                                    <th>Giá Ưu Đãi</th>
                                    <th>Suất Còn</th>
                                    <th>Loại</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cb" items="${comboList}">
                                    <tr class="menu-row" data-category="COMBO" data-name="${cb.tenMon}">
                                        <td class="fw-bold text-info">#${cb.id}</td>
                                        <td>
                                            <img class="food-thumb" src="${cb.hinhAnh}" data-dbimg="${cb.hinhAnh}" alt="${cb.tenMon}">
                                        </td>
                                        <td class="fw-bold text-white">${cb.tenMon}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${cb.gia}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td class="fw-semibold text-white">${cb.soLuongTon}</td>
                                        <td><span class="badge bg-primary">COMBO</span></td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                                    data-id="${cb.id}" data-ten="${cb.tenMon}" data-gia="${cb.gia}"
                                                    data-ton="${cb.soLuongTon}" data-dm="COMBO" data-img="${cb.hinhAnh}"
                                                    onclick="openEditDv(this)">
                                                <i class="fa-solid fa-pen-to-square"></i> Sửa
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/dich-vu?action=delete&id=${cb.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1"
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

            <!-- TAB 4: ĐƠN GỌI MÓN & THUÊ GEAR TỪ KHÁCH HÀNG -->
            <div class="tab-pane fade ${param.tab == 'orders' ? 'show active' : ''}" id="tab-orders">
                <div class="p3r-card overflow-hidden">
                    <div class="p-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: var(--border) !important;">
                        <h5 class="fw-bold m-0 text-white">
                            <i class="fa-solid fa-receipt me-2 text-info"></i>Danh Sách Đơn Gọi Món F&amp;B &amp; Thuê Gear Từ Hội Viên
                        </h5>
                        <span class="badge bg-info text-dark">Đồng bộ trực tiếp với cổng Member &amp; IT</span>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-p3r table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Hội Viên</th>
                                    <th>Máy Trạm</th>
                                    <th>Nội Dung Đặt</th>
                                    <th>SL</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ord" items="${customerOrders}">
                                    <tr>
                                        <td class="fw-bold text-info">#${ord.orderId}</td>
                                        <td class="fw-bold text-white">${ord.customerName}</td>
                                        <td><span class="badge bg-primary fs-6">${ord.machineCode}</span></td>
                                        <td class="fw-bold text-white">${ord.itemName}</td>
                                        <td>${ord.quantity}</td>
                                        <td class="fw-bold text-success">
                                            <fmt:formatNumber value="${ord.amount}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ord.status == 'COMPLETED'}">
                                                    <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i>Đã giao xong</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock me-1"></i>Đang phục vụ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${ord.status != 'COMPLETED'}">
                                                <a href="${pageContext.request.contextPath}/admin/dich-vu?orderAction=complete&orderId=${ord.orderId}"
                                                   class="btn btn-p3r btn-sm px-3">
                                                    Hoàn tất đơn
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty customerOrders}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">
                                            Chưa có đơn gọi món hoặc thuê gear nào từ hội viên.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL CẬP NHẬT MÓN / GEAR / COMBO -->
    <div class="modal fade modal-p3r" id="editDvModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/dich-vu" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Cập Nhật Dịch Vụ / Gear / Combo
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="update">
                    <input type="hidden" name="id" id="editDvId">
                    <div class="mb-3">
                        <label class="form-label">Tên món / Thiết bị / Combo</label>
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
                            <option value="Cơm">Cơm</option>
                            <option value="Đồ ăn vặt">Đồ ăn vặt</option>
                            <option value="Nước">Nước</option>
                            <option value="Mì trộn">Mì trộn</option>
                            <option value="Mì nước">Mì nước</option>
                            <option value="GEAR">Thuê Gaming Gear (GEAR)</option>
                            <option value="COMBO">Combo Khuyến Mãi (COMBO)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link hình ảnh hoặc chọn file từ máy tính</label>
                        <div class="input-group">
                            <input type="text" name="hinhAnh" id="editHinhAnh" class="form-control form-p3r" placeholder="https://...">
                            <label class="btn btn-outline-info mb-0" title="Chọn ảnh từ máy tính">
                                <i class="fa-solid fa-image"></i>
                                <input type="file" accept="image/*" hidden onchange="encodeImageToInput(this, 'editHinhAnh')">
                            </label>
                        </div>
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
        function encodeImageToInput(fileInput, targetInputId) {
            const file = fileInput.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = new Image();
                img.onload = function() {
                    const canvas = document.createElement('canvas');
                    const maxW = 300;
                    const scale = maxW / img.width;
                    canvas.width = maxW;
                    canvas.height = img.height * scale;
                    canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
                    document.getElementById(targetInputId).value = canvas.toDataURL('image/jpeg', 0.8);
                };
                img.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }

        function getFallbackImage(name, category) {
            const n = (name || '').toLowerCase();
            const c = (category || '').toLowerCase();

            if (c === 'gear' || n.includes('chuột') || n.includes('phím') || n.includes('tai nghe')) {
                if (n.includes('chuột') && n.includes('phím')) return 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&w=200&q=80';
                if (n.includes('chuột') || n.includes('logitech') || n.includes('razer')) return 'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=200&q=80';
                if (n.includes('phím') || n.includes('corsair') || n.includes('wooting')) return 'https://images.unsplash.com/photo-1595225476474-87563907a212?auto=format&fit=crop&w=200&q=80';
                if (n.includes('tai nghe') || n.includes('hyperx')) return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=200&q=80';
                return 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=200&q=80';
            }
            if (n.includes('pepsi') || n.includes('pessi')) return 'https://images.unsplash.com/photo-1629203851122-3726ecdf080e?auto=format&fit=crop&w=200&q=80';
            if (n.includes('coca')) return 'https://images.unsplash.com/photo-1554866585-cd94860890b7?auto=format&fit=crop&w=200&q=80';
            if (n.includes('redbull') || n.includes('bò húc') || n.includes('tăng lực')) return 'https://images.unsplash.com/photo-1622543925917-763c34d1a86e?auto=format&fit=crop&w=200&q=80';
            if (n.includes('sting') || n.includes('dâu')) return 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=200&q=80';
            if (n.includes('trà') || n.includes('cam') || n.includes('chanh')) return 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=200&q=80';
            if (n.includes('cơm gà') || n.includes('gà')) return 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=200&q=80';
            if (n.includes('cơm') || c === 'cơm') return 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=200&q=80';
            if (n.includes('mì trộn') || n.includes('mì xào') || c === 'mì trộn') return 'https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=200&q=80';
            if (n.includes('mì nước') || n.includes('mì cay') || n.includes('mì bò') || c === 'mì nước') return 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=200&q=80';
            if (n.includes('khoai')) return 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=200&q=80';
            if (n.includes('xúc xích') || n.includes('cá viên') || n.includes('snack') || c === 'đồ ăn vặt') return 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=200&q=80';
            if (c === 'nước' || c === 'drink') return 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=200&q=80';
            if (c === 'combo') return 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=200&q=80';
            return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=200&q=80';
        }

        function normalizeCategory(name, rawCat) {
            const n = (name || '').toLowerCase();
            const c = (rawCat || '').trim();
            if (['Cơm', 'Đồ ăn vặt', 'Nước', 'Mì trộn', 'Mì nước', 'GEAR', 'COMBO'].includes(c)) return c;
            if (c.toUpperCase() === 'DRINK') return 'Nước';
            if (n.includes('cơm')) return 'Cơm';
            if (n.includes('mì trộn') || n.includes('mì xào')) return 'Mì trộn';
            if (n.includes('mì')) return 'Mì nước';
            return 'Đồ ăn vặt';
        }

        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.menu-row').forEach(row => {
                const name = row.getAttribute('data-name');
                const rawCat = row.getAttribute('data-category');
                const normalizedCat = normalizeCategory(name, rawCat);

                row.setAttribute('data-normalized-cat', normalizedCat);
                const img = row.querySelector('.food-thumb');
                if (img) {
                    const dbImg = img.getAttribute('data-dbimg');
                    const fallback = getFallbackImage(name, normalizedCat);
                    img.src = (dbImg && dbImg.trim() !== '') ? dbImg : fallback;
                    img.onerror = function() { this.src = fallback; };
                }

                const badge = row.querySelector('.category-label');
                if (badge) badge.textContent = normalizedCat;
            });
        });

        function filterMenu(category, btn) {
            document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');

            document.querySelectorAll('#menuTable .menu-row').forEach(row => {
                const rowCat = row.getAttribute('data-normalized-cat');
                if (category === 'ALL' || rowCat === category) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function openEditDv(btn) {
            const name = btn.getAttribute('data-ten');
            const rawDm = btn.getAttribute('data-dm');
            document.getElementById('editDvId').value = btn.getAttribute('data-id');
            document.getElementById('editTenMon').value = name;
            document.getElementById('editGiaMon').value = btn.getAttribute('data-gia');
            document.getElementById('editTonKho').value = btn.getAttribute('data-ton');
            document.getElementById('editDanhMuc').value = normalizeCategory(name, rawDm);
            document.getElementById('editHinhAnh').value = btn.getAttribute('data-img') || '';
            new bootstrap.Modal(document.getElementById('editDvModal')).show();
        }
    </script>
</body>
</html>