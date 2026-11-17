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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "MemberPortalServlet", urlPatterns = {"/profile", "/member"})
public class MemberPortalServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private void initSessionData(HttpSession session, UserDAO userDAO, String keyword, String roomFilter) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            currentUser = new User();
            currentUser.setUserId(1);
            currentUser.setUsername("member01");
            currentUser.setFullName("Nguyễn Lê Phú Hào");
            currentUser.setPhone("0901234567");
            currentUser.setEmail("member@redzone.vn");
            currentUser.setBalance(new BigDecimal("100000"));
            currentUser.setStatus("ACTIVE");
            session.setAttribute("currentUser", currentUser);
        }

        if (session.getAttribute("bookingHistory") == null) {
            session.setAttribute("bookingHistory", new ArrayList<Booking>());
        }
        if (session.getAttribute("orderHistory") == null) {
            session.setAttribute("orderHistory", new ArrayList<ServiceOrder>());
        }

        session.setAttribute("computers", userDAO.searchComputers(keyword, roomFilter));
        session.setAttribute("menuItems", userDAO.getMenuItems());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        UserDAO userDAO = new UserDAO();

        String keyword = request.getParameter("keyword");
        String roomFilter = request.getParameter("roomFilter");
        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.isEmpty()) {
            activeTab = (keyword != null || roomFilter != null) ? "booking" : "profile";
        }

        initSessionData(session, userDAO, keyword, roomFilter);
        request.setAttribute("activeTab", activeTab);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("roomFilter", roomFilter != null ? roomFilter : "ALL");

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        UserDAO userDAO = new UserDAO();
        initSessionData(session, userDAO, null, "ALL");

        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");
        String activeTab = "profile";

        if ("updateProfile".equals(action)) {
            // UC-04.4: Cập nhật hồ sơ tài khoản cá nhân
            activeTab = "profile";
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            userDAO.updateProfile(currentUser.getUserId(), fullName, phone, email);
            currentUser.setFullName(fullName);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);
            session.setAttribute("currentUser", currentUser);
            request.setAttribute("message", "[UC-04.4] Cập nhật hồ sơ cá nhân thành công!");

        } else if ("topUp".equals(action)) {
            // UC-09 & UC-09.1 & UC-10.1: Nạp tiền & cập nhật số dư
            activeTab = "profile";
            try {
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                String method = request.getParameter("method");
                if (amount.compareTo(BigDecimal.ZERO) > 0) {
                    userDAO.topUpBalance(currentUser.getUserId(), amount);
                    currentUser.setBalance(currentUser.getBalance().add(amount));
                    session.setAttribute("currentUser", currentUser);
                    request.setAttribute("message", "[UC-09] Nạp thành công " + amount + " VNĐ qua cổng " + method + "!");
                } else {
                    request.setAttribute("error", "Số tiền nạp phải lớn hơn 0!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Số tiền không hợp lệ!");
            }

        } else if ("bookMachine".equals(action)) {
            // UC-08 (UC-08.1 & UC-08.2): Đặt trước phòng game / máy trạm
            activeTab = "booking";
            String machineCode = request.getParameter("machineCode");
            String roomName = request.getParameter("roomName");
            String timeSlot = request.getParameter("timeSlot");
            int hours = Integer.parseInt(request.getParameter("hours"));

            userDAO.createBooking(currentUser.getUserId(), machineCode, roomName, timeSlot, hours);
            List<Booking> bookings = (List<Booking>) session.getAttribute("bookingHistory");
            bookings.add(0, new Booking(bookings.size() + 1, currentUser.getUserId(), machineCode, roomName, timeSlot, hours, "Đang chờ duyệt (UC-08.3)"));
            session.setAttribute("bookingHistory", bookings);

            request.setAttribute("message", "[UC-08] Đã gửi yêu cầu đặt trước máy " + machineCode + " (" + roomName + ") lúc " + timeSlot + " trong " + hours + " giờ!");

        } else if ("orderService".equals(action)) {
            // UC-12 & UC-13.1: Gọi món ăn/nước uống tại máy & Áp dụng khuyến mãi/combo
            activeTab = "service";
            String machineCode = request.getParameter("machineCode");
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String promoCode = request.getParameter("promoCode");

            MenuItem selectedItem = null;
            for (MenuItem m : userDAO.getMenuItems()) {
                if (m.getItemId() == itemId) {
                    selectedItem = m;
                    break;
                }
            }

            if (selectedItem != null && quantity > 0) {
                BigDecimal total = selectedItem.getPrice().multiply(new BigDecimal(quantity));
                String appliedPromo = "Không áp dụng";

                // UC-13.1: Áp dụng khuyến mãi / combo
                if ("REDZONE10".equalsIgnoreCase(promoCode != null ? promoCode.trim() : "")) {
                    total = total.multiply(new BigDecimal("0.90")).setScale(0, RoundingMode.HALF_UP);
                    appliedPromo = "REDZONE10 (-10%)";
                } else if ("VIP20".equalsIgnoreCase(promoCode != null ? promoCode.trim() : "")) {
                    total = total.multiply(new BigDecimal("0.80")).setScale(0, RoundingMode.HALF_UP);
                    appliedPromo = "VIP20 (-20%)";
                }

                if (currentUser.getBalance().compareTo(total) >= 0) {
                    userDAO.deductBalance(currentUser.getUserId(), total);
                    userDAO.createServiceOrder(currentUser.getUserId(), machineCode, selectedItem.getItemName(), quantity, appliedPromo, total);

                    currentUser.setBalance(currentUser.getBalance().subtract(total));
                    session.setAttribute("currentUser", currentUser);

                    List<ServiceOrder> orders = (List<ServiceOrder>) session.getAttribute("orderHistory");
                    orders.add(0, new ServiceOrder(orders.size() + 1, machineCode, selectedItem.getItemName(), quantity, appliedPromo, total, "Đang phục vụ tại máy"));
                    session.setAttribute("orderHistory", orders);

                    request.setAttribute("message", "[UC-12] Đặt thành công " + quantity + "x " + selectedItem.getItemName() + " tới máy " + machineCode + " (Tổng thanh toán: " + total + " VNĐ)!");
                } else {
                    request.setAttribute("error", "Số dư tài khoản (" + currentUser.getBalance() + " VNĐ) không đủ để thanh toán " + total + " VNĐ. Vui lòng nạp thêm tiền!");
                }
            }
        }

        request.setAttribute("activeTab", activeTab);
        request.setAttribute("keyword", "");
        request.setAttribute("roomFilter", "ALL");
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
