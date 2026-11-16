<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Người Dùng</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f9; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        th { background-color: #cc0000; color: white; }

        .badge { padding: 5px 10px; border-radius: 15px; color: white; font-size: 12px; font-weight: bold; }
        .bg-success { background-color: #28a745; }
        .bg-danger { background-color: #dc3545; }

        .btn { padding: 8px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 12px; margin: 2px; display: inline-block; cursor: pointer; }
        .btn-warning { background-color: #ff9800; color: black; font-weight: bold;}
        .btn-info { background-color: #17a2b8; font-weight: bold;}
        .btn-danger { background-color: #dc3545; font-weight: bold;}
    </style>
</head>
<body>
    <div class="container">
        <h2 style="color: #cc0000;">QUẢN LÝ TÀI KHOẢN HỆ THỐNG</h2>

        <table>
            <tr>
                <th>Mã TK</th>
                <th>Tên Đăng Nhập</th>
                <th>Họ & Tên</th>
                <th>Vai Trò</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>

            <c:forEach items="${danhSachUser}" var="u">
                <tr>
                    <td>${u.maTK}</td>
                    <td><b>${u.username}</b></td>
                    <td>${u.hoTen}</td>
                    <td>${u.role}</td>
                    <td>
                        <c:choose>
                            <c:when test="${u.trangThai == 'ACTIVE'}">
                                <span class="badge bg-success">Hoạt động</span>
                            </c:when>
                            <c:when test="${u.trangThai == 'LOCKED'}">
                                <span class="badge bg-danger">Đã khóa</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge">${u.trangThai}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- Không cho phép Admin tự khóa/xóa chính mình (Giả sử Admin gốc là MaTK = 1) -->
                        <c:if test="${u.maTK != 1}">

                            <c:if test="${u.trangThai == 'ACTIVE'}">
                                <a href="${pageContext.request.contextPath}/admin/users?action=lock&id=${u.maTK}"
                                   class="btn btn-warning" onclick="return confirm('Bạn có chắc chắn muốn KHÓA tài khoản ${u.username}?');">Khóa</a>
                            </c:if>

                            <c:if test="${u.trangThai == 'LOCKED'}">
                                <a href="${pageContext.request.contextPath}/admin/users?action=unlock&id=${u.maTK}"
                                   class="btn btn-info">Mở Khóa</a>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${u.maTK}"
                               class="btn btn-danger" onclick="return confirm('CẢNH BÁO: Xóa vĩnh viễn tài khoản ${u.username}? Hành động này không thể hoàn tác!');">Xóa</a>

                        </c:if>
                    </td>
                </tr>
            </c:forEach>

        </table>

        <br><br>
        <a href="${pageContext.request.contextPath}/views/admin/admin_dashboard.jsp"
           style="text-decoration: none; padding: 10px 15px; background: #6c757d; border-radius: 4px; color: white;">&larr; Trở về Dashboard</a>
    </div>
</body>
</html>