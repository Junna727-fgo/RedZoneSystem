<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, com.redzone.dao.DBConnection" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // 1. Tự động xử lý xác nhận giao đơn F&B / Thuê Gear nếu IT bấm nút "Xác nhận đã giao"
    String quickAction = request.getParameter("quickAction");
    if ("completeOrder".equals(quickAction)) {
        String orderId = request.getParameter("orderId");
        if (orderId != null && !orderId.isEmpty()) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("UPDATE ServiceOrders SET status = 'COMPLETED' WHERE order_id = ?")) {
                ps.setInt(1, Integer.parseInt(orderId));
                ps.executeUpdate();
            } catch (Exception e) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE ServiceOrders SET status = 'COMPLETED' WHERE id = ?")) {
                    ps.setInt(1, Integer.parseInt(orderId));
                    ps.executeUpdate();
                } catch (Exception ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/it/dashboard?tab=orders");
            return;
        }
    }

    // 2. Lấy Map Tên Phòng từ bảng PHONG_MAY để hiển thị tên khu vực thật thay vì "Phòng #1"
    Map<Integer, String> roomNameMap = new HashMap<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT MaPhong, TenPhong FROM PHONG_MAY");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            roomNameMap.put(rs.getInt("MaPhong"), rs.getString("TenPhong"));
        }
    } catch (Exception ignored) {}
    request.setAttribute("roomNameMap", roomNameMap);

    // 3. Lấy danh sách đơn F&B và Thuê Gear từ bảng ServiceOrders (loại trừ đơn nạp tiền TOPUP)
    ArrayList serviceOrderList = new ArrayList();
    int pendingOrders = 0;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT TOP 30 * FROM ServiceOrders WHERE ISNULL(promo_code, '') <> 'TOPUP' ORDER BY 1 DESC");
         ResultSet rs = ps.executeQuery()) {
        ResultSetMetaData meta = rs.getMetaData();
        int colCount = meta.getColumnCount();
        while (rs.next()) {
            HashMap row = new HashMap();
            for (int i = 1; i <= colCount; i++) {
                row.put(meta.getColumnName(i).toLowerCase(), rs.getObject(i));
            }
            if (!"COMPLETED".equalsIgnoreCase(String.valueOf(row.get("status")))) {
                pendingOrders++;
            }
            serviceOrderList.add(row);
        }
    } catch (Exception ignored) {}
    request.setAttribute("serviceOrderList", serviceOrderList);
    request.setAttribute("pendingOrders", pendingOrders);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RedZone IT - Trung Tâm Kỹ Thuật &amp; Vận Hành</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        * { box-sizing: border-box; }
        body {
            min-height: 100vh;
            background: radial-gradient(circle at 20% 15%, #0e3888 0%, #061430 48%, #020814 100%);
            color: #f4f9ff;
            margin: 0;
        }
        .wrapper { display: flex; min-height: 100vh; }

        /* SIDEBAR TRÁI */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #091533 0%, #050b1c 100%);
            border-right: 1px solid var(--border);
            box-shadow: 4px 0 25px rgba(0, 0, 0, 0.6);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; bottom: 0; left: 0;
            z-index: 1000;
        }
        .sidebar-brand {
            padding: 1.35rem 1.5rem;
            border-bottom: 1px solid var(--border);
            font-weight: 900;
            font-style: italic;
            font-size: 1.25rem;
            color: #fff;
            text-decoration: none;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sidebar-brand i, .sidebar-brand span { color: var(--cyan); }
        .sidebar-menu { list-style: none; padding: 1.2rem 0.9rem; margin: 0; flex: 1; }
        .sidebar-item { margin-bottom: 0.45rem; }
        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 0.85rem 1rem;
            color: var(--muted);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.96rem;
            text-transform: uppercase;
            border-radius: 8px;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
            transition: all 0.25s ease;
            cursor: pointer;
        }
        .sidebar-link i { width: 22px; text-align: center; font-size: 1.1rem; }
        .sidebar-link:hover { color: #fff; background: rgba(0, 229, 255, 0.1); }
        .sidebar-link.active {
            background: linear-gradient(90deg, rgba(0, 229, 255, 0.25), rgba(0, 119, 255, 0.12));
            color: #fff;
            border-left: 4px solid var(--cyan);
            box-shadow: 0 0 15px rgba(0, 229, 255, 0.15);
        }
        .sidebar-link.active i { color: var(--cyan); }

        /* MAIN PANEL */
        .main-panel { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar {
            height: 68px;
            background: rgba(4, 14, 36, 0.95);
            border-bottom: 2px solid var(--cyan);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
        }
        .page-title {
            font-weight: 900;
            font-style: italic;
            font-size: 1.15rem;
            margin: 0;
            text-transform: uppercase;
        }

        /* CARDS & TABLES */
        .p3r-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.55);
        }
        .stat-box {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 1.1rem 1.3rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .stat-val {
            font-weight: 900;
            font-size: 1.65rem;
            color: #fff;
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
            padding: 0.85rem 0.75rem;
        }
        .table-p3r td { vertical-align: middle; padding: 0.8rem 0.75rem; }

        /* LƯỚI SƠ ĐỒ MÁY TRẠM TRỰC QUAN */
        .pc-node {
            background: #041028;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            padding: 1rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .pc-node:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0, 229, 255, 0.22);
        }
        .pc-node.status-ok { border-top: 4px solid #00e676; }
        .pc-node.status-use { border-top: 4px solid #00d2ff; }
        .pc-node.status-warn { border-top: 4px solid #ffca28; }

        @media (max-width: 992px) {
            .sidebar { width: 72px; }
            .sidebar-brand span, .sidebar-brand div, .sidebar-link span { display: none; }
            .main-panel { margin-left: 72px; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- SIDEBAR ĐIỀU HƯỚNG IT -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/it/dashboard" class="sidebar-brand">
            <i class="fa-solid fa-microchip"></i>
            <div>REDZONE <span>IT</span></div>
        </a>

        <ul class="sidebar-menu nav flex-column" role="tablist">
            <li class="sidebar-item">
                <button class="sidebar-link ${param.tab == null || param.tab == 'machines' ? 'active' : ''}"
                        data-bs-toggle="tab" data-bs-target="#tab-machines" type="button">
                    <i class="fa-solid fa-desktop"></i>
                    <span>Giám Sát Phòng Máy</span>
                </button>
            </li>
            <li class="sidebar-item">
                <button class="sidebar-link ${param.tab == 'maintenance' ? 'active' : ''}"
                        data-bs-toggle="tab" data-bs-target="#tab-maintenance" type="button">
                    <i class="fa-solid fa-screwdriver-wrench"></i>
                    <span>Sự Cố &amp; Bảo Trì</span>
                </button>
            </li>
            <li class="sidebar-item">
                <button class="sidebar-link ${param.tab == 'hardware' ? 'active' : ''}"
                        data-bs-toggle="tab" data-bs-target="#tab-hardware" type="button">
                    <i class="fa-solid fa-memory"></i>
                    <span>Kho Linh Kiện / Gear</span>
                </button>
            </li>
            <li class="sidebar-item">
                <button class="sidebar-link ${param.tab == 'orders' ? 'active' : ''}"
                        data-bs-toggle="tab" data-bs-target="#tab-orders" type="button">
                    <i class="fa-solid fa-headset"></i>
                    <span>Giao Gear &amp; F&amp;B</span>
                    <c:if test="${pendingOrders > 0}">
                        <span class="badge bg-danger ms-auto">${pendingOrders}</span>
                    </c:if>
                </button>
            </li>
            <li class="sidebar-item mt-3 pt-3" style="border-top: 1px solid var(--border);">
                <a href="${pageContext.request.contextPath}/profile.jsp" class="sidebar-link">
                    <i class="fa-solid fa-id-badge"></i>
                    <span>Hồ Sơ Cá Nhân</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- MAIN CONTENT -->
    <div class="main-panel">
        <header class="topbar">
            <div class="d-flex align-items-center gap-3">
                <h1 class="page-title">IT Technical Control Center</h1>
                <span class="badge bg-info text-dark fw-bold">
                    <i class="fa-solid fa-circle-check me-1"></i> Ca Trực Kỹ Thuật
                </span>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="text-light fw-semibold">
                    <i class="fa-solid fa-user-gear text-info me-1"></i>
                    Kỹ thuật viên: <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'IT Staff'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm fw-bold">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </header>

        <div class="container-fluid p-4">
            <!-- THỐNG KÊ NHANH -->
            <c:set var="totalPc" value="0"/>
            <c:set var="readyPc" value="0"/>
            <c:set var="issuePc" value="0"/>
            <c:forEach var="m" items="${listMayTram}">
                <c:set var="totalPc" value="${totalPc + 1}"/>
                <c:choose>
                    <c:when test="${m.trangThai == 'AVAILABLE' || m.trangThai == 'SanSang'}">
                        <c:set var="readyPc" value="${readyPc + 1}"/>
                    </c:when>
                    <c:when test="${m.trangThai == 'MAINTENANCE' || m.trangThai == 'BaoTri' || m.trangThai == 'Hong'}">
                        <c:set var="issuePc" value="${issuePc + 1}"/>
                    </c:when>
                </c:choose>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-box">
                        <div>
                            <div class="text-uppercase small fw-bold" style="color: var(--muted);">Tổng Số Máy Trạm</div>
                            <div class="stat-val">${totalPc}</div>
                        </div>
                        <i class="fa-solid fa-computer fa-2x text-info opacity-75"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div>
                            <div class="text-uppercase small fw-bold" style="color: var(--muted);">Sẵn Sàng Hoạt Động</div>
                            <div class="stat-val text-success">${readyPc}</div>
                        </div>
                        <i class="fa-solid fa-circle-check fa-2x text-success opacity-75"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div>
                            <div class="text-uppercase small fw-bold" style="color: var(--muted);">Đang Bảo Trì / Lỗi</div>
                            <div class="stat-val text-warning">${issuePc}</div>
                        </div>
                        <i class="fa-solid fa-triangle-exclamation fa-2x text-warning opacity-75"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div>
                            <div class="text-uppercase small fw-bold" style="color: var(--muted);">Đơn Chờ Giao Gear / F&amp;B</div>
                            <div class="stat-val text-info">${pendingOrders}</div>
                        </div>
                        <i class="fa-solid fa-bell-concierge fa-2x text-info opacity-75"></i>
                    </div>
                </div>
            </div>

            <!-- NỘI DUNG CÁC TAB -->
            <div class="tab-content">
                <!-- TAB 1: GIÁM SÁT & CẬP NHẬT TRẠNG THÁI MÁY TRẠM -->
                <div class="tab-pane fade ${param.tab == null || param.tab == 'machines' ? 'show active' : ''}" id="tab-machines">
                    <!-- Sơ đồ trực quan từng máy -->
                    <div class="p3r-card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold m-0" style="color: var(--cyan);">
                                <i class="fa-solid fa-grip me-2"></i>Sơ Đồ Trạng Thái Máy Trạm Trực Quan
                            </h5>
                            <div class="small">
                                <span class="badge bg-success me-1">Sẵn sàng</span>
                                <span class="badge bg-info text-dark me-1">Đang chơi</span>
                                <span class="badge bg-warning text-dark">Bảo trì</span>
                            </div>
                        </div>
                        <div class="row g-3">
                            <c:forEach var="m" items="${listMayTram}">
                                <c:set var="isOk" value="${m.trangThai == 'AVAILABLE' || m.trangThai == 'SanSang'}"/>
                                <c:set var="isUse" value="${m.trangThai == 'IN_USE'}"/>
                                <div class="col-xl-3 col-md-4 col-sm-6">
                                    <div class="pc-node ${isOk ? 'status-ok' : (isUse ? 'status-use' : 'status-warn')}">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="fw-bold fs-5 text-white">
                                                <i class="fa-solid fa-desktop me-1 text-info"></i>${m.tenMay}
                                            </span>
                                            <span class="badge ${isOk ? 'bg-success' : (isUse ? 'bg-info text-dark' : 'bg-warning text-dark')}">
                                                ${isOk ? 'Sẵn sàng' : (isUse ? 'Đang chơi' : 'Bảo trì')}
                                            </span>
                                        </div>
                                        <div class="small mb-2" style="color: var(--muted);">
                                            ${roomNameMap[m.maPhong] != null ? roomNameMap[m.maPhong] : 'Phòng #' += m.maPhong} • ID: #${m.maMay}
                                        </div>
                                        <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="d-flex gap-2 mt-2">
                                            <input type="hidden" name="action" value="updateMayStatus">
                                            <input type="hidden" name="maMay" value="${m.maMay}">
                                            <select name="trangThai" class="form-select form-select-sm form-p3r">
                                                <option value="AVAILABLE" ${isOk ? 'selected' : ''}>Sẵn Sàng</option>
                                                <option value="IN_USE" ${isUse ? 'selected' : ''}>Đang Chơi</option>
                                                <option value="MAINTENANCE" ${!isOk && !isUse ? 'selected' : ''}>Bảo Trì</option>
                                            </select>
                                            <button type="submit" class="btn btn-p3r btn-sm px-3">Lưu</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Bảng chi tiết cấu hình máy trạm -->
                    <div class="p3r-card overflow-hidden">
                        <div class="p-3 border-bottom" style="border-color: var(--border) !important;">
                            <h6 class="fw-bold m-0 text-white"><i class="fa-solid fa-list-check me-2 text-info"></i>Bảng Chi Tiết Cấu Hình &amp; Trạng Thái</h6>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-p3r table-striped table-hover mb-0">
                                <thead>
                                <tr>
                                    <th>Mã Máy</th>
                                    <th>Khu Vực / Phòng</th>
                                    <th>Tên Máy</th>
                                    <th>Cấu Hình</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Cập Nhật Nhanh</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="m" items="${listMayTram}">
                                    <c:set var="isOk" value="${m.trangThai == 'AVAILABLE' || m.trangThai == 'SanSang'}"/>
                                    <c:set var="isUse" value="${m.trangThai == 'IN_USE'}"/>
                                    <tr>
                                        <td class="fw-bold text-info">#${m.maMay}</td>
                                        <td class="fw-semibold text-white">${roomNameMap[m.maPhong] != null ? roomNameMap[m.maPhong] : 'Phòng #' += m.maPhong}</td>
                                        <td class="fw-bold text-info">${m.tenMay}</td>
                                        <td style="color: var(--muted);">${m.cauHinh}</td>
                                        <td>
                                            <span class="badge ${isOk ? 'bg-success' : (isUse ? 'bg-info text-dark' : 'bg-warning text-dark')}">
                                                ${isOk ? 'Sẵn sàng' : (isUse ? 'Đang chơi' : 'Bảo trì')}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="d-inline-flex gap-2">
                                                <input type="hidden" name="action" value="updateMayStatus">
                                                <input type="hidden" name="maMay" value="${m.maMay}">
                                                <select name="trangThai" class="form-select form-select-sm form-p3r w-auto">
                                                    <option value="AVAILABLE" ${isOk ? 'selected' : ''}>Sẵn Sàng</option>
                                                    <option value="IN_USE" ${isUse ? 'selected' : ''}>Đang Chơi</option>
                                                    <option value="MAINTENANCE" ${!isOk && !isUse ? 'selected' : ''}>Bảo Trì</option>
                                                </select>
                                                <button type="submit" class="btn btn-p3r btn-sm">Lưu</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- TAB 2: LẬP BIÊN BẢN SỰ CỐ & QUẢN LÝ BẢO TRÌ -->
                <div class="tab-pane fade ${param.tab == 'maintenance' ? 'show active' : ''}" id="tab-maintenance">
                    <div class="row g-4">
                        <div class="col-lg-4">
                            <div class="p3r-card p-4">
                                <h5 class="fw-bold mb-3" style="color: var(--cyan);">
                                    <i class="fa-solid fa-file-circle-exclamation me-2"></i>Lập Biên Bản Sự Cố Mới
                                </h5>
                                <form action="${pageContext.request.contextPath}/it/dashboard" method="post">
                                    <input type="hidden" name="action" value="lapBienBan">
                                    <div class="mb-3">
                                        <label class="form-label">Chọn Máy Trạm</label>
                                        <select name="maMay" class="form-select form-p3r" required>
                                            <c:forEach var="m" items="${listMayTram}">
                                                <option value="${m.maMay}">${m.tenMay} (${roomNameMap[m.maPhong] != null ? roomNameMap[m.maPhong] : 'Phòng #' += m.maPhong})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Thiết Bị Lỗi (Tùy chọn)</label>
                                        <select name="maThietBi" class="form-select form-p3r">
                                            <option value="">-- Lỗi phần mềm / Toàn máy --</option>
                                            <c:forEach var="tb" items="${listThietBi}">
                                                <option value="${tb.maThietBi}">${tb.tenThietBi} (Máy #${tb.maMay})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mô Tả Sự Cố</label>
                                        <textarea name="moTaSuCo" class="form-control form-p3r" rows="3" placeholder="VD: Mất tín hiệu màn hình, kẹt phím Space..." required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Chi Phí Dự Kiến (VNĐ)</label>
                                        <input type="number" name="chiPhi" class="form-control form-p3r" value="0" min="0" required>
                                    </div>
                                    <button type="submit" class="btn btn-warning w-100 fw-bold py-2">
                                        <i class="fa-solid fa-lock me-1"></i> Lập Biên Bản &amp; Khóa Máy
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="col-lg-8">
                            <div class="p3r-card overflow-hidden">
                                <div class="p-3 border-bottom" style="border-color: var(--border) !important;">
                                    <h5 class="fw-bold m-0 text-white"><i class="fa-solid fa-clipboard-list me-2 text-info"></i>Danh Sách Biên Bản Bảo Trì</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-p3r table-striped table-hover mb-0">
                                        <thead>
                                        <tr>
                                            <th>Mã BB</th>
                                            <th>Máy / TB</th>
                                            <th>Ngày Lập</th>
                                            <th>Mô Tả Sự Cố</th>
                                            <th>Chi Phí</th>
                                            <th>Trạng Thái</th>
                                            <th class="text-end">Xử Lý</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="bb" items="${listBienBan}">
                                            <tr>
                                                <td class="fw-bold text-info">#${bb.maBienBan}</td>
                                                <td class="fw-semibold">Máy #${bb.maMay} <c:if test="${bb.maThietBi != null}">(TB #${bb.maThietBi})</c:if></td>
                                                <td>${bb.ngayLap}</td>
                                                <td>${bb.moTaSuCo}</td>
                                                <td class="fw-bold text-warning"><fmt:formatNumber value="${bb.chiPhi}" maxFractionDigits="0"/> đ</td>
                                                <td>
                                                    <span class="badge ${bb.trangThaiXuLy == 'HoanThanh' ? 'bg-success' : 'bg-warning text-dark'}">
                                                        ${bb.trangThaiXuLy}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <c:if test="${bb.trangThaiXuLy == 'DangXuLy'}">
                                                        <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="d-inline-flex gap-1">
                                                            <input type="hidden" name="action" value="hoanTatBaoTri">
                                                            <input type="hidden" name="maBienBan" value="${bb.maBienBan}">
                                                            <input type="hidden" name="maMay" value="${bb.maMay}">
                                                            <input type="number" name="chiPhi" value="${bb.chiPhi}" class="form-control form-control-sm form-p3r" style="width:95px">
                                                            <button type="submit" class="btn btn-success btn-sm fw-bold">Xong</button>
                                                        </form>
                                                    </c:if>
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

                <!-- TAB 3: QUẢN LÝ THIẾT BỊ PHẦN CỨNG -->
                <div class="tab-pane fade ${param.tab == 'hardware' ? 'show active' : ''}" id="tab-hardware">
                    <div class="p3r-card p-4 mb-4">
                        <h5 class="fw-bold mb-3" style="color: var(--cyan);">
                            <i class="fa-solid fa-plus-circle me-2"></i>Thêm Thiết Bị Phần Cứng Vào Máy Trạm
                        </h5>
                        <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="row g-3">
                            <input type="hidden" name="action" value="addThietBi">
                            <div class="col-md-2">
                                <select name="maMay" class="form-select form-p3r" required>
                                    <c:forEach var="m" items="${listMayTram}">
                                        <option value="${m.maMay}">Máy #${m.maMay} - ${m.tenMay}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <input type="text" name="tenThietBi" class="form-control form-p3r" placeholder="Tên TB (VD: Chuột Logitech G Pro)" required>
                            </div>
                            <div class="col-md-2">
                                <input type="text" name="soSerial" class="form-control form-p3r" placeholder="Số Serial" required>
                            </div>
                            <div class="col-md-2">
                                <select name="tinhTrang" class="form-select form-p3r">
                                    <option value="Tot">Tốt</option>
                                    <option value="CanBaoTri">Cần bảo trì</option>
                                    <option value="HuHong">Hư hỏng</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="text" name="moTaSuCo" class="form-control form-p3r" placeholder="Ghi chú tình trạng">
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
                                    <th>Mã TB</th>
                                    <th>Thuộc Máy</th>
                                    <th>Tên Thiết Bị</th>
                                    <th>Số Serial</th>
                                    <th>Tình Trạng</th>
                                    <th>Mô Tả / Ghi Chú</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="tb" items="${listThietBi}">
                                    <tr>
                                        <td class="fw-bold text-info">#${tb.maThietBi}</td>
                                        <td class="fw-semibold">Máy #${tb.maMay}</td>
                                        <td class="fw-bold text-white">${tb.tenThietBi}</td>
                                        <td><code>${tb.soSerial}</code></td>
                                        <td>
                                            <span class="badge ${tb.tinhTrang == 'Tot' ? 'bg-success' : (tb.tinhTrang == 'CanBaoTri' ? 'bg-warning text-dark' : 'bg-danger')}">
                                                ${tb.tinhTrang}
                                            </span>
                                        </td>
                                        <td style="color: var(--muted);">${tb.moTaSuCo}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- TAB 4: GIAO GEAR & PHỤC VỤ F&B TỪ MEMBER -->
                <div class="tab-pane fade ${param.tab == 'orders' ? 'show active' : ''}" id="tab-orders">
                    <div class="p3r-card overflow-hidden">
                        <div class="p-3 border-bottom d-flex justify-content-between align-items-center" style="border-color: var(--border) !important;">
                            <h5 class="fw-bold m-0" style="color: var(--cyan);">
                                <i class="fa-solid fa-headset me-2"></i>Yêu Cầu Thuê Gear &amp; Gọi Món Từ Hội Viên
                            </h5>
                            <span class="small" style="color: var(--muted);">Đồng bộ trực tiếp với cổng Member</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-p3r table-striped table-hover mb-0">
                                <thead>
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Vị Trí Máy</th>
                                    <th>Nội Dung (Thuê Gear / Món)</th>
                                    <th>Số Lượng</th>
                                    <th>Tổng Thanh Toán</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Thao Tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="ord" items="${serviceOrderList}">
                                    <c:set var="oid" value="${ord['order_id'] != null ? ord['order_id'] : ord['id']}"/>
                                    <tr>
                                        <td class="fw-bold text-info">#${oid}</td>
                                        <td><span class="badge bg-primary fs-6">${ord['machine_code']}</span></td>
                                        <td class="fw-bold text-white">${ord['item_name']}</td>
                                        <td>${ord['quantity']}</td>
                                        <td class="fw-bold" style="color: var(--cyan);">
                                            <fmt:formatNumber value="${ord['final_amount']}" maxFractionDigits="0"/> VNĐ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ord['status'] == 'COMPLETED'}">
                                                    <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i>Đã giao tới máy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark"><i class="fa-solid fa-spinner fa-spin me-1"></i>Đang chuẩn bị / Giao</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${ord['status'] != 'COMPLETED'}">
                                                <a href="${pageContext.request.contextPath}/it/dashboard?quickAction=completeOrder&orderId=${oid}"
                                                   class="btn btn-p3r btn-sm px-3">
                                                    <i class="fa-solid fa-truck-fast me-1"></i> Xác nhận đã giao
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty serviceOrderList}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">
                                            Hiện chưa có yêu cầu thuê Gear hoặc gọi món mới từ hội viên.
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
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>