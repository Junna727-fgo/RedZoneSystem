<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>RedZone - Bảng Điều Khiển Kỹ Thuật (IT)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Quản Lý Kỹ Thuật & Bảo Trì Phòng Máy</h2>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
    </div>

    <!-- 1. TÌNH TRẠNG MÁY TRẠM -->
    <div class="card bg-secondary text-white mb-4">
        <div class="card-header fw-bold">1. Giám Sát & Cập Nhật Tình Trạng Máy Trạm</div>
        <div class="card-body">
            <table class="table table-dark table-striped align-middle">
                <thead>
                <tr>
                    <th>Mã Máy</th>
                    <th>Phòng</th>
                    <th>Tên Máy</th>
                    <th>Cấu Hình</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác Nhanh</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${listMayTram}">
                    <tr>
                        <td>#${m.maMay}</td>
                        <td>Phòng ${m.maPhong}</td>
                        <td>${m.tenMay}</td>
                        <td>${m.cauHinh}</td>
                        <td>
                            <span class="badge ${m.trangThai == 'SanSang' ? 'bg-success' : (m.trangThai == 'BaoTri' ? 'bg-warning text-dark' : 'bg-danger')}">
                                ${m.trangThai}
                            </span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="d-flex gap-2">
                                <input type="hidden" name="action" value="updateMayStatus">
                                <input type="hidden" name="maMay" value="${m.maMay}">
                                <select name="trangThai" class="form-select form-select-sm w-auto">
                                    <option value="SanSang" ${m.trangThai == 'SanSang' ? 'selected' : ''}>Sẵn Sàng</option>
                                    <option value="BaoTri" ${m.trangThai == 'BaoTri' ? 'selected' : ''}>Bảo Trì</option>
                                    <option value="Hong" ${m.trangThai == 'Hong' ? 'selected' : ''}>Hỏng</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 2. LẬP BIÊN BẢN SỰ CỐ & QUẢN LÝ BẢO TRÌ -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card bg-secondary text-white">
                <div class="card-header fw-bold">2. Lập Biên Bản Sự Cố Mới</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/it/dashboard" method="post">
                        <input type="hidden" name="action" value="lapBienBan">
                        <div class="mb-2">
                            <label class="form-label">Chọn Máy Trạm</label>
                            <select name="maMay" class="form-select" required>
                                <c:forEach var="m" items="${listMayTram}">
                                    <option value="${m.maMay}">${m.tenMay} (Phòng ${m.maPhong})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Thiết Bị Lỗi (Tùy chọn)</label>
                            <select name="maThietBi" class="form-select">
                                <option value="">-- Lỗi phần mềm / Toàn máy --</option>
                                <c:forEach var="tb" items="${listThietBi}">
                                    <option value="${tb.maThietBi}">${tb.tenThietBi} (Máy #${tb.maMay})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Mô Tả Sự Cố</label>
                            <textarea name="moTaSuCo" class="form-control" rows="2" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chi Phí Dự Kiến (VNĐ)</label>
                            <input type="number" name="chiPhi" class="form-control" value="0" min="0" required>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 fw-bold">Lập Biên Bản & Khóa Máy</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card bg-secondary text-white">
                <div class="card-header fw-bold">Danh Sách Biên Bản Bảo Trì</div>
                <div class="card-body">
                    <table class="table table-dark table-bordered align-middle">
                        <thead>
                        <tr>
                            <th>Mã BB</th>
                            <th>Máy / TB</th>
                            <th>Ngày Lập</th>
                            <th>Mô Tả Sự Cố</th>
                            <th>Chi Phí</th>
                            <th>Trạng Thái</th>
                            <th>Xử Lý</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="bb" items="${listBienBan}">
                            <tr>
                                <td>#${bb.maBienBan}</td>
                                <td>Máy #${bb.maMay} <c:if test="${bb.maThietBi != null}">(TB #${bb.maThietBi})</c:if></td>
                                <td>${bb.ngayLap}</td>
                                <td>${bb.moTaSuCo}</td>
                                <td>${bb.chiPhi} đ</td>
                                <td>
                                    <span class="badge ${bb.trangThaiXuLy == 'HoanThanh' ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${bb.trangThaiXuLy}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${bb.trangThaiXuLy == 'DangXuLy'}">
                                        <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="d-flex gap-1">
                                            <input type="hidden" name="action" value="hoanTatBaoTri">
                                            <input type="hidden" name="maBienBan" value="${bb.maBienBan}">
                                            <input type="hidden" name="maMay" value="${bb.maMay}">
                                            <input type="number" name="chiPhi" value="${bb.chiPhi}" class="form-control form-control-sm" style="width:90px">
                                            <button type="submit" class="btn btn-success btn-sm">Xong</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. QUẢN LÝ THIẾT BỊ PHẦN CỨNG -->
    <div class="card bg-secondary text-white">
        <div class="card-header fw-bold">3. Quản Lý Thiết Bị Phần Cứng Phòng Máy</div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/it/dashboard" method="post" class="row g-2 mb-3">
                <input type="hidden" name="action" value="addThietBi">
                <div class="col-md-2">
                    <select name="maMay" class="form-select" required>
                        <c:forEach var="m" items="${listMayTram}">
                            <option value="${m.maMay}">Máy #${m.maMay} - ${m.tenMay}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="text" name="tenThietBi" class="form-control" placeholder="Tên TB (VD: Chuột Logitech)" required>
                </div>
                <div class="col-md-2">
                    <input type="text" name="soSerial" class="form-control" placeholder="Số Serial" required>
                </div>
                <div class="col-md-2">
                    <select name="tinhTrang" class="form-select">
                        <option value="Tot">Tốt</option>
                        <option value="CanBaoTri">Cần bảo trì</option>
                        <option value="HuHong">Hư hỏng</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="text" name="moTaSuCo" class="form-control" placeholder="Ghi chú tình trạng">
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-info w-100">Thêm</button>
                </div>
            </form>

            <table class="table table-dark table-sm align-middle">
                <thead>
                <tr>
                    <th>Mã TB</th>
                    <th>Thuộc Máy</th>
                    <th>Tên Thiết Bị</th>
                    <th>Số Serial</th>
                    <th>Tình Trạng</th>
                    <th>Mô Tả Sự Cố</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="tb" items="${listThietBi}">
                    <tr>
                        <td>#${tb.maThietBi}</td>
                        <td>Máy #${tb.maMay}</td>
                        <td>${tb.tenThietBi}</td>
                        <td>${tb.soSerial}</td>
                        <td>${tb.tinhTrang}</td>
                        <td>${tb.moTaSuCo}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>