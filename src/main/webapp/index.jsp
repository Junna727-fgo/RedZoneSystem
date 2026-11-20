<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - RedZone Cyber System</title>
    <!-- Bootstrap 5, FontAwesome & Google Fonts -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-dark: #09090b;
            --card-bg: #131318;
            --input-bg: #1c1c24;
            --red-primary: #ff1e27;
            --red-dark: #b80d14;
            --red-glow: rgba(255, 30, 39, 0.4);
            --border-color: #2a2a35;
        }

        body {
            background-color: var(--bg-dark);
            color: #fff;
            font-family: 'Rajdhani', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            background-image:
                linear-gradient(rgba(255, 30, 39, 0.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 30, 39, 0.04) 1px, transparent 1px),
                radial-gradient(circle at 50% 50%, rgba(255, 30, 39, 0.12) 0%, transparent 65%);
            background-size: 40px 40px, 40px 40px, 100% 100%;
        }

        .login-container {
            width: 100%;
            max-width: 430px;
            padding: 15px;
            z-index: 2;
        }

        .login-card {
            background: linear-gradient(160deg, #16161d 0%, #0e0e12 100%);
            border: 1px solid var(--border-color);
            border-top: 3px solid var(--red-primary);
            border-radius: 14px;
            padding: 2.5rem 2.2rem;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.85), 0 0 25px rgba(255, 30, 39, 0.15);
            position: relative;
        }

        /* Góc trang trí công nghệ */
        .login-card::after {
            content: "";
            position: absolute;
            bottom: -1px;
            right: -1px;
            width: 25px;
            height: 25px;
            border-bottom: 3px solid var(--red-primary);
            border-right: 3px solid var(--red-primary);
            border-bottom-right-radius: 14px;
        }

        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .brand-icon {
            font-size: 2.6rem;
            color: var(--red-primary);
            text-shadow: 0 0 15px var(--red-glow);
            margin-bottom: 0.5rem;
        }

        .brand-title {
            font-family: 'Orbitron', sans-serif;
            font-weight: 800;
            font-size: 1.75rem;
            letter-spacing: 2px;
            margin: 0;
            color: #fff;
        }

        .brand-title span {
            color: var(--red-primary);
            text-shadow: 0 0 12px var(--red-glow);
        }

        .brand-subtitle {
            color: #8b92a5;
            font-size: 0.95rem;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-top: 4px;
        }

        .form-label {
            color: #d1d5db;
            font-weight: 600;
            letter-spacing: 0.5px;
            font-size: 1rem;
            margin-bottom: 0.4rem;
        }

        .input-group-cyber {
            position: relative;
        }

        .input-group-cyber i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            transition: color 0.3s ease;
        }

        .form-control-cyber {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 0.75rem 1rem 0.75rem 2.7rem;
            border-radius: 8px;
            font-size: 1.05rem;
            width: 100%;
            transition: all 0.3s ease;
        }

        .form-control-cyber:focus {
            background-color: #22222b;
            border-color: var(--red-primary);
            box-shadow: 0 0 12px rgba(255, 30, 39, 0.25);
            outline: none;
            color: #fff;
        }

        .form-control-cyber:focus + i,
        .input-group-cyber:focus-within i {
            color: var(--red-primary);
        }

        .remember-cyber {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #9ca3af;
            font-size: 0.98rem;
            cursor: pointer;
            user-select: none;
        }

        .remember-cyber input[type="checkbox"] {
            accent-color: var(--red-primary);
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .btn-cyber-login {
            background: linear-gradient(90deg, var(--red-dark), var(--red-primary));
            border: none;
            color: #fff;
            font-family: 'Orbitron', sans-serif;
            font-weight: 600;
            font-size: 1rem;
            letter-spacing: 2px;
            padding: 0.85rem;
            border-radius: 8px;
            width: 100%;
            margin-top: 0.5rem;
            text-transform: uppercase;
            transition: all 0.3s ease;
        }

        .btn-cyber-login:hover {
            background: linear-gradient(90deg, var(--red-primary), #ff474e);
            box-shadow: 0 0 20px var(--red-glow);
            transform: translateY(-2px);
        }

        .register-link {
            color: #9ca3af;
            font-size: 0.98rem;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .register-link span {
            color: var(--red-primary);
            font-weight: 700;
            text-decoration: underline;
        }

        .register-link:hover span {
            color: #ff5259;
            text-shadow: 0 0 8px var(--red-glow);
        }

        .alert-cyber {
            background-color: rgba(255, 30, 39, 0.15);
            border: 1px solid var(--red-primary);
            color: #ff8085;
            font-size: 0.95rem;
            padding: 0.65rem 1rem;
            border-radius: 8px;
            margin-bottom: 1.2rem;
            text-align: center;
        }

        .alert-cyber-success {
            background-color: rgba(16, 185, 129, 0.15);
            border: 1px solid #10b981;
            color: #6ee7b7;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-card">
            <div class="brand-header">
                <div class="brand-icon">
                    <i class="fa-solid fa-fire-flame-curved"></i>
                </div>
                <h1 class="brand-title">RED<span>ZONE</span></h1>
                <div class="brand-subtitle">Cyber Gaming System</div>
            </div>

            <!-- Thông báo lỗi / thành công tự động bắt từ URL -->
            <c:if test="${param.error == 'invalid'}">
                <div class="alert-cyber">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Sai tên đăng nhập, mật khẩu hoặc tài khoản bị khóa!
                </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert-cyber">
                    <i class="fa-solid fa-ban me-1"></i> Bạn không có quyền truy cập khu vực này!
                </div>
            </c:if>
            <c:if test="${param.error == 'login_required'}">
                <div class="alert-cyber">
                    <i class="fa-solid fa-shield-halved me-1"></i> Vui lòng đăng nhập để tiếp tục!
                </div>
            </c:if>
            <c:if test="${param.success == 'registered'}">
                <div class="alert-cyber alert-cyber-success">
                    <i class="fa-solid fa-circle-check me-1"></i> Đăng ký thành công! Vui lòng chờ Admin duyệt.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <div class="input-group-cyber">
                        <input type="text" name="username" value="${cookie.c_user.value}" class="form-control-cyber" placeholder="Nhập tài khoản..." required autocomplete="off">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group-cyber">
                        <input type="password" name="password" class="form-control-cyber" placeholder="Nhập mật khẩu..." required>
                        <i class="fa-solid fa-lock"></i>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="remember-cyber">
                        <input type="checkbox" name="remember" ${cookie.c_remember.value == 'true' ? 'checked' : ''}>
                        Ghi nhớ tài khoản đăng nhập
                    </label>
                </div>

                <button type="submit" class="btn btn-cyber-login">
                    Đăng Nhập <i class="fa-solid fa-right-to-bracket ms-1"></i>
                </button>

                <div class="text-center mt-4">
                    <a href="register.jsp" class="register-link">
                        Chưa có tài khoản? <span>Đăng ký ngay</span>
                    </a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>