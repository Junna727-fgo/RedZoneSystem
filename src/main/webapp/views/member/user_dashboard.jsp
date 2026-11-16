<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<body style="background: #f0fff0; font-family: Arial; padding: 20px;">
    <h2>GIAO DIỆN HỘI VIÊN</h2>
    <p>Xin chào, <b>${sessionScope.userLog.hoTen}</b>!</p>
    <ul><li>Đặt máy / Mua đồ ăn</li></ul>
    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
</body>
</html>