package com.redzone.controller;

import com.redzone.dao.DBConnection;
import com.redzone.dao.TaiKhoanDAO;
import com.redzone.dao.UserDAO;
import com.redzone.model.TaiKhoan;
import com.redzone.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/action"})
public class AdminUserController extends HttpServlet {
    private TaiKhoanDAO dao = new TaiKhoanDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            if ("approveTopUp".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                int userId = Integer.parseInt(request.getParameter("userId"));
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                userDAO.approveTopUpRequest(orderId, userId, amount);
            } else if ("rejectTopUp".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE ServiceOrders SET status = 'REJECTED' WHERE order_id = ?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                int id = Integer.parseInt(request.getParameter("id"));
                if ("lock".equals(action)) {
                    dao.updateTrangThai(id, 0);
                } else if ("unlock".equals(action) || "approve".equals(action)) {
                    dao.updateTrangThai(id, 1);
                } else if ("delete".equals(action)) {
                    dao.deleteUser(id);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // 1. Lấy danh sách toàn bộ tài khoản
        List<TaiKhoan> list = dao.getAllUsers();
        request.setAttribute("userList", list);

        // 2. Lấy danh sách yêu cầu nạp tiền từ Member đang chờ duyệt (khớp đúng cột Username, HoTen)
        List pendingTopUps = new ArrayList();
        String sqlTopUp = "SELECT s.order_id, s.user_id, s.machine_code, s.item_name, s.final_amount, s.status, s.created_at, " +
                "t.Username, t.HoTen " +
                "FROM ServiceOrders s LEFT JOIN TAI_KHOAN t ON s.user_id = t.MaTK " +
                "WHERE UPPER(ISNULL(s.promo_code, '')) = 'TOPUP' " +
                "AND UPPER(ISNULL(s.status, '')) = 'PENDING' " +
                "ORDER BY s.order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlTopUp);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map row = new HashMap();
                row.put("orderId", rs.getInt("order_id"));
                row.put("userId", rs.getInt("user_id"));
                String uName = rs.getString("Username") != null ? rs.getString("Username") : ("ID #" + rs.getInt("user_id"));
                String fName = rs.getString("HoTen") != null ? rs.getString("HoTen") : uName;
                row.put("username", uName);
                row.put("fullName", fName);
                row.put("machineCode", rs.getString("machine_code"));
                row.put("itemName", rs.getString("item_name"));
                row.put("amount", rs.getBigDecimal("final_amount"));
                row.put("createdAt", rs.getTimestamp("created_at"));
                pendingTopUps.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("pendingTopUps", pendingTopUps);

        request.getRequestDispatcher("/views/admin/user_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");

        if ("add".equals(type)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            double balance = Double.parseDouble(request.getParameter("balance"));

            String hashedPass = PasswordUtil.hashSHA256(pass);
            TaiKhoan tk = new TaiKhoan(0, user, hashedPass, fullName, role, 1, balance);
            dao.addUser(tk);
        } else if ("update".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            double balance = Double.parseDouble(request.getParameter("balance"));
            dao.updateUser(id, fullName, role, balance);
        } else if ("topUpDirect".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            double addAmount = Double.parseDouble(request.getParameter("addAmount"));
            if (addAmount > 0) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE TAI_KHOAN SET SoDuVi = ISNULL(SoDuVi, 0) + ? WHERE MaTK = ?")) {
                    ps.setDouble(1, addAmount);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else if ("reset".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String newPass = request.getParameter("newPassword");

            String hashedNewPass = PasswordUtil.hashSHA256(newPass);
            dao.resetPassword(id, hashedNewPass);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}