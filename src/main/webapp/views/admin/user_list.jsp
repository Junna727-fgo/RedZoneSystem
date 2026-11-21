<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tài Khoản - RedZone Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@500;600;700&family=Montserrat:ital,wght@0,800;1,900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-abyss: #030a18;
            --card-bg: #07193d;
            --input-bg: #041028;
            --cyan: #00e5ff;
            --cyan-glow: rgba(0, 229, 255, 0.35);
            --border: rgba(0, 229, 255, 0.28);
            --danger: #ff2a55;
        }
        body {
            min-height: 100vh;
            background: radial-gradient(circle at 20% 15%, #0e3888 0%, #061430 48%, #020814 100%);
            color: #f4f9ff;
            font-family: 'Chakra Petch', sans-serif;
        }
        .navbar-p3r {
            background: rgba(4, 14, 36, 0.95);
            border-bottom: 2px solid var(--cyan);
            box-shadow: 0 4px 20px rgba(0, 229, 255, 0.18);
            padding: 0.8rem 2rem;
        }
        .brand-logo {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 1.4rem;
            color: #fff !important;
            letter-spacing: 1.5px;
            text-decoration: none;
        }
        .brand-logo i, .brand-logo span { color: var(--cyan); }
        .page-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            letter-spacing: 1.5px;
            border-left: 4px solid var(--cyan);
            padding-left: 14px;
            text-transform: uppercase;
        }
        .btn-back {
            border: 1px solid var(--cyan);
            color: var(--cyan);
            font-weight: 700;
        }
        .btn-back:hover { background: var(--cyan); color: var(--bg-abyss); }
        .p3r-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-top: 3px solid var(--cyan);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.55);
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
            font-family: 'Montserrat', sans-serif;
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
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-style: italic;
            font-size: 0.82rem;
            text-transform: uppercase;
            border-bottom: 2px solid var(--cyan);
            padding: 0.9rem 0.75rem;
        }
        .table-p3r td { vertical-align: middle; padding: 0.85rem 0.75rem; }
        .modal-p3r .modal-content {
            background: #061636;
            border: 1px solid var(--cyan);
            border-top: 4px solid var(--cyan);
            color: #fff;
        }
        .modal-p3r .modal-header { border-bottom: 1px solid var(--border); }
        .modal-p3r .modal-footer { border-top: 1px solid var(--border); }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-p3r mb-4">
        <div class="container-fluid">
            <a class="navbar-brand brand-logo" href="dashboard">
                <i class="fa-solid fa-terminal me-2"></i>REDZONE <span>ADMIN</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm fw-bold">
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

        <div class="p3r-card p-4 mb-4">
            <h5 class="text-white fw-bold mb-3">
                <i class="fa-solid fa-user-plus me-2" style="color: var(--cyan);"></i>Thêm Tài Khoản Mới
            </h5>
            <form action="users" method="post" class="row g-3">
                <input type="hidden" name="type" value="add">
                <div class="col-md-2">
                    <input type="text" name="username" class="form-control form-p3r" placeholder="Username" required>
                </div>
                <div class="col-md-2">
                    <input type="password" name="password" class="form-control form-p3r" placeholder="Mật khẩu" required>
                </div>
                <div class="col-md-3">
                    <input type="text" name="fullName" class="form-control form-p3r" placeholder="Họ và tên" required>
                </div>
                <div class="col-md-2">
                    <select name="role" class="form-select form-p3r">
                        <option value="Admin">Admin</option>
                        <option value="IT">IT</option>
                        <option value="Member" selected>Member</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="number" step="1000" min="0" name="balance" class="form-control form-p3r" placeholder="Số dư (VNĐ)" value="0">
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
                                <td class="fw-bold text-info">#${u.id}</td>
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
                                <td class="fw-bold" style="color: var(--cyan);">
                                    <fmt:formatNumber value="${u.balance}" type="number" maxFractionDigits="0"/> VNĐ
                                </td>
                                <td class="text-end text-nowrap">
                                    <button type="button" class="btn btn-outline-info btn-sm fw-bold"
                                            onclick="openEditModal('${u.id}', '${u.username}', '${u.fullName}', '${u.role}', '${u.balance}')">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </button>
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

    <div class="modal fade modal-p3r" id="editUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="users" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);"><i class="fa-solid fa-user-pen me-2"></i>Cập Nhật Tài Khoản</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="update">
                    <input type="hidden" name="id" id="editUserId">
                    <div class="mb-3">
                        <label class="form-label text-info">Tên đăng nhập</label>
                        <input type="text" id="editUsername" class="form-control form-p3r" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" name="fullName" id="editFullName" class="form-control form-p3r" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phân quyền (Vai trò)</label>
                        <select name="role" id="editRole" class="form-select form-p3r">
                            <option value="Admin">Admin (Chủ phòng game)</option>
                            <option value="IT">IT (Nhân viên kỹ thuật / Thu ngân)</option>
                            <option value="Member">Member (Hội viên)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số dư ví (VNĐ)</label>
                        <input type="number" step="1000" min="0" name="balance" id="editBalance" class="form-control form-p3r" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-p3r px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal fade modal-p3r" id="resetPassModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="users" method="post" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color: var(--cyan);"><i class="fa-solid fa-key me-2"></i>Cấp Lại Mật Khẩu</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="type" value="reset">
                    <input type="hidden" name="id" id="resetUserId">
                    <p class="text-light">Đặt lại mật khẩu mới cho tài khoản: <strong id="resetUsername" style="color: var(--cyan);"></strong></p>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control form-p3r" placeholder="Nhập mật khẩu mới..." required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-p3r px-4">Xác Nhận Đổi</button>
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