package com.redzone.dao;

import com.redzone.model.TaiKhoan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TaiKhoanDAO {

    // 1. Đăng nhập
    public TaiKhoan checkLogin(String username, String password) {
        String query = "SELECT t.MaTK, t.MaVaiTro, t.Username, t.HoTen, v.TenVaiTro, t.TrangThai " +
                "FROM TAI_KHOAN t JOIN VAI_TRO v ON t.MaVaiTro = v.MaVaiTro " +
                "WHERE t.Username = ? AND t.Password = ? AND t.TrangThai = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new TaiKhoan(
                        rs.getInt("MaTK"), rs.getInt("MaVaiTro"),
                        rs.getString("Username"), rs.getString("HoTen"),
                        rs.getString("TenVaiTro"), rs.getString("TrangThai")
                );
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 2. Kiểm tra user tồn tại (dành cho Đăng ký)
    public boolean checkUserExist(String username) {
        String query = "SELECT 1 FROM TAI_KHOAN WHERE Username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 3. Đăng ký tài khoản mới
    public boolean registerUser(String username, String password, String hoTen, String sdt, String cccd) {
        String query = "INSERT INTO TAI_KHOAN (MaVaiTro, Username, Password, HoTen, SDT, CCCD_XacThuc, SoDuVi, TrangThai) " +
                "VALUES (3, ?, ?, ?, ?, ?, 0, 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, hoTen);
            ps.setString(4, sdt);
            ps.setString(5, cccd);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 4. Lấy danh sách TOÀN BỘ tài khoản (Dành cho Admin)
    public List<TaiKhoan> getAllTaiKhoan() {
        List<TaiKhoan> list = new ArrayList<>();
        String query = "SELECT t.MaTK, t.MaVaiTro, t.Username, t.HoTen, v.TenVaiTro, t.TrangThai " +
                "FROM TAI_KHOAN t JOIN VAI_TRO v ON t.MaVaiTro = v.MaVaiTro";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new TaiKhoan(
                        rs.getInt("MaTK"), rs.getInt("MaVaiTro"),
                        rs.getString("Username"), rs.getString("HoTen"),
                        rs.getString("TenVaiTro"), rs.getString("TrangThai")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. Khóa hoặc Mở khóa tài khoản
    public void updateTrangThaiTaiKhoan(int maTK, String trangThaiMoi) {
        String query = "UPDATE TAI_KHOAN SET TrangThai = ? WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, trangThaiMoi);
            ps.setInt(2, maTK);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 6. Xóa vĩnh viễn tài khoản
    public void deleteTaiKhoan(int maTK) {
        String query = "DELETE FROM TAI_KHOAN WHERE MaTK = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, maTK);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}