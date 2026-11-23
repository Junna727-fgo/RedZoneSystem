package com.redzone.dao;

import com.redzone.model.Phong;
import com.redzone.model.PhongMay;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PhongMayDAO {

    // ================= QUẢN LÝ PHÒNG / KHU VỰC =================
    public List<Phong> getAllPhong() {
        List<Phong> list = new ArrayList<>();
        String sql = "SELECT * FROM PHONG_MAY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Phong(
                        rs.getInt("MaPhong"),
                        rs.getString("TenPhong"),
                        rs.getDouble("DonGiaCoBan"),
                        rs.getString("MoTaDichVuKem")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addPhong(String tenPhong, double donGia, String moTa) {
        String sql = "INSERT INTO PHONG_MAY (TenPhong, DonGiaCoBan, MoTaDichVuKem) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, tenPhong);
            ps.setDouble(2, donGia);
            ps.setNString(3, moTa);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePhong(int maPhong, String tenPhong, double donGia, String moTa) {
        String sql = "UPDATE PHONG_MAY SET TenPhong = ?, DonGiaCoBan = ?, MoTaDichVuKem = ? WHERE MaPhong = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, tenPhong);
            ps.setDouble(2, donGia);
            ps.setNString(3, moTa);
            ps.setInt(4, maPhong);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePhong(int maPhong) {
        String sql = "DELETE FROM PHONG_MAY WHERE MaPhong = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= QUẢN LÝ MÁY TRẠM =================
    public List<PhongMay> getAllPhongMay() {
        List<PhongMay> list = new ArrayList<>();
        String sql = "SELECT m.MaMay, p.TenPhong, m.TenMay, p.DonGiaCoBan, m.TrangThai " +
                "FROM MAY_TRAM m JOIN PHONG_MAY p ON m.MaPhong = p.MaPhong";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new PhongMay(
                        rs.getInt("MaMay"),
                        rs.getString("TenPhong"),
                        rs.getString("TenMay"),
                        rs.getDouble("DonGiaCoBan"),
                        rs.getString("TrangThai")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addMayTram(int maPhong, String tenMay, String trangThai) {
        String sql = "INSERT INTO MAY_TRAM (MaPhong, TenMay, TrangThai) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            ps.setNString(2, tenMay);
            ps.setString(3, trangThai);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateMayTram(int maMay, int maPhong, String tenMay, String trangThai) {
        String sql = "UPDATE MAY_TRAM SET MaPhong = ?, TenMay = ?, TrangThai = ? WHERE MaMay = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maPhong);
            ps.setNString(2, tenMay);
            ps.setString(3, trangThai);
            ps.setInt(4, maMay);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePhongMay(int id) {
        String sql = "DELETE FROM MAY_TRAM WHERE MaMay = ?";
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