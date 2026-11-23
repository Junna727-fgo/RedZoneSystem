<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - RedZone Cyber System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:ital,wght@0,500;0,600;0,700;1,700&family=Montserrat:ital,wght@0,700;0,900;1,800;1,900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/p3r-theme.css">
    <style>
        /* 1. Tối ưu GPU cho nền video */
        .p3r-bg-video {
            filter: none !important;
            transform: translate3d(0, 0, 0);
            backface-visibility: hidden;
        }
        .p3r-login-wrapper.p3r-video-mode .p3r-login-card {
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            background: rgba(4, 15, 40, 0.92) !important;
        }

        /* 2. Nút con mắt hiện/ẩn mật khẩu */
        .p3r-input-wrap {
            position: relative;
        }
        .p3r-input.has-eye {
            padding-right: 44px !important;
        }
        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear {
            display: none;
        }
        .p3r-eye-btn {
            position: absolute;
            top: 50%;
            right: 8px;
            transform: translateY(-50%);
            z-index: 5;
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: transparent;
            border: none;
            border-radius: 4px;
            color: #8fb4df;
            cursor: pointer;
            padding: 0;
            transition: color 0.18s ease, background 0.18s ease, transform 0.12s ease;
        }
        .p3r-eye-btn:hover {
            color: #00e5ff;
            background: rgba(0, 229, 255, 0.14);
        }
        .p3r-eye-btn:active {
            transform: translateY(-50%) scale(0.9);
        }
        .p3r-eye-btn:focus-visible {
            outline: 2px solid #00e5ff;
            outline-offset: 1px;
        }
        .p3r-eye-btn i {
            position: static !important;
            top: auto !important;
            left: auto !important;
            right: auto !important;
            transform: none !important;
            font-size: 0.95rem !important;
            color: inherit !important;
            pointer-events: none;
        }

        /* 3. Tối ưu nút chính (.p3r-btn) */
        .p3r-btn {
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            min-height: 48px;
            padding: 12px 22px;
            border: none;
            background: linear-gradient(100deg, #00e5ff 0%, #0095ff 55%, #1d5bff 100%);
            color: #020a18;
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-style: italic;
            font-size: 0.95rem;
            letter-spacing: 1.4px;
            text-transform: uppercase;
            clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%);
            box-shadow: 0 6px 20px rgba(0, 229, 255, 0.28);
            cursor: pointer;
            user-select: none;
            -webkit-tap-highlight-color: transparent;
            transition: transform 0.16s ease, box-shadow 0.2s ease, filter 0.2s ease;
        }
        .p3r-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -120%;
            width: 65%;
            height: 100%;
            background: linear-gradient(105deg, transparent 0%, rgba(255, 255, 255, 0.45) 50%, transparent 100%);
            transform: skewX(-20deg);
            pointer-events: none;
            transition: transform 0.45s ease;
        }
        .p3r-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 26px rgba(0, 229, 255, 0.55);
            filter: brightness(1.08);
            color: #020a18;
        }
        .p3r-btn:hover::before {
            transform: translateX(380%) skewX(-20deg);
        }
        .p3r-btn i {
            transition: transform 0.2s ease;
        }
        .p3r-btn:hover i {
            transform: translateX(4px);
        }
        .p3r-btn:active {
            transform: translateY(0) scale(0.98);
            box-shadow: 0 3px 12px rgba(0, 229, 255, 0.35);
        }
        .p3r-btn:focus-visible {
            outline: 2px solid #ffffff;
            outline-offset: 3px;
        }
        .p3r-btn:disabled,
        .p3r-btn.is-loading {
            opacity: 0.78;
            cursor: not-allowed;
            transform: none;
            filter: saturate(0.85);
        }

        /* 4. Link chuyển trang */
        .p3r-link {
            display: inline-block;
            padding: 6px 12px;
            font-size: 0.9rem;
            text-decoration: none;
            transition: color 0.18s ease, transform 0.16s ease;
        }
        .p3r-link span {
            position: relative;
            font-weight: 700;
            color: #00e5ff;
        }
        .p3r-link span::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -2px;
            width: 100%;
            height: 2px;
            background: #00e5ff;
            transform: scaleX(0);
            transform-origin: right;
            transition: transform 0.22s ease;
        }
        .p3r-link:hover span::after {
            transform: scaleX(1);
            transform-origin: left;
        }
        .p3r-link:active {
            transform: scale(0.97);
        }

        /* 5. Cụm nút HUD nhạc nền BGM */
        .p3r-bgm-hud {
            position: fixed;
            top: 22px;
            left: 28px;
            z-index: 20;
            display: inline-flex;
            align-items: stretch;
            min-height: 38px;
            background: rgba(3, 12, 34, 0.94);
            border: 1px solid rgba(0, 229, 255, 0.45);
            border-left: 4px solid #00e5ff;
            clip-path: polygon(0 0, 100% 0, calc(100% - 12px) 100%, 0 100%);
            box-shadow: 0 0 18px rgba(0, 229, 255, 0.22);
            user-select: none;
            overflow: hidden;
        }
        .p3r-bgm-toggle {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 8px 14px;
            background: transparent;
            border: none;
            color: #f4f9ff;
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-style: italic;
            font-size: 0.78rem;
            letter-spacing: 1.1px;
            text-transform: uppercase;
            cursor: pointer;
            transition: background 0.18s ease, transform 0.12s ease;
        }
        .p3r-bgm-toggle:hover { background: rgba(0, 229, 255, 0.16); }
        .p3r-bgm-toggle:active { transform: scale(0.97); }
        .p3r-bgm-bars {
            display: inline-flex;
            align-items: flex-end;
            gap: 3px;
            height: 14px;
        }
        .p3r-bgm-bars span {
            width: 3px;
            height: 4px;
            background: #8fb4df;
            transition: height 0.2s ease;
        }
        .p3r-bgm-hud.is-playing .p3r-bgm-bars span {
            background: #00e5ff;
            animation: p3rEq 0.9s ease-in-out infinite;
        }
        .p3r-bgm-hud.is-playing .p3r-bgm-bars span:nth-child(2) { animation-delay: 0.2s; }
        .p3r-bgm-hud.is-playing .p3r-bgm-bars span:nth-child(3) { animation-delay: 0.4s; }
        .p3r-bgm-track {
            color: #00e5ff;
            font-family: 'Chakra Petch', sans-serif;
            font-style: normal;
            font-weight: 700;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            border-left: 1px solid rgba(143, 180, 223, 0.35);
            padding-left: 10px;
            max-width: 185px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .p3r-bgm-controls {
            display: inline-flex;
            align-items: center;
            border-left: 1px solid rgba(0, 229, 255, 0.28);
            padding-right: 14px;
        }
        .p3r-bgm-ctrl {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 100%;
            background: transparent;
            border: none;
            color: #8fb4df;
            font-size: 0.85rem;
            cursor: pointer;
            transition: background 0.16s ease, color 0.16s ease, transform 0.12s ease;
        }
        .p3r-bgm-ctrl:hover { color: #020a18; background: #00e5ff; }
        .p3r-bgm-ctrl:active { transform: scale(0.9); }
        .p3r-bgm-toggle:focus-visible,
        .p3r-bgm-ctrl:focus-visible {
            outline: 2px solid #00e5ff;
            outline-offset: -2px;
        }
        @keyframes p3rEq {
            0%, 100% { height: 4px; }
            50% { height: 14px; }
        }
        @media (max-width: 576px) {
            .p3r-bgm-hud { top: 14px; left: 14px; }
            .p3r-bgm-track { display: none; }
        }
    </style>
</head>
<body class="p3r-body">

    <!-- Nền Video Makoto (P3R) -->
    <div class="p3r-bg-layer">
        <video class="p3r-bg-video" autoplay loop muted playsinline disablePictureInPicture preload="auto">
            <source src="${pageContext.request.contextPath}/assets/media/p3r-bg.mp4?v=6" type="video/mp4">
        </video>
        <div class="p3r-video-vignette"></div>
    </div>

    <!-- HUD trình phát nhạc nền góc trên trái -->
    <audio id="p3rBgmAudio" preload="auto"></audio>
    <div id="p3rBgmHud" class="p3r-bgm-hud">
        <button type="button" id="p3rBgmToggle" class="p3r-bgm-toggle" title="Bật / Tắt nhạc nền">
            <span class="p3r-bgm-bars">
                <span></span><span></span><span></span>
            </span>
            <span id="p3rBgmStatus">BGM OFF</span>
            <span id="p3rBgmTrack" class="p3r-bgm-track">LOADING...</span>
        </button>
        <div class="p3r-bgm-controls">
            <button type="button" id="p3rBgmPrev" class="p3r-bgm-ctrl" title="Bài trước">
                <i class="fa-solid fa-backward-step"></i>
            </button>
            <button type="button" id="p3rBgmNext" class="p3r-bgm-ctrl" title="Bài tiếp theo">
                <i class="fa-solid fa-forward-step"></i>
            </button>
        </div>
    </div>

    <!-- HUD ngày giờ & mặt trăng góc trên phải -->
    <div class="p3r-hud-top">
        <div>
            <div class="p3r-hud-date" id="p3rDate">--/--</div>
            <div class="p3r-hud-phase" id="p3rPhase">DARK HOUR</div>
        </div>
        <div class="p3r-moon" title="Dark Hour"></div>
    </div>

    <!-- Khung Đăng nhập -->
    <main class="p3r-login-wrapper p3r-video-mode">
        <section class="p3r-login-card">
            <div class="p3r-card-header">
                <div class="p3r-card-kicker"><i class="fa-solid fa-terminal me-1"></i> S.E.E.S // CYBER PORTAL</div>
                <h1 class="p3r-brand-inline">RED<span>ZONE</span> SYSTEM</h1>
                <div style="color: var(--p3-muted); font-size: 0.92rem;">Đăng nhập để kết nối trạm máy của bạn</div>
            </div>

            <c:if test="${param.error == 'invalid'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Sai tên đăng nhập, mật khẩu hoặc tài khoản bị khóa!
                </div>
            </c:if>
            <c:if test="${param.error == 'out_of_time'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-wallet me-1"></i> Tài khoản bạn đã hết tiền! Vui lòng liên hệ quầy để nạp thêm giờ chơi.
                </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-ban me-1"></i> Bạn không có quyền truy cập khu vực này!
                </div>
            </c:if>
            <c:if test="${param.error == 'login_required'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-shield-halved me-1"></i> Vui lòng đăng nhập để tiếp tục!
                </div>
            </c:if>
            <c:if test="${param.success == 'registered'}">
                <div class="p3r-alert p3r-alert-success">
                    <i class="fa-solid fa-circle-check me-1"></i> Đăng ký thành công! Vui lòng chờ Admin duyệt.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="p3r-label">Tên đăng nhập</label>
                    <div class="p3r-input-wrap">
                        <input type="text" name="username" value="${cookie.c_user.value}"
                               class="p3r-input" placeholder="Nhập tài khoản..." required autocomplete="off">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="p3r-label">Mật khẩu</label>
                    <div class="p3r-input-wrap">
                        <input type="password" id="loginPassword" name="password"
                               class="p3r-input has-eye" placeholder="Nhập mật khẩu..." required>
                        <i class="fa-solid fa-lock"></i>
                        <button type="button" class="p3r-eye-btn" data-toggle-pass="loginPassword"
                                title="Hiện mật khẩu" aria-label="Hiện mật khẩu">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="p3r-remember">
                        <input type="checkbox" name="remember" ${cookie.c_remember.value == 'true' ? 'checked' : ''}>
                        Ghi nhớ tài khoản đăng nhập
                    </label>
                </div>

                <button type="submit" class="p3r-btn">
                    Kết Nối Hệ Thống <i class="fa-solid fa-angles-right ms-1"></i>
                </button>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="p3r-link">
                        Chưa có tài khoản? <span>Đăng ký hội viên</span>
                    </a>
                </div>
            </form>
        </section>
    </main>

    <script>
        // 1. Tự cập nhật HUD ngày giờ P3R
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

        // 2. Trình phát nhạc nền P3R (đồng bộ với register.jsp)
        (function () {
            const audio = document.getElementById('p3rBgmAudio');
            const hud = document.getElementById('p3rBgmHud');
            const toggleBtn = document.getElementById('p3rBgmToggle');
            const prevBtn = document.getElementById('p3rBgmPrev');
            const nextBtn = document.getElementById('p3rBgmNext');
            const statusText = document.getElementById('p3rBgmStatus');
            const trackText = document.getElementById('p3rBgmTrack');
            if (!audio || !hud) return;

            const basePath = '${pageContext.request.contextPath}/assets/media/';

            const PLAYLIST = [
                { title: 'Changing Seasons -Reload-', file: 'p3r-1.m4a' },
                { title: 'Color Your Night', file: 'p3r-2.m4a' },
                { title: 'Because I Will Protect You -Reload-', file: 'p3r-3.m4a' }
            ];

            audio.volume = 0.35;

            let currentIndex = parseInt(sessionStorage.getItem('p3r_bgm_index') || '0', 10);
            if (isNaN(currentIndex) || currentIndex < 0 || currentIndex >= PLAYLIST.length) {
                currentIndex = 0;
            }
            const savedTime = parseFloat(sessionStorage.getItem('p3r_bgm_time') || '0');
            const isMuted = sessionStorage.getItem('p3r_bgm_muted') === 'true';

            function setUI(playing) {
                hud.classList.toggle('is-playing', playing);
                statusText.textContent = playing ? 'BGM ON' : 'BGM OFF';
            }

            function loadTrack(index, startTime) {
                currentIndex = (index + PLAYLIST.length) % PLAYLIST.length;
                const track = PLAYLIST[currentIndex];
                audio.src = basePath + track.file;
                trackText.textContent = track.title;
                trackText.title = track.title;
                sessionStorage.setItem('p3r_bgm_index', String(currentIndex));

                if (startTime && startTime > 0) {
                    audio.addEventListener('loadedmetadata', function applyTime() {
                        if (audio.duration && startTime < audio.duration) {
                            audio.currentTime = startTime;
                        }
                    }, { once: true });
                }
            }

            function playCurrent(allowUnlock) {
                const p = audio.play();
                if (p !== undefined) {
                    p.then(function () {
                        setUI(true);
                        sessionStorage.setItem('p3r_bgm_muted', 'false');
                    }).catch(function () {
                        setUI(false);
                        if (allowUnlock) {
                            statusText.textContent = 'CLICK PLAY';
                            const unlock = function (e) {
                                if (e.target.closest('#p3rBgmHud')) return;
                                if (sessionStorage.getItem('p3r_bgm_muted') !== 'true') {
                                    audio.play().then(function () { setUI(true); }).catch(function () {});
                                }
                                document.removeEventListener('click', unlock);
                                document.removeEventListener('keydown', unlock);
                            };
                            document.addEventListener('click', unlock);
                            document.addEventListener('keydown', unlock);
                        }
                    });
                }
            }

            function switchTrack(step) {
                sessionStorage.setItem('p3r_bgm_time', '0');
                sessionStorage.setItem('p3r_bgm_muted', 'false');
                loadTrack(currentIndex + step, 0);
                playCurrent(false);
            }

            loadTrack(currentIndex, savedTime);
            if (!isMuted) {
                playCurrent(true);
            } else {
                setUI(false);
            }

            toggleBtn.addEventListener('click', function () {
                if (audio.paused) {
                    sessionStorage.setItem('p3r_bgm_muted', 'false');
                    playCurrent(false);
                } else {
                    audio.pause();
                    sessionStorage.setItem('p3r_bgm_muted', 'true');
                    setUI(false);
                }
            });

            prevBtn.addEventListener('click', function () { switchTrack(-1); });
            nextBtn.addEventListener('click', function () { switchTrack(1); });
            audio.addEventListener('ended', function () { switchTrack(1); });

            window.addEventListener('beforeunload', function () {
                sessionStorage.setItem('p3r_bgm_index', String(currentIndex));
                sessionStorage.setItem('p3r_bgm_time', String(audio.currentTime || 0));
            });
        })();

        // 3. Nút con mắt hiện / ẩn mật khẩu
        document.querySelectorAll('[data-toggle-pass]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                const input = document.getElementById(btn.getAttribute('data-toggle-pass'));
                const icon = btn.querySelector('i');
                if (!input || !icon) return;

                const isHidden = input.type === 'password';
                input.type = isHidden ? 'text' : 'password';
                icon.classList.toggle('fa-eye', !isHidden);
                icon.classList.toggle('fa-eye-slash', isHidden);
                btn.title = isHidden ? 'Ẩn mật khẩu' : 'Hiện mật khẩu';
                btn.setAttribute('aria-label', btn.title);
            });
        });

        // 4. Hiệu ứng loading & khóa chống bấm đúp khi gửi form
        (function () {
            const form = document.querySelector('form');
            const submitBtn = form ? form.querySelector('button[type="submit"]') : null;
            if (!form || !submitBtn) return;

            const originalHtml = submitBtn.innerHTML;
            form.addEventListener('submit', function () {
                if (submitBtn.disabled) return;
                submitBtn.disabled = true;
                submitBtn.classList.add('is-loading');
                submitBtn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin"></i> Đang Kết Nối...';
            });

            window.addEventListener('pageshow', function () {
                submitBtn.disabled = false;
                submitBtn.classList.remove('is-loading');
                submitBtn.innerHTML = originalHtml;
            });
        })();
    </script>

</body>
</html>