package com.redzone.model;

public class BaoCaoGiaoDich {
    private int maGD;
    private String khachHang;
    private String loaiDoanhThu; // Tiền giờ chơi / Dịch vụ F&B
    private double soTien;
    private String thoiGian;
    private String trangThai;

    public BaoCaoGiaoDich() {}

    public BaoCaoGiaoDich(int maGD, String khachHang, String loaiDoanhThu, double soTien, String thoiGian, String trangThai) {
        this.maGD = maGD;
        this.khachHang = khachHang;
        this.loaiDoanhThu = loaiDoanhThu;
        this.soTien = soTien;
        this.thoiGian = thoiGian;
        this.trangThai = trangThai;
    }

    public int getMaGD() { return maGD; }
    public void setMaGD(int maGD) { this.maGD = maGD; }
    public String getKhachHang() { return khachHang; }
    public void setKhachHang(String khachHang) { this.khachHang = khachHang; }
    public String getLoaiDoanhThu() { return loaiDoanhThu; }
    public void setLoaiDoanhThu(String loaiDoanhThu) { this.loaiDoanhThu = loaiDoanhThu; }
    public double getSoTien() { return soTien; }
    public void setSoTien(double soTien) { this.soTien = soTien; }
    public String getThoiGian() { return thoiGian; }
    public void setThoiGian(String thoiGian) { this.thoiGian = thoiGian; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}