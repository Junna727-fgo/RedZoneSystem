<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.redzone.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "profile";
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
    String roomFilter = (String) request.getAttribute("roomFilter");
    if (roomFilter == null) roomFilter = "ALL";

    List<Computer> computers = (List<Computer>) session.getAttribute("computers");
    List<MenuItem> menuItems = (List<MenuItem>) session.getAttribute("menuItems");
    List<Booking> bookingHistory = (List<Booking>) session.getAttribute("bookingHistory");
    List<ServiceOrder> orderHistory = (List<ServiceOrder>) session.getAttribute("orderHistory");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cổng Hội Viên - RedZoneSystem</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background-color: #121417; color: #e4e6eb; }
        .navbar { background-color: #1c1f24; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e63946; }
        .navbar h1 { margin: 0; font-size: 22px; color: #e63946; letter-spacing: 1px; }
        .user-info { font-size: 15px; }
        .balance-badge { background: #198754; color: #fff; padding: 5px 12px; border-radius: 20px; font-weight: bold; margin-left: 8px; }
        .container { max-width: 1000px; margin: 25px auto; padding: 0 15px; }
        
        /* Tabs */
        .tabs { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 1px solid #333; padding-bottom: 10px; }
        .tab-btn { background: #242830; color: #ccc; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-size: 15px; font-weight: 600; transition: 0.2s; }
        .tab-btn:hover { background: #323842; color: #fff; }
        .tab-btn.active { background: #e63946; color: #fff; }
        .tab-content { display: none; background: #1c1f24; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.4); }
        .tab-content.active { display: block; }

        /* Forms & Tables */
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        .card { background: #242830; padding: 20px; border-radius: 8px; border: 1px solid #333; }
        h3 { margin-top: 0; color: #f8f9fa; border-bottom: 1px solid #3a3f4b; padding-bottom: 10px; }
        label { display: block; margin-bottom: 5px; font-size: 14px; color: #adb5bd; }
        input[type="text"], input[type="email"], input[type="number"], input[type="time"], select {
            width: 100%; padding: 9px 12px; margin-bottom: 15px; background: #121417; border: 1px solid #444; color: #fff; border-radius: 5px; box-sizing: border-box;
        }
        .btn { background: #e63946; color: #fff; border: none; padding: 10px 18px; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn:hover { background: #c92a36; }
        .btn-green { background: #198754; }
        .btn-green:hover { background: #157347; }
        .btn-blue { background: #0d6efd; }
        .btn-blue:hover { background: #0b5ed7; }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #333; font-size: 14px; }
        th { background-color: #242830; color: #e63946; }
        .status-avail { color: #20c997; font-weight: bold; }
        .status-busy { color: #dc3545; font-weight: bold; }
        .alert-success { background: #14532d; color: #bbf7d0; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; border-left: 4px solid #22c55e; }
        .alert-error { background: #7f1d1d; color: #fecaca; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; border-left: 4px solid #ef4444; }
    </style>
</head>
<body>

<div class="navbar">
    <h1>REDZONE GAMING SYSTEM</h1>
    <div class="user-info">
        Hội viên: <strong><%= user.getFullName() %></strong> (<%= user.getUsername() %>)
        <span class="balance-badge">Số dư: <%= user.getBalance() %> VNĐ</span>
        &nbsp;|&nbsp; <a href="<%= request.getContextPath() %>/logout" style="color: #adb5bd; text-decoration: none;">Đăng xuất (UC-01)</a>
    </div>
</div>

<div class="container">
    <% if (request.getAttribute("message") != null) { %>
        <div class="alert-success"><%= request.getAttribute("message") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <!-- Thanh điều hướng các nhóm Use Case của Khách hàng (Hội viên) -->
    <div class="tabs">
        <button class="tab-btn <%= "profile".equals(activeTab) ? "active" : "" %>" onclick="openTab('profile')">
            1. Hồ sơ & Nạp tiền (UC-04.4, UC-09)
        </button>
        <button class="tab-btn <%= "booking".equals(activeTab) ? "active" : "" %>" onclick="openTab('booking')">
            2. Tìm & Đặt phòng/máy (UC-07.2, UC-08)
        </button>
        <button class="tab-btn <%= "service".equals(activeTab) ? "active" : "" %>" onclick="openTab('service')">
            3. Gọi món & Combo tại máy (UC-12, UC-13.1)
        </button>
    </div>

    <!-- TAB 1: HỒ SƠ & NẠP TIỀN -->
    <div id="tab-profile" class="tab-content <%= "profile".equals(activeTab) ? "active" : "" %>">
        <div class="grid-2">
            <div class="card">
                <h3>Cập nhật hồ sơ cá nhân (UC-04.4)</h3>
                <form action="<%= request.getContextPath() %>/profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <label>Tên đăng nhập:</label>
                    <input type="text" value="<%= user.getUsername() %>" disabled>
                    <label>Họ và tên:</label>
                    <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                    <label>Số điện thoại:</label>
                    <input type="text" name="phone" value="<%= user.getPhone() %>">
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= user.getEmail() %>">
                    <button type="submit" class="btn btn-blue">Lưu thông tin hồ sơ</button>
                </form>
            </div>

            <div class="card">
                <h3>Nạp tiền tài khoản hội viên (UC-09 & UC-10.1)</h3>
                <form action="<%= request.getContextPath() %>/profile" method="post">
                    <input type="hidden" name="action" value="topUp">
                    <label>Hình thức & Phương thức nạp (UC-09.1):</label>
                    <select name="method">
                        <option value="Ví điện tử MoMo">Ví điện tử MoMo (Tự động)</option>
                        <option value="Chuyển khoản Ngân hàng QR">Chuyển khoản Ngân hàng (VietQR)</option>
                        <option value="Thanh toán tại quầy">Nạp tiền mặt tại quầy thu ngân</option>
                    </select>
                    <label>Số tiền muốn nạp (VNĐ):</label>
                    <input type="number" name="amount" min="10000" step="5000" placeholder="Ví dụ: 50000" required>
                    <button type="submit" class="btn btn-green">Xác nhận nạp tiền</button>
                </form>
            </div>
        </div>
    </div>

    <!-- TAB 2: TÌM KIẾM & ĐẶT TRƯỚC PHÒNG / MÁY TRẠM -->
    <div id="tab-booking" class="tab-content <%= "booking".equals(activeTab) ? "active" : "" %>">
        <div class="card" style="margin-bottom: 20px;">
            <h3>Tìm kiếm & Lọc mã máy, mã phòng (UC-07.2)</h3>
            <form action="<%= request.getContextPath() %>/profile" method="get" style="display: flex; gap: 15px; align-items: flex-end;">
                <input type="hidden" name="tab" value="booking">
                <div style="flex: 2;">
                    <label>Tìm theo mã máy (VD: MAY-01, VIP-01):</label>
                    <input type="text" name="keyword" value="<%= keyword %>" style="margin-bottom: 0;" placeholder="Nhập mã máy...">
                </div>
                <div style="flex: 1;">
                    <label>Lọc theo khu vực phòng:</label>
                    <select name="roomFilter" style="margin-bottom: 0;">
                        <option value="ALL" <%= "ALL".equals(roomFilter) ? "selected" : "" %>>Tất cả phòng</option>
                        <option value="Phòng Thường" <%= "Phòng Thường".equals(roomFilter) ? "selected" : "" %>>Phòng Thường</option>
                        <option value="Phòng VIP" <%= "Phòng VIP".equals(roomFilter) ? "selected" : "" %>>Phòng VIP</option>
                        <option value="Phòng Thi Đấu" <%= "Phòng Thi Đấu".equals(roomFilter) ? "selected" : "" %>>Phòng Thi Đấu</option>
                        <option value="Phòng Đôi" <%= "Phòng Đôi".equals(roomFilter) ? "selected" : "" %>>Phòng Đôi</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-blue">Tìm & Lọc</button>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Mã máy</th>
                        <th>Khu vực phòng</th>
                        <th>Cấu hình</th>
                        <th>Giá giờ</th>
                        <th>Trạng thái</th>
                        <th>Đặt trước (UC-08)</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (computers != null) {
                        for (Computer c : computers) { %>
                    <tr>
                        <td><strong><%= c.getMachineCode() %></strong></td>
                        <td><%= c.getRoomName() %></td>
                        <td><%= c.getSpecs() %></td>
                        <td><%= c.getPricePerHour() %> đ/h</td>
                        <td>
                            <% if ("AVAILABLE".equals(c.getStatus())) { %>
                                <span class="status-avail">Sẵn sàng</span>
                            <% } else { %>
                                <span class="status-busy"><%= c.getStatus() %></span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("AVAILABLE".equals(c.getStatus())) { %>
                            <form action="<%= request.getContextPath() %>/profile" method="post" style="display: flex; gap: 6px; align-items: center;">
                                <input type="hidden" name="action" value="bookMachine">
                                <input type="hidden" name="machineCode" value="<%= c.getMachineCode() %>">
                                <input type="hidden" name="roomName" value="<%= c.getRoomName() %>">
                                <input type="time" name="timeSlot" value="19:00" required style="width: 105px; margin: 0; padding: 5px;">
                                <input type="number" name="hours" value="2" min="1" max="12" required style="width: 55px; margin: 0; padding: 5px;" title="Số giờ chơi">
                                <button type="submit" class="btn" style="padding: 6px 10px;">Đặt chỗ</button>
                            </form>
                            <% } else { %>
                                <span style="color: #777;">Không khả dụng</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>Lịch sử yêu cầu đặt phòng / máy trạm (UC-08.2)</h3>
            <table>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Mã máy</th>
                        <th>Phòng</th>
                        <th>Khung giờ bắt đầu</th>
                        <th>Thời lượng</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bookingHistory != null && !bookingHistory.isEmpty()) {
                        for (Booking b : bookingHistory) { %>
                    <tr>
                        <td>#BK<%= b.getBookingId() %></td>
                        <td><strong><%= b.getMachineCode() %></strong></td>
                        <td><%= b.getRoomName() %></td>
                        <td><%= b.getTimeSlot() %></td>
                        <td><%= b.getHours() %> giờ</td>
                        <td style="color: #ffc107;"><%= b.getStatus() %></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" style="text-align: center; color: #777;">Chưa có yêu cầu đặt máy nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- TAB 3: GỌI MÓN ĂN / NƯỚC UỐNG & COMBO TẠI MÁY -->
    <div id="tab-service" class="tab-content <%= "service".equals(activeTab) ? "active" : "" %>">
        <div class="grid-2">
            <div class="card">
                <h3>Gọi món ăn / nước uống tại máy (UC-12)</h3>
                <form action="<%= request.getContextPath() %>/profile" method="post">
                    <input type="hidden" name="action" value="orderService">
                    <label>Chọn máy đang ngồi:</label>
                    <select name="machineCode">
                        <option value="MAY-01">MAY-01 (Phòng Thường)</option>
                        <option value="VIP-01">VIP-01 (Phòng VIP)</option>
                        <option value="VIP-02">VIP-02 (Phòng VIP)</option>
                        <option value="COMP-01">COMP-01 (Phòng Thi Đấu)</option>
                    </select>

                    <label>Chọn Món ăn / Đồ uống / Combo:</label>
                    <select name="itemId">
                        <% if (menuItems != null) {
                            for (MenuItem m : menuItems) { %>
                        <option value="<%= m.getItemId() %>">[<%= m.getCategory() %>] <%= m.getItemName() %> - <%= m.getPrice() %> VNĐ</option>
                        <% } } %>
                    </select>

                    <label>Số lượng:</label>
                    <input type="number" name="quantity" value="1" min="1" max="20" required>

                    <label>Mã khuyến mãi / Combo (UC-13.1 - Nhập REDZONE10 hoặc VIP20):</label>
                    <input type="text" name="promoCode" placeholder="Nhập mã giảm giá (nếu có)...">

                    <button type="submit" class="btn btn-green">Đặt món & Thanh toán bằng số dư</button>
                </form>
            </div>

            <div class="card">
                <h3>Danh sách món đã gọi tại máy</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Máy</th>
                            <th>Món / Combo</th>
                            <th>SL</th>
                            <th>Khuyến mãi</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orderHistory != null && !orderHistory.isEmpty()) {
                            for (ServiceOrder o : orderHistory) { %>
                        <tr>
                            <td><strong><%= o.getMachineCode() %></strong></td>
                            <td><%= o.getItemName() %></td>
                            <td><%= o.getQuantity() %></td>
                            <td><%= o.getPromoCode() %></td>
                            <td style="color: #20c997;"><%= o.getFinalAmount() %> đ</td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" style="text-align: center; color: #777;">Chưa gọi món nào.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function openTab(tabName) {
        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
        document.getElementById('tab-' + tabName).classList.add('active');
        event.currentTarget.classList.add('active');
    }
</script>
</body>
</html>
