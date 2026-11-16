<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<body style="background: #f0f8ff; font-family: Arial; padding: 20px;">
    <h2>GIAO DIỆN KỸ THUẬT / THU NGÂN</h2>
    <p>Xin chào, <b>${sessionScope.userLog.hoTen}</b>!</p>
    <ul><li>Mở máy / Nạp tiền</li></ul>
    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
</body>
</html>