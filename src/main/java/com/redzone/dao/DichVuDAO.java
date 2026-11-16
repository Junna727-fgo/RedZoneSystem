package com.redzone.dao;

import com.redzone.model.DichVu;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DichVuDAO {

    public List<DichVu> getAllDichVu() {
        List<DichVu> list = new ArrayList<>();
        String sql = "SELECT * FROM MON_AN_DO_UONG ORDER BY MaMon DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new DichVu(
                        rs.getInt("MaMon"),
                        rs.getString("TenMon"),
                        rs.getDouble("DonGia"),
                        rs.getInt("SoLuongTon"),
                        rs.getString("DanhMuc")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addDichVu(DichVu dv) {
        String sql = "INSERT INTO MON_AN_DO_UONG (TenMon, DanhMuc, DonGia, SoLuongTon, TrangThai) VALUES (?, ?, ?, ?, 'AVAILABLE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dv.getTenMon());
            ps.setString(2, dv.getDanhMuc());
            ps.setDouble(3, dv.getGia());
            ps.setInt(4, dv.getSoLuongTon());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDichVu(DichVu dv) {
        String trangThai = (dv.getSoLuongTon() > 0) ? "AVAILABLE" : "OUT_OF_STOCK";
        String sql = "UPDATE MON_AN_DO_UONG SET TenMon = ?, DonGia = ?, SoLuongTon = ?, DanhMuc = ?, TrangThai = ? WHERE MaMon = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dv.getTenMon());
            ps.setDouble(2, dv.getGia());
            ps.setInt(3, dv.getSoLuongTon());
            ps.setString(4, dv.getDanhMuc());
            ps.setString(5, trangThai);
            ps.setInt(6, dv.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDichVu(int id) {
        String sql = "DELETE FROM MON_AN_DO_UONG WHERE MaMon = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}