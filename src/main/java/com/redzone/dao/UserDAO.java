package com.redzone.dao;

import com.redzone.model.MenuItem;
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

    // Tự động đảm bảo bảng ServiceOrders tồn tại để lưu đơn gọi món, thuê gear và yêu cầu nạp tiền
    private void ensureServiceOrdersTable(Connection conn) {
        String sql = "IF OBJECT_ID('ServiceOrders', 'U') IS NULL " +
                "CREATE TABLE ServiceOrders (" +
                "    order_id INT IDENTITY(1,1) PRIMARY KEY," +
                "    user_id INT NOT NULL," +
                "    machine_code NVARCHAR(50)," +
                "    item_name NVARCHAR(200)," +
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

    // 1. Lấy thông tin User theo MaTK (khớp đúng cột Username, TrangThai kiểu VARCHAR)
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

    // 2. Lấy danh sách món ăn / đồ uống trực tiếp từ bảng MON_AN_DO_UONG (đồng bộ với Admin)
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

        // Dự phòng dữ liệu mẫu nếu bảng MON_AN_DO_UONG chưa có dữ liệu
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

    // 3. Cập nhật hồ sơ cá nhân trong bảng TAI_KHOAN
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

    // 4. Tạo đơn gọi món / thuê gear vào bảng ServiceOrders (hiện sang giao diện Admin & IT)
    public boolean createServiceOrder(int userId, String machineCode, String itemName, int quantity, String promoCode, BigDecimal finalAmount) {
        String sql = "INSERT INTO ServiceOrders (user_id, machine_code, item_name, quantity, promo_code, final_amount, status) VALUES (?, ?, ?, ?, ?, ?, 'SERVING')";
        try (Connection conn = getConnection()) {
            ensureServiceOrdersTable(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, machineCode);
                ps.setNString(3, itemName);
                ps.setInt(4, quantity);
                ps.setString(5, promoCode);
                ps.setBigDecimal(6, finalAmount);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. Trừ tiền trong cột SoDuVi của bảng TAI_KHOAN (khóa chính MaTK)
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

    // 6. Khách hàng gửi yêu cầu nạp tiền (Trạng thái PENDING chờ Admin duyệt)
    public boolean createTopUpRequest(int userId, String machineCode, BigDecimal amount, String methodLabel) {
        String sql = "INSERT INTO ServiceOrders (user_id, machine_code, item_name, quantity, promo_code, final_amount, status) VALUES (?, ?, ?, 1, 'TOPUP', ?, 'PENDING')";
        try (Connection conn = getConnection()) {
            ensureServiceOrdersTable(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, machineCode);
                ps.setNString(3, "NAP_TIEN: " + methodLabel);
                ps.setBigDecimal(4, amount);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 7. Admin bấm "Chấp nhận" -> Cộng tiền vào SoDuVi của khách và đổi trạng thái đơn thành APPROVED
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
}