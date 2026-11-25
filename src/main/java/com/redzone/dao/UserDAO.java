package com.redzone.dao;

import com.redzone.model.MenuItem;
import com.redzone.model.QrPaymentOrder;
import com.redzone.model.User;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    private void ensureServiceOrdersTable(Connection conn) {
        String sql = "IF OBJECT_ID('ServiceOrders', 'U') IS NULL " +
                "CREATE TABLE ServiceOrders (" +
                "    order_id INT IDENTITY(1,1) PRIMARY KEY," +
                "    user_id INT NOT NULL," +
                "    machine_code NVARCHAR(50)," +
                "    item_name NVARCHAR(255)," +
                "    quantity INT DEFAULT 1," +
                "    promo_code NVARCHAR(50)," +
                "    final_amount DECIMAL(18,2)," +
                "    status NVARCHAR(50) DEFAULT 'SERVING'," +
                "    created_at DATETIME DEFAULT GETDATE()" +
                ")";
        try (Statement st = conn.createStatement()) {
            st.execute(sql);
        } catch (Exception ignored) {
        }
    }

    private String safeTruncate(String s, int maxLen) {
        if (s == null) return "";
        return s.length() <= maxLen ? s : s.substring(0, maxLen - 3) + "...";
    }

    public User getUserById(int userId) {
        String sql = "SELECT MaTK, Username, HoTen, SoDuVi, TrangThai FROM TAI_KHOAN WHERE MaTK = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("MaTK"));
                    u.setUsername(rs.getString("Username"));
                    u.setFullName(rs.getString("HoTen"));
                    BigDecimal bal = rs.getBigDecimal("SoDuVi");
                    u.setBalance(bal != null ? bal : BigDecimal.ZERO);
                    String st = rs.getString("TrangThai");
                    u.setStatus("ACTIVE".equalsIgnoreCase(st) || "1".equals(st) ? "Hoạt động"
                            : ("LOCKED".equalsIgnoreCase(st) || "0".equals(st) ? "Khóa" : "Chờ duyệt"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<MenuItem> getMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT MaMon, TenMon, DonGia FROM MON_AN_DO_UONG WHERE UPPER(ISNULL(DanhMuc, '')) <> 'GEAR' AND ISNULL(SoLuongTon, 1) > 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setItemId(rs.getInt("MaMon"));
                item.setItemName(rs.getString("TenMon"));
                item.setPrice(rs.getBigDecimal("DonGia"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list.isEmpty()) {
            MenuItem m1 = new MenuItem();
            m1.setItemId(1);
            m1.setItemName("Mì Xào Bò Trứng");
            m1.setPrice(new BigDecimal("35000"));
            list.add(m1);

            MenuItem m2 = new MenuItem();
            m2.setItemId(2);
            m2.setItemName("Cơm Gà Xối Mỡ");
            m2.setPrice(new BigDecimal("40000"));
            list.add(m2);

            MenuItem m3 = new MenuItem();
            m3.setItemId(3);
            m3.setItemName("Sting Dâu Lạnh");
            m3.setPrice(new BigDecimal("15000"));
            list.add(m3);

            MenuItem m4 = new MenuItem();
            m4.setItemId(4);
            m4.setItemName("Combo Cơm + Sting");
            m4.setPrice(new BigDecimal("50000"));
            list.add(m4);
        }
        return list;
    }

    public boolean updateProfile(int userId, String fullName, String phone, String email) {
        String sql = "UPDATE TAI_KHOAN SET HoTen = ? WHERE MaTK = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, fullName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Giữ nguyên hàm cũ (mặc định SERVING cho đơn tiền mặt)
    public boolean createServiceOrder(int userId, String machineCode, String itemName, int quantity, String promoCode, BigDecimal finalAmount) {
        return createServiceOrderWithStatus(userId, machineCode, itemName, quantity, promoCode, finalAmount, "SERVING");
    }

    // Mới: Tạo đơn dịch vụ với trạng thái tùy chỉnh (PENDING cho QR chờ Admin duyệt, SERVING cho tiền mặt)
    public boolean createServiceOrderWithStatus(int userId, String machineCode, String itemName, int quantity, String promoCode, BigDecimal finalAmount, String status) {
        String sql = "INSERT INTO ServiceOrders (user_id, machine_code, item_name, quantity, promo_code, final_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection()) {
            ensureServiceOrdersTable(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, machineCode);
                ps.setNString(3, safeTruncate(itemName, 195));
                ps.setInt(4, quantity);
                ps.setString(5, promoCode);
                ps.setBigDecimal(6, finalAmount);
                ps.setString(7, status);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deductPlayTimeBalance(int userId, BigDecimal amountToDeduct) {
        String sql = "UPDATE TAI_KHOAN SET SoDuVi = CASE WHEN ISNULL(SoDuVi, 0) >= ? THEN SoDuVi - ? ELSE 0 END WHERE MaTK = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amountToDeduct);
            ps.setBigDecimal(2, amountToDeduct);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createTopUpRequest(int userId, String machineCode, BigDecimal amount, String methodLabel) {
        return createServiceOrderWithStatus(userId, machineCode, "NAP_TIEN: " + methodLabel, 1, "TOPUP", amount, "PENDING");
    }

    public boolean approveTopUpRequest(int orderId, int userId, BigDecimal amount) {
        String updateOrderSql = "UPDATE ServiceOrders SET status = 'APPROVED' WHERE order_id = ? AND status = 'PENDING'";
        String updateBalanceSql = "UPDATE TAI_KHOAN SET SoDuVi = ISNULL(SoDuVi, 0) + ? WHERE MaTK = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(updateOrderSql);
                 PreparedStatement psUser = conn.prepareStatement(updateBalanceSql)) {
                psOrder.setInt(1, orderId);
                int rows = psOrder.executeUpdate();
                if (rows > 0) {
                    psUser.setBigDecimal(1, amount);
                    psUser.setInt(2, userId);
                    psUser.executeUpdate();
                    conn.commit();
                    return true;
                }
                conn.rollback();
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== CHỨC NĂNG DUYỆT THANH TOÁN QR (ADMIN) ====================

    public List<QrPaymentOrder> getPaymentOrdersForAdmin(String statusFilter, String typeFilter) {
        List<QrPaymentOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT so.order_id, so.user_id, ISNULL(tk.Username, 'guest') AS Username, " +
                        "ISNULL(tk.HoTen, N'Khách hàng') AS HoTen, so.machine_code, so.item_name, " +
                        "so.quantity, ISNULL(so.promo_code, 'FNB') AS promo_code, so.final_amount, " +
                        "so.status, CONVERT(VARCHAR(19), so.created_at, 120) AS created_at " +
                        "FROM ServiceOrders so LEFT JOIN TAI_KHOAN tk ON so.user_id = tk.MaTK WHERE 1=1 "
        );

        List<String> params = new ArrayList<>();
        if (statusFilter != null && !"ALL".equalsIgnoreCase(statusFilter)) {
            if ("DONE".equalsIgnoreCase(statusFilter)) {
                sql.append("AND so.status IN ('APPROVED', 'SERVING', 'COMPLETED') ");
            } else {
                sql.append("AND so.status = ? ");
                params.add(statusFilter.toUpperCase());
            }
        }
        if (typeFilter != null && !"ALL".equalsIgnoreCase(typeFilter)) {
            if ("SERVICE".equalsIgnoreCase(typeFilter)) {
                sql.append("AND ISNULL(so.promo_code, '') <> 'TOPUP' ");
            } else {
                sql.append("AND UPPER(ISNULL(so.promo_code, '')) = ? ");
                params.add(typeFilter.toUpperCase());
            }
        }
        sql.append("ORDER BY CASE WHEN so.status = 'PENDING' THEN 0 ELSE 1 END, so.order_id DESC");

        try (Connection conn = getConnection()) {
            ensureServiceOrdersTable(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setString(i + 1, params.get(i));
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        QrPaymentOrder o = new QrPaymentOrder();
                        o.setOrderId(rs.getInt("order_id"));
                        o.setUserId(rs.getInt("user_id"));
                        o.setUsername(rs.getString("Username"));
                        o.setFullName(rs.getString("HoTen"));
                        o.setMachineCode(rs.getString("machine_code"));
                        o.setItemName(rs.getString("item_name"));
                        o.setQuantity(rs.getInt("quantity"));
                        o.setPromoCode(rs.getString("promo_code"));
                        o.setFinalAmount(rs.getBigDecimal("final_amount"));
                        o.setStatus(rs.getString("status"));
                        o.setCreatedAt(rs.getString("created_at"));
                        list.add(o);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Duyệt thanh toán chung: TOPUP -> cộng tiền + APPROVED; FNB/GEAR -> chuyển SERVING
    public boolean approvePaymentOrder(int orderId) {
        String selectSql = "SELECT user_id, promo_code, final_amount, status FROM ServiceOrders WHERE order_id = ?";
        String updateOrderSql = "UPDATE ServiceOrders SET status = ? WHERE order_id = ? AND status = 'PENDING'";
        String addBalanceSql = "UPDATE TAI_KHOAN SET SoDuVi = ISNULL(SoDuVi, 0) + ? WHERE MaTK = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                int userId = 0;
                String promoCode = "";
                BigDecimal amount = BigDecimal.ZERO;
                String currentStatus = "";

                try (PreparedStatement psSel = conn.prepareStatement(selectSql)) {
                    psSel.setInt(1, orderId);
                    try (ResultSet rs = psSel.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        userId = rs.getInt("user_id");
                        promoCode = rs.getString("promo_code");
                        amount = rs.getBigDecimal("final_amount");
                        currentStatus = rs.getString("status");
                    }
                }

                if (!"PENDING".equalsIgnoreCase(currentStatus)) {
                    conn.rollback();
                    return false;
                }

                boolean isTopUp = "TOPUP".equalsIgnoreCase(promoCode);
                String nextStatus = isTopUp ? "APPROVED" : "SERVING";

                try (PreparedStatement psUpd = conn.prepareStatement(updateOrderSql)) {
                    psUpd.setString(1, nextStatus);
                    psUpd.setInt(2, orderId);
                    if (psUpd.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                if (isTopUp && amount != null && amount.compareTo(BigDecimal.ZERO) > 0) {
                    try (PreparedStatement psBal = conn.prepareStatement(addBalanceSql)) {
                        psBal.setBigDecimal(1, amount);
                        psBal.setInt(2, userId);
                        psBal.executeUpdate();
                    }
                }

                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Từ chối yêu cầu thanh toán đang PENDING
    public boolean rejectPaymentOrder(int orderId) {
        String sql = "UPDATE ServiceOrders SET status = 'REJECTED' WHERE order_id = ? AND status = 'PENDING'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lịch sử giao dịch gần nhất của 1 hội viên (để hiện trạng thái duyệt realtime trên profile.jsp)
    public List<QrPaymentOrder> getUserRecentTransactions(int userId, int limit) {
        List<QrPaymentOrder> list = new ArrayList<>();
        String sql = "SELECT TOP (?) order_id, user_id, machine_code, item_name, quantity, " +
                "ISNULL(promo_code, 'FNB') AS promo_code, final_amount, status, " +
                "CONVERT(VARCHAR(16), created_at, 120) AS created_at " +
                "FROM ServiceOrders WHERE user_id = ? ORDER BY order_id DESC";
        try (Connection conn = getConnection()) {
            ensureServiceOrdersTable(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        QrPaymentOrder o = new QrPaymentOrder();
                        o.setOrderId(rs.getInt("order_id"));
                        o.setUserId(rs.getInt("user_id"));
                        o.setMachineCode(rs.getString("machine_code"));
                        o.setItemName(rs.getString("item_name"));
                        o.setQuantity(rs.getInt("quantity"));
                        o.setPromoCode(rs.getString("promo_code"));
                        o.setFinalAmount(rs.getBigDecimal("final_amount"));
                        o.setStatus(rs.getString("status"));
                        o.setCreatedAt(rs.getString("created_at"));
                        list.add(o);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}