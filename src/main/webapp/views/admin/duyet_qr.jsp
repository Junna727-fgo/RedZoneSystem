<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.redzone.util.TinNhanStore" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    int unreadMsg = TinNhanStore.countUnread();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Thanh Toán VietQR - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-override.css">
    <style>
        :root {
            --bg-main: #060b19;
            --bg-card: #0b1633;
            --cyan-primary: #00d2ff;
            --border-color: rgba(0, 210, 255, 0.22);
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
        }
        * { box-sizing: border-box; }
        body { background-color: var(--bg-main); color: var(--text-main); margin: 0; min-height: 100vh; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #091533 0%, #050b1c 100%);
            border-right: 1px solid var(--border-color);
            box-shadow: 4px 0 25px rgba(0, 0, 0, 0.6);
            display: flex; flex-direction: column;
            position: fixed; top: 0; bottom: 0; left: 0; z-index: 1000;
        }
        .sidebar-brand {
            padding: 1.4rem 1.5rem; border-bottom: 1px solid var(--border-color);
            font-weight: 800; font-size: 1.25rem; color: #fff; text-decoration: none;
            letter-spacing: 1px; display: flex; align-items: center; gap: 10px;
        }
        .sidebar-brand i, .sidebar-brand span { color: var(--cyan-primary); }
        .sidebar-menu { list-style: none; padding: 1.2rem 0.9rem; margin: 0; flex: 1; }
        .sidebar-item { margin-bottom: 0.45rem; }
        .sidebar-link {
            display: flex; align-items: center; gap: 14px; padding: 0.85rem 1.1rem;
            color: var(--text-muted); text-decoration: none; font-weight: 700;
            font-size: 0.96rem; text-transform: uppercase; border-radius: 8px; transition: all 0.25s ease;
        }
        .sidebar-link i { width: 22px; text-align: center; font-size: 1.1rem; }
        .sidebar-link:hover { color: #fff; background: rgba(0, 210, 255, 0.1); }
        .sidebar-link.active {
            background: linear-gradient(90deg, rgba(0, 210, 255, 0.25), rgba(0, 119, 255, 0.12));
            color: #fff; border-left: 4px solid var(--cyan-primary);
        }
        .sidebar-link.active i { color: var(--cyan-primary); }

        .main-panel { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .topbar {
            height: 68px; background-color: rgba(7, 14, 33, 0.92);
            border-bottom: 1px solid var(--border-color); padding: 0 2rem;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 999; backdrop-filter: blur(8px);
        }
        .topbar-title { font-size: 1.2rem; font-weight: 800; margin: 0; color: #fff; }
        .btn-logout-cyber {
            border: 1px solid #ff3b5c; color: #ff5c77; font-weight: 700;
            padding: 0.35rem 0.9rem; border-radius: 6px; text-decoration: none; font-size: 0.92rem;
        }
        .btn-logout-cyber:hover { background: #ff3b5c; color: #fff; }

        .content-wrapper { padding: 1.8rem 2rem; }
        .mini-stat-card {
            background: var(--bg-card); border: 1px solid var(--border-color);
            border-radius: 10px; padding: 1.15rem 1.35rem;
            display: flex; align-items: center; justify-content: space-between;
        }
        .mini-stat-label { font-size: 0.84rem; text-transform: uppercase; color: var(--text-muted); font-weight: 700; }
        .mini-stat-val { font-size: 1.5rem; font-weight: 800; color: #fff; margin-top: 0.2rem; }
        .mini-stat-icon { font-size: 2rem; color: var(--cyan-primary); opacity: 0.8; }

        .bank-banner {
            background: linear-gradient(100deg, rgba(0, 210, 255, 0.14), rgba(0, 119, 255, 0.08));
            border: 1px solid rgba(0, 210, 255, 0.38); border-left: 4px solid var(--cyan-primary);
            border-radius: 10px; padding: 0.95rem 1.3rem;
            display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 12px;
        }
        .dashboard-card {
            background-color: var(--bg-card); border: 1px solid var(--border-color);
            border-radius: 12px; padding: 1.4rem; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.45);
        }
        .filter-pill {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 0.45rem 0.95rem; border-radius: 7px; text-decoration: none;
            font-weight: 700; font-size: 0.88rem; color: #cbd5e1;
            border: 1px solid rgba(0, 210, 255, 0.25); background: rgba(6, 11, 25, 0.7);
            transition: all 0.2s;
        }
        .filter-pill:hover, .filter-pill.active {
            background: var(--cyan-primary); color: #020a18; border-color: var(--cyan-primary);
        }
        .table-cyber { color: #e2e8f0; margin-bottom: 0; }
        .table-cyber thead th {
            background: rgba(0, 210, 255, 0.1); color: var(--cyan-primary);
            border-bottom: 1px solid var(--border-color); font-size: 0.82rem;
            text-transform: uppercase; letter-spacing: 0.6px; padding: 0.85rem 0.75rem;
        }
        .table-cyber tbody td {
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
            vertical-align: middle; padding: 0.85rem 0.75rem; font-size: 0.92rem;
        }
        .table-cyber tbody tr:hover { background: rgba(0, 210, 255, 0.05); }
        .badge-type-topup { background: rgba(0, 245, 160, 0.16); color: #00f5a0; border: 1px solid rgba(0, 245, 160, 0.45); }
        .badge-type-fnb { background: rgba(255, 193, 7, 0.16); color: #ffd43b; border: 1px solid rgba(255, 193, 7, 0.45); }
        .badge-type-gear { background: rgba(0, 210, 255, 0.16); color: #00d2ff; border: 1px solid rgba(0, 210, 255, 0.45); }
    </style>
</head>
<body>
<div class="wrapper">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <a href="dashboard" class="sidebar-brand">
            <i class="fa-solid fa-terminal"></i>
            <div>REDZONE <span>ADMIN</span></div>
        </a>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="dashboard" class="sidebar-link">
                    <i class="fa-solid fa-chart-pie"></i><span>Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="duyet-qr" class="sidebar-link active">
                    <i class="fa-solid fa-qrcode"></i><span>Duyệt Thanh Toán QR</span>
                    <c:if test="${pendingCount > 0}">
                        <span class="badge bg-danger ms-auto">${pendingCount}</span>
                    </c:if>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="users" class="sidebar-link">
                    <i class="fa-solid fa-users-gear"></i><span>Quản Lý Tài Khoản</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="phong-may" class="sidebar-link">
                    <i class="fa-solid fa-desktop"></i><span>Phòng &amp; Máy Trạm</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="dich-vu" class="sidebar-link">
                    <i class="fa-solid fa-utensils"></i><span>Menu F&amp;B &amp; Gear</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="tin-nhan" class="sidebar-link">
                    <i class="fa-solid fa-headset"></i><span>Tin Nhắn Khách</span>
                    <% if (unreadMsg > 0) { %>
                        <span class="badge bg-danger ms-auto"><%= unreadMsg %></span>
                    <% } %>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="bao-cao" class="sidebar-link">
                    <i class="fa-solid fa-file-invoice-dollar"></i><span>Doanh Thu &amp; Báo Cáo</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- MAIN PANEL -->
    <div class="main-panel">
        <header class="topbar">
            <div class="d-flex align-items-center gap-3">
                <h1 class="topbar-title"><i class="fa-solid fa-qrcode text-info me-2"></i>Duyệt Thanh Toán VietQR</h1>
                <a href="duyet-qr?status=${currentStatus}&type=${currentType}" class="btn btn-sm btn-outline-info fw-bold">
                    <i class="fa-solid fa-rotate-right me-1"></i> Làm mới
                </a>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="text-light fw-semibold">
                    <i class="fa-solid fa-user-shield text-info me-1"></i>
                    <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout-cyber">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                </a>
            </div>
        </header>

        <div class="content-wrapper">
            <!-- Thông báo hành động -->
            <c:if test="${param.msg == 'approved'}">
                <div class="alert alert-success d-flex align-items-center gap-2 py-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <strong>Đã duyệt giao dịch thành công!</strong> (Đơn nạp giờ đã tự động cộng tiền vào ví hội viên; đơn dịch vụ đã chuyển sang trạng thái phục vụ).
                </div>
            </c:if>
            <c:if test="${param.msg == 'rejected'}">
                <div class="alert alert-warning d-flex align-items-center gap-2 py-2">
                    <i class="fa-solid fa-ban"></i>
                    <strong>Đã từ chối yêu cầu thanh toán!</strong> Không có tiền nào được cộng vào tài khoản.
                </div>
            </c:if>
            <c:if test="${param.msg == 'failed'}">
                <div class="alert alert-danger d-flex align-items-center gap-2 py-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <strong>Thao tác không thành công!</strong> Đơn này có thể đã được xử lý trước đó.
                </div>
            </c:if>

            <!-- Thông tin tài khoản nhận VietQR -->
            <div class="bank-banner mb-4">
                <div>
                    <div class="text-info fw-bold small text-uppercase mb-1">
                        <i class="fa-solid fa-building-columns me-1"></i> Tài khoản nhận VietQR đang kích hoạt
                    </div>
                    <div class="fs-6 fw-bold text-white">
                        ${bankId} • STK: <span class="text-info">${accountNo}</span> • Chủ TK: <span class="text-warning">${accountName}</span>
                    </div>
                </div>
                <div class="small text-secondary">
                    Đối chiếu biến động số dư App ${bankId} theo đúng <strong>Số tiền</strong> &amp; <strong>Mã CK</strong> trước khi bấm Duyệt.
                </div>
            </div>

            <!-- 3 thẻ thống kê nhanh -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Đơn Đang Chờ Duyệt</div>
                            <div class="mini-stat-val text-warning">${pendingCount} đơn</div>
                            <div class="small text-secondary">Nạp giờ: ${pendingTopUp} • Dịch vụ: ${pendingService}</div>
                        </div>
                        <i class="fa-solid fa-hourglass-half mini-stat-icon text-warning"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Tổng Tiền Chờ Xác Nhận</div>
                            <div class="mini-stat-val text-info">
                                <fmt:formatNumber value="${pendingTotalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                            </div>
                        </div>
                        <i class="fa-solid fa-money-bill-transfer mini-stat-icon"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mini-stat-card">
                        <div>
                            <div class="mini-stat-label">Kết Quả Đang Hiển Thị</div>
                            <div class="mini-stat-val">${paymentList.size()} giao dịch</div>
                        </div>
                        <i class="fa-solid fa-list-check mini-stat-icon text-success"></i>
                    </div>
                </div>
            </div>

            <!-- Bảng danh sách giao dịch -->
            <div class="dashboard-card">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div class="d-flex flex-wrap gap-2">
                        <a href="duyet-qr?status=PENDING&type=${currentType}" class="filter-pill ${currentStatus == 'PENDING' ? 'active' : ''}">
                            <i class="fa-solid fa-clock"></i> Chờ duyệt (${pendingCount})
                        </a>
                        <a href="duyet-qr?status=DONE&type=${currentType}" class="filter-pill ${currentStatus == 'DONE' ? 'active' : ''}">
                            <i class="fa-solid fa-check"></i> Đã duyệt
                        </a>
                        <a href="duyet-qr?status=REJECTED&type=${currentType}" class="filter-pill ${currentStatus == 'REJECTED' ? 'active' : ''}">
                            <i class="fa-solid fa-xmark"></i> Đã từ chối
                        </a>
                        <a href="duyet-qr?status=ALL&type=${currentType}" class="filter-pill ${currentStatus == 'ALL' ? 'active' : ''}">
                            Tất cả
                        </a>
                    </div>

                    <div class="d-flex flex-wrap gap-2">
                        <a href="duyet-qr?status=${currentStatus}&type=ALL" class="filter-pill ${currentType == 'ALL' ? 'active' : ''}">Mọi loại</a>
                        <a href="duyet-qr?status=${currentStatus}&type=TOPUP" class="filter-pill ${currentType == 'TOPUP' ? 'active' : ''}">
                            <i class="fa-solid fa-bolt"></i> Nạp giờ chơi
                        </a>
                        <a href="duyet-qr?status=${currentStatus}&type=SERVICE" class="filter-pill ${currentType == 'SERVICE' ? 'active' : ''}">
                            <i class="fa-solid fa-utensils"></i> Dịch vụ (F&amp;B / Gear)
                        </a>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-cyber align-middle">
                        <thead>
                            <tr>
                                <th>#Mã</th>
                                <th>Hội Viên &amp; Máy</th>
                                <th>Loại GD</th>
                                <th>Nội Dung &amp; Mã CK</th>
                                <th class="text-end">Số Tiền</th>
                                <th>Thời Gian</th>
                                <th>Trạng Thái</th>
                                <th class="text-center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty paymentList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-secondary">
                                        <i class="fa-solid fa-inbox fa-2x mb-2 d-block text-info"></i>
                                        Hiện chưa có yêu cầu thanh toán nào trong mục này.
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="o" items="${paymentList}">
                                <tr>
                                    <td class="fw-bold text-info">#${o.orderId}</td>
                                    <td>
                                        <div class="fw-bold text-white">${o.fullName}</div>
                                        <div class="small text-secondary">@${o.username} • Máy <span class="text-info">${o.machineCode}</span></div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.promoCode == 'TOPUP'}">
                                                <span class="badge badge-type-topup px-2 py-1"><i class="fa-solid fa-clock me-1"></i>Nạp giờ</span>
                                            </c:when>
                                            <c:when test="${o.promoCode == 'GEAR'}">
                                                <span class="badge badge-type-gear px-2 py-1"><i class="fa-solid fa-headset me-1"></i>Thuê Gear</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-type-fnb px-2 py-1"><i class="fa-solid fa-utensils me-1"></i>Đồ ăn / Nước</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="max-width: 300px;">
                                        <div class="text-light">${o.itemName}</div>
                                    </td>
                                    <td class="text-end fw-bold text-success fs-6">
                                        <fmt:formatNumber value="${o.finalAmount}" type="number" maxFractionDigits="0"/>đ
                                    </td>
                                    <td class="small text-secondary">${o.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                            </c:when>
                                            <c:when test="${o.status == 'APPROVED' || o.status == 'COMPLETED'}">
                                                <span class="badge bg-success">${o.statusLabel}</span>
                                            </c:when>
                                            <c:when test="${o.status == 'SERVING'}">
                                                <span class="badge bg-info text-dark">${o.statusLabel}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">${o.statusLabel}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${o.status == 'PENDING'}">
                                            <div class="d-inline-flex gap-1">
                                                <form action="duyet-qr" method="post" class="d-inline"
                                                      onsubmit="return confirm('Xác nhận ĐÃ NHẬN đủ tiền và DUYỆT đơn #${o.orderId}?');">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                                    <input type="hidden" name="status" value="${currentStatus}">
                                                    <input type="hidden" name="type" value="${currentType}">
                                                    <button type="submit" class="btn btn-sm btn-success fw-bold">
                                                        <i class="fa-solid fa-check me-1"></i>Duyệt
                                                    </button>
                                                </form>
                                                <form action="duyet-qr" method="post" class="d-inline"
                                                      onsubmit="return confirm('Từ chối đơn #${o.orderId}?');">
                                                    <input type="hidden" name="action" value="reject">
                                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                                    <input type="hidden" name="status" value="${currentStatus}">
                                                    <input type="hidden" name="type" value="${currentType}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold">
                                                        <i class="fa-solid fa-xmark"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${o.status != 'PENDING'}">
                                            <span class="text-secondary small">—</span>
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
</body>
</html>