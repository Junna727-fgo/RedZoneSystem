<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>RedZone - Đăng Ký Tài Khoản</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .register-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        input { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        button { width: 100%; padding: 10px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        button:hover { background: #218838; }
        .error { color: red; font-size: 14px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="register-box">
        <h2 style="color: #333;">ĐĂNG KÝ HỘI VIÊN</h2>

        <div class="error">${error}</div>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <input type="text" name="username" placeholder="Tên đăng nhập" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <input type="text" name="hoTen" placeholder="Họ và tên" required>
            <input type="text" name="sdt" placeholder="Số điện thoại" required>
            <input type="text" name="cccd" placeholder="CCCD / CMND (Không bắt buộc)">
            <button type="submit">ĐĂNG KÝ NGAY</button>
        </form>

        <div style="margin-top: 15px;">
            <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration: none; color: #007bff;">&larr; Quay lại Đăng nhập</a>
        </div>
    </div>
</body>
</html>