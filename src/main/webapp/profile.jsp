<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.redzone.model.User" %>
<%@ page import="com.redzone.model.MenuItem" %>
<%@ page import="com.redzone.model.ServiceOrder" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<String[]> gameList = (List<String[]>) session.getAttribute("gameList");
    List<MenuItem> menuItems = (List<MenuItem>) session.getAttribute("menuItems");
    List<String[]> gearList = (List<String[]>) session.getAttribute("gearList");
    List<ServiceOrder> orderHistory = (List<ServiceOrder>) session.getAttribute("orderHistory");
    List<String> gearHistory = (List<String>) session.getAttribute("gearHistory");
    List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
    Integer remainingMinutes = (Integer) session.getAttribute("remainingMinutes");
    if (remainingMinutes == null) remainingMinutes = 0;

    DecimalFormat df = new DecimalFormat("#,###");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String openModalOnLoad = (String) request.getAttribute("openModalOnLoad");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>REDZONE GAMING - Client Desktop</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: #0b0e14; color: #e2e8f0; display: flex; height: 100vh; overflow: hidden; }

        /* KHU VỰC TRÁI: MÀN HÌNH DESKTOP TRỐNG */
        .desktop-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: radial-gradient(circle at center, #151b28 0%, #0b0e14 100%);
            position: relative;
        }
        .desktop-logo { text-align: center; user-select: none; }
        .desktop-logo h1 { font-size: 56px; font-weight: 900; color: #ef4444; letter-spacing: 3px; text-shadow: 0 10px 30px rgba(239,68,68,0.3); }
        .desktop-logo h1 span { color: #fff; }
        .desktop-logo p { font-size: 18px; color: #64748b; margin-top: 10px; font-weight: 500; letter-spacing: 1px; }

        /* ALERT THÔNG BÁO HIỂN THỊ TRÊN DESKTOP */
        .alerts-container { position: absolute; top: 20px; left: 50%; transform: translateX(-50%); width: 80%; max-width: 600px; z-index: 10; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 10px; font-size: 14px; font-weight: 600; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
        .alert-success { background: rgba(16, 185, 129, 0.9); border: 1px solid #10b981; color: #fff; }
        .alert-error { background: rgba(239, 68, 68, 0.9); border: 1px solid #ef4444; color: #fff; }

        /* KHU VỰC PHẢI: SIDEBAR CLIENT NET */
        .right-sidebar { width: 340px; background: rgba(17, 22, 34, 0.95); border-left: 1px solid #1e293b; padding: 20px; display: flex; flex-direction: column; justify-content: space-between; backdrop-filter: blur(10px); z-index: 20; }
        .user-box { background: linear-gradient(145deg, #182032, #121724); border: 1px solid #263147; border-radius: 12px; padding: 16px; margin-bottom: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.4); }
        .user-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .user-name { font-size: 17px; font-weight: 700; color: #fff; }
        .machine-badge { background: #10b981; color: #052e16; font-size: 11px; font-weight: 800; padding: 3px 8px; border-radius: 6px; }

        .time-stats { display: flex; flex-direction: column; gap: 10px; background: #0b0e14; padding: 12px; border-radius: 8px; border: 1px solid #1e293b; }
        .stat-row { display: flex; justify-content: space-between; font-size: 13px; }
        .stat-label { color: #94a3b8; }
        .stat-val { font-weight: 700; color: #f8fafc; }
        .stat-val.money { color: #34d399; font-size: 15px; }
        .stat-val.countdown { color: #facc15; font-size: 16px; font-family: monospace; }

        /* CÁC NÚT CHỨC NĂNG BÊN PHẢI */
        .action-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px; }
        .func-btn { background: #1a2234; border: 1px solid #2d3748; color: #f8fafc; padding: 14px 8px; border-radius: 10px; font-size: 13px; font-weight: 600; cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 6px; transition: 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.2); }
        .func-btn:hover { background: #ef4444; border-color: #ef4444; color: #fff; transform: translateY(-3px); box-shadow: 0 6px 12px rgba(239, 68, 68, 0.2); }
        .func-btn.full-width { grid-column: span 2; flex-direction: row; justify-content: center; background: #1e293b; }
        .func-btn.btn-game { grid-column: span 2; flex-direction: row; justify-content: center; background: linear-gradient(45deg, #ef4444, #b91c1c); border-color: #ef4444; font-size: 15px; padding: 16px; }
        .func-btn.btn-game:hover { background: linear-gradient(45deg, #f87171, #ef4444); }
        .func-btn span.icon { font-size: 20px; }

        .logout-btn { width: 100%; padding: 12px; background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; border-radius: 8px; font-weight: 700; cursor: pointer; text-align: center; text-decoration: none; display: block; transition: 0.2s; margin-top: 15px;}
        .logout-btn:hover { background: #ef4444; color: #fff; }

        /* MODAL POPUP */
        .modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.75); z-index: 1000; justify-content: center; align-items: center; backdrop-filter: blur(5px); }
        .modal.active { display: flex; }
        .modal-content { background: #151b28; border: 1px solid #2d3748; border-radius: 14px; width: 520px; max-width: 95%; max-height: 88vh; overflow-y: auto; padding: 24px; position: relative; box-shadow: 0 10px 40px rgba(0,0,0,0.5); }
        .modal-content.large-modal { width: 850px; } /* Khung rộng hơn cho Menu Game */
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; border-bottom: 1px solid #1e293b; padding-bottom: 10px; gap: 15px; }
        .modal-header h3 { font-size: 18px; color: #fff; white-space: nowrap; }
        .close-btn { background: none; border: none; color: #94a3b8; font-size: 26px; cursor: pointer; line-height: 1; }
        .close-btn:hover { color: #ef4444; }

        /* CSS CHO MODAL DANH SÁCH GAME */
        .search-game { flex: 1; background: #0b0e14; border: 1px solid #2d3748; color: #fff; padding: 10px 16px; border-radius: 8px; outline: none; }
        .search-game:focus { border-color: #ef4444; }
        .game-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; margin-top: 10px; }
        .game-card { background: #0b0e14; border: 1px solid #1e293b; border-radius: 10px; overflow: hidden; transition: 0.2s; cursor: pointer; position: relative; }
        .game-card:hover { transform: translateY(-4px); border-color: #ef4444; box-shadow: 0 8px 15px rgba(239, 68, 68, 0.25); }
        .game-card img { width: 100%; height: 130px; object-fit: cover; display: block; }
        .game-tag { position: absolute; top: 8px; right: 8px; background: #ef4444; color: #fff; font-size: 10px; font-weight: 800; padding: 3px 6px; border-radius: 4px; }
        .game-info { padding: 10px; }
        .game-title { font-weight: 700; font-size: 14px; color: #fff; margin-bottom: 2px; }
        .game-genre { font-size: 11px; color: #94a3b8; }

        /* CSS FORM / LỊCH SỬ DÙNG TRUNG CHUNG */
        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 13px; color: #94a3b8; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; background: #0b0e14; border: 1px solid #2d3748; border-radius: 8px; color: #fff; outline: none; }
        .submit-btn { width: 100%; padding: 11px; background: #ef4444; color: #fff; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; margin-top: 6px; }
        .submit-btn:hover { background: #dc2626; }
        .history-list { margin-top: 16px; border-top: 1px solid #1e293b; padding-top: 12px; font-size: 13px; }
        .history-item { background: #0b0e14; padding: 8px 12px; border-radius: 6px; margin-bottom: 8px; border-left: 3px solid #ef4444; }

        /* CHAT BOX */
        .chat-box { background: #0b0e14; border: 1px solid #1e293b; border-radius: 8px; height: 240px; overflow-y: auto; padding: 12px; margin-bottom: 12px; display: flex; flex-direction: column; gap: 10px; }
        .chat-msg { background: #1a2234; padding: 8px 12px; border-radius: 8px; font-size: 13px; }
        .chat-msg .sender { font-weight: 700; color: #ef4444; font-size: 12px; margin-bottom: 3px; }
        .chat-msg .time { float: right; color: #64748b; font-weight: 400; font-size: 11px; }
        .chat-input-row { display: flex; gap: 8px; }
        .chat-input-row input { flex: 1; padding: 10px; background: #0b0e14; border: 1px solid #2d3748; border-radius: 8px; color: #fff; }
        .chat-input-row button { padding: 10px 18px; background: #ef4444; color: #fff; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; }
    </style>
</head>
<body>

    <!-- BÊN TRÁI: MÀN HÌNH DESKTOP (Trống, sạch sẽ) -->
    <div class="desktop-area">
        <div class="alerts-container">
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-success"><%= message %></div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>
        </div>

        <div class="desktop-logo">
            <h1>REDZONE <span>GAMING</span></h1>
            <p>Xin chào, <%= currentUser.getFullName() %>!</p>
        </div>
    </div>

    <!-- BÊN PHẢI: Ô THÔNG TIN THỜI GIAN & CÁC NÚT CHỨC NĂNG -->
    <div class="right-sidebar">
        <div>
            <!-- KHUNG THÔNG TIN TÀI KHOẢN -->
            <div class="user-box">
                <div class="user-header">
                    <div>
                        <div style="font-size: 11px; color: #94a3b8;">HỘI VIÊN TRỰC TUYẾN</div>
                        <div class="user-name"><%= currentUser.getUsername() %></div>
                    </div>
                    <span class="machine-badge">ONLINE</span>
                </div>

                <div class="time-stats">
                    <div class="stat-row">
                        <span class="stat-label">Số dư ví:</span>
                        <span class="stat-val money"><%= df.format(currentUser.getBalance()) %> VNĐ</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Thời gian quy đổi:</span>
                        <span class="stat-val" id="totalHoursText">0h 00m</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Đang chơi:</span>
                        <span class="stat-val countdown" id="countdownTimer">00:00:00</span>
                    </div>
                </div>
            </div>

            <div style="font-size: 12px; font-weight: 700; color: #94a3b8; margin-bottom: 8px;">BẢNG ĐIỀU KHIỂN (CLIENT)</div>

            <!-- DANH SÁCH NÚT BẤM -->
            <div class="action-grid">
                <!-- Nút lớn hiển thị Menu Game -->
                <button class="func-btn btn-game" onclick="openModal('modalGameMenu')">
                    <span class="icon">🎮</span>
                    <span>MENU GAME</span>
                </button>

                <button class="func-btn" onclick="openModal('modalTopUp')">
                    <span class="icon">💳</span>
                    <span>Nạp Tiền</span>
                </button>
                <button class="func-btn" onclick="openModal('modalService')">
                    <span class="icon">🍜</span>
                    <span>Gọi Món</span>
                </button>
                <button class="func-btn" onclick="openModal('modalGear')">
                    <span class="icon">🖱️</span>
                    <span>Thuê Gear</span>
                </button>
                <button class="func-btn" onclick="openModal('modalProfile')">
                    <span class="icon">👤</span>
                    <span>Hồ Sơ</span>
                </button>
                <button class="func-btn full-width" onclick="openModal('modalChat')">
                    <span class="icon">💬</span>
                    <span>Nhắn Tin Trực Tiếp Quầy</span>
                </button>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">⏻ TẮT MÁY (ĐĂNG XUẤT)</a>
    </div>

    <!-- ================= CÁC MODAL POPUP CỦA HỆ THỐNG ================= -->

    <!-- 0. MODAL DANH SÁCH GAME (MỚI) -->
    <div id="modalGameMenu" class="modal">
        <div class="modal-content large-modal">
            <div class="modal-header">
                <h3>🎮 KHO GAME REDZONE</h3>
                <input type="text" id="gameSearch" class="search-game" placeholder="🔍 Tìm kiếm tựa game..." onkeyup="filterGames()">
                <button class="close-btn" onclick="closeModal('modalGameMenu')">&times;</button>
            </div>

            <div class="game-grid" id="gameGrid">
                <% if (gameList != null) {
                    for (String[] g : gameList) { %>
                    <div class="game-card" data-name="<%= g[0].toLowerCase() %>" onclick="launchGame('<%= g[0] %>')">
                        <span class="game-tag"><%= g[3] %></span>
                        <img src="<%= g[2] %>" alt="<%= g[0] %>">
                        <div class="game-info">
                            <div class="game-title"><%= g[0] %></div>
                            <div class="game-genre"><%= g[1] %></div>
                        </div>
                    </div>
                <%  }
                   } %>
            </div>
        </div>
    </div>

    <!-- 1. MODAL NẠP TIỀN -->
    <div id="modalTopUp" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>💳 Nạp Tiền Vào Tài Khoản</h3>
                <button class="close-btn" onclick="closeModal('modalTopUp')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="topUp">
                <div class="form-group">
                    <label>Số tiền muốn nạp (VNĐ) — Bảng giá: 10.000đ = 1 giờ chơi</label>
                    <input type="number" name="amount" min="10000" step="5000" value="20000" required>
                </div>
                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <select name="method">
                        <option value="TRANSFER">Chuyển khoản / Mã QR (Hệ thống tự cộng tiền)</option>
                        <option value="CASH">Tiền mặt (Nhân viên sẽ mang phiếu đến thu tại máy)</option>
                    </select>
                </div>
                <button type="submit" class="submit-btn">XÁC NHẬN YÊU CẦU NẠP</button>
            </form>
        </div>
    </div>

    <!-- 2. MODAL GỌI MÓN / COMBO -->
    <div id="modalService" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🍜 Dịch Vụ Ăn Uống Tại Bàn</h3>
                <button class="close-btn" onclick="closeModal('modalService')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="orderService">
                <div class="form-group">
                    <label>Mã máy bạn đang sử dụng</label>
                    <input type="text" name="machineCode" value="VIP-01" required>
                </div>
                <div class="form-group">
                    <label>Menu (Sẽ được trừ trực tiếp vào số dư ví)</label>
                    <select name="itemId">
                        <% if (menuItems != null) {
                            for (MenuItem item : menuItems) { %>
                            <option value="<%= item.getItemId() %>"><%= item.getItemName() %> - <%= df.format(item.getPrice()) %> VNĐ</option>
                        <%  }
                           } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Số lượng</label>
                    <input type="number" name="quantity" value="1" min="1" max="20" required>
                </div>
                <button type="submit" class="submit-btn">GỬI BILL XUỐNG BẾP</button>
            </form>

            <div class="history-list">
                <strong>Bill đã gọi trong phiên này:</strong>
                <% if (orderHistory != null) {
                    for (ServiceOrder ord : orderHistory) { %>
                    <div class="history-item">
                        <%= ord.getQuantity() %>x <%= ord.getItemName() %> (<%= ord.getMachineCode() %>) - <b><%= df.format(ord.getFinalAmount()) %>đ</b> [<%= ord.getStatus() %>]
                    </div>
                <%  }
                   } %>
            </div>
        </div>
    </div>

    <!-- 3. MODAL THUÊ GEAR -->
    <div id="modalGear" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🖱️ Dịch Vụ Mượn & Thuê Gear</h3>
                <button class="close-btn" onclick="closeModal('modalGear')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="rentGear">
                <div class="form-group">
                    <label>Mã máy bạn đang sử dụng</label>
                    <input type="text" name="machineCode" value="VIP-01" required>
                </div>
                <div class="form-group">
                    <label>Kho Thiết bị Esport (Tính phí theo giờ)</label>
                    <select name="gearId">
                        <% if (gearList != null) {
                            for (String[] gear : gearList) { %>
                            <option value="<%= gear[0] %>"><%= gear[1] %> - <%= gear[2] %> VNĐ/h</option>
                        <%  }
                           } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Thời gian thuê dự kiến (Giờ)</label>
                    <input type="number" name="hours" value="2" min="1" max="24" required>
                </div>
                <button type="submit" class="submit-btn">ĐẶT THUÊ THIẾT BỊ</button>
            </form>

            <div class="history-list">
                <strong>Thiết bị đang thuê:</strong>
                <% if (gearHistory != null) {
                    for (String gh : gearHistory) { %>
                    <div class="history-item"><%= gh %></div>
                <%  }
                   } %>
            </div>
        </div>
    </div>

    <!-- 4. MODAL HỒ SƠ -->
    <div id="modalProfile" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>👤 Quản Lý Thông Tin Tài Khoản</h3>
                <button class="close-btn" onclick="closeModal('modalProfile')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <div class="form-group">
                    <label>Họ và tên chủ tài khoản</label>
                    <input type="text" name="fullName" value="<%= currentUser.getFullName() != null ? currentUser.getFullName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Số điện thoại liên lạc</label>
                    <input type="text" name="phone" value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Địa chỉ Email</label>
                    <input type="email" name="email" value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>">
                </div>
                <button type="submit" class="submit-btn">LƯU THAY ĐỔI</button>
            </form>
        </div>
    </div>

    <!-- 5. MODAL CHAT VỚI NHÂN VIÊN QUẦY -->
    <div id="modalChat" class="modal <%= "modalChat".equals(openModalOnLoad) ? "active" : "" %>">
        <div class="modal-content">
            <div class="modal-header">
                <h3>💬 Kênh Chat - Quản Trị Viên</h3>
                <button class="close-btn" onclick="closeModal('modalChat')">&times;</button>
            </div>
            <div class="chat-box" id="chatBox">
                <% if (chatHistory != null) {
                    for (String[] c : chatHistory) { %>
                    <div class="chat-msg">
                        <div class="sender"><%= c[0] %> <span class="time"><%= c[2] %></span></div>
                        <div><%= c[1] %></div>
                    </div>
                <%  }
                   } %>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post" class="chat-input-row">
                <input type="hidden" name="action" value="sendMessage">
                <input type="text" name="msgContent" placeholder="Bạn cần hỗ trợ gì? Nhập ở đây..." required autocomplete="off">
                <button type="submit">Gửi</button>
            </form>
        </div>
    </div>

    <script>
        // Mở, đóng các khung popup
        function openModal(id) {
            document.getElementById(id).classList.add('active');
            if (id === 'modalChat') {
                const cb = document.getElementById('chatBox');
                cb.scrollTop = cb.scrollHeight;
            }
        }
        function closeModal(id) {
            document.getElementById(id).classList.remove('active');
        }
        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) {
                e.target.classList.remove('active');
            }
        };

        // Tìm kiếm game trong popup Game Menu
        function filterGames() {
            const key = document.getElementById('gameSearch').value.toLowerCase();
            document.querySelectorAll('.game-card').forEach(card => {
                const name = card.getAttribute('data-name');
                card.style.display = name.includes(key) ? 'block' : 'none';
            });
        }

        function launchGame(gameName) {
            alert("🚀 Đang khởi chạy " + gameName + "...\nĐang kết nối tới máy chủ, vui lòng đợi giây lát.");
            closeModal('modalGameMenu');
        }

        // Tự động ẩn các khung thông báo lỗi/thành công sau 5 giây
        setTimeout(() => {
            const alerts = document.querySelector('.alerts-container');
            if (alerts) { alerts.style.display = 'none'; }
        }, 5000);

        // Đồng hồ đếm ngược giờ chơi
        let totalMinutes = <%= remainingMinutes %>;
        let totalSeconds = totalMinutes * 60;

        const initH = Math.floor(totalMinutes / 60);
        const initM = totalMinutes % 60;
        document.getElementById('totalHoursText').innerText = initH + " giờ " + (initM < 10 ? "0" : "") + initM + " phút";

        function updateTimer() {
            if (totalSeconds <= 0) {
                document.getElementById('countdownTimer').innerText = "00:00:00 (Hết giờ)";
                return;
            }
            const h = Math.floor(totalSeconds / 3600);
            const m = Math.floor((totalSeconds % 3600) / 60);
            const s = totalSeconds % 60;
            document.getElementById('countdownTimer').innerText =
                (h < 10 ? "0" : "") + h + ":" +
                (m < 10 ? "0" : "") + m + ":" +
                (s < 10 ? "0" : "") + s;
            totalSeconds--;
        }
        updateTimer();
        setInterval(updateTimer, 1000);
    </script>
</body>
</html>