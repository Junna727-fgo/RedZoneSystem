package com.redzone.controller;

import com.redzone.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/bao-cao"})
public class AdminBaoCaoController extends HttpServlet {

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double revTopUp = 0;
        double revFnb = 0;
        double revGear = 0;
        double maintenanceCost = 0;
        List transactions = new ArrayList();

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Doanh thu Nạp tiền giờ chơi đã duyệt
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ISNULL(SUM(final_amount), 0) FROM ServiceOrders WHERE promo_code = 'TOPUP' AND status = 'APPROVED'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) revTopUp = rs.getDouble(1);
            }

            // 2. Doanh thu Dịch vụ F&B
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ISNULL(SUM(final_amount), 0) FROM ServiceOrders WHERE ISNULL(promo_code, '') NOT IN ('TOPUP', 'GEAR') AND status IN ('SERVING', 'COMPLETED')");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) revFnb = rs.getDouble(1);
            }

            // 3. Doanh thu Thuê Gaming Gear
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ISNULL(SUM(final_amount), 0) FROM ServiceOrders WHERE promo_code = 'GEAR' AND status IN ('SERVING', 'COMPLETED')");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) revGear = rs.getDouble(1);
            }

            // 4. Chi phí bảo trì phần cứng từ bộ phận IT
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ISNULL(SUM(ChiPhi), 0) FROM BIEN_BAN_BAO_TRI");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) maintenanceCost = rs.getDouble(1);
            } catch (Exception ignored) {}

            // 5. Lấy lịch sử 50 giao dịch gần nhất từ ServiceOrders nối với TAI_KHOAN
            String sqlTx = "SELECT TOP 50 s.order_id, s.machine_code, s.item_name, s.quantity, s.promo_code, s.final_amount, s.status, s.created_at, " +
                    "t.HoTen, t.TenDangNhap " +
                    "FROM ServiceOrders s LEFT JOIN TAI_KHOAN t ON s.user_id = t.MaTK " +
                    "ORDER BY s.order_id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sqlTx);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map row = new HashMap();
                    row.put("orderId", rs.getInt("order_id"));
                    row.put("customerName", rs.getString("HoTen") != null ? rs.getString("HoTen") : rs.getString("TenDangNhap"));
                    row.put("machineCode", rs.getString("machine_code"));
                    row.put("itemName", rs.getString("item_name"));
                    row.put("quantity", rs.getInt("quantity"));
                    row.put("category", rs.getString("promo_code"));
                    row.put("amount", rs.getBigDecimal("final_amount"));
                    row.put("status", rs.getString("status"));
                    row.put("createdAt", rs.getTimestamp("created_at"));
                    transactions.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Xuất file Excel (CSV UTF-8 BOM) khi bấm nút Xuất Báo Cáo
        String action = request.getParameter("action");
        if ("export".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"BaoCaoDoanhThu_RedZone.csv\"");
            try (OutputStream out = response.getOutputStream()) {
                out.write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});
                StringBuilder sb = new StringBuilder();
                sb.append("Ma GD,Khach Hang,May Tram,Noi Dung,Phan Loai,So Luong,Thanh Tien (VND),Trang Thai,Thoi Gian\n");
                for (Object obj : transactions) {
                    Map tx = (Map) obj;
                    sb.append("#").append(tx.get("orderId")).append(",")
                            .append("\"").append(tx.get("customerName")).append("\",")
                            .append(tx.get("machineCode")).append(",")
                            .append("\"").append(tx.get("itemName")).append("\",")
                            .append(tx.get("category")).append(",")
                            .append(tx.get("quantity")).append(",")
                            .append(tx.get("amount")).append(",")
                            .append(tx.get("status")).append(",")
                            .append(tx.get("createdAt")).append("\n");
                }
                out.write(sb.toString().getBytes(StandardCharsets.UTF_8));
                out.flush();
            }
            return;
        }

        double totalRevenue = revTopUp + revFnb + revGear;
        double netProfit = totalRevenue - maintenanceCost;

        request.setAttribute("revTopUp", revTopUp);
        request.setAttribute("revFnb", revFnb);
        request.setAttribute("revGear", revGear);
        request.setAttribute("maintenanceCost", maintenanceCost);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("netProfit", netProfit);
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/views/admin/bao_cao.jsp").forward(request, response);
    }
}