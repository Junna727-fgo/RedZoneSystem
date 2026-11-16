<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Tài Khoản - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0a0a0c;
            --card-bg: #141418;
            --input-bg: #1c1c24;
            --red-primary: #ff1e27;
            --red-glow: rgba(255, 30, 39, 0.35);
            --border-color: #2a2a35;
        }
        body {
            background-color: var(--bg-dark);
            color: #f1f1f1;
            font-family: 'Rajdhani', sans-serif;
            min-height: 100vh;
            background-image: radial-gradient(circle at 15% 15%, rgba(255, 30, 39, 0.08) 0%, transparent 40%);
        }
        .navbar-cyber {
            background-color: rgba(15, 15, 19, 0.95);
            border-bottom: 2px solid var(--red-primary);
            box-shadow: 0 4px 20px rgba(255, 30, 39, 0.2);
            padding: 0.8rem 2rem;
        }
        .brand-logo {
            font-family: 'Orbitron', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            color: #fff !important;
            letter-spacing: 2px;
        }
        .brand-logo span { color: var(--red-primary); }
        .page-title {
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            letter-spacing: 1.5px;
            border-left: 4px solid var(--red-primary);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .btn-back {
            border: 1px solid #4b5563;
            color: #d1d5db;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-back:hover {
            border-color: var(--red-primary);
            color: #fff;
            background: rgba(255, 30, 39, 0.15);
        }
        .cyber-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-top: 3px solid var(--red-primary);
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
        .form-control-cyber, .form-select-cyber {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: #fff;
            font-size: 1rem;
        }
        .form-control-cyber:focus, .form-select-cyber:focus {
            background-color: #22222b;
            border-color: var(--red-primary);
            box-shadow: 0 0 10px rgba(255, 30, 39, 0.25);
            color: #fff;
        }
        .btn-cyber {
            background: linear-gradient(90deg, #c80d14, var(--red-primary));
            border: none;
            color: #fff;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s;
        }
        .btn-cyber:hover {
            box-shadow: 0 0 15px var(--red-glow);
            color: #fff;
        }
        .table-cyber {
            --bs-table-bg: #141418;
            --bs-table-color: #e5e7eb;
            --bs-table-border-color: #2a2a35;
            --bs-table-striped-bg: #191920;
            --bs-table-hover-bg: #202029;
        }
        .table-cyber thead th {
            background-color: #1c1c24;
            color: var(--red-primary);
            font-family: 'Orbitron', sans-serif;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            border-bottom: 2px solid var(--red-primary);
            padding: 1rem 0.75rem;
        }
        .table-cyber td {
            vertical-align: middle;
            padding: 0.85rem 0.75rem;
            font-size: 1.05rem;
        }
        .modal-cyber .modal-content {
            background-color: #16161d;
            border: 1px solid var(--red-primary);
            color: #fff;
        }
        .modal-cyber .modal-header {
            border-bottom: 1px solid #2a2a35;
        }
        .modal-cyber .modal-footer {
            border-top: 1px solid #2a2a35;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-cyber mb-4">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-fire-flame-curved text-danger me-2"></i>REDZONE <span>ADMIN</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="page-title m-0">Quản Lý Tài Khoản</h3>
            <a href="dashboard" class="btn btn-back px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <!-- Form Thêm Tài Khoản -->
        <div class="cyber-card p-4 mb-4">
            <h5 class="text-white fw-bold mb-3">
                <i class="fa-solid fa-user-plus text-danger me-2"></i>Thêm Tài Khoản Mới
            </h5>
            <form action="users" method="post" class="row g-3">
                <input type="hidden" name="type" value="add">
                <div class="col-md-2">
                    <input type="text" name="username" class="form-control form-control-cyber" placeholder="Username" required>
                </div>
                <div class="col-md-2">
                    <input type="password" name="password" class="form-control form-control-cyber" placeholder="Mật khẩu" required>
                </div>
                <div class="col-md-3">
                    <input type="text" name="fullName" class="form-control form-control-cyber" placeholder="Họ và tên" required>
                </div>
                <div class="col-md-2">
                    <select name="role" class="form-select form-select-cyber">
                        <option value="Admin">Admin</option>
                        <option value="IT">IT</option>
                        <option value="Member" selected>Member</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="number" step="1000" min="0" name="balance" class="form-control form-control-cyber" placeholder="Số dư (VNĐ)" value="0">
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-cyber w-100 h-100">Thêm</button>
                </div>
            </form>
        </div>

        <!-- Bảng danh sách tài khoản -->
        <div class="cyber-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-cyber table-striped table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Họ Tên</th>
                            <th>Vai Trò</th>
                            <th>Trạng Thái</th>
                            <th>Số Dư Ví</th>
                            <th class="text-end">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr>
                                <td class="fw-bold text-secondary">#${u.id}</td>
                                <td class="fw-bold text-white">${u.username}</td>
                                <td>${u.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'Admin'}"><span class="badge bg-danger">ADMIN</span></c:when>
                                        <c:when test="${u.role == 'IT'}"><span class="badge bg-info text-dark">IT STAFF</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">MEMBER</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.trangThai == 1}">
                                            <span class="badge bg-success"><i class="fa-solid fa-circle-check me-1"></i>Hoạt động</span>
                                        </c:when>
                                        <c:when test="${u.trangThai == 0}">
                                            <span class="badge bg-danger"><i class="fa-solid fa-lock me-1"></i>Đã khóa</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock me-1"></i>Chờ duyệt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold text-warning">
                                    <fmt:formatNumber value="${u.balance}" type="number" maxFractionDigits="0"/> VNĐ
                                </td>
                                <td class="text-end">
                                    <!-- Nút Sửa thông tin & Phân quyền -->
                                    <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                            onclick="openEditModal('${u.id}', '${u.username}', '${u.fullName}', '${u.role}', '${u.balance}')">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </button>

                                    <!-- Nút Cấp lại mật khẩu -->
                                    <button type="button" class="btn btn-outline-light btn-sm fw-bold ms-1"
                                            onclick="openResetModal('${u.id}', '${u.username}')">
                                        <i class="fa-solid fa-key"></i> Đổi MK
                                    </button>

                                    <c:if test="${u.trangThai == 2}">
                                        <a href="users?action=approve&id=${u.id}" class="btn btn-success btn-sm fw-bold ms-1">Duyệt</a>
                                    </c:if>
                                    <c:if test="${u.trangThai == 1}">
                                        <a href="users?action=lock&id=${u.id}" class="btn btn-outline-warning btn-sm fw-bold ms-1">
                                            <i class="fa-solid fa-lock"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${u.trangThai == 0}">
                                        <a href="users?action=unlock&id=${u.id}" class="btn btn-outline-success btn-sm fw-bold ms-1">
                                            <i class="fa-solid fa-unlock"></i>
                                        </a>
                                    </c:if>
                                    <a href="users?action=delete&id=${u.id}" class="btn btn-outline-danger btn-sm fw-bold ms-1" onclick="return confirm('Xóa tài khoản này?')">
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

    <!-- Modal Sửa Thông Tin & Phân Quyền -->
    <div class="modal fade modal-cyber" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="users" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-user-pen me-2"></i>Cập Nhật Tài Khoản</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="update">
                    <input type="hidden" name="id" id="editUserId">
                    <div class="mb-3">
                        <label class="form-label text-secondary">Tên đăng nhập</label>
                        <input type="text" id="editUsername" class="form-control form-control-cyber" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" name="fullName" id="editFullName" class="form-control form-control-cyber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phân quyền (Vai trò)</label>
                        <select name="role" id="editRole" class="form-select form-select-cyber">
                            <option value="Admin">Admin (Chủ phòng game)</option>
                            <option value="IT">IT (Nhân viên kỹ thuật / Thu ngân)</option>
                            <option value="Member">Member (Hội viên)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số dư ví (VNĐ)</label>
                        <input type="number" step="1000" min="0" name="balance" id="editBalance" class="form-control form-control-cyber" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-cyber px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Cấp Lại Mật Khẩu -->
    <div class="modal fade modal-cyber" id="resetPassModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="users" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-key me-2"></i>Cấp Lại Mật Khẩu</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="reset">
                    <input type="hidden" name="id" id="resetUserId">
                    <p class="text-light">Đặt lại mật khẩu mới cho tài khoản: <strong id="resetUsername" class="text-warning"></strong></p>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control form-control-cyber" placeholder="Nhập mật khẩu mới..." required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-cyber px-4">Xác Nhận Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditModal(id, username, fullName, role, balance) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editUsername').value = username;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editRole').value = role;
            document.getElementById('editBalance').value = balance;
            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        }

        function openResetModal(id, username) {
            document.getElementById('resetUserId').value = id;
            document.getElementById('resetUsername').innerText = username;
            new bootstrap.Modal(document.getElementById('resetPassModal')).show();
        }
    </script>
</body>
</html>