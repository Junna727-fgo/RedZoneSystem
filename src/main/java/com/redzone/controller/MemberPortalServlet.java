package com.redzone.controller;

import com.redzone.dao.DichVuDAO;
import com.redzone.dao.UserDAO;
import com.redzone.model.*;
import com.redzone.util.TinNhanStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "MemberPortalServlet", urlPatterns = {"/profile", "/member", "/user/dashboard"})
public class MemberPortalServlet extends HttpServlet {

    private void updateRemainingTime(HttpSession session, BigDecimal balance) {
        if (balance == null) {
            balance = BigDecimal.ZERO;
        }
        int remainingMinutes = balance
                .multiply(new BigDecimal("60"))
                .divide(new BigDecimal("10000"), 0, RoundingMode.DOWN)
                .intValue();
        session.setAttribute("remainingMinutes", remainingMinutes);
    }

    @SuppressWarnings("unchecked")
    private boolean initSessionData(HttpSession session, UserDAO userDAO) {
        TaiKhoan userLog = (TaiKhoan) session.getAttribute("userLog");
        if (userLog == null) {
            userLog = (TaiKhoan) session.getAttribute("user");
        }
        if (userLog == null) {
            return false;
        }

        User dbUser = userDAO.getUserById(userLog.getId());
        User currentUser = (User) session.getAttribute("currentUser");
        if (dbUser != null) {
            currentUser = dbUser;
            session.setAttribute("currentUser", currentUser);
        } else if (currentUser == null) {
            currentUser = new User();
            currentUser.setUserId(userLog.getId());
            currentUser.setUsername(userLog.getUsername());
            currentUser.setFullName(userLog.getFullName());
            currentUser.setBalance(BigDecimal.valueOf(userLog.getBalance()));
            currentUser.setStatus(userLog.getTrangThai() == 1 ? "Hoạt động"
                    : (userLog.getTrangThai() == 0 ? "Khóa" : "Chờ duyệt"));
            session.setAttribute("currentUser", currentUser);
        }
        if (currentUser.getBalance() == null) {
            currentUser.setBalance(BigDecimal.ZERO);
        }

        if (session.getAttribute("orderHistory") == null) {
            session.setAttribute("orderHistory", new ArrayList<ServiceOrder>());
        }
        if (session.getAttribute("gearHistory") == null) {
            session.setAttribute("gearHistory", new ArrayList<String>());
        }
        if (session.getAttribute("chatHistory") == null) {
            List<String[]> chats = new ArrayList<>();
            chats.add(new String[]{"Nhân viên Quầy", "Xin chào! Bạn cần hỗ trợ nạp tiền, gọi món hay đổi thiết bị cứ nhắn tại đây nhé.", "Hệ thống"});
            session.setAttribute("chatHistory", chats);
        }

        List<String[]> gameList = new ArrayList<>();
        gameList.add(new String[]{"League of Legends", "MOBA • Riot Games", "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400&q=80", "HOT", "MOBA"});
        gameList.add(new String[]{"VALORANT", "FPS • Riot Games", "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=400&q=80", "HOT", "FPS"});
        gameList.add(new String[]{"Counter-Strike 2", "FPS • Valve", "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=400&q=80", "ESPORTS", "FPS"});
        gameList.add(new String[]{"FC Online (FIFA)", "Sports • EA", "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=400&q=80", "POPULAR", "SPORTS"});
        gameList.add(new String[]{"PUBG: Battlegrounds", "Battle Royale • Krafton", "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=400&q=80", "FPS", "BATTLE ROYALE"});
        gameList.add(new String[]{"Genshin Impact", "RPG • HoYoverse", "https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=400&q=80", "RPG", "RPG"});
        session.setAttribute("gameList", gameList);

        List<String[]> gearList = new ArrayList<>();
        List<MenuItem> dbMenuItems = new ArrayList<>();
        try {
            DichVuDAO dvDao = new DichVuDAO();
            for (DichVu dv : dvDao.getAllDichVu()) {
                if ("GEAR".equalsIgnoreCase(dv.getDanhMuc())) {
                    if (dv.getSoLuongTon() > 0) {
                        String lower = dv.getTenMon().toLowerCase();
                        String gCat = lower.contains("combo") ? "COMBO"
                                : (lower.contains("chuột") ? "CHUOT"
                                : (lower.contains("phím") ? "BAN_PHIM" : "COMBO"));
                        gearList.add(new String[]{
                                String.valueOf(dv.getId()),
                                dv.getTenMon(),
                                String.valueOf((long) dv.getGia()),
                                gCat,
                                "Sẵn có: " + dv.getSoLuongTon() + " bộ tại quầy",
                                dv.getHinhAnh() != null ? dv.getHinhAnh().trim() : ""
                        });
                    }
                } else {
                    MenuItem item = new MenuItem();
                    item.setItemId(dv.getId());
                    item.setItemName(dv.getTenMon());
                    item.setCategory(dv.getDanhMuc());
                    item.setPrice(BigDecimal.valueOf(dv.getGia()));
                    item.setImageUrl(dv.getHinhAnh());
                    dbMenuItems.add(item);
                }
            }
        } catch (Exception ignored) {}

        if (gearList.isEmpty()) {
            gearList.add(new String[]{"1", "Chuột Logitech G Pro X Superlight", "15000", "CHUOT", "Chuột không dây siêu nhẹ 63g", ""});
            gearList.add(new String[]{"2", "Chuột Razer DeathAdder V3 Pro", "15000", "CHUOT", "Cảm biến Focus Pro 30K", ""});
            gearList.add(new String[]{"3", "Bàn phím cơ Corsair K70 RGB", "15000", "BAN_PHIM", "Switch Cherry MX Speed", ""});
            gearList.add(new String[]{"4", "Bàn phím cơ Wooting 60HE (Rapid Trigger)", "25000", "BAN_PHIM", "Rapid Trigger chuẩn Valorant/CS2", ""});
            gearList.add(new String[]{"5", "Tai nghe HyperX Cloud II Wireless", "10000", "COMBO", "Âm thanh vòm 7.1 không dây", ""});
            gearList.add(new String[]{"6", "Combo Chuột G Pro X + Phím Wooting 60HE", "35000", "COMBO", "Trọn bộ thi đấu Esport", ""});
        }
        session.setAttribute("gearList", gearList);

        if (dbMenuItems.isEmpty()) {
            dbMenuItems = userDAO.getMenuItems();
        }
        session.setAttribute("menuItems", dbMenuItems);

        // Nạp lịch sử giao dịch thực tế từ SQL để khách theo dõi trạng thái Admin duyệt
        session.setAttribute("recentTransactions", userDAO.getUserRecentTransactions(currentUser.getUserId(), 10));

        updateRemainingTime(session, currentUser.getBalance());
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        UserDAO userDAO = new UserDAO();

        if (!initSessionData(session, userDAO)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");

        if ("tickPlayTime".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.getWriter().write("{\"status\":\"EXPIRED\"}");
                return;
            }
            BigDecimal ratePerMinute = new BigDecimal("167");
            userDAO.deductPlayTimeBalance(currentUser.getUserId(), ratePerMinute);
            User refreshed = userDAO.getUserById(currentUser.getUserId());
            if (refreshed != null) {
                currentUser = refreshed;
                session.setAttribute("currentUser", currentUser);
            }
            updateRemainingTime(session, currentUser.getBalance());
            int remMins = (Integer) session.getAttribute("remainingMinutes");
            if (currentUser.getBalance().compareTo(BigDecimal.ZERO) <= 0) {
                response.getWriter().write("{\"status\":\"EXPIRED\"}");
            } else {
                response.getWriter().write("{\"status\":\"OK\",\"balance\":" + currentUser.getBalance() + ",\"remainingMinutes\":" + remMins + "}");
            }
            return;
        }

        if (!initSessionData(session, userDAO)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        DecimalFormat df = new DecimalFormat("#,###");

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            userDAO.updateProfile(currentUser.getUserId(), fullName, phone, email);
            currentUser.setFullName(fullName);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);
            session.setAttribute("currentUser", currentUser);
            request.setAttribute("message", "Cập nhật hồ sơ cá nhân thành công!");

        } else if ("topUp".equals(action)) {
            try {
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                String method = request.getParameter("method");
                String machineCode = request.getParameter("machineCode");
                String transferCode = request.getParameter("transferCode");
                if (machineCode == null || machineCode.trim().isEmpty()) {
                    machineCode = "VIP-01";
                }

                if (amount.compareTo(BigDecimal.ZERO) > 0) {
                    String methodLabel = "TRANSFER".equals(method)
                            ? ("VietQR ACB" + (transferCode != null && !transferCode.trim().isEmpty() ? " | Mã CK: " + transferCode.trim() : ""))
                            : "Tiền mặt tại máy";
                    boolean ok = userDAO.createTopUpRequest(currentUser.getUserId(), machineCode, amount, methodLabel);
                    if (ok) {
                        request.setAttribute("message", "Đã gửi yêu cầu nạp " + df.format(amount) + " VNĐ (" + methodLabel + ")! Vui lòng chờ Admin xác nhận cộng tiền.");
                    } else {
                        request.setAttribute("error", "Lỗi lưu yêu cầu nạp tiền xuống Database!");
                    }
                } else {
                    request.setAttribute("error", "Số tiền nạp phải lớn hơn 0!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Số tiền không hợp lệ!");
            }

        } else if ("orderCart".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            String paymentMethod = request.getParameter("paymentMethod");
            String transferCode = request.getParameter("transferCode");
            boolean isQr = "TRANSFER".equals(paymentMethod);
            String payTag = isQr ? "CK VietQR" : "Tiền mặt";
            String[] itemIds = request.getParameterValues("itemIds");
            String[] quantities = request.getParameterValues("quantities");

            if (itemIds != null && quantities != null) {
                List<MenuItem> menuItems = (List<MenuItem>) session.getAttribute("menuItems");
                List<ServiceOrder> orders = (List<ServiceOrder>) session.getAttribute("orderHistory");
                BigDecimal grandTotal = BigDecimal.ZERO;
                int totalItems = 0;
                StringBuilder qrSummary = new StringBuilder();

                for (int i = 0; i < itemIds.length; i++) {
                    int id = Integer.parseInt(itemIds[i]);
                    int qty = Integer.parseInt(quantities[i]);
                    if (qty <= 0) continue;

                    MenuItem found = null;
                    if (menuItems != null) {
                        for (MenuItem m : menuItems) {
                            if (m.getItemId() == id) {
                                found = m;
                                break;
                            }
                        }
                    }
                    if (found != null) {
                        BigDecimal subTotal = found.getPrice().multiply(new BigDecimal(qty));
                        grandTotal = grandTotal.add(subTotal);
                        totalItems += qty;

                        if (isQr) {
                            if (qrSummary.length() > 0) qrSummary.append(", ");
                            qrSummary.append(qty).append("x ").append(found.getItemName());
                            orders.add(0, new ServiceOrder(orders.size() + 1, machineCode, found.getItemName(), qty, payTag, subTotal, "Chờ Admin duyệt QR"));
                        } else {
                            userDAO.createServiceOrderWithStatus(currentUser.getUserId(), machineCode,
                                    found.getItemName() + " [Tiền mặt]", qty, "FNB", subTotal, "SERVING");
                            orders.add(0, new ServiceOrder(orders.size() + 1, machineCode, found.getItemName(), qty, payTag, subTotal, "Đang chuẩn bị"));
                        }
                    }
                }

                // Với đơn QR: gom 1 bản ghi tổng tiền ở trạng thái PENDING để Admin đối chiếu 1-1 với chuyển khoản
                if (isQr && totalItems > 0) {
                    String qrItemLabel = qrSummary.toString() + " [VietQR"
                            + (transferCode != null && !transferCode.trim().isEmpty() ? " | " + transferCode.trim() : "") + "]";
                    userDAO.createServiceOrderWithStatus(currentUser.getUserId(), machineCode,
                            qrItemLabel, totalItems, "FNB", grandTotal, "PENDING");
                    request.setAttribute("message", "Đã gửi đơn " + totalItems + " món (Tổng: " + df.format(grandTotal) + " VNĐ - VietQR)! Chờ Admin duyệt chuyển khoản để quầy ra món.");
                } else if (totalItems > 0) {
                    request.setAttribute("message", "Đặt thành công " + totalItems + " món tới máy " + machineCode + " (Tổng: " + df.format(grandTotal) + " VNĐ)! Nhân viên đang mang ra.");
                }

                session.setAttribute("orderHistory", orders);
                request.setAttribute("openModalOnLoad", "modalService");
            }

        } else if ("rentGearCart".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            String paymentMethod = request.getParameter("paymentMethod");
            String transferCode = request.getParameter("transferCode");
            boolean isQr = "TRANSFER".equals(paymentMethod);
            String payTag = isQr ? "CK VietQR" : "Tiền mặt";
            String[] gearIds = request.getParameterValues("gearIds");
            String[] gearHours = request.getParameterValues("gearHours");

            if (gearIds != null && gearHours != null) {
                List<String[]> gearList = (List<String[]>) session.getAttribute("gearList");
                List<String> gearHistory = (List<String>) session.getAttribute("gearHistory");
                BigDecimal grandTotal = BigDecimal.ZERO;
                int totalGears = 0;
                StringBuilder qrSummary = new StringBuilder();

                for (int i = 0; i < gearIds.length; i++) {
                    String gId = gearIds[i];
                    int hrs = Integer.parseInt(gearHours[i]);
                    if (hrs <= 0) continue;

                    for (String[] g : gearList) {
                        if (g[0].equals(gId)) {
                            String gName = g[1];
                            BigDecimal price = new BigDecimal(g[2]);
                            BigDecimal subTotal = price.multiply(new BigDecimal(hrs));
                            grandTotal = grandTotal.add(subTotal);
                            totalGears++;

                            if (isQr) {
                                if (qrSummary.length() > 0) qrSummary.append(", ");
                                qrSummary.append(gName).append(" (").append(hrs).append("h)");
                                gearHistory.add(0, gName + " (" + hrs + " giờ) tại máy " + machineCode + " - " + df.format(subTotal) + " VNĐ [Chờ Admin duyệt QR]");
                            } else {
                                userDAO.createServiceOrderWithStatus(currentUser.getUserId(), machineCode,
                                        "Thuê Gear: " + gName + " (" + hrs + "h) [Tiền mặt]", 1, "GEAR", subTotal, "SERVING");
                                gearHistory.add(0, gName + " (" + hrs + " giờ) tại máy " + machineCode + " - " + df.format(subTotal) + " VNĐ [Tiền mặt]");
                            }
                            break;
                        }
                    }
                }

                if (isQr && totalGears > 0) {
                    String qrGearLabel = "Thuê Gear: " + qrSummary.toString() + " [VietQR"
                            + (transferCode != null && !transferCode.trim().isEmpty() ? " | " + transferCode.trim() : "") + "]";
                    userDAO.createServiceOrderWithStatus(currentUser.getUserId(), machineCode,
                            qrGearLabel, totalGears, "GEAR", grandTotal, "PENDING");
                    request.setAttribute("message", "Đã gửi đơn thuê Gear (Tổng: " + df.format(grandTotal) + " VNĐ - VietQR)! Chờ Admin duyệt chuyển khoản.");
                } else if (totalGears > 0) {
                    request.setAttribute("message", "Thuê thành công Gaming Gear tại máy " + machineCode + " (Tổng: " + df.format(grandTotal) + " VNĐ)! Kỹ thuật viên IT đang mang thiết bị ra.");
                }

                session.setAttribute("gearHistory", gearHistory);
                request.setAttribute("openModalOnLoad", "modalGear");
            }

        } else if ("sendMessage".equals(action)) {
            String msgContent = request.getParameter("msgContent");
            String machineCode = request.getParameter("machineCode");
            if (machineCode == null || machineCode.trim().isEmpty()) {
                machineCode = "VIP-01";
            }
            if (msgContent != null && !msgContent.trim().isEmpty()) {
                TinNhanStore.addMessage(currentUser.getFullName(), machineCode, "Yêu cầu từ máy trạm", msgContent.trim());

                List<String[]> chats = (List<String[]>) session.getAttribute("chatHistory");
                String timeNow = new SimpleDateFormat("HH:mm").format(new Date());
                chats.add(new String[]{currentUser.getFullName(), msgContent.trim(), timeNow});
                chats.add(new String[]{"Nhân viên Quầy", "Quầy Admin đã nhận được tin nhắn: \"" + msgContent.trim() + "\". Nhân viên sẽ hỗ trợ bạn ngay!", timeNow});
                session.setAttribute("chatHistory", chats);
                request.setAttribute("openModalOnLoad", "modalChat");
            }
        }

        // Làm mới lại danh sách giao dịch gần nhất ngay sau POST
        session.setAttribute("recentTransactions", userDAO.getUserRecentTransactions(currentUser.getUserId(), 10));
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}