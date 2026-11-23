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

        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: rgba(3, 10, 24, 0.85); }
        ::-webkit-scrollbar-thumb { background: rgba(0, 229, 255, 0.45); }
        ::-webkit-scrollbar-thumb:hover { background: var(--p3-cyan); }

        .desktop-video-bg {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 0;
            opacity: 0.44;
            pointer-events: none;
        }
        .desktop-video-overlay {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at center, rgba(4, 16, 42, 0.32) 0%, rgba(2, 8, 22, 0.84) 100%);
            z-index: 1;
            pointer-events: none;
        }

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

        .desktop-logo { text-align: center; user-select: none; position: relative; z-index: 4; }
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
            background: rgba(4, 15, 40, 0.78);
            border: 1px solid rgba(0, 229, 255, 0.35);
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
            color: #cfe4ff;
            text-transform: uppercase;
            z-index: 4;
            background: rgba(3, 12, 32, 0.65);
            padding: 6px 14px;
            border: 1px solid rgba(0, 229, 255, 0.2);
        }
        .desktop-status-bar i { color: var(--p3-cyan); margin-right: 6px; }

        .alerts-container {
            position: absolute;
            top: 24px;
            left: 50%;
            transform: translateX(-50%);
            width: 82%;
            max-width: 580px;
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
        .alert-success { background: rgba(0, 245, 160, 0.22); border: 1px solid var(--p3-success); border-left: 5px solid var(--p3-success); color: #9effdc; }
        .alert-error { background: rgba(255, 42, 85, 0.25); border: 1px solid var(--p3-danger); border-left: 5px solid var(--p3-danger); color: #ffb3c1; }

        .right-sidebar {
            width: 400px;
            background: linear-gradient(180deg, rgba(6, 22, 56, 0.97) 0%, rgba(2, 8, 22, 0.99) 100%);
            border-left: 3px solid var(--p3-cyan);
            box-shadow: -14px 0 45px rgba(0, 229, 255, 0.22);
            padding: 18px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backdrop-filter: blur(16px);
            z-index: 20;
            overflow-y: auto;
        }

        .user-box {
            background: linear-gradient(150deg, rgba(18, 66, 158, 0.65) 0%, rgba(4, 14, 36, 0.96) 100%);
            border: 1px solid rgba(0, 229, 255, 0.55);
            border-top: 4px solid var(--p3-cyan);
            padding: 16px;
            margin-bottom: 16px;
            position: relative;
            clip-path: polygon(0 0, calc(100% - 22px) 0, 100% 22px, 100% 100%, 16px 100%, 0 calc(100% - 16px));
            box-shadow: 0 14px 34px rgba(0, 0, 0, 0.6), inset 0 0 28px rgba(0, 229, 255, 0.12);
        }

        .user-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(0, 229, 255, 0.25);
        }
        .user-avatar-group { display: flex; align-items: center; gap: 11px; }
        .user-avatar-hex {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #00f0ff, #1858ff);
            color: #020a18;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
            font-weight: 900;
            clip-path: polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%);
            box-shadow: 0 0 16px rgba(0, 229, 255, 0.6);
        }
        .user-role-tag { font-size: 10px; font-weight: 700; letter-spacing: 2px; color: var(--p3-cyan); text-transform: uppercase; }
        .user-name { font-family: 'Montserrat', sans-serif; font-size: 18px; font-weight: 900; font-style: italic; color: #fff; line-height: 1.15; }
        .machine-badge {
            background: rgba(0, 245, 160, 0.16);
            border: 1px solid var(--p3-success);
            color: var(--p3-success);
            font-family: 'Montserrat', sans-serif;
            font-size: 11px;
            font-weight: 900;
            font-style: italic;
            padding: 4px 11px;
            letter-spacing: 1px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            clip-path: polygon(6px 0, 100% 0, calc(100% - 6px) 100%, 0 100%);
            box-shadow: 0 0 14px rgba(0, 245, 160, 0.3);
        }
        .pulse-dot { width: 7px; height: 7px; border-radius: 50%; background: var(--p3-success); box-shadow: 0 0 8px var(--p3-success); animation: pulseGlow 1.5s infinite; }
        @keyframes pulseGlow { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.4; transform: scale(0.8); } }

        .countdown-hero-card {
            background: linear-gradient(100deg, rgba(2, 10, 28, 0.95) 0%, rgba(12, 44, 108, 0.88) 100%);
            border: 1px solid rgba(0, 229, 255, 0.45);
            border-left: 4px solid var(--p3-cyan);
            padding: 13px 15px;
            margin-bottom: 10px;
            position: relative;
            box-shadow: inset 0 0 18px rgba(0, 229, 255, 0.12);
        }
        .countdown-top-label {
            display: flex;
            justify-content: space-between;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.2px;
            color: #b7d7ff;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .countdown-big-digits {
            font-family: 'Chakra Petch', monospace;
            font-size: 31px;
            font-weight: 700;
            color: #4df3ff;
            letter-spacing: 2.5px;
            text-shadow: 0 0 18px rgba(0, 229, 255, 0.75);
            line-height: 1.05;
        }
        .time-progress-track {
            width: 100%;
            height: 7px;
            background: rgba(255, 255, 255, 0.12);
            margin-top: 9px;
            overflow: hidden;
            position: relative;
            background-image: repeating-linear-gradient(90deg, transparent, transparent 14px, rgba(2, 8, 22, 0.8) 14px, rgba(2, 8, 22, 0.8) 16px);
        }
        .time-progress-fill {
            height: 100%;
            width: 80%;
            background: linear-gradient(90deg, #00e5ff, #00f5a0);
            box-shadow: 0 0 12px var(--p3-cyan);
            transition: width 1s linear;
        }

        .wallet-mini-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 9px; }
        .wallet-mini-card {
            background: rgba(2, 9, 24, 0.9);
            border: 1px solid rgba(143, 180, 223, 0.25);
            padding: 10px 12px;
        }
        .wallet-mini-card.balance-card { border-left: 3px solid var(--p3-success); }
        .wallet-mini-card.hours-card { border-left: 3px solid #388bff; }
        .mini-label { font-size: 10px; color: var(--p3-muted); text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 3px; }
        .mini-val { font-size: 14px; font-weight: 700; color: #fff; }
        .mini-val.money { color: var(--p3-success); text-shadow: 0 0 10px rgba(0, 245, 160, 0.4); }

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
        .section-caption::after { content: ""; flex: 1; height: 1px; background: linear-gradient(90deg, rgba(0, 229, 255, 0.5), transparent); }

        .action-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 9px; }
        .func-btn {
            background: rgba(9, 27, 68, 0.78);
            border: 1px solid rgba(0, 229, 255, 0.25);
            border-left: 3px solid var(--p3-cyan);
            color: var(--p3-white);
            padding: 12px 10px;
            font-family: 'Chakra Petch', sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            clip-path: polygon(0 0, calc(100% - 10px) 0, 100% 10px, 100% 100%, 0 100%);
            transition: all 0.2s ease;
        }
        .func-btn span.icon { font-size: 18px; color: var(--p3-cyan); transition: color 0.2s ease; }
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
            padding: 14px;
            clip-path: polygon(12px 0, 100% 0, calc(100% - 12px) 100%, 0 100%);
            box-shadow: 0 6px 24px rgba(0, 229, 255, 0.35);
        }
        .func-btn.btn-game span.icon { color: #020a18; font-size: 20px; }
        .func-btn.btn-game:hover { background: linear-gradient(95deg, #ffffff 0%, #52f2ff 100%); box-shadow: 0 0 28px rgba(0, 229, 255, 0.7); }

        .func-btn.full-width { grid-column: span 2; flex-direction: row; justify-content: center; gap: 10px; padding: 12px; background: rgba
        rgba(13, 50, 125, 0.52); }

                .logout-btn {
                    width: 100%;
                    padding: 11px;
                    margin-top: 14px;
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
                .logout-btn:hover { background: var(--p3-danger); color: #fff; box-shadow: 0 0 22px rgba(255, 42, 85, 0.55); transform: translateX(3px); }

                .modal {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(2, 8, 22, 0.84);
                    z-index: 1000;
                    justify-content: center;
                    align-items: center;
                    backdrop-filter: blur(8px);
                    padding: 16px;
                }
                .modal.active { display: flex; }

                .modal-content {
                    background: linear-gradient(165deg, rgba(7, 25, 61, 0.98) 0%, rgba(3, 10, 26, 0.99) 100%);
                    border: 1px solid rgba(0, 229, 255, 0.45);
                    border-top: 4px solid var(--p3-cyan);
                    width: 560px;
                    max-width: 100%;
                    max-height: 90vh;
                    overflow-y: auto;
                    padding: 22px 24px 26px;
                    position: relative;
                    clip-path: polygon(0 0, calc(100% - 22px) 0, 100% 22px, 100% 100%, 16px 100%, 0 calc(100% - 16px));
                    box-shadow: 0 20px 55px rgba(0, 0, 0, 0.8), 0 0 32px rgba(0, 229, 255, 0.18);
                }
                .modal-content.large-modal { width: 960px; }
                .modal-content.xl-modal { width: 1120px; }

                .modal-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 16px;
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
                .close-btn:hover { background: var(--p3-danger); border-color: var(--p3-danger); color: #fff; }

                .category-tabs { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px; }
                .cat-tab {
                    background: rgba(3, 12, 32, 0.9);
                    border: 1px solid rgba(0, 229, 255, 0.3);
                    color: #cfe4ff;
                    padding: 7px 16px;
                    font-family: 'Chakra Petch', sans-serif;
                    font-size: 12px;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    cursor: pointer;
                    clip-path: polygon(8px 0, 100% 0, calc(100% - 8px) 100%, 0 100%);
                    transition: all 0.2s ease;
                }
                .cat-tab:hover, .cat-tab.active { background: var(--p3-cyan); color: var(--p3-abyss); border-color: var(--p3-cyan); box-shadow: 0 0 14px rgba(0, 229, 255, 0.45); }

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
                .game-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(215px, 1fr)); gap: 15px; }
                .game-card {
                    background: rgba(3, 12, 32, 0.94);
                    border: 1px solid rgba(0, 229, 255, 0.22);
                    overflow: hidden;
                    transition: all 0.22s ease;
                    position: relative;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    clip-path: polygon(0 0, calc(100% - 14px) 0, 100% 14px, 100% 100%, 0 100%);
                }
                .game-card:hover { transform: translateY(-4px); border-color: var(--p3-cyan); box-shadow: 0 10px 24px rgba(0, 229, 255, 0.28); }
                .game-card img { width: 100%; height: 128px; object-fit: cover; display: block; }
                .game-tag {
                    position: absolute; top: 8px; right: 8px;
                    background: var(--p3-cyan); color: var(--p3-abyss);
                    font-size: 10px; font-weight: 800; letter-spacing: 1px; padding: 3px 8px;
                    text-transform: uppercase; clip-path: polygon(5px 0, 100% 0, calc(100% - 5px) 100%, 0 100%);
                }
                .game-info { padding: 11px 12px 12px; flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
                .game-title { font-weight: 700; font-size: 15px; color: #fff; margin-bottom: 3px; }
                .game-genre { font-size: 11px; color: var(--p3-muted); margin-bottom: 10px; }
                .play-game-btn {
                    width: 100%; padding: 8px 12px;
                    background: linear-gradient(95deg, #00c4ff 0%, #1a66ff 100%);
                    border: none; color: #020a18;
                    font-family: 'Montserrat', sans-serif; font-weight: 900; font-style: italic; font-size: 12px;
                    letter-spacing: 1.2px; text-transform: uppercase; cursor: pointer;
                    display: flex; align-items: center; justify-content: center; gap: 6px;
                    clip-path: polygon(8px 0, 100% 0, calc(100% - 8px) 100%, 0 100%);
                    transition: all 0.2s ease;
                }
                .play-game-btn:hover { background: #fff; box-shadow: 0 0 16px rgba(0, 229, 255, 0.65); }

                .split-shop-layout {
                    display: grid;
                    grid-template-columns: 1.5fr 1fr;
                    gap: 20px;
                    align-items: start;
                }
                .shop-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                    gap: 12px;
                    max-height: 58vh;
                    overflow-y: auto;
                    padding-right: 4px;
                }
                .shop-card {
                    background: rgba(3, 12, 32, 0.94);
                    border: 1px solid rgba(0, 229, 255, 0.22);
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    overflow: hidden;
                    transition: all 0.2s ease;
                    clip-path: polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%);
                }
                .shop-card:hover { border-color: var(--p3-cyan); transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0, 229, 255, 0.22); }
                .shop-card img { width: 100%; height: 108px; object-fit: cover; display: block; }
                .shop-card-body { padding: 10px; display: flex; flex-direction: column; gap: 5px; flex: 1; justify-content: space-between; }
                .shop-cat-badge { font-size: 10px; color: var(--p3-cyan); font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }
                .shop-name { font-size: 13px; font-weight: 700; color: #fff; line-height: 1.3; }
                .shop-desc { font-size: 11px; color: var(--p3-muted); line-height: 1.3; }
                .shop-price { font-size: 14px; font-weight: 700; color: var(--p3-success); margin-top: 2px; }
                .add-cart-btn {
                    width: 100%; padding: 7px 10px; margin-top: 4px;
                    background: rgba(0, 229, 255, 0.14); border: 1px solid var(--p3-cyan);
                    color: var(--p3-cyan); font-family: 'Chakra Petch', sans-serif;
                    font-size: 12px; font-weight: 700; text-transform: uppercase; cursor: pointer;
                    transition: all 0.2s ease;
                }
                .add-cart-btn:hover { background: var(--p3-cyan); color: var(--p3-abyss); }

                .cart-panel {
                    background: rgba(2, 9, 24, 0.96);
                    border: 1px solid rgba(0, 229, 255, 0.38);
                    border-top: 3px solid var(--p3-cyan);
                    padding: 15px;
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }
                .cart-title {
                    font-family: 'Montserrat', sans-serif;
                    font-weight: 900;
                    font-style: italic;
                    font-size: 14px;
                    color: var(--p3-cyan);
                    text-transform: uppercase;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    border-bottom: 1px solid rgba(0, 229, 255, 0.22);
                    padding-bottom: 8px;
                }
                .cart-items-list { max-height: 230px; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; }
                .cart-empty { text-align: center; color: var(--p3-muted); font-size: 13px; padding: 28px 10px; border: 1px dashed rgba(143, 180, 223, 0.25); }
                .cart-item-row {
                    background: rgba(10, 32, 80, 0.58);
                    border: 1px solid rgba(0, 229, 255, 0.22);
                    border-left: 3px solid var(--p3-cyan);
                    padding: 8px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                .cart-item-thumb {
                    width: 48px;
                    height: 48px;
                    object-fit: cover;
                    border: 1px solid rgba(0, 229, 255, 0.4);
                    flex-shrink: 0;
                }
                .cart-item-info { flex: 1; min-width: 0; }
                .cart-item-name { font-size: 13px; font-weight: 700; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
                .cart-item-sub { font-size: 12px; color: var(--p3-success); margin-top: 2px; }
                .cart-controls { display: flex; align-items: center; gap: 5px; flex-shrink: 0; }
                .cart-qty-badge { font-weight: 700; font-size: 13px; min-width: 24px; text-align: center; color: #fff; }
                .btn-plus, .btn-minus {
                    width: 25px; height: 25px; background: var(--p3-cyan); border: none; color: var(--p3-abyss);
                    font-weight: 900; font-size: 15px; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
                }
                .btn-minus {
                    background: rgba(0, 229, 255, 0.2);
                    border: 1px solid var(--p3-cyan);
                    color: var(--p3-cyan);
                }
                .btn-plus:hover, .btn-minus:hover { background: #fff; color: var(--p3-abyss); }
                .btn-remove {
                    width: 25px; height: 25px; background: rgba(255, 42, 85, 0.22); border: 1px solid var(--p3-danger);
                    color: #ff8ca3; font-weight: 900; font-size: 14px; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
                }
                .btn-remove:hover { background: var(--p3-danger); color: #fff; }

                .cart-total-box {
                    display: flex; justify-content: space-between; align-items: center;
                    padding-top: 8px; border-top: 1px solid rgba(0, 229, 255, 0.25);
                    font-size: 14px; font-weight: 700;
                }
                .cart-total-box span:last-child { color: var(--p3-success); font-size: 17px; }

                .form-group { margin-bottom: 10px; }
                .form-group label { display: block; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: #cfe4ff; margin-bottom: 4px; }
                .form-group input, .form-group select {
                    width: 100%; padding: 8px 11px; background: rgba(2, 10, 26, 0.92);
                    border: 1px solid rgba(143, 180, 223, 0.28); border-left: 3px solid rgba(0, 229, 255, 0.5);
                    color: #fff; font-family: 'Chakra Petch', sans-serif; font-size: 13px; outline: none;
                }
                .form-group input:focus, .form-group select:focus { border-color: var(--p3-cyan); background: rgba(7, 25, 61, 0.95); }
                .form-group select option { background: #061430; color: #fff; }

                .submit-btn {
                    width: 100%; padding: 12px;
                    background: linear-gradient(95deg, #00c4ff 0%, #1a66ff 100%);
                    color: #020a18; border: none; font-family: 'Montserrat', sans-serif; font-weight: 900; font-style: italic;
                    font-size: 14px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; margin-top: 4px;
                    clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%); transition: all 0.2s ease;
                }
                .submit-btn:hover { background: linear-gradient(95deg, #ffffff 0%, #52f2ff 100%); box-shadow: 0 0 22px rgba(0, 229, 255, 0.6); transform: translateX(3px); }

                .history-list { margin-top: 16px; border-top: 1px solid rgba(0, 229, 255, 0.22); padding-top: 10px; font-size: 13px; }
                .history-list strong { display: block; color: var(--p3-cyan); letter-spacing: 1px; text-transform: uppercase; font-size: 11px; margin-bottom: 6px; }
                .history-item { background: rgba(2, 10, 26, 0.85); padding: 8px 11px; margin-bottom: 6px; border: 1px solid rgba(143, 180, 223, 0.14); border-left: 3px solid var(--p3-cyan); color: #e4f0ff; }

                .chat-box { background: rgba(2, 9, 24, 0.9); border: 1px solid rgba(0, 229, 255, 0.25); height: 250px; overflow-y: auto; padding: 12px; margin-bottom: 12px; display: flex; flex-direction: column; gap: 10px; }
                .chat-msg { background: rgba(13, 50, 125, 0.42); border-left: 3px solid var(--p3-cyan); padding: 9px 12px; font-size: 13px; }
                .chat-msg .sender { font-weight: 700; color: var(--p3-cyan); font-size: 12px; margin-bottom: 4px; text-transform: uppercase; }
                .chat-msg .time { float: right; color: var(--p3-muted); font-weight: 500; font-size: 11px; }
                .chat-input-row { display: flex; gap: 8px; }
                .chat-input-row input { flex: 1; padding: 10px 12px; background: rgba(2, 10, 26, 0.92); border: 1px solid rgba(0, 229, 255, 0.3); color: #fff; font-family: 'Chakra Petch', sans-serif; outline: none; }
                .chat-input-row button { padding: 10px 22px; background: linear-gradient(95deg, #00c4ff, #1a66ff); color: #020a18; border: none; font-family: 'Montserrat', sans-serif; font-weight: 900; font-style: italic; text-transform: uppercase; cursor: pointer; clip-path: polygon(8px 0, 100% 0, calc(100% - 8px) 100%, 0 100%); }

                @media (max-width: 960px) {
                    body.p3r-client-body { flex-direction: column; height: auto; overflow-y: auto; }
                    .desktop-area { min-height: 45vh; padding-top: 90px; }
                    .right-sidebar { width: 100%; border-left: none; border-top: 3px solid var(--p3-cyan); }
                    .desktop-status-bar { display: none; }
                    .split-shop-layout { grid-template-columns: 1fr; }
                }
            </style>
        </head>
        <body class="p3r-client-body">

            <video class="desktop-video-bg" autoplay loop muted playsinline>
                <source src="<%= request.getContextPath() %>/assets/media/56481-479644998_medium.mp4" type="video/mp4">
            </video>
            <div class="desktop-video-overlay"></div>

            <div class="p3r-bg-layer">
                <div class="p3r-caustics"></div>
                <div class="p3r-shard s1"></div>
                <div class="p3r-shard s2"></div>
                <div class="p3r-shard s3"></div>
                <div class="p3r-watermark">DARK HOUR<br>REDZONE</div>
            </div>

            <div class="desktop-area">
                <div class="desktop-hud-left">
                    <div class="p3r-moon" title="Dark Hour"></div>
                    <div>
                        <div class="p3r-hud-date" id="p3rDate">--/--</div>
                        <div class="p3r-hud-phase" id="p3rPhase">DARK HOUR</div>
                    </div>
                </div>

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

            <div class="right-sidebar">
                <div>
                    <div class="user-box">
                        <div class="user-header">
                            <div class="user-avatar-group">
                                <div class="user-avatar-hex"><i class="fa-solid fa-bolt"></i></div>
                                <div>
                                    <div class="user-role-tag">HỘI VIÊN VIP • MÁY VIP-01</div>
                                    <div class="user-name"><%= currentUser.getUsername() %></div>
                                </div>
                            </div>
                            <span class="machine-badge"><span class="pulse-dot"></span> ONLINE</span>
                        </div>

                        <div class="countdown-hero-card">
                            <div class="countdown-top-label">
                                <span><i class="fa-solid fa-hourglass-half"></i> THỜI GIAN CÒN LẠI</span>
                                <span style="color: var(--p3-cyan);">10.000đ / GIỜ</span>
                            </div>
                            <div class="countdown-big-digits" id="countdownTimer">00:00:00</div>
                            <div class="time-progress-track">
                                <div class="time-progress-fill" id="timeProgressBar"></div>
                            </div>
                        </div>

                        <div class="wallet-mini-grid">
                            <div class="wallet-mini-card balance-card">
                                <div class="mini-label"><i class="fa-solid fa-wallet"></i> Số dư khả dụng</div>
                                <div class="mini-val money"><%= df.format(currentUser.getBalance()) %> VNĐ</div>
                            </div>
                            <div class="wallet-mini-card hours-card">
                                <div class="mini-label"><i class="fa-regular fa-clock"></i> Tổng giờ quy đổi</div>
                                <div class="mini-val" id="totalHoursText">0h 00m</div>
                            </div>
                        </div>
                    </div>

                    <div class="section-caption">BẢNG ĐIỀU KHIỂN (CLIENT)</div>

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

            <!-- 0. MODAL MENU GAME -->
            <div id="modalGameMenu" class="modal">
                <div class="modal-content large-modal">
                    <div class="modal-header">
                        <h3><i class="fa-solid fa-gamepad"></i> KHO GAME REDZONE</h3>
                        <input type="text" id="gameSearch" class="search-game" placeholder="Tìm kiếm tựa game..." onkeyup="filterGames()">
                        <button class="close-btn" onclick="closeModal('modalGameMenu')">&times;</button>
                    </div>

                    <div class="category-tabs" id="gameCategoryTabs">
                        <button type="button" class="cat-tab active" onclick="selectGameCat('ALL', this)">Tất cả</button>
                        <button type="button" class="cat-tab" onclick="selectGameCat('MOBA', this)">MOBA</button>
                        <button type="button" class="cat-tab" onclick="selectGameCat('FPS', this)">FPS / Bắn Súng</button>
                        <button type="button" class="cat-tab" onclick="selectGameCat('BATTLE ROYALE', this)">Battle Royale</button>
                        <button type="button" class="cat-tab" onclick="selectGameCat('SPORTS', this)">Thể Thao</button>
                        <button type="button" class="cat-tab" onclick="selectGameCat('RPG', this)">Nhập Vai (RPG)</button>
                    </div>

                    <div class="game-grid" id="gameGrid">
                        <% if (gameList != null) {
                            for (String[] g : gameList) { %>
                            <div class="game-card" data-name="<%= g[0].toLowerCase() %>" data-cat="<%= g.length > 4 ? g[4] : "ALL" %>">
                                <span class="game-tag"><%= g[3] %></span>
                                <img src="<%= g[2] %>" alt="<%= g[0] %>">
                                <div class="game-info">
                                    <div>
                                        <div class="game-title"><%= g[0] %></div>
                                        <div class="game-genre"><%= g[1] %></div>
                                    </div>
                                    <button type="button" class="play-game-btn" onclick="launchGame('<%= g[0] %>')">
                                        <i class="fa-solid fa-play"></i> CHƠI NGAY
                                    </button>
                                </div>
                            </div>
                        <%  }
                           } %>
                    </div>
                </div>
            </div>

            <!-- 1. MODAL NẠP TIỀN (GỬI YÊU CẦU CHỜ ADMIN DUYỆT) -->
            <div id="modalTopUp" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3><i class="fa-solid fa-credit-card"></i> Gửi Yêu Cầu Nạp Tiền</h3>
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
                                <option value="TRANSFER">Chuyển khoản Ngân hàng / Quét QR (Chờ Admin duyệt)</option>
                                <option value="CASH">Tiền mặt (Nhân viên thu tại máy &amp; Admin duyệt)</option>
                            </select>
                        </div>
                        <div style="font-size: 12px; color: var(--p3-cyan); margin-bottom: 12px; background: rgba(0, 229, 255, 0.08); padding: 8px 10px; border-left: 3px solid var(--p3-cyan);">
                            <i class="fa-solid fa-circle-info"></i> Tiền sẽ được cộng vào tài khoản ngay sau khi Admin xác nhận giao dịch.
                        </div>
                        <button type="submit" class="submit-btn">GỬI YÊU CẦU CHO ADMIN</button>
                    </form>
                </div>
            </div>

            <!-- 2. MODAL GỌI MÓN -->
            <div id="modalService" class="modal <%= "modalService".equals(openModalOnLoad) ? "active" : "" %>">
                <div class="modal-content xl-modal">
                    <div class="modal-header">
                        <h3><i class="fa-solid fa-utensils"></i> Dịch Vụ Ăn Uống Tại Bàn</h3>
                        <button class="close-btn" onclick="closeModal('modalService')">&times;</button>
                    </div>

                    <div class="category-tabs">
                        <button type="button" class="cat-tab active" onclick="selectFoodCat('ALL', this)">Tất cả món</button>
                        <button type="button" class="cat-tab" onclick="selectFoodCat('MI', this)"><i class="fa-solid fa-bowl-food"></i> Mì</button>
                        <button type="button" class="cat-tab" onclick="selectFoodCat('COM', this)"><i class="fa-solid fa-plate-wheat"></i> Cơm</button>
                        <button type="button" class="cat-tab" onclick="selectFoodCat('NUOC', this)"><i class="fa-solid fa-mug-hot"></i> Nước Uống</button>
                        <button type="button" class="cat-tab" onclick="selectFoodCat('COMBO', this)"><i class="fa-solid fa-fire"></i> Combo</button>
                    </div>

                    <div class="split-shop-layout">
                        <div class="shop-grid" id="foodGrid">
                            <% if (menuItems != null) {
                                for (MenuItem item : menuItems) {
                                    String rawName = item.getItemName() != null ? item.getItemName() : "Món ăn";
                                    String lower = rawName.toLowerCase();
                                    String catCode = "COMBO";
                                    String catLabel = "Combo";
                                    String imgUrl = "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80";

                                    if (lower.contains("combo")) {
                                        catCode = "COMBO"; catLabel = "Combo Tiết Kiệm";
                                        imgUrl = "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400&q=80";
                                    } else if (lower.contains("mì") || lower.contains("mi ") || lower.contains("phở") || lower.contains("bún") || lower.contains("nui")) {
                                        catCode = "MI"; catLabel = "Mì & Sợi";
                                        imgUrl = "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&q=80";
                                    } else if (lower.contains("cơm") || lower.contains("com ") || lower.contains("gà") || lower.contains("sườn")) {
                                        catCode = "COM"; catLabel = "Cơm Văn Phòng / Cyber";
                                        imgUrl = "https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&q=80";
                                    } else if (lower.contains("nước") || lower.contains("sting") || lower.contains("coca") || lower.contains("pepsi") || lower.contains("trà") || lower.contains("cà phê") || lower.contains("cafe") || lower.contains("redbull") || lower.contains("bò húc") || lower.contains("sữa")) {
                                        catCode = "NUOC"; catLabel = "Nước Giải Khát";
                                        imgUrl = "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&q=80";
                                    }
                            %>
                                <div class="shop-card food-card" data-food-cat="<%= catCode %>">
                                    <img src="<%= imgUrl %>" alt="<%= rawName %>">
                                    <div class="shop-card-body">
                                        <div>
                                            <div class="shop-cat-badge"><%= catLabel %></div>
                                            <div class="shop-name"><%= rawName %></div>
                                        </div>
                                        <div>
                                            <div class="shop-price"><%= df.format(item.getPrice()) %> VNĐ</div>
                                            <button type="button" class="add-cart-btn"
                                                    onclick="addFoodToCart(<%= item.getItemId() %>, '<%= rawName.replace("'", "\\'") %>', <%= item.getPrice() %>, '<%= imgUrl %>')">
                                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            <%  }
                               } %>
                        </div>

                        <div class="cart-panel">
                            <div class="cart-title">
                                <span><i class="fa-solid fa-bag-shopping"></i> Giỏ Hàng Món Ăn</span>
                                <span id="foodCartBadge" style="background: var(--p3-cyan); color: #020a18; padding: 2px 8px; font-size: 11px;">0 món</span>
                            </div>

                            <div class="cart-items-list" id="foodCartContainer">
                                <div class="cart-empty">Chưa có món nào trong giỏ.<br>Hãy bấm "Thêm vào giỏ hàng" bên trái!</div>
                            </div>

                            <form action="<%= request.getContextPath() %>/member" method="post" id="foodOrderForm" onsubmit="return handleOrderSubmit(event, 'FOOD')">
                                <input type="hidden" name="action" value="orderCart">
                                <div id="foodCartHiddenInputs"></div>

                                <div class="form-group" style="margin-top: 6px;">
                                    <label>Mã máy nhận đồ ăn</label>
                                    <input type="text" name="machineCode" id="foodMachineCode" value="VIP-01" required>
                                </div>

                                <div class="form-group">
                                    <label>Phương thức thanh toán</label>
                                    <select name="paymentMethod" id="foodPaymentMethod">
                                        <option value="CASH">Tiền mặt (Nhân viên thu khi mang đồ ra)</option>
                                        <option value="TRANSFER">Chuyển khoản Ngân hàng / Quét QR</option>
                                    </select>
                                </div>

                                <div class="cart-total-box">
                                    <span>TỔNG THANH TOÁN:</span>
                                    <span id="foodCartTotal">0 VNĐ</span>
                                </div>

                                <button type="submit" class="submit-btn" style="margin-top: 10px;">
                                    <i class="fa-solid fa-check-double"></i> XÁC NHẬN ĐẶT HÀNG
                                </button>
                            </form>
                        </div>
                    </div>

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
                <div id="modalGear" class="modal <%= "modalGear".equals(openModalOnLoad) ? "active" : "" %>">
                    <div class="modal-content xl-modal">
                        <div class="modal-header">
                            <h3><i class="fa-solid fa-computer-mouse"></i> Mượn &amp; Thuê Gear Esport</h3>
                            <button class="close-btn" onclick="closeModal('modalGear')">&times;</button>
                        </div>

                        <div class="category-tabs">
                            <button type="button" class="cat-tab active" onclick="selectGearCat('ALL', this)">Tất cả thiết bị</button>
                            <button type="button" class="cat-tab" onclick="selectGearCat('CHUOT', this)"><i class="fa-solid fa-computer-mouse"></i> Chuột Gaming</button>
                            <button type="button" class="cat-tab" onclick="selectGearCat('BAN_PHIM', this)"><i class="fa-solid fa-keyboard"></i> Bàn Phím Cơ</button>
                            <button type="button" class="cat-tab" onclick="selectGearCat('COMBO', this)"><i class="fa-solid fa-layer-group"></i> Combo Gear</button>
                        </div>

                        <div class="split-shop-layout">
                            <div class="shop-grid" id="gearVisualGrid">
                                <% if (gearList != null) {
                                    for (String[] gear : gearList) {
                                        String gId = gear[0];
                                        String gName = gear[1];
                                        String gPrice = gear[2];
                                        String gCat = gear.length > 3 ? gear[3] : "COMBO";
                                        String gDesc = gear.length > 4 ? gear[4] : "Thiết bị thi đấu Esport chuyên nghiệp";
                                        String gImg = "CHUOT".equals(gCat)
                                                ? "https://images.unsplash.com/photo-1527814050087-3793815479db?w=400&q=80"
                                                : ("BAN_PHIM".equals(gCat)
                                                    ? "https://images.unsplash.com/photo-1595225476474-87563907a212?w=400&q=80"
                                                    : "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=400&q=80");
                                        String gCatName = "CHUOT".equals(gCat) ? "Chuột Gaming" : ("BAN_PHIM".equals(gCat) ? "Bàn Phím Cơ" : "Combo Chuột + Phím");
                                %>
                                    <div class="shop-card gear-card" data-gear-cat="<%= gCat %>">
                                        <img src="<%= gImg %>" alt="<%= gName %>">
                                        <div class="shop-card-body">
                                            <div>
                                                <div class="shop-cat-badge"><%= gCatName %></div>
                                                <div class="shop-name"><%= gName %></div>
                                                <div class="shop-desc"><%= gDesc %></div>
                                            </div>
                                            <div>
                                                <div class="shop-price"><%= df.format(Long.parseLong(gPrice)) %> VNĐ / giờ</div>
                                                <button type="button" class="add-cart-btn"
                                                        onclick="addGearToCart('<%= gId %>', '<%= gName.replace("'", "\\'") %>', <%= gPrice %>, '<%= gImg %>')">
                                                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ thuê
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                <%  }
                                   } %>
                            </div>

                            <!-- BÊN TAY PHẢI: GIỎ HÀNG THUÊ GEAR -->
                            <div class="cart-panel">
                                <div class="cart-title">
                                    <span><i class="fa-solid fa-headset"></i> Giỏ Thuê Thiết Bị</span>
                                    <span id="gearCartBadge" style="background: var(--p3-cyan); color: #020a18; padding: 2px 8px; font-size: 11px;">0 thiết bị</span>
                                </div>

                                <div class="cart-items-list" id="gearCartContainer">
                                    <div class="cart-empty">Chưa chọn thiết bị nào.<br>Hãy bấm "Thêm vào giỏ thuê" bên trái!</div>
                                </div>

                                <form action="<%= request.getContextPath() %>/member" method="post" id="gearOrderForm" onsubmit="return handleOrderSubmit(event, 'GEAR')">
                                    <input type="hidden" name="action" value="rentGearCart">
                                    <div id="gearCartHiddenInputs"></div>

                                    <div class="form-group" style="margin-top: 6px;">
                                        <label>Mã máy nhận thiết bị</label>
                                        <input type="text" name="machineCode" id="gearMachineCode" value="VIP-01" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Phương thức thanh toán</label>
                                        <select name="paymentMethod" id="gearPaymentMethod">
                                            <option value="CASH">Tiền mặt (Nhân viên thu khi giao Gear)</option>
                                            <option value="TRANSFER">Chuyển khoản Ngân hàng / Quét QR</option>
                                        </select>
                                    </div>

                                    <div class="cart-total-box">
                                        <span>TỔNG PHÍ THUÊ:</span>
                                        <span id="gearCartTotal">0 VNĐ</span>
                                    </div>

                                    <button type="submit" class="submit-btn" style="margin-top: 10px;">
                                        <i class="fa-solid fa-check-double"></i> XÁC NHẬN THUÊ GEAR
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="history-list">
                            <strong>Thiết bị đang thuê trong phiên này:</strong>
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

                <!-- 6. MODAL THANH TOÁN & ĐẶT HÀNG THÀNH CÔNG -->
                <div id="modalPaymentSuccess" class="modal" style="z-index: 2000;">
                    <div class="modal-content" style="width: 440px; text-align: center;">
                        <div class="modal-header">
                            <h3><i class="fa-solid fa-receipt"></i> XÁC NHẬN THANH TOÁN</h3>
                            <button class="close-btn" onclick="closeModal('modalPaymentSuccess')">&times;</button>
                        </div>

                        <div style="font-size: 46px; color: var(--p3-success); margin: 6px 0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <h2 style="font-family: 'Montserrat', sans-serif; font-style: italic; color: var(--p3-success); font-size: 20px; margin-bottom: 8px;">
                            ĐẶT HÀNG THÀNH CÔNG!
                        </h2>
                        <p id="paySuccessSubtitle" style="color: #cfe4ff; font-size: 13px; margin-bottom: 14px;"></p>

                        <div id="qrPaymentBox" style="display: none; background: #fff; padding: 12px; margin: 0 auto 14px; width: 210px; border: 3px solid var(--p3-cyan);">
                            <img id="qrPaymentImg" src="" alt="QR Thanh Toán" style="width: 100%; display: block;">
                            <div style="color: #020a18; font-weight: 800; font-size: 11px; margin-top: 6px;">QUÉT MÃ QR ĐỂ CHUYỂN KHOẢN</div>
                        </div>

                        <div style="background: rgba(2, 10, 26, 0.9); border: 1px solid rgba(0, 229, 255, 0.3); padding: 12px; margin-bottom: 16px; text-align: left; font-size: 13px;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
                                <span style="color: var(--p3-muted);">Vị trí máy:</span>
                                <strong id="payMachineLabel" style="color: #fff;">VIP-01</strong>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
                                <span style="color: var(--p3-muted);">Hình thức:</span>
                                <strong id="payMethodLabel" style="color: var(--p3-cyan);">Tiền mặt</strong>
                            </div>
                            <div style="display: flex; justify-content: space-between; border-top: 1px dashed rgba(0,229,255,0.25); padding-top: 6px;">
                                <span style="color: var(--p3-muted);">Tổng tiền thanh toán:</span>
                                <strong id="payAmountLabel" style="color: var(--p3-success); font-size: 16px;">0 VNĐ</strong>
                            </div>
                        </div>

                        <button type="button" class="submit-btn" onclick="confirmFinalSubmit()">
                            HOÀN TẤT &amp; GỬI ĐƠN XUỐNG QUẦY
                        </button>
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

                    (function scrollChatOnLoad() {
                        const chatModal = document.getElementById('modalChat');
                        const cb = document.getElementById('chatBox');
                        if (chatModal && chatModal.classList.contains('active') && cb) {
                            cb.scrollTop = cb.scrollHeight;
                        }
                    })();

                    // 3. Lọc thể loại Game, Tìm kiếm & Chạy Game
                    let currentGameCat = 'ALL';
                    function selectGameCat(cat, btn) {
                        currentGameCat = cat;
                        document.querySelectorAll('#gameCategoryTabs .cat-tab').forEach(function(b) { b.classList.remove('active'); });
                        btn.classList.add('active');
                        filterGames();
                    }

                    function filterGames() {
                        const key = document.getElementById('gameSearch').value.toLowerCase();
                        document.querySelectorAll('.game-card').forEach(function(card) {
                            const name = card.getAttribute('data-name');
                            const cat = card.getAttribute('data-cat');
                            const matchName = name.includes(key);
                            const matchCat = (currentGameCat === 'ALL' || cat === currentGameCat);
                            card.style.display = (matchName && matchCat) ? 'flex' : 'none';
                        });
                    }

                    function launchGame(gameName) {
                        alert("🚀 ĐANG KHỞI CHẠY GAME: " + gameName.toUpperCase() + "\nHệ thống đang đồng bộ cấu hình & kết nối máy chủ...");
                        closeModal('modalGameMenu');
                    }

                    // 4. Phân loại Món Ăn & Giỏ Hàng (Có nút -, +, x)
                    function selectFoodCat(cat, btn) {
                        btn.parentElement.querySelectorAll('.cat-tab').forEach(function(b) { b.classList.remove('active'); });
                        btn.classList.add('active');
                        document.querySelectorAll('.food-card').forEach(function(card) {
                            const fCat = card.getAttribute('data-food-cat');
                            card.style.display = (cat === 'ALL' || fCat === cat) ? 'flex' : 'none';
                        });
                    }

                    let foodCart = {};

                    function addFoodToCart(id, name, price, img) {
                        const key = String(id);
                        if (foodCart[key]) {
                            foodCart[key].qty += 1;
                        } else {
                            foodCart[key] = { id: key, name: name, price: Number(price), img: img, qty: 1 };
                        }
                        renderFoodCart();
                    }

                    function increaseFoodItem(id) {
                        const key = String(id);
                        if (foodCart[key]) {
                            foodCart[key].qty += 1;
                            renderFoodCart();
                        }
                    }

                    function decreaseFoodItem(id) {
                        const key = String(id);
                        if (foodCart[key]) {
                            foodCart[key].qty -= 1;
                            if (foodCart[key].qty <= 0) {
                                delete foodCart[key];
                            }
                            renderFoodCart();
                        }
                    }

                    function removeFoodItem(id) {
                        const key = String(id);
                        if (foodCart[key]) {
                            delete foodCart[key];
                            renderFoodCart();
                        }
                    }

                    function renderFoodCart() {
                        const container = document.getElementById('foodCartContainer');
                        const hiddenInputs = document.getElementById('foodCartHiddenInputs');
                        const totalEl = document.getElementById('foodCartTotal');
                        const badgeEl = document.getElementById('foodCartBadge');

                        const keys = Object.keys(foodCart);
                        if (keys.length === 0) {
                            container.innerHTML = '<div class="cart-empty">Chưa có món nào trong giỏ.<br>Hãy bấm "Thêm vào giỏ hàng" bên trái!</div>';
                            hiddenInputs.innerHTML = '';
                            totalEl.innerText = '0 VNĐ';
                            badgeEl.innerText = '0 món';
                            return;
                        }

                        let html = '';
                        let inputsHtml = '';
                        let grandTotal = 0;
                        let totalQty = 0;

                        keys.forEach(function(key) {
                            const item = foodCart[key];
                            const subTotal = item.price * item.qty;
                            grandTotal += subTotal;
                            totalQty += item.qty;

                            html += '<div class="cart-item-row">' +
                                        '<img src="' + item.img + '" alt="' + item.name + '" class="cart-item-thumb">' +
                                        '<div class="cart-item-info">' +
                                            '<div class="cart-item-name" title="' + item.name + '">' + item.name + '</div>' +
                                            '<div class="cart-item-sub">' + subTotal.toLocaleString('vi-VN') + ' VNĐ</div>' +
                                        '</div>' +
                                        '<div class="cart-controls">' +
                                            '<button type="button" class="btn-minus" title="Giảm số lượng" onclick="decreaseFoodItem(\'' + item.id + '\')">-</button>' +
                                            '<span class="cart-qty-badge">' + item.qty + '</span>' +
                                            '<button type="button" class="btn-plus" title="Thêm số lượng" onclick="increaseFoodItem(\'' + item.id + '\')">+</button>' +
                                            '<button type="button" class="btn-remove" title="Xóa món" onclick="removeFoodItem(\'' + item.id + '\')">&times;</button>' +
                                        '</div>' +
                                    '</div>';

                            inputsHtml += '<input type="hidden" name="itemIds" value="' + item.id + '">' +
                                          '<input type="hidden" name="quantities" value="' + item.qty + '">';
                        });

                        container.innerHTML = html;
                        hiddenInputs.innerHTML = inputsHtml;
                        totalEl.innerText = grandTotal.toLocaleString('vi-VN') + ' VNĐ';
                        badgeEl.innerText = totalQty + ' món';
                    }

                    // 5. Phân loại Gear & Giỏ Hàng Thuê Gear (Có nút -, +, x)
                    function selectGearCat(cat, btn) {
                        btn.parentElement.querySelectorAll('.cat-tab').forEach(function(b) { b.classList.remove('active'); });
                        btn.classList.add('active');
                        document.querySelectorAll('.gear-card').forEach(function(card) {
                            const gCat = card.getAttribute('data-gear-cat');
                            card.style.display = (cat === 'ALL' || gCat === cat) ? 'flex' : 'none';
                        });
                    }

                    let gearCart = {};

                    function addGearToCart(id, name, price, img) {
                        const key = String(id);
                        if (gearCart[key]) {
                            gearCart[key].hours += 1;
                        } else {
                            gearCart[key] = { id: key, name: name, price: Number(price), img: img, hours: 1 };
                        }
                        renderGearCart();
                    }

                    function increaseGearHour(id) {
                        const key = String(id);
                        if (gearCart[key]) {
                            gearCart[key].hours += 1;
                            renderGearCart();
                        }
                    }

                    function decreaseGearHour(id) {
                        const key = String(id);
                        if (gearCart[key]) {
                            gearCart[key].hours -= 1;
                            if (gearCart[key].hours <= 0) {
                                delete gearCart[key];
                            }
                            renderGearCart();
                        }
                    }

                    function removeGearItem(id) {
                        const key = String(id);
                        if (gearCart[key]) {
                            delete gearCart[key];
                            renderGearCart();
                        }
                    }

                    function renderGearCart() {
                        const container = document.getElementById('gearCartContainer');
                        const hiddenInputs = document.getElementById('gearCartHiddenInputs');
                        const totalEl = document.getElementById('gearCartTotal');
                        const badgeEl = document.getElementById('gearCartBadge');

                        const keys = Object.keys(gearCart);
                        if (keys.length === 0) {
                            container.innerHTML = '<div class="cart-empty">Chưa chọn thiết bị nào.<br>Hãy bấm "Thêm vào giỏ thuê" bên trái!</div>';
                            hiddenInputs.innerHTML = '';
                            totalEl.innerText = '0 VNĐ';
                            badgeEl.innerText = '0 thiết bị';
                            return;
                        }

                        let html = '';
                        let inputsHtml = '';
                        let grandTotal = 0;

                        keys.forEach(function(key) {
                            const g = gearCart[key];
                            const subTotal = g.price * g.hours;
                            grandTotal += subTotal;

                            html += '<div class="cart-item-row">' +
                                        '<img src="' + g.img + '" alt="' + g.name + '" class="cart-item-thumb">' +
                                        '<div class="cart-item-info">' +
                                            '<div class="cart-item-name" title="' + g.name + '">' + g.name + '</div>' +
                                            '<div class="cart-item-sub">' + subTotal.toLocaleString('vi-VN') + ' VNĐ (' + g.hours + ' giờ)</div>' +
                                        '</div>' +
                                        '<div class="cart-controls">' +
                                            '<button type="button" class="btn-minus" title="Giảm 1 giờ" onclick="decreaseGearHour(\'' + g.id + '\')">-</button>' +
                                            '<span class="cart-qty-badge">' + g.hours + 'h</span>' +
                                            '<button type="button" class="btn-plus" title="Thêm 1 giờ" onclick="increaseGearHour(\'' + g.id + '\')">+</button>' +
                                            '<button type="button" class="btn-remove" title="Xóa thiết bị" onclick="removeGearItem(\'' + g.id + '\')">&times;</button>' +
                                        '</div>' +
                                    '</div>';

                            inputsHtml += '<input type="hidden" name="gearIds" value="' + g.id + '">' +
                                          '<input type="hidden" name="gearHours" value="' + g.hours + '">';
                        });

                        container.innerHTML = html;
                        hiddenInputs.innerHTML = inputsHtml;
                        totalEl.innerText = grandTotal.toLocaleString('vi-VN') + ' VNĐ';
                        badgeEl.innerText = keys.length + ' thiết bị';
                    }

                    // 6. Xử lý Popup Thanh toán (Tiền mặt / Chuyển khoản QR) & Đặt hàng thành công
                    let pendingSubmitForm = null;

                    function handleOrderSubmit(event, type) {
                        event.preventDefault();
                        let isFood = (type === 'FOOD');
                        let cartObj = isFood ? foodCart : gearCart;

                        if (Object.keys(cartObj).length === 0) {
                            alert(isFood ? "Giỏ hàng món ăn đang trống!" : "Giỏ thuê Gear đang trống!");
                            return false;
                        }

                        let machine = document.getElementById(isFood ? 'foodMachineCode' : 'gearMachineCode').value;
                        let method = document.getElementById(isFood ? 'foodPaymentMethod' : 'gearPaymentMethod').value;
                        let totalText = document.getElementById(isFood ? 'foodCartTotal' : 'gearCartTotal').innerText;
                        let numericAmount = totalText.replace(/[^\d]/g, '');

                        document.getElementById('payMachineLabel').innerText = machine;
                        document.getElementById('payAmountLabel').innerText = totalText;

                        const qrBox = document.getElementById('qrPaymentBox');
                        const qrImg = document.getElementById('qrPaymentImg');

                        if (method === 'TRANSFER') {
                            document.getElementById('payMethodLabel').innerText = "Chuyển khoản QR";
                            document.getElementById('paySuccessSubtitle').innerText = "Vui lòng quét mã QR bên dưới để thanh toán đơn hàng:";
                            qrImg.src = "https://img.vietqr.io/image/MB-0999999999-compact2.png?amount=" + numericAmount + "&addInfo=REDZONE%20" + encodeURIComponent(machine);
                            qrBox.style.display = "block";
                        } else {
                            document.getElementById('payMethodLabel').innerText = "Tiền mặt tại máy";
                            document.getElementById('paySuccessSubtitle').innerText = "Nhân viên sẽ mang đơn ra tận máy và thu tiền mặt trực tiếp.";
                            qrBox.style.display = "none";
                        }

                        pendingSubmitForm = document.getElementById(isFood ? 'foodOrderForm' : 'gearOrderForm');
                        openModal('modalPaymentSuccess');
                        return false;
                    }

                    function confirmFinalSubmit() {
                        if (pendingSubmitForm) {
                            pendingSubmitForm.submit();
                        }
                    }

                    // 7. Tự ẩn thông báo sau 5 giây
                    setTimeout(function() {
                        const alerts = document.querySelector('.alerts-container');
                        if (alerts) { alerts.style.display = 'none'; }
                    }, 5000);

                    // 8. Đồng hồ đếm ngược giờ chơi & Đồng bộ trừ tiền Database mỗi 60 giây
                    let totalMinutes = <%= remainingMinutes %>;
                    let totalSeconds = totalMinutes * 60;
                    const maxReferenceSeconds = Math.max(totalSeconds, 18000);

                    function updateHoursDisplay(mins) {
                        const initH = Math.floor(mins / 60);
                        const initM = mins % 60;
                        document.getElementById('totalHoursText').innerText = initH + " giờ " + (initM < 10 ? "0" : "") + initM + " phút";
                    }
                    updateHoursDisplay(totalMinutes);

                    function forceLogoutExpired() {
                        alert("⏰ TÀI KHOẢN ĐÃ HẾT GIỜ CHƠI!\nHệ thống sẽ tự động đăng xuất về màn hình chính.");
                        window.location.href = "<%= request.getContextPath() %>/logout";
                    }

                    function updateTimer() {
                        const progressBar = document.getElementById('timeProgressBar');
                        if (totalSeconds <= 0) {
                            document.getElementById('countdownTimer').innerText = "00:00:00 (HẾT GIỜ)";
                            document.getElementById('countdownTimer').style.color = "var(--p3-danger)";
                            if (progressBar) progressBar.style.width = "0%";
                            forceLogoutExpired();
                            return;
                        }
                        const h = Math.floor(totalSeconds / 3600);
                        const m = Math.floor((totalSeconds % 3600) / 60);
                        const s = totalSeconds % 60;
                        document.getElementById('countdownTimer').innerText =
                            (h < 10 ? "0" : "") + h + ":" +
                            (m < 10 ? "0" : "") + m + ":" +
                            (s < 10 ? "0" : "") + s;

                        if (progressBar) {
                            const pct = Math.min(100, Math.max(5, (totalSeconds / maxReferenceSeconds) * 100));
                            progressBar.style.width = pct + "%";
                        }
                        totalSeconds--;
                    }
                    updateTimer();
                    setInterval(updateTimer, 1000);

                    setInterval(function() {
                        fetch("<%= request.getContextPath() %>/member", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: "action=tickPlayTime"
                        })
                        .then(function(res) { return res.json(); })
                        .then(function(data) {
                            if (data.status === "EXPIRED") {
                                forceLogoutExpired();
                            } else if (data.status === "OK") {
                                const moneyEl = document.querySelector('.mini-val.money');
                                if (moneyEl) moneyEl.innerText = Number(data.balance).toLocaleString('vi-VN') + " VNĐ";
                                updateHoursDisplay(data.remainingMinutes);
                            }
                        })
                        .catch(function(err) { console.error("Lỗi đồng bộ giờ chơi:", err); });
                    }, 60000);
                </script>
            </body>
            </html>
