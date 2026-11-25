package com.redzone.dao;

import com.redzone.model.DichVu;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DichVuDAO {

    private String getDefaultImage(String tenMon, String danhMuc) {
        String n = (tenMon != null) ? tenMon.toLowerCase() : "";
        String c = (danhMuc != null) ? danhMuc.toLowerCase() : "";

        if (c.contains("gear") || n.contains("chuột") || n.contains("phím") || n.contains("tai nghe")) {
            return "https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("pepsi") || n.contains("pessi")) {
            return "https://images.unsplash.com/photo-1629203851122-3726ecdf080e?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("coca")) {
            return "https://images.unsplash.com/photo-1554866585-cd94860890b7?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("redbull") || n.contains("bò húc") || n.contains("tăng lực")) {
            return "https://images.unsplash.com/photo-1622543925917-763c34d1a86e?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("sting") || c.equals("nước")) {
            return "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("cơm gà")) {
            return "https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=400&q=80";
        }
        if (c.equals("cơm") || n.contains("cơm")) {
            return "https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=400&q=80";
        }
        if (c.equals("mì trộn") || n.contains("mì trộn") || n.contains("mì xào")) {
            return "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80";
        }
        if (c.equals("mì nước") || n.contains("mì")) {
            return "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=400&q=80";
        }
        if (n.contains("khoai")) {
            return "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=400&q=80";
        }
        if (c.contains("combo")) {
            return "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=400&q=80";
        }
        return "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=400&q=80";
    }

    public List<DichVu> getAllDichVu() {
        List<DichVu> list = new ArrayList<>();
        String sql = "SELECT MaMon, TenMon, DonGia, SoLuongTon, DanhMuc, HinhAnh FROM MON_AN_DO_UONG ORDER BY MaMon DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DichVu dv = new DichVu();
                dv.setId(rs.getInt("MaMon"));
                dv.setTenMon(rs.getString("TenMon"));
                dv.setGia(rs.getDouble("DonGia"));
                dv.setSoLuongTon(rs.getInt("SoLuongTon"));
                dv.setDanhMuc(rs.getString("DanhMuc"));
                String img = rs.getString("HinhAnh");
                dv.setHinhAnh((img != null && !img.trim().isEmpty()) ? img : getDefaultImage(dv.getTenMon(), dv.getDanhMuc()));
                list.add(dv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addDichVu(DichVu dv) {
        String img = (dv.getHinhAnh() != null && !dv.getHinhAnh().trim().isEmpty())
                ? dv.getHinhAnh().trim()
                : getDefaultImage(dv.getTenMon(), dv.getDanhMuc());
        String sql = "INSERT INTO MON_AN_DO_UONG (TenMon, DanhMuc, DonGia, SoLuongTon, TrangThai, HinhAnh) VALUES (?, ?, ?, ?, 'AVAILABLE', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, dv.getTenMon());
            ps.setNString(2, dv.getDanhMuc());
            ps.setDouble(3, dv.getGia());
            ps.setInt(4, dv.getSoLuongTon());
            ps.setNString(5, img);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDichVu(DichVu dv) {
        String img = (dv.getHinhAnh() != null && !dv.getHinhAnh().trim().isEmpty())
                ? dv.getHinhAnh().trim()
                : getDefaultImage(dv.getTenMon(), dv.getDanhMuc());
        String sql = "UPDATE MON_AN_DO_UONG SET TenMon = ?, DanhMuc = ?, DonGia = ?, SoLuongTon = ?, HinhAnh = ? WHERE MaMon = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, dv.getTenMon());
            ps.setNString(2, dv.getDanhMuc());
            ps.setDouble(3, dv.getGia());
            ps.setInt(4, dv.getSoLuongTon());
            ps.setNString(5, img);
            ps.setInt(6, dv.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteDichVu(int id) {
        String sql = "DELETE FROM MON_AN_DO_UONG WHERE MaMon = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}