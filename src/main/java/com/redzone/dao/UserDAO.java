package com.redzone.dao;

import com.redzone.model.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBConnection {

    // UC-04.4: Cập nhật hồ sơ tài khoản cá nhân
    public boolean updateProfile(int userId, String fullName, String phone, String email) {
        String sql = "UPDATE Users SET full_name = ?, phone = ?, email = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    // UC-09 & UC-10.1: Nạp tiền & cập nhật số dư tài khoản
    public boolean topUpBalance(int userId, BigDecimal amount) {
        String sql = "UPDATE Users SET balance = balance + ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    // Trừ tiền khi gọi món/combo tại máy (UC-12)
    public boolean deductBalance(int userId, BigDecimal amount) {
        String sql = "UPDATE Users SET balance = balance - ? WHERE user_id = ? AND balance >= ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, amount);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    // UC-07.2: Tìm kiếm & lọc mã máy, mã phòng
    public List<Computer> searchComputers(String keyword, String roomFilter) {
        List<Computer> list = new ArrayList<>();
        String sql = "SELECT * FROM Computers WHERE 1=1";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND machine_code LIKE ?";
        }
        if (roomFilter != null && !roomFilter.trim().isEmpty() && !"ALL".equals(roomFilter)) {
            sql += " AND room_name = ?";
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (roomFilter != null && !roomFilter.trim().isEmpty() && !"ALL".equals(roomFilter)) {
                ps.setString(idx++, roomFilter);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Computer(
                    rs.getInt("machine_id"),
                    rs.getString("machine_code"),
                    rs.getNString("room_name"),
                    rs.getNString("specs"),
                    rs.getBigDecimal("price_per_hour"),
                    rs.getString("status")
                ));
            }
        } catch (Exception e) {
            // Fallback dữ liệu mẫu nếu DB chưa tạo bảng Computers
            list = getDefaultComputers(keyword, roomFilter);
        }
        if (list.isEmpty() && (keyword == null || keyword.isEmpty()) && (roomFilter == null || "ALL".equals(roomFilter))) {
            list = getDefaultComputers(null, "ALL");
        }
        return list;
    }

    public List<Computer> getDefaultComputers(String keyword, String roomFilter) {
        List<Computer> all = new ArrayList<>();
        all.add(new Computer(1, "MAY-01", "Phòng Thường", "i5-12400F / RTX 3060 / 165Hz", new BigDecimal("10000"), "AVAILABLE"));
        all.add(new Computer(2, "MAY-02", "Phòng Thường", "i5-12400F / RTX 3060 / 165Hz", new BigDecimal("10000"), "IN_USE"));
        all.add(new Computer(3, "VIP-01", "Phòng VIP", "i7-13700F / RTX 4060Ti / 240Hz", new BigDecimal("15000"), "AVAILABLE"));
        all.add(new Computer(4, "VIP-02", "Phòng VIP", "i7-13700F / RTX 4060Ti / 240Hz", new BigDecimal("15000"), "AVAILABLE"));
        all.add(new Computer(5, "COMP-01", "Phòng Thi Đấu", "i9-14900K / RTX 4080 / 360Hz", new BigDecimal("25000"), "AVAILABLE"));
        all.add(new Computer(6, "COUPLE-01", "Phòng Đôi", "i7-13700F / RTX 4060 / Ghế Sofa", new BigDecimal("30000"), "RESERVED"));

        List<Computer> filtered = new ArrayList<>();
        for (Computer c : all) {
            boolean matchKey = (keyword == null || keyword.trim().isEmpty()) || c.getMachineCode().toLowerCase().contains(keyword.trim().toLowerCase());
            boolean matchRoom = (roomFilter == null || "ALL".equals(roomFilter)) || c.getRoomName().equalsIgnoreCase(roomFilter);
            if (matchKey && matchRoom) {
                filtered.add(c);
            }
        }
        return filtered;
    }

    // UC-08: Lưu yêu cầu đặt trước phòng/máy trạm
    public boolean createBooking(int userId, String machineCode, String roomName, String timeSlot, int hours) {
        String sql = "INSERT INTO Bookings (user_id, machine_code, room_name, time_slot, hours, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, machineCode);
            ps.setNString(3, roomName);
            ps.setString(4, timeSlot);
            ps.setInt(5, hours);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    // UC-12 & UC-13.1: Lưu đơn gọi món & combo tại máy
    public boolean createServiceOrder(int userId, String machineCode, String itemName, int quantity, String promoCode, BigDecimal finalAmount) {
        String sql = "INSERT INTO ServiceOrders (user_id, machine_code, item_name, quantity, promo_code, final_amount, status) VALUES (?, ?, ?, ?, ?, ?, 'PREPARING')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, machineCode);
            ps.setNString(3, itemName);
            ps.setInt(4, quantity);
            ps.setString(5, promoCode);
            ps.setBigDecimal(6, finalAmount);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public List<MenuItem> getMenuItems() {
        List<MenuItem> menu = new ArrayList<>();
        menu.add(new MenuItem(1, "Mì xào bò trứng", "FOOD", new BigDecimal("35000")));
        menu.add(new MenuItem(2, "Cơm chiên dương châu", "FOOD", new BigDecimal("40000")));
        menu.add(new MenuItem(3, "Sting Dâu / Bò Húc", "DRINK", new BigDecimal("15000")));
        menu.add(new MenuItem(4, "Trà đào cam sả", "DRINK", new BigDecimal("25000")));
        menu.add(new MenuItem(5, "Combo Đêm (3h chơi + Mì trứng + Sting)", "COMBO", new BigDecimal("55000")));
        menu.add(new MenuItem(6, "Combo Chiến Thần (5h chơi + Cơm chiên + Bò húc)", "COMBO", new BigDecimal("85000")));
        return menu;
    }
}
