package com.redzone.dao;

import com.redzone.model.BienBanBaoTri;
import com.redzone.model.MayTram;
import com.redzone.model.ThietBiPhanCung;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ITManagementDAO {

    // 1. Lấy danh sách toàn bộ máy trạm (UC: Xem tình trạng phòng, máy)
    public List<MayTram> getAllMayTram() {
        List<MayTram> list = new ArrayList<>();
        String sql = "SELECT * FROM MAY_TRAM ORDER BY MaPhong, MaMay";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new MayTram(
                    rs.getInt("MaMay"),
                    rs.getInt("MaPhong"),
                    rs.getString("TenMay"),
                    rs.getString("CauHinh"),
                    rs.getString("TrangThai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Cập nhật trạng thái máy trạm (UC: Cập nhật tình trạng máy)
    public boolean updateTrangThaiMay(int maMay, String trangThaiMoi) {
        String sql = "UPDATE MAY_TRAM SET TrangThai = ? WHERE MaMay = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThaiMoi);
            ps.setInt(2, maMay);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Lấy danh sách thiết bị phần cứng (UC: Quản lý phần cứng & thiết bị phòng máy)
    public List<ThietBiPhanCung> getAllThietBi() {
        List<ThietBiPhanCung> list = new ArrayList<>();
        String sql = "SELECT * FROM THIET_BI_PHAN_CUNG ORDER BY MaMay, MaThietBi";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ThietBiPhanCung(
                    rs.getInt("MaThietBi"),
                    rs.getInt("MaMay"),
                    rs.getString("TenThietBi"),
                    rs.getString("SoSerial"),
                    rs.getString("TinhTrang"),
                    rs.getString("MoTaSuCo")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Thêm mới hoặc cập nhật tình trạng thiết bị phần cứng
    public boolean addThietBi(ThietBiPhanCung tb) {
        String sql = "INSERT INTO THIET_BI_PHAN_CUNG (MaMay, TenThietBi, SoSerial, TinhTrang, MoTaSuCo) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tb.getMaMay());
            ps.setString(2, tb.getTenThietBi());
            ps.setString(3, tb.getSoSerial());
            ps.setString(4, tb.getTinhTrang());
            ps.setString(5, tb.getMoTaSuCo());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTinhTrangThietBi(int maThietBi, String tinhTrang, String moTaSuCo) {
        String sql = "UPDATE THIET_BI_PHAN_CUNG SET TinhTrang = ?, MoTaSuCo = ? WHERE MaThietBi = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tinhTrang);
            ps.setString(2, moTaSuCo);
            ps.setInt(3, maThietBi);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Lập biên bản bảo trì & tự động chuyển máy sang trạng thái "BaoTri" (Transaction)
    public boolean lapBienBanBaoTri(BienBanBaoTri bb) {
        String sqlInsertBB = "INSERT INTO BIEN_BAN_BAO_TRI (MaMay, MaThietBi, MaTKLap, NgayLap, MoTaSuCo, ChiPhi, TrangThaiXuLy) VALUES (?, ?, ?, NOW(), ?, ?, ?)";
        String sqlUpdateMay = "UPDATE MAY_TRAM SET TrangThai = 'BaoTri' WHERE MaMay = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            try (PreparedStatement ps1 = conn.prepareStatement(sqlInsertBB)) {
                ps1.setInt(1, bb.getMaMay());
                if (bb.getMaThietBi() != null && bb.getMaThietBi() > 0) {
                    ps1.setInt(2, bb.getMaThietBi());
                } else {
                    ps1.setNull(2, Types.INTEGER);
                }
                ps1.setInt(3, bb.getMaTKLap());
                ps1.setString(4, bb.getMoTaSuCo());
                ps1.setDouble(5, bb.getChiPhi());
                ps1.setString(6, "DangXuLy");
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdateMay)) {
                ps2.setInt(1, bb.getMaMay());
                ps2.executeUpdate();
            }

            conn.commit(); // Xác nhận lưu cả 2 bảng
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // 6. Hoàn tất bảo trì & mở lại máy trạm về trạng thái "SanSang"
    public boolean hoanTatBaoTri(int maBienBan, int maMay, double chiPhiCuoiCung) {
        String sqlBB = "UPDATE BIEN_BAN_BAO_TRI SET TrangThaiXuLy = 'HoanThanh', ChiPhi = ? WHERE MaBienBan = ?";
        String sqlMay = "UPDATE MAY_TRAM SET TrangThai = 'SanSang' WHERE MaMay = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlBB)) {
                ps1.setDouble(1, chiPhiCuoiCung);
                ps1.setInt(2, maBienBan);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlMay)) {
                ps2.setInt(1, maMay);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // 7. Lấy danh sách biên bản bảo trì
    public List<BienBanBaoTri> getAllBienBan() {
        List<BienBanBaoTri> list = new ArrayList<>();
        String sql = "SELECT * FROM BIEN_BAN_BAO_TRI ORDER BY NgayLap DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BienBanBaoTri bb = new BienBanBaoTri();
                bb.setMaBienBan(rs.getInt("MaBienBan"));
                bb.setMaMay(rs.getInt("MaMay"));
                int maTB = rs.getInt("MaThietBi");
                bb.setMaThietBi(rs.wasNull() ? null : maTB);
                bb.setMaTKLap(rs.getInt("MaTKLap"));
                bb.setNgayLap(rs.getTimestamp("NgayLap"));
                bb.setMoTaSuCo(rs.getString("MoTaSuCo"));
                bb.setChiPhi(rs.getDouble("ChiPhi"));
                bb.setTrangThaiXuLy(rs.getString("TrangThaiXuLy"));
                list.add(bb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}