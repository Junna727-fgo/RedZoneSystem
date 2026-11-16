package com.redzone.model;

public class PhongMay {
    private int id;
    private String tenPhong;
    private String tenMay;
    private double donGia;
    private String trangThai; // Trống, Đang sử dụng, Bảo trì

    public PhongMay() {}

    public PhongMay(int id, String tenPhong, String tenMay, double donGia, String trangThai) {
        this.id = id;
        this.tenPhong = tenPhong;
        this.tenMay = tenMay;
        this.donGia = donGia;
        this.trangThai = trangThai;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTenPhong() { return tenPhong; }
    public void setTenPhong(String tenPhong) { this.tenPhong = tenPhong; }
    public String getTenMay() { return tenMay; }
    public void setTenMay(String tenMay) { this.tenMay = tenMay; }
    public double getDonGia() { return donGia; }
    public void setDonGia(double donGia) { this.donGia = donGia; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}
