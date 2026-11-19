package com.redzone.model;

import java.sql.Timestamp;

public class BienBanBaoTri {
    private int maBienBan;
    private int maMay;
    private Integer maThietBi; // Có thể null nếu bảo trì toàn bộ máy
    private int maTKLap;
    private Timestamp ngayLap;
    private String moTaSuCo;
    private double chiPhi;
    private String trangThaiXuLy; // VD: "DangXuLy", "HoanThanh"

    public BienBanBaoTri() {}

    // Getters & Setters
    public int getMaBienBan() { return maBienBan; }
    public void setMaBienBan(int maBienBan) { this.maBienBan = maBienBan; }
    public int getMaMay() { return maMay; }
    public void setMaMay(int maMay) { this.maMay = maMay; }
    public Integer getMaThietBi() { return maThietBi; }
    public void setMaThietBi(Integer maThietBi) { this.maThietBi = maThietBi; }
    public int getMaTKLap() { return maTKLap; }
    public void setMaTKLap(int maTKLap) { this.maTKLap = maTKLap; }
    public Timestamp getNgayLap() { return ngayLap; }
    public void setNgayLap(Timestamp ngayLap) { this.ngayLap = ngayLap; }
    public String getMoTaSuCo() { return moTaSuCo; }
    public void setMoTaSuCo(String moTaSuCo) { this.moTaSuCo = moTaSuCo; }
    public double getChiPhi() { return chiPhi; }
    public void setChiPhi(double chiPhi) { this.chiPhi = chiPhi; }
    public String getTrangThaiXuLy() { return trangThaiXuLy; }
    public void setTrangThaiXuLy(String trangThaiXuLy) { this.trangThaiXuLy = trangThaiXuLy; }
}