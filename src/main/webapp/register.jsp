<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - RedZone System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-dark text-white d-flex align-items-center justify-content-center vh-100">
    <div class="card bg-secondary p-4 rounded shadow" style="width: 400px;">
        <h3 class="text-center mb-4 text-warning">ĐĂNG KÝ TÀI KHOẢN</h3>
        <form action="register" method="post">
            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <input type="text" name="fullName" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-warning w-100 mb-3 fw-bold">ĐĂNG KÝ</button>
            <div class="text-center">
                <a href="index.jsp" class="text-white text-decoration-none">Đã có tài khoản? Đăng nhập</a>
            </div>
        </form>
    </div>
</body>
</html>
