package com.redzone.controller;

import com.redzone.dao.UserDAO;
import com.redzone.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
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

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getUserId() != userLog.getId()) {
            currentUser = userDAO.getUserById(userLog.getId());
            if (currentUser == null) {
                currentUser = new User();
                currentUser.setUserId(userLog.getId());
                currentUser.setUsername(userLog.getUsername());
                currentUser.setFullName(userLog.getFullName());
                currentUser.setBalance(BigDecimal.valueOf(userLog.getBalance()));
                currentUser.setStatus(userLog.getTrangThai() == 1 ? "Hoạt động"
                        : (userLog.getTrangThai() == 0 ? "Khóa" : "Chờ duyệt"));
            }
            if (currentUser.getBalance() == null) {
                currentUser.setBalance(BigDecimal.ZERO);
            }
            session.setAttribute("currentUser", currentUser);
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
        gameList.add(new String[]{"Dota 2", "MOBA • Valve", "https://images.unsplash.com/photo-1560253023-3ec5d502959f?w=400&q=80", "ESPORTS", "MOBA"});
        gameList.add(new String[]{"VALORANT", "FPS • Riot Games", "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=400&q=80", "HOT", "FPS"});
        gameList.add(new String[]{"Counter-Strike 2", "FPS • Valve", "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=400&q=80", "ESPORTS", "FPS"});
        gameList.add(new String[]{"CrossFire (Đột Kích)", "FPS • Smilegate", "https://images.unsplash.com/photo-1593305841991-05c297ba4575?w=400&q=80", "CLASSIC", "FPS"});
        gameList.add(new String[]{"PUBG: Battlegrounds", "Battle Royale • Krafton", "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=400&q=80", "SURVIVAL", "BATTLE ROYALE"});
        gameList.add(new String[]{"Apex Legends", "Battle Royale • Respawn", "https://images.unsplash.com/photo-1605901309584-818e25960a8f?w=400&q=80", "ACTION", "BATTLE ROYALE"});
        gameList.add(new String[]{"FC Online (FIFA)", "Sports • EA", "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=400&q=80", "POPULAR", "SPORTS"});
        gameList.add(new String[]{"Genshin Impact", "RPG • HoYoverse", "https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=400&q=80", "RPG", "RPG"});
        gameList.add(new String[]{"Black Myth: Wukong", "RPG • Game Science", "https://images.unsplash.com/photo-1534423861386-85a16f5d13fd?w=400&q=80", "AAA", "RPG"});
        session.setAttribute("gameList", gameList);

        List<String[]> gearList = new ArrayList<>();
        gearList.add(new String[]{"1", "Chuột Logitech G Pro X Superlight 2", "15000", "CHUOT", "Siêu nhẹ 60g • Cảm biến HERO 2 32K DPI"});
        gearList.add(new String[]{"2", "Chuột Razer DeathAdder V3 Pro", "15000", "CHUOT", "Công thái học • Focus Pro 30K Optical"});
        gearList.add(new String[]{"3", "Chuột Razer Viper V3 Pro White", "18000", "CHUOT", "Chuẩn Esport FPS • Polling Rate 8000Hz"});
        gearList.add(new String[]{"4", "Chuột Zowie EC2-CW Wireless", "15000", "CHUOT", "Chuyên trị CS2 / VALORANT • Dock sạc rời"});
        gearList.add(new String[]{"5", "Chuột Lamzu Atlantis OG V2 4K", "12000", "CHUOT", "Siêu nhẹ 55g • Switch Huano Blue Shell"});

        gearList.add(new String[]{"6", "Bàn phím Wooting 60HE (Rapid Trigger)", "25000", "BAN_PHIM", "Switch từ tính Lekker • Rapid Trigger 0.1mm"});
        gearList.add(new String[]{"7", "Bàn phím Corsair K70 MAX RGB", "18000", "BAN_PHIM", "Switch MGX chỉnh điểm nhận phím • Kê tay êm"});
        gearList.add(new String[]{"8", "Bàn phím Razer Huntsman V3 Pro TKL", "22000", "BAN_PHIM", "Analog Optical Gen-2 • Chuẩn thi đấu"});
        gearList.add(new String[]{"9", "Bàn phím Logitech G Pro X TKL Lightspeed", "18000", "BAN_PHIM", "Không dây độ trễ thấp • Tactile Switch"});
        gearList.add(new String[]{"10", "Bàn phím Keychron Q1 Pro Custom", "15000", "BAN_PHIM", "Nhôm nguyên khối • Gõ đầm êm tay"});

        gearList.add(new String[]{"11", "Combo Pro FPS (G Pro X 2 + Wooting 60HE)", "35000", "COMBO", "Tiết kiệm 5.000đ/h • Tối ưu bắn súng"});
        gearList.add(new String[]{"12", "Combo Razer Esport (Viper V3 Pro + Huntsman V3)", "35000", "COMBO", "Full hệ sinh thái Razer Synapse"});
        gearList.add(new String[]{"13", "Combo Streamer (DeathAdder V3 + K70 MAX)", "28000", "COMBO", "Mượt mà mọi tựa game MOBA & AAA"});
        session.setAttribute("gearList", gearList);

        session.setAttribute("menuItems", userDAO.getMenuItems());
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

        if (!initSessionData(session, userDAO)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");

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
                String methodLabel = "TRANSFER".equals(method) ? "Chuyển khoản QR" : "Tiền mặt tại máy";

                if (amount.compareTo(BigDecimal.ZERO) > 0) {
                    userDAO.createTopUpRequest(currentUser.getUserId(), "VIP-01", amount, methodLabel);
                    request.setAttribute("message", "Đã gửi yêu cầu nạp " + amount + " VNĐ (" + methodLabel + ") sang Admin! Vui lòng chờ Admin xác nhận để cộng giờ chơi.");
                } else {
                    request.setAttribute("error", "Số tiền nạp phải lớn hơn 0!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Số tiền không hợp lệ!");
            }

        } else if ("rentGearCart".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            String paymentMethod = request.getParameter("paymentMethod");
            String methodLabel = "TRANSFER".equals(paymentMethod) ? "Chuyển khoản QR" : "Tiền mặt tại máy";
            String[] gearIds = request.getParameterValues("gearIds");
            String[] gearHours = request.getParameterValues("gearHours");

            if (gearIds != null && gearHours != null && gearIds.length == gearHours.length) {
                List<String[]> gearList = (List<String[]>) session.getAttribute("gearList");
                List<String> gearHistory = (List<String>) session.getAttribute("gearHistory");
                BigDecimal grandTotal = BigDecimal.ZERO;
                StringBuilder summary = new StringBuilder();
                int count = 0;

                for (int i = 0; i < gearIds.length; i++) {
                    String gId = gearIds[i];
                    int hrs = Integer.parseInt(gearHours[i]);
                    if (hrs <= 0) continue;

                    for (String[] g : gearList) {
                        if (g[0].equals(gId)) {
                            BigDecimal subTotal = new BigDecimal(g[2]).multiply(new BigDecimal(hrs));
                            grandTotal = grandTotal.add(subTotal);

                            userDAO.createServiceOrder(currentUser.getUserId(), machineCode, "Thuê: " + g[1] + " (" + hrs + "h) [" + methodLabel + "]", 1, "Không áp dụng", subTotal);
                            gearHistory.add(0, g[1] + " (" + hrs + " giờ) tại máy " + machineCode + " - " + subTotal + " VNĐ (" + methodLabel + ")");

                            if (count > 0) summary.append(", ");
                            summary.append(g[1]).append(" (").append(hrs).append("h)");
                            count++;
                            break;
                        }
                    }
                }

                if (count > 0) {
                    session.setAttribute("gearHistory", gearHistory);
                    request.setAttribute("message", "Đặt hàng thành công! Thuê: " + summary + " tại máy " + machineCode + " (" + methodLabel + " - " + grandTotal + " VNĐ).");
                }
            } else {
                request.setAttribute("error", "Giỏ thuê Gear đang trống!");
                request.setAttribute("openModalOnLoad", "modalGear");
            }

        } else if ("sendMessage".equals(action)) {
            String msgContent = request.getParameter("msgContent");
            if (msgContent != null && !msgContent.trim().isEmpty()) {
                List<String[]> chats = (List<String[]>) session.getAttribute("chatHistory");
                String timeNow = new SimpleDateFormat("HH:mm").format(new Date());
                chats.add(new String[]{currentUser.getFullName(), msgContent.trim(), timeNow});
                chats.add(new String[]{"Nhân viên Quầy", "Quầy đã nhận được tin nhắn: \"" + msgContent.trim() + "\". Nhân viên sẽ hỗ trợ bạn ngay!", timeNow});
                session.setAttribute("chatHistory", chats);
                String may = request.getParameter("machineCode");
                if (may == null || may.trim().isEmpty()) may = "Máy Member (" + currentUser.getUsername() + ")";
                com.redzone.util.TinNhanStore.addMessage(currentUser.getFullName(), may, "Tin nhắn từ Member", msgContent.trim());
                request.setAttribute("openModalOnLoad", "modalChat");
            }

        } else if ("orderCart".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            String paymentMethod = request.getParameter("paymentMethod");
            String methodLabel = "TRANSFER".equals(paymentMethod) ? "Chuyển khoản QR" : "Tiền mặt tại máy";
            String[] itemIds = request.getParameterValues("itemIds");
            String[] quantities = request.getParameterValues("quantities");

            if (itemIds != null && quantities != null && itemIds.length == quantities.length) {
                List<MenuItem> allMenu = userDAO.getMenuItems();
                List<ServiceOrder> orders = (List<ServiceOrder>) session.getAttribute("orderHistory");
                BigDecimal grandTotal = BigDecimal.ZERO;
                StringBuilder summary = new StringBuilder();
                int count = 0;

                for (int i = 0; i < itemIds.length; i++) {
                    int id = Integer.parseInt(itemIds[i]);
                    int qty = Integer.parseInt(quantities[i]);
                    if (qty <= 0) continue;

                    for (MenuItem m : allMenu) {
                        if (m.getItemId() == id) {
                            BigDecimal subTotal = m.getPrice().multiply(new BigDecimal(qty));
                            grandTotal = grandTotal.add(subTotal);

                            userDAO.createServiceOrder(currentUser.getUserId(), machineCode, m.getItemName() + " [" + methodLabel + "]", qty, "Không áp dụng", subTotal);
                            orders.add(0, new ServiceOrder(orders.size() + 1, machineCode, m.getItemName(), qty, "Không áp dụng", subTotal, "Đang phục vụ (" + methodLabel + ")"));

                            if (count > 0) summary.append(", ");
                            summary.append(qty).append("x ").append(m.getItemName());
                            count++;
                            break;
                        }
                    }
                }

                if (count > 0) {
                    session.setAttribute("orderHistory", orders);
                    request.setAttribute("message", "Đặt hàng thành công! Đã gửi đơn: " + summary + " tới máy " + machineCode + " (" + methodLabel + " - " + grandTotal + " VNĐ).");
                }
            } else {
                request.setAttribute("error", "Giỏ hàng đang trống, vui lòng chọn món trước khi xác nhận!");
                request.setAttribute("openModalOnLoad", "modalService");
            }

        } else if ("tickPlayTime".equals(action)) {
            BigDecimal costPerMinute = new BigDecimal("167");
            BigDecimal currentBal = currentUser.getBalance();

            response.setContentType("application/json;charset=UTF-8");
            if (currentBal != null && currentBal.compareTo(costPerMinute) >= 0) {
                userDAO.deductPlayTimeBalance(currentUser.getUserId(), costPerMinute);
                BigDecimal newBal = currentBal.subtract(costPerMinute);
                currentUser.setBalance(newBal);
                session.setAttribute("currentUser", currentUser);
                updateRemainingTime(session, newBal);

                int remMins = (Integer) session.getAttribute("remainingMinutes");
                response.getWriter().write("{\"status\":\"OK\", \"balance\":" + newBal.longValue() + ", \"remainingMinutes\":" + remMins + "}");
            } else {
                userDAO.deductPlayTimeBalance(currentUser.getUserId(), currentBal != null ? currentBal : BigDecimal.ZERO);
                currentUser.setBalance(BigDecimal.ZERO);
                session.invalidate();
                response.getWriter().write("{\"status\":\"EXPIRED\"}");
            }
            return;
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}