<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>RedZone - Đăng Nhập</title>
</head>
<body style="font-family: Arial; text-align: center; margin-top: 100px;">
    <h2>HỆ THỐNG QUẢN LÝ PHÒNG GAME</h2>

    <!-- Thông báo đăng ký thành công (Màu xanh) -->
    <h4 style="color: green;">${msg}</h4>

    <!-- Thông báo lỗi (Màu đỏ) - Bao gồm cả lỗi từ AuthFilter đẩy ra -->
    <h4 style="color: red;">${error}</h4>

    <!-- Form gửi dữ liệu đến LoginServlet -->
    <form action="${pageContext.request.contextPath}/login" method="post" style="display: inline-block; text-align: left; padding: 20px; border: 1px solid #ccc; width: 250px;">
        <label>Tài khoản:</label><br>
        <input type="text" name="username" required style="width: 100%; margin-bottom: 15px; padding: 5px;"><br>

        <label>Mật khẩu:</label><br>
        <input type="password" name="password" required style="width: 100%; margin-bottom: 15px; padding: 5px;"><br>

        <button type="submit" style="width: 100%; padding: 10px; background: #007bff; color: white; border: none; cursor: pointer;">ĐĂNG NHẬP</button>
    </form>

    <div style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/register.jsp">Chưa có tài khoản? Đăng ký ngay</a>
    </div>
</body>
</html>