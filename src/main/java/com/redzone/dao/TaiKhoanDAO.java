package com.redzone.dao;

import com.redzone.model.TaiKhoan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaiKhoanDAO {

    public TaiKhoan checkLogin(String username, String password) {
        String sql = "SELECT tk.*, vt.TenVaiTro FROM TAI_KHOAN tk " +
                "JOIN VAI_TRO vt ON tk.MaVaiTro = vt.MaVaiTro " +
                "WHERE tk.Username = ? AND tk.Password = ? AND tk.TrangThai = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new TaiKhoan(
                            rs.getInt("MaTK"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("HoTen"),
                            rs.getString("TenVaiTro"),
                            1,
                            rs.getDouble("SoDuVi")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TaiKhoan> getAllUsers() {
        List<TaiKhoan> list = new ArrayList<>();
        String sql = "SELECT tk.*, vt.TenVaiTro FROM TAI_KHOAN tk JOIN VAI_TRO vt ON tk.MaVaiTro = vt.MaVaiTro";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int status = "ACTIVE".equalsIgnoreCase(rs.getString("TrangThai")) ? 1 : 0;
                list.add(new TaiKhoan(
                        rs.getInt("MaTK"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("HoTen"),
                        rs.getString("TenVaiTro"),
                        status,
                        rs.getDouble("SoDuVi")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addUser(TaiKhoan tk) {
        int maVaiTro = getMaVaiTroByName(tk.getRole());
        String trangThai = (tk.getTrangThai() == 1) ? "ACTIVE" : "LOCKED";
        String sql = "INSERT INTO TAI_KHOAN (MaVaiTro, Username, Password, HoTen, SoDuVi, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maVaiTro);
            ps.setString(2, tk.getUsername());
            ps.setString(3, tk.getPassword());
            ps.setString(4, tk.getFullName());
            ps.setDouble(5, tk.getBalance());
            ps.setString(6, trangThai);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Bổ sung hàm cập nhật thông tin & phân quyền (UC-04.1, UC-04.2)
    public boolean updateUser(int id, String fullName, String role, double balance) {
        int maVaiTro = getMaVaiTroByName(role);
        String sql = "UPDATE TAI_KHOAN SET HoTen = ?, MaVaiTro = ?, SoDuVi = ? WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setInt(2, maVaiTro);
            ps.setDouble(3, balance);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTrangThai(int id, int trangThai) {
        String statusStr = (trangThai == 1) ? "ACTIVE" : "LOCKED";
        String sql = "UPDATE TAI_KHOAN SET TrangThai = ? WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusStr);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPassword(int id, String newPassword) {
        String sql = "UPDATE TAI_KHOAN SET Password = ? WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM TAI_KHOAN WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private int getMaVaiTroByName(String role) {
        if ("Admin".equalsIgnoreCase(role)) return 1;
        if ("IT".equalsIgnoreCase(role)) return 2;
        return 3; // Mặc định Member
    }
}