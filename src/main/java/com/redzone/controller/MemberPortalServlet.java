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
        gameList.add(new String[]{"League of Legends", "MOBA • Riot Games", "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400&q=80", "HOT"});
        gameList.add(new String[]{"VALORANT", "FPS • Riot Games", "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=400&q=80", "HOT"});
        gameList.add(new String[]{"Counter-Strike 2", "FPS • Valve", "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=400&q=80", "ESPORTS"});
        gameList.add(new String[]{"FC Online (FIFA)", "Sports • EA", "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=400&q=80", "POPULAR"});
        gameList.add(new String[]{"PUBG: Battlegrounds", "Battle Royale • Krafton", "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=400&q=80", "FPS"});
        gameList.add(new String[]{"Genshin Impact", "RPG • HoYoverse", "https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=400&q=80", "RPG"});
        session.setAttribute("gameList", gameList);

        List<String[]> gearList = new ArrayList<>();
        gearList.add(new String[]{"1", "Chuột Logitech G Pro X Superlight", "15000"});
        gearList.add(new String[]{"2", "Chuột Razer DeathAdder V3 Pro", "15000"});
        gearList.add(new String[]{"3", "Bàn phím cơ Corsair K70 RGB", "15000"});
        gearList.add(new String[]{"4", "Bàn phím cơ Wooting 60HE (Rapid Trigger)", "25000"});
        gearList.add(new String[]{"5", "Tai nghe HyperX Cloud II Wireless", "10000"});
        gearList.add(new String[]{"6", "Combo Chuột G Pro X + Phím Wooting 60HE", "35000"});
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

                if (amount.compareTo(BigDecimal.ZERO) > 0) {
                    if ("TRANSFER".equals(method)) {
                        userDAO.topUpBalance(currentUser.getUserId(), amount);
                        currentUser.setBalance(currentUser.getBalance().add(amount));
                        session.setAttribute("currentUser", currentUser);
                        updateRemainingTime(session, currentUser.getBalance());
                        request.setAttribute("message", "Nạp thành công " + amount + " VNĐ qua chuyển khoản tài khoản ngân hàng!");
                    } else {
                        request.setAttribute("message", "Đã gửi yêu cầu nạp " + amount + " VNĐ tiền mặt! Nhân viên sẽ tới máy của bạn trong giây lát.");
                    }
                } else {
                    request.setAttribute("error", "Số tiền nạp phải lớn hơn 0!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Số tiền không hợp lệ!");
            }

        } else if ("rentGear".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            String gearId = request.getParameter("gearId");
            int hours = Integer.parseInt(request.getParameter("hours"));

            String gearName = "";
            BigDecimal pricePerHour = BigDecimal.ZERO;
            List<String[]> gearList = (List<String[]>) session.getAttribute("gearList");
            for (String[] g : gearList) {
                if (g[0].equals(gearId)) {
                    gearName = g[1];
                    pricePerHour = new BigDecimal(g[2]);
                    break;
                }
            }

            if (!gearName.isEmpty() && hours > 0) {
                BigDecimal total = pricePerHour.multiply(new BigDecimal(hours));
                if (currentUser.getBalance().compareTo(total) >= 0) {
                    userDAO.deductBalance(currentUser.getUserId(), total);
                    userDAO.createServiceOrder(currentUser.getUserId(), machineCode, "Thuê: " + gearName + " (" + hours + "h)", 1, "Không áp dụng", total);

                    currentUser.setBalance(currentUser.getBalance().subtract(total));
                    session.setAttribute("currentUser", currentUser);
                    updateRemainingTime(session, currentUser.getBalance());

                    List<String> gearHistory = (List<String>) session.getAttribute("gearHistory");
                    gearHistory.add(0, gearName + " (" + hours + " giờ) tại máy " + machineCode + " - " + total + " VNĐ");
                    session.setAttribute("gearHistory", gearHistory);

                    request.setAttribute("message", "Thuê thành công " + gearName + " trong " + hours + " giờ (Tổng: " + total + " VNĐ)! Nhân viên đang mang tới máy " + machineCode + ".");
                } else {
                    request.setAttribute("error", "Số dư (" + currentUser.getBalance() + " VNĐ) không đủ để thuê thiết bị (" + total + " VNĐ)!");
                }
            }

        } else if ("sendMessage".equals(action)) {
            String msgContent = request.getParameter("msgContent");
            if (msgContent != null && !msgContent.trim().isEmpty()) {
                List<String[]> chats = (List<String[]>) session.getAttribute("chatHistory");
                String timeNow = new SimpleDateFormat("HH:mm").format(new Date());
                chats.add(new String[]{currentUser.getFullName(), msgContent.trim(), timeNow});
                chats.add(new String[]{"Nhân viên Quầy", "Quầy đã nhận được tin nhắn: \"" + msgContent.trim() + "\". Nhân viên sẽ hỗ trợ bạn ngay!", timeNow});
                session.setAttribute("chatHistory", chats);
                request.setAttribute("openModalOnLoad", "modalChat");
            }

        } else if ("orderService".equals(action)) {
            String machineCode = request.getParameter("machineCode");
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            MenuItem selectedItem = null;
            for (MenuItem m : userDAO.getMenuItems()) {
                if (m.getItemId() == itemId) {
                    selectedItem = m;
                    break;
                }
            }

            if (selectedItem != null && quantity > 0) {
                BigDecimal total = selectedItem.getPrice().multiply(new BigDecimal(quantity));

                if (currentUser.getBalance().compareTo(total) >= 0) {
                    userDAO.deductBalance(currentUser.getUserId(), total);
                    userDAO.createServiceOrder(currentUser.getUserId(), machineCode, selectedItem.getItemName(), quantity, "Không áp dụng", total);

                    currentUser.setBalance(currentUser.getBalance().subtract(total));
                    session.setAttribute("currentUser", currentUser);
                    updateRemainingTime(session, currentUser.getBalance());

                    List<ServiceOrder> orders = (List<ServiceOrder>) session.getAttribute("orderHistory");
                    orders.add(0, new ServiceOrder(orders.size() + 1, machineCode, selectedItem.getItemName(), quantity, "Không áp dụng", total, "Đang phục vụ tại máy"));
                    session.setAttribute("orderHistory", orders);

                    request.setAttribute("message", "Đặt thành công " + quantity + "x " + selectedItem.getItemName() + " tới máy " + machineCode + " (Tổng: " + total + " VNĐ)!");
                } else {
                    request.setAttribute("error", "Số dư (" + currentUser.getBalance() + " VNĐ) không đủ để thanh toán " + total + " VNĐ!");
                }
            }
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}