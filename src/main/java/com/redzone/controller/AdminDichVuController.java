package com.redzone.controller;

import com.redzone.dao.DBConnection;
import com.redzone.dao.DichVuDAO;
import com.redzone.model.DichVu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/dich-vu", "/admin/dich-vu/action"})
public class AdminDichVuController extends HttpServlet {
    private DichVuDAO dao = new DichVuDAO();

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Xử lý hoàn tất đơn F&B / Thuê Gear
        String orderAction = request.getParameter("orderAction");
        if ("complete".equals(orderAction)) {
            String orderId = request.getParameter("orderId");
            if (orderId != null && !orderId.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE ServiceOrders SET status = 'COMPLETED' WHERE order_id = ?")) {
                    ps.setInt(1, Integer.parseInt(orderId.trim()));
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=orders");
            return;
        }

        // 2. Xử lý xóa món hoặc nạp nhanh Gear
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                dao.deleteDichVu(Integer.parseInt(idStr.trim()));
            }
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
            return;
        } else if ("seedGear".equals(action)) {
            dao.addDichVu(new DichVu(0, "Chuột Logitech G Pro X Superlight", 15000, 10, "GEAR", "https://images.unsplash.com/photo-1527814050087-3793815479db?w=400&q=80"));
            dao.addDichVu(new DichVu(0, "Chuột Razer DeathAdder V3 Pro", 15000, 8, "GEAR", "https://images.unsplash.com/photo-1527814050087-3793815479db?w=400&q=80"));
            dao.addDichVu(new DichVu(0, "Bàn phím cơ Corsair K70 RGB", 15000, 10, "GEAR", "https://images.unsplash.com/photo-1595225476474-87563907a212?w=400&q=80"));
            dao.addDichVu(new DichVu(0, "Bàn phím cơ Wooting 60HE (Rapid Trigger)", 25000, 5, "GEAR", "https://images.unsplash.com/photo-1595225476474-87563907a212?w=400&q=80"));
            dao.addDichVu(new DichVu(0, "Tai nghe HyperX Cloud II Wireless", 10000, 12, "GEAR", "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80"));
            dao.addDichVu(new DichVu(0, "Combo Chuột G Pro X + Phím Wooting 60HE", 35000, 5, "GEAR", "https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=400&q=80"));
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=gear");
            return;
        }

        // 3. Phân loại Menu F&B, Combo, Gear
        List<DichVu> allList = dao.getAllDichVu();
        List<DichVu> monLeList = new ArrayList<>();
        List<DichVu> comboList = new ArrayList<>();
        List<DichVu> gearList = new ArrayList<>();

        for (DichVu dv : allList) {
            if ("COMBO".equalsIgnoreCase(dv.getDanhMuc())) {
                comboList.add(dv);
            } else if ("GEAR".equalsIgnoreCase(dv.getDanhMuc())) {
                gearList.add(dv);
            } else {
                monLeList.add(dv);
            }
        }

        // 4. Lấy danh sách Đơn Khách Đặt (F&B + Thuê Gear) từ ServiceOrders (khớp đúng cột Username, HoTen)
        List customerOrders = new ArrayList();
        int servingCount = 0;
        String sqlOrders = "SELECT s.order_id, s.machine_code, s.item_name, s.quantity, s.promo_code, s.final_amount, s.status, " +
                "t.HoTen, t.Username " +
                "FROM ServiceOrders s LEFT JOIN TAI_KHOAN t ON s.user_id = t.MaTK " +
                "WHERE UPPER(ISNULL(s.promo_code, '')) <> 'TOPUP' " +
                "AND ISNULL(s.item_name, '') NOT LIKE N'%Nạp%' " +
                "ORDER BY s.order_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOrders);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map row = new HashMap();
                row.put("orderId", rs.getInt("order_id"));
                row.put("machineCode", rs.getString("machine_code"));
                row.put("itemName", rs.getString("item_name"));
                row.put("quantity", rs.getInt("quantity"));
                row.put("type", rs.getString("promo_code"));
                row.put("amount", rs.getBigDecimal("final_amount"));
                String st = rs.getString("status");
                row.put("status", st);
                String cName = rs.getString("HoTen") != null ? rs.getString("HoTen")
                        : (rs.getString("Username") != null ? rs.getString("Username") : ("Hội viên #" + rs.getInt("order_id")));
                row.put("customerName", cName);
                if (!"COMPLETED".equalsIgnoreCase(st)) {
                    servingCount++;
                }
                customerOrders.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("dichVuList", monLeList);
        request.setAttribute("comboList", comboList);
        request.setAttribute("gearList", gearList);
        request.setAttribute("customerOrders", customerOrders);
        request.setAttribute("servingCount", servingCount);
        request.getRequestDispatcher("/views/admin/dich_vu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");
        String danhMuc = request.getParameter("danhMuc");
        String hinhAnh = request.getParameter("hinhAnh");

        if ("add".equals(type)) {
            String tenMon = request.getParameter("tenMon");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));

            DichVu dv = new DichVu(0, tenMon, gia, soLuongTon, danhMuc, hinhAnh);
            dao.addDichVu(dv);
        } else if ("update".equals(type)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                String tenMon = request.getParameter("tenMon");
                double gia = Double.parseDouble(request.getParameter("gia"));
                int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));

                DichVu dv = new DichVu(id, tenMon, gia, soLuongTon, danhMuc, hinhAnh);
                dao.updateDichVu(dv);
            }
        }

        if ("GEAR".equalsIgnoreCase(danhMuc)) {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=gear");
        } else if ("COMBO".equalsIgnoreCase(danhMuc)) {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=combo");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
        }
    }
}