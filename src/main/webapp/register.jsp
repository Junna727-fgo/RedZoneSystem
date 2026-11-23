<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Hội Viên - RedZone Cyber System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:ital,wght@0,500;0,600;0,700;1,700&family=Montserrat:ital,wght@0,700;0,900;1,800;1,900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/p3r-theme.css">
</head>
<body class="p3r-body">

    <!-- Nền Video Makoto (P3R) đồng bộ với index.jsp -->
    <div class="p3r-bg-layer">
        <video id="p3rBgA" class="p3r-bg-video" autoplay muted playsinline preload="auto" style="z-index: 2; opacity: 1;">
            <source src="${pageContext.request.contextPath}/assets/media/p3r-bg.mp4?v=1" type="video/mp4">
        </video>
        <video id="p3rBgB" class="p3r-bg-video" muted playsinline preload="auto" style="z-index: 1; opacity: 0;">
            <source src="${pageContext.request.contextPath}/assets/media/p3r-bg.mp4?v=2" type="video/mp4">
        </video>
        <div class="p3r-video-vignette" style="z-index: 3;"></div>
    </div>

    <!-- HUD ngày giờ & mặt trăng góc trên phải kiểu P3R -->
    <div class="p3r-hud-top">
        <div>
            <div class="p3r-hud-date" id="p3rDate">--/--</div>
            <div class="p3r-hud-phase" id="p3rPhase">DARK HOUR</div>
        </div>
        <div class="p3r-moon" title="Dark Hour"></div>
    </div>

    <!-- Khung Đăng ký căn gọn bên phải để lộ trọn Makoto bên trái -->
    <main class="p3r-login-wrapper p3r-video-mode">
        <section class="p3r-login-card">
            <div class="p3r-card-header">
                <div class="p3r-card-kicker"><i class="fa-solid fa-user-plus me-1"></i> S.E.E.S // MEMBER RECRUITMENT</div>
                <h1 class="p3r-brand-inline">JOIN <span>REDZONE</span></h1>
                <div style="color: var(--p3-muted); font-size: 0.92rem;">Tạo tài khoản hội viên để kết nối hệ thống</div>
            </div>

            <!-- Thông báo lỗi nếu RegisterServlet trả về -->
            <c:if test="${not empty error}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> ${error}
                </div>
            </c:if>
            <c:if test="${param.error == 'exists'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!
                </div>
            </c:if>
            <c:if test="${param.error == 'failed'}">
                <div class="p3r-alert">
                    <i class="fa-solid fa-circle-xmark me-1"></i> Đăng ký thất bại, vui lòng thử lại sau!
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="p3r-label">Họ và tên</label>
                    <div class="p3r-input-wrap">
                        <input type="text" name="fullName" class="p3r-input"
                               placeholder="Nhập họ và tên..." required autocomplete="off">
                        <i class="fa-solid fa-id-badge"></i>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="p3r-label">Tên đăng nhập</label>
                    <div class="p3r-input-wrap">
                        <input type="text" name="username" class="p3r-input"
                               placeholder="Chọn tài khoản..." required autocomplete="off">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="p3r-label">Mật khẩu</label>
                    <div class="p3r-input-wrap">
                        <input type="password" name="password" class="p3r-input"
                               placeholder="Nhập mật khẩu..." required>
                        <i class="fa-solid fa-lock"></i>
                    </div>
                </div>

                <button type="submit" class="p3r-btn">
                    Tạo Tài Khoản <i class="fa-solid fa-angles-right ms-1"></i>
                </button>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="p3r-link">
                        Đã có tài khoản? <span>Quay lại đăng nhập</span>
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

        // 2. Crossfade loop đồng bộ với index.jsp
        const vidA = document.getElementById('p3rBgA');
        const vidB = document.getElementById('p3rBgB');

        if (vidA && vidB) {
            const LOOP_START = 2.0;
            const TRIGGER_AT = 4.9;
            const FADE_MS = 900;

            let active = vidA;
            let standby = vidB;
            let swapping = false;

            function seekSafe(video, time) {
                try {
                    if (video.readyState >= 1) {
                        video.currentTime = time;
                    }
                } catch (e) {}
            }

            vidB.addEventListener('loadedmetadata', function () {
                seekSafe(vidB, LOOP_START);
            }, { once: true });
            vidB.load();

            function doCrossfade() {
                if (swapping) return;

                if (standby.readyState < 2) {
                    seekSafe(active, LOOP_START);
                    active.play().catch(function () {});
                    return;
                }

                swapping = true;
                const oldVid = active;
                const newVid = standby;

                oldVid.style.transition = 'none';
                oldVid.style.zIndex = '1';
                oldVid.style.opacity = '1';

                newVid.style.transition = 'none';
                newVid.style.zIndex = '2';
                newVid.style.opacity = '0';
                seekSafe(newVid, LOOP_START);

                const playPromise = newVid.play();
                const startFade = function () {
                    void newVid.offsetWidth;
                    newVid.style.transition = 'opacity ' + FADE_MS + 'ms ease-in-out';
                    newVid.style.opacity = '1';

                    active = newVid;
                    standby = oldVid;

                    setTimeout(function () {
                        standby.pause();
                        standby.style.transition = 'none';
                        standby.style.opacity = '0';
                        standby.style.zIndex = '1';
                        seekSafe(standby, LOOP_START);
                        swapping = false;
                    }, FADE_MS + 80);
                };

                if (playPromise && typeof playPromise.then === 'function') {
                    playPromise.then(startFade).catch(function () {
                        swapping = false;
                        seekSafe(oldVid, LOOP_START);
                        oldVid.play().catch(function () {});
                    });
                } else {
                    startFade();
                }
            }

            function watchLoop() {
                if (!swapping && !active.paused && active.currentTime >= TRIGGER_AT) {
                    doCrossfade();
                }
                requestAnimationFrame(watchLoop);
            }
            requestAnimationFrame(watchLoop);

            [vidA, vidB].forEach(function (v) {
                v.addEventListener('ended', function () {
                    if (v === active) {
                        swapping = false;
                        seekSafe(v, LOOP_START);
                        v.play().catch(function () {});
                    }
                });
            });
        }
    </script>

</body>
</html>