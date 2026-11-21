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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>REDZONE GAMING - Client Desktop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:ital,wght@0,500;0,600;0,700;1,700&family=Montserrat:ital,wght@0,700;0,900;1,800;1,900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/p3r-theme.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body.p3r-client-body {
            font-family: 'Chakra Petch', sans-serif;
            background: radial-gradient(circle at 22% 24%, #0e3888 0%, #061430 50%, #020814 100%);
            color: var(--p3-white);
            display: flex;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }

        /* Thanh cuộn đồng bộ Cyan */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: rgba(3, 10, 24, 0.85); }
        ::-webkit-scrollbar-thumb { background: rgba(0, 229, 255, 0.45); }
        ::-webkit-scrollbar-thumb:hover { background: var(--p3-cyan); }

        /* ================= KHU VỰC TRÁI: CLIENT DESKTOP ================= */
        .desktop-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
            z-index: 2;
            padding: 30px;
        }

        .desktop-hud-left {
            position: absolute;
            top: 24px;
            left: 28px;
            display: flex;
            align-items: center;
            gap: 14px;
            z-index: 5;
        }

        .desktop-hud-left .p3r-hud-phase {
            margin-top: 5px;
            border-right: none;
            border-left: 3px solid var(--p3-cyan);
        }

        .desktop-logo {
            text-align: center;
            user-select: none;
            position: relative;
            z-index: 4;
        }

        .desktop-kicker {
            display: inline-block;
            background: var(--p3-cyan);
            color: var(--p3-abyss);
            font-weight: 700;
            font-size: 12px;
            letter-spacing: 3px;
            padding: 4px 18px;
            text-transform: uppercase;
            transform: skewX(-14deg);
            margin-bottom: 16px;
            box-shadow: 0 0 20px rgba(0, 229, 255, 0.35);
        }
        .desktop-kicker span { display: inline-block; transform: skewX(14deg); }

        .desktop-logo h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: clamp(44px, 5.5vw, 72px);
            line-height: 0.95;
            letter-spacing: 2px;
            color: #fff;
            text-transform: uppercase;
            text-shadow: 4px 4px 0 rgba(0, 229, 255, 0.25), 0 12px 35px rgba(0, 0, 0, 0.55);
        }
        .desktop-logo h1 span { color: var(--p3-cyan); }

        .desktop-welcome {
            margin-top: 18px;
            font-size: 18px;
            color: #cfe4ff;
            letter-spacing: 1px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(4, 15, 40, 0.72);
            border: 1px solid rgba(0, 229, 255, 0.3);
            border-left: 4px solid var(--p3-cyan);
            padding: 8px 22px;
            backdrop-filter: blur(8px);
        }
        .desktop-welcome strong { color: var(--p3-cyan); }

        .desktop-status-bar {
            position: absolute;
            bottom: 22px;
            left: 28px;
            display: flex;
            gap: 18px;
            font-size: 12px;
            letter-spacing: 1.5px;
            color: var(--p3-muted);
            text-transform: uppercase;
            z-index: 4;
        }
        .desktop-status-bar i { color: var(--p3-cyan); margin-right: 6px; }

        /* ALERT THÔNG BÁO */
        .alerts-container {
            position: absolute;
            top: 24px;
            left: 50%;
            transform: translateX(-50%);
            width: 82%;
            max-width: 560px;
            z-index: 30;
        }
        .alert {
            padding: 12px 18px;
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: 700;
            text-align: center;
            backdrop-filter: blur(10px);
            clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.45);
        }
        .alert-success {
            background: rgba(0, 245, 160, 0.18);
            border: 1px solid var(--p3-success);
            border-left: 5px solid var(--p3-success);
            color: #9effdc;
        }
        .alert-error {
            background: rgba(255, 42, 85, 0.22);
            border: 1px solid var(--p3-danger);
            border-left: 5px solid var(--p3-danger);
            color: #ffb3c1;
        }

        /* ================= KHU VỰC PHẢI: SIDEBAR P3R COMMAND MENU ================= */
        .right-sidebar {
            width: 365px;
            background: linear-gradient(180deg, rgba(6, 20, 52, 0.96) 0%, rgba(3, 10, 26, 0.98) 100%);
            border-left: 3px solid var(--p3-cyan);
            box-shadow: -12px 0 40px rgba(0, 229, 255, 0.14);
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backdrop-filter: blur(14px);
            z-index: 20;
            overflow-y: auto;
        }

        /* KHUNG THÔNG TIN HỘI VIÊN */
        .user-box {
            background: linear-gradient(155deg, rgba(13, 50, 125, 0.55), rgba(4, 14, 36, 0.92));
            border: 1px solid rgba(0, 229, 255, 0.32);
            border-top: 3px solid var(--p3-cyan);
            padding: 16px;
            margin-bottom: 18px;
            clip-path: polygon(0 0, calc(100% - 18px) 0, 100% 18px, 100% 100%, 14px 100%, 0 calc(100% - 14px));
            box-shadow: 0 10px 26px rgba(0, 0, 0, 0.45);
        }

        .user-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .user-role-tag {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
            color: var(--p3-cyan);
            text-transform: uppercase;
        }
        .user-name {
            font-family: 'Montserrat', sans-serif;
            font-size: 19px;
            font-weight: 900;
            font-style: italic;
            color: #fff;
            margin-top: 2px;
        }
        .machine-badge {
            background: var(--p3-success);
            color: #021a12;
            font-family: 'Montserrat', sans-serif;
            font-size: 11px;
            font-weight: 900;
            font-style: italic;
            padding: 4px 12px;
            letter-spacing: 1px;
            clip-path: polygon(6px 0, 100% 0, calc(100% - 6px) 100%, 0 100%);
            box-shadow: 0 0 14px rgba(0, 245, 160, 0.45);
        }

        .time-stats {
            display: flex;
            flex-direction: column;
            gap: 9px;
            background: rgba(2, 9, 24, 0.85);
            padding: 12px 14px;
            border: 1px solid rgba(143, 180, 223, 0.18);
            border-left: 3px solid var(--p3-blue);
        }
        .stat-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }
        .stat-label { color: var(--p3-muted); font-weight: 600; }
        .stat-val { font-weight: 700; color: #f4f9ff; }
        .stat-val.money { color: var(--p3-success); font-size: 15px; text-shadow: 0 0 10px rgba(0, 245, 160, 0.3); }
        .stat-val.countdown {
            color: var(--p3-cyan);
            font-size: 17px;
            font-family: 'Chakra Petch', monospace;
            letter-spacing: 1px;
            text-shadow: 0 0 12px rgba(0, 229, 255, 0.45);
        }

        .section-caption {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2.5px;
            color: var(--p3-cyan);
            text-transform: uppercase;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-caption::after {
            content: "";
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, rgba(0, 229, 255, 0.5), transparent);
        }

        /* LƯỚI NÚT CHỨC NĂNG */
        .action-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .func-btn {
            background: rgba(9, 27, 68, 0.78);
            border: 1px solid rgba(0, 229, 255, 0.25);
            border-left: 3px solid var(--p3-cyan);
            color: var(--p3-white);
            padding: 13px 10px;
            font-family: 'Chakra Petch', sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 7px;
            clip-path: polygon(0 0, calc(100% - 10px) 0, 100% 10px, 100% 100%, 0 100%);
            transition: all 0.2s ease;
        }
        .func-btn span.icon { font-size: 19px; color: var(--p3-cyan); transition: color 0.2s ease; }

        .func-btn:hover {
            background: linear-gradient(95deg, #ffffff 0%, #6ef4ff 100%);
            border-color: #fff;
            color: var(--p3-abyss);
            transform: translateX(4px);
            box-shadow: 0 0 22px rgba(0, 229, 255, 0.5);
        }
        .func-btn:hover span.icon { color: var(--p3-abyss); }

        .func-btn.btn-game {
            grid-column: span 2;
            flex-direction: row;
            justify-content: center;
            gap: 10px;
            background: linear-gradient(95deg, #00d2ff 0%, #1858ff 100%);
            border: none;
            color: #020a18;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 16px;
            letter-spacing: 2px;
            padding: 15px;
            clip-path: polygon(12px 0, 100% 0, calc(100% - 12px) 100%, 0 100%);
            box-shadow: 0 6px 24px rgba(0, 229, 255, 0.35);
        }
        .func-btn.btn-game span.icon { color: #020a18; font-size: 20px; }
        .func-btn.btn-game:hover {
            background: linear-gradient(95deg, #ffffff 0%, #52f2ff 100%);
            box-shadow: 0 0 28px rgba(0, 229, 255, 0.7);
        }

        .func-btn.full-width {
            grid-column: span 2;
            flex-direction: row;
            justify-content: center;
            gap: 10px;
            padding: 13px;
            background: rgba(13, 50, 125, 0.52);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            margin-top: 16px;
            background: rgba(255, 42, 85, 0.14);
            border: 1px solid var(--p3-danger);
            color: #ff8ca3;
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-style: italic;
            font-size: 13px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%);
            transition: all 0.2s ease;
        }
        .logout-btn:hover {
            background: var(--p3-danger);
            color: #fff;
            box-shadow: 0 0 22px rgba(255, 42, 85, 0.55);
            transform: translateX(3px);
        }

        /* ================= MODAL POPUP P3R ================= */
        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(2, 8, 22, 0.78);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(7px);
            padding: 16px;
        }
        .modal.active { display: flex; }

        .modal-content {
            background: linear-gradient(165deg, rgba(7, 25, 61, 0.97) 0%, rgba(3, 10, 26, 0.98) 100%);
            border: 1px solid rgba(0, 229, 255, 0.4);
            border-top: 4px solid var(--p3-cyan);
            width: 540px;
            max-width: 100%;
            max-height: 88vh;
            overflow-y: auto;
            padding: 24px 26px 28px;
            position: relative;
            clip-path: polygon(0 0, calc(100% - 22px) 0, 100% 22px, 100% 100%, 16px 100%, 0 calc(100% - 16px));
            box-shadow: 0 20px 55px rgba(0, 0, 0, 0.75), 0 0 32px rgba(0, 229, 255, 0.16);
        }
        .modal-content.large-modal { width: 880px; }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            border-bottom: 1px solid rgba(0, 229, 255, 0.25);
            padding-bottom: 12px;
            gap: 15px;
        }
        .modal-header h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 18px;
            color: #fff;
            letter-spacing: 1px;
            text-transform: uppercase;
            white-space: nowrap;
        }
        .modal-header h3 i { color: var(--p3-cyan); margin-right: 8px; }

        .close-btn {
            background: rgba(0, 229, 255, 0.12);
            border: 1px solid rgba(0, 229, 255, 0.35);
            color: var(--p3-cyan);
            width: 34px;
            height: 34px;
            font-size: 22px;
            cursor: pointer;
            line-height: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }
        .close-btn:hover {
            background: var(--p3-danger);
            border-color: var(--p3-danger);
            color: #fff;
        }

        /* KHO GAME */
        .search-game {
            flex: 1;
            background: rgba(2, 9, 24, 0.92);
            border: 1px solid rgba(0, 229, 255, 0.3);
            border-left: 3px solid var(--p3-cyan);
            color: #fff;
            padding: 9px 14px;
            font-family: 'Chakra Petch', sans-serif;
            font-size: 14px;
            outline: none;
        }
        .search-game:focus {
            border-color: var(--p3-cyan);
            box-shadow: 0 0 14px rgba(0, 229, 255, 0.28);
        }

        .game-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
            margin-top: 10px;
        }
        .game-card {
            background: rgba(3, 12, 32, 0.92);
            border: 1px solid rgba(0, 229, 255, 0.22);
            overflow: hidden;
            transition: all 0.22s ease;
            cursor: pointer;
            position: relative;
            clip-path: polygon(0 0, calc(100% - 14px) 0, 100% 14px, 100% 100%, 0 100%);
        }
        .game-card:hover {
            transform: translateY(-4px);
            border-color: var(--p3-cyan);
            box-shadow: 0 10px 24px rgba(0, 229, 255, 0.28);
        }
        .game-card img { width: 100%; height: 132px; object-fit: cover; display: block; }
        .game-tag {
            position: absolute;
            top: 8px;
            right: 8px;
            background: var(--p3-cyan);
            color: var(--p3-abyss);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1px;
            padding: 3px 8px;
            text-transform: uppercase;
            clip-path: polygon(5px 0, 100% 0, calc(100% - 5px) 100%, 0 100%);
        }
        .game-info { padding: 11px 12px; }
        .game-title { font-weight: 700; font-size: 14px; color: #fff; margin-bottom: 3px; }
        .game-genre { font-size: 12px; color: var(--p3-muted); }

        /* FORM & LỊCH SỬ TRONG MODAL */
        .form-group { margin-bottom: 14px; }
        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #cfe4ff;
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px 13px;
            background: rgba(2, 10, 26, 0.92);
            border: 1px solid rgba(143, 180, 223, 0.28);
            border-left: 3px solid rgba(0, 229, 255, 0.5);
            color: #fff;
            font-family: 'Chakra Petch', sans-serif;
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--p3-cyan);
            background: rgba(7, 25, 61, 0.95);
            box-shadow: 0 0 14px rgba(0, 229, 255, 0.25);
        }
        .form-group select option { background: #061430; color: #fff; }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(95deg, #00c4ff 0%, #1a66ff 100%);
            color: #020a18;
            border: none;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 14px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 6px;
            clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%);
            transition: all 0.2s ease;
        }
        .submit-btn:hover {
            background: linear-gradient(95deg, #ffffff 0%, #52f2ff 100%);
            box-shadow: 0 0 22px rgba(0, 229, 255, 0.6);
            transform: translateX(3px);
        }

        .history-list {
            margin-top: 18px;
            border-top: 1px solid rgba(0, 229, 255, 0.22);
            padding-top: 12px;
            font-size: 13px;
        }
        .history-list strong {
            display: block;
            color: var(--p3-cyan);
            letter-spacing: 1px;
            text-transform: uppercase;
            font-size: 12px;
            margin-bottom: 8px;
        }
        .history-item {
            background: rgba(2, 10, 26, 0.85);
            padding: 9px 12px;
            margin-bottom: 8px;
            border: 1px solid rgba(143, 180, 223, 0.14);
            border-left: 3px solid var(--p3-cyan);
            color: #e4f0ff;
        }

        /* CHAT BOX */
        .chat-box {
            background: rgba(2, 9, 24, 0.9);
            border: 1px solid rgba(0, 229, 255, 0.25);
            height: 250px;
            overflow-y: auto;
            padding: 12px;
            margin-bottom: 12px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .chat-msg {
            background: rgba(13, 50, 125, 0.42);
            border-left: 3px solid var(--p3-cyan);
            padding: 9px 12px;
            font-size: 13px;
        }
        .chat-msg .sender {
            font-weight: 700;
            color: var(--p3-cyan);
            font-size: 12px;
            margin-bottom: 4px;
            text-transform: uppercase;
        }
        .chat-msg .time { float: right; color: var(--p3-muted); font-weight: 500; font-size: 11px; }
        .chat-input-row { display: flex; gap: 8px; }
        .chat-input-row input {
            flex: 1;
            padding: 10px 12px;
            background: rgba(2, 10, 26, 0.92);
            border: 1px solid rgba(0, 229, 255, 0.3);
            color: #fff;
            font-family: 'Chakra Petch', sans-serif;
            outline: none;
        }
        .chat-input-row input:focus { border-color: var(--p3-cyan); }
        .chat-input-row button {
            padding: 10px 22px;
            background: linear-gradient(95deg, #00c4ff, #1a66ff);
            color: #020a18;
            border: none;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            text-transform: uppercase;
            cursor: pointer;
            clip-path: polygon(8px 0, 100% 0, calc(100% - 8px) 100%, 0 100%);
        }
        .chat-input-row button:hover {
            background: #fff;
            box-shadow: 0 0 16px rgba(0, 229, 255, 0.6);
        }

        @media (max-width: 900px) {
            body.p3r-client-body { flex-direction: column; height: auto; overflow-y: auto; }
            .desktop-area { min-height: 45vh; padding-top: 90px; }
            .right-sidebar { width: 100%; border-left: none; border-top: 3px solid var(--p3-cyan); }
            .desktop-status-bar { display: none; }
        }
    </style>
</head>
<body class="p3r-client-body">

    <!-- Lớp nền P3R Dark Hour (dùng chung animation từ p3r-theme.css) -->
    <div class="p3r-bg-layer">
        <div class="p3r-caustics"></div>
        <div class="p3r-shard s1"></div>
        <div class="p3r-shard s2"></div>
        <div class="p3r-shard s3"></div>
        <div class="p3r-watermark">DARK HOUR<br>REDZONE</div>
    </div>

    <!-- BÊN TRÁI: MÀN HÌNH DESKTOP CLIENT -->
    <div class="desktop-area">
        <!-- HUD Ngày giờ kiểu P3R -->
        <div class="desktop-hud-left">
            <div class="p3r-moon" title="Dark Hour"></div>
            <div>
                <div class="p3r-hud-date" id="p3rDate">--/--</div>
                <div class="p3r-hud-phase" id="p3rPhase">DARK HOUR</div>
            </div>
        </div>

        <!-- Thông báo hệ thống -->
        <div class="alerts-container">
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= message %></div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
            <% } %>
        </div>

        <div class="desktop-logo">
            <div class="desktop-kicker"><span>S.E.E.S // CLIENT TERMINAL ACTIVE</span></div>
            <h1>RED<span>ZONE</span> GAMING</h1>
            <div class="desktop-welcome">
                <i class="fa-solid fa-user-astronaut"></i>
                Xin chào, <strong><%= currentUser.getFullName() %></strong>!
            </div>
        </div>

        <div class="desktop-status-bar">
            <span><i class="fa-solid fa-signal"></i> PING: 4ms</span>
            <span><i class="fa-solid fa-shield-halved"></i> SESSION SECURED</span>
            <span><i class="fa-solid fa-headset"></i> SUPPORT READY</span>
        </div>
    </div>

    <!-- BÊN PHẢI: Ô THÔNG TIN THỜI GIAN & MENU LỆNH P3R -->
    <div class="right-sidebar">
        <div>
            <!-- KHUNG THÔNG TIN TÀI KHOẢN -->
            <div class="user-box">
                <div class="user-header">
                    <div>
                        <div class="user-role-tag">HỘI VIÊN TRỰC TUYẾN</div>
                        <div class="user-name"><%= currentUser.getUsername() %></div>
                    </div>
                    <span class="machine-badge">ONLINE</span>
                </div>

                <div class="time-stats">
                    <div class="stat-row">
                        <span class="stat-label"><i class="fa-solid fa-wallet"></i> Số dư ví:</span>
                        <span class="stat-val money"><%= df.format(currentUser.getBalance()) %> VNĐ</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label"><i class="fa-regular fa-clock"></i> Quy đổi giờ:</span>
                        <span class="stat-val" id="totalHoursText">0h 00m</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label"><i class="fa-solid fa-hourglass-half"></i> Còn lại:</span>
                        <span class="stat-val countdown" id="countdownTimer">00:00:00</span>
                    </div>
                </div>
            </div>

            <div class="section-caption">BẢNG ĐIỀU KHIỂN (CLIENT)</div>

            <!-- DANH SÁCH NÚT BẤM -->
            <div class="action-grid">
                <button class="func-btn btn-game" onclick="openModal('modalGameMenu')">
                    <span class="icon"><i class="fa-solid fa-gamepad"></i></span>
                    <span>MENU GAME</span>
                </button>

                <button class="func-btn" onclick="openModal('modalTopUp')">
                    <span class="icon"><i class="fa-solid fa-credit-card"></i></span>
                    <span>Nạp Tiền</span>
                </button>
                <button class="func-btn" onclick="openModal('modalService')">
                    <span class="icon"><i class="fa-solid fa-utensils"></i></span>
                    <span>Gọi Món</span>
                </button>
                <button class="func-btn" onclick="openModal('modalGear')">
                    <span class="icon"><i class="fa-solid fa-computer-mouse"></i></span>
                    <span>Thuê Gear</span>
                </button>
                <button class="func-btn" onclick="openModal('modalProfile')">
                    <span class="icon"><i class="fa-solid fa-id-card"></i></span>
                    <span>Hồ Sơ</span>
                </button>
                <button class="func-btn full-width" onclick="openModal('modalChat')">
                    <span class="icon"><i class="fa-solid fa-comments"></i></span>
                    <span>Nhắn Tin Trực Tiếp Quầy</span>
                </button>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
            <i class="fa-solid fa-power-off"></i> TẮT MÁY (ĐĂNG XUẤT)
        </a>
    </div>

    <!-- ================= CÁC MODAL POPUP CỦA HỆ THỐNG ================= -->

    <!-- 0. MODAL DANH SÁCH GAME -->
    <div id="modalGameMenu" class="modal">
        <div class="modal-content large-modal">
            <div class="modal-header">
                <h3><i class="fa-solid fa-gamepad"></i> KHO GAME REDZONE</h3>
                <input type="text" id="gameSearch" class="search-game" placeholder="Tìm kiếm tựa game..." onkeyup="filterGames()">
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
                <h3><i class="fa-solid fa-credit-card"></i> Nạp Tiền Tài Khoản</h3>
                <button class="close-btn" onclick="closeModal('modalTopUp')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="topUp">
                <div class="form-group">
                    <label>Số tiền muốn nạp (VNĐ) — 10.000đ = 1 giờ chơi</label>
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
                <h3><i class="fa-solid fa-utensils"></i> Dịch Vụ Ăn Uống Tại Bàn</h3>
                <button class="close-btn" onclick="closeModal('modalService')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/member" method="post">
                <input type="hidden" name="action" value="orderService">
                <div class="form-group">
                    <label>Mã máy bạn đang sử dụng</label>
                    <input type="text" name="machineCode" value="VIP-01" required>
                </div>
                <div class="form-group">
                    <label>Menu (Trừ trực tiếp vào số dư ví)</label>
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
                <h3><i class="fa-solid fa-computer-mouse"></i> Mượn &amp; Thuê Gear</h3>
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
                <h3><i class="fa-solid fa-id-card"></i> Thông Tin Tài Khoản</h3>
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
                <h3><i class="fa-solid fa-comments"></i> Kênh Chat - Quầy Quản Trị</h3>
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
        // 1. HUD ngày giờ P3R
        (function updateP3RHud() {
            const now = new Date();
            const d = String(now.getDate()).padStart(2, '0');
            const m = String(now.getMonth() + 1).padStart(2, '0');
            const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
            const h = now.getHours();

            document.getElementById('p3rDate').textContent = m + '/' + d + ' ' + days[now.getDay()];

            let phase = 'EVENING';
            if (h >= 0 && h < 5) phase = 'DARK HOUR';
            else if (h >= 5 && h < 12) phase = 'MORNING';
            else if (h >= 12 && h < 18) phase = 'AFTERNOON';
            document.getElementById('p3rPhase').textContent = phase;
        })();

        // 2. Mở, đóng các khung popup
        function openModal(id) {
            document.getElementById(id).classList.add('active');
            if (id === 'modalChat') {
                const cb = document.getElementById('chatBox');
                if (cb) cb.scrollTop = cb.scrollHeight;
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
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal.active').forEach(function(m) {
                    m.classList.remove('active');
                });
            }
        });

        // Tự cuộn xuống cuối nếu modalChat được mở sẵn sau khi gửi tin
        (function scrollChatOnLoad() {
            const chatModal = document.getElementById('modalChat');
            const cb = document.getElementById('chatBox');
            if (chatModal && chatModal.classList.contains('active') && cb) {
                cb.scrollTop = cb.scrollHeight;
            }
        })();

        // 3. Tìm kiếm & khởi chạy game
        function filterGames() {
            const key = document.getElementById('gameSearch').value.toLowerCase();
            document.querySelectorAll('.game-card').forEach(function(card) {
                const name = card.getAttribute('data-name');
                card.style.display = name.includes(key) ? 'block' : 'none';
            });
        }

        function launchGame(gameName) {
            alert("Đang khởi chạy " + gameName + "...\nĐang kết nối tới máy chủ, vui lòng đợi giây lát.");
            closeModal('modalGameMenu');
        }

        // 4. Tự ẩn thông báo sau 5 giây
        setTimeout(function() {
            const alerts = document.querySelector('.alerts-container');
            if (alerts) { alerts.style.display = 'none'; }
        }, 5000);

        // 5. Đồng hồ đếm ngược giờ chơi
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