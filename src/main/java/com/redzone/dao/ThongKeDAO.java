package com.redzone.dao;

import com.redzone.model.BaoCaoGiaoDich;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThongKeDAO {

    public double getDoanhThuFnB() {
        double total = 0;
        String sql = "SELECT ISNULL(SUM(TongTien), 0) AS total FROM HOA_DON_FNB";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public double getDoanhThuNapTien() {
        double total = 0;
        String sql = "SELECT ISNULL(SUM(SoTien), 0) AS total FROM GIAO_DICH_NAP_TIEN WHERE TrangThai = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        } catch (SQLException e) {
            // Bỏ qua nếu chưa có giao dịch nạp
        }
        return total;
    }

    public double getTotalDoanhThu() {
        return getDoanhThuFnB() + getDoanhThuNapTien();
    }

    public int getTotalUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS cnt FROM TAI_KHOAN";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalPhongMay() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS cnt FROM MAY_TRAM";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<BaoCaoGiaoDich> getChiTietDoanhThu() {
        List<BaoCaoGiaoDich> list = new ArrayList<>();
        // Lấy dữ liệu từ Hóa đơn F&B
        String sqlFnB = "SELECT hd.MaHD, ISNULL(tk.HoTen, N'Khách vãng lai') AS KhachHang, " +
                "hd.TongTien, CONVERT(VARCHAR(19), hd.NgayTao, 120) AS ThoiGian, hd.TrangThai " +
                "FROM HOA_DON_FNB hd LEFT JOIN TAI_KHOAN tk ON hd.MaTK = tk.MaTK " +
                "ORDER BY hd.MaHD DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlFnB);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BaoCaoGiaoDich(
                        rs.getInt("MaHD"),
                        rs.getString("KhachHang"),
                        "Dịch vụ F&B",
                        rs.getDouble("TongTien"),
                        rs.getString("ThoiGian"),
                        rs.getString("TrangThai")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Lấy dữ liệu từ Giao dịch nạp giờ chơi
        String sqlNap = "SELECT gd.MaGD, ISNULL(tk.HoTen, N'Hội viên') AS KhachHang, " +
                "gd.SoTien, CONVERT(VARCHAR(19), gd.NgayGiaoDich, 120) AS ThoiGian, gd.TrangThai " +
                "FROM GIAO_DICH_NAP_TIEN gd LEFT JOIN TAI_KHOAN tk ON gd.MaTK = tk.MaTK " +
                "ORDER BY gd.MaGD DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlNap);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BaoCaoGiaoDich(
                        rs.getInt("MaGD"),
                        rs.getString("KhachHang"),
                        "Nạp giờ chơi",
                        rs.getDouble("SoTien"),
                        rs.getString("ThoiGian"),
                        rs.getString("TrangThai")
                ));
            }
        } catch (SQLException e) {
            // Bỏ qua nếu bảng trống
        }
        return list;
    }
}