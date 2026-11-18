package com.redzone.model;

public class MayTram {
    private int maMay;
    private int maPhong;
    private String tenMay;
    private String cauHinh;
    private String trangThai; // VD: "SanSang", "DangSuDung", "BaoTri", "Hong"

    public MayTram() {}

    public MayTram(int maMay, int maPhong, String tenMay, String cauHinh, String trangThai) {
        this.maMay = maMay;
        this.maPhong = maPhong;
        this.tenMay = tenMay;
        this.cauHinh = cauHinh;
        this.trangThai = trangThai;
    }

    // Getters & Setters
    public int getMaMay() { return maMay; }
    public void setMaMay(int maMay) { this.maMay = maMay; }
    public int getMaPhong() { return maPhong; }
    public void setMaPhong(int maPhong) { this.maPhong = maPhong; }
    public String getTenMay() { return tenMay; }
    public void setTenMay(String tenMay) { this.tenMay = tenMay; }
    public String getCauHinh() { return cauHinh; }
    public void setCauHinh(String cauHinh) { this.cauHinh = cauHinh; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}