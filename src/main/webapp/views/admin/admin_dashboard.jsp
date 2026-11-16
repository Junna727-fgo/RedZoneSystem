<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - RedZone</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; padding: 40px; }
        .dashboard-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); max-width: 600px; margin: 0 auto; }
        h2 { color: #cc0000; border-bottom: 2px solid #cc0000; padding-bottom: 10px; margin-top: 0; }
        ul { line-height: 2.2; font-size: 16px; }
        a.menu-link { color: #007bff; text-decoration: none; font-weight: bold; }
        a.menu-link:hover { text-decoration: underline; }
        .btn-logout { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #333; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .btn-logout:hover { background: #555; }
    </style>
</head>
<body>
    <div class="dashboard-box">
        <h2>TRUNG TÂM ĐIỀU HÀNH ADMIN</h2>
        <p>Xin chào Chủ quán, <b style="color: #cc0000;">${sessionScope.userLog.hoTen}</b>!</p>

        <h3>Danh mục quản lý:</h3>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-link">Quản lý Tài khoản</a>
                (Xem danh sách, Khóa / Mở khóa, Xóa user)
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/may-tram" class="menu-link">Quản lý Phòng & Máy trạm</a>
                (Giám sát trạng thái máy, Bảo trì)
            </li>
            <li><span style="color: gray;">Quản lý Kho F&B & Khuyến mãi (Đang phát triển)</span></li>
            <li><span style="color: gray;">Thống kê Doanh thu tổng quát (Đang phát triển)</span></li>
        </ul>

        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất hệ thống</a>
    </div>
</body>
</html>