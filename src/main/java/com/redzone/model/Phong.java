package com.redzone.model;

public class Phong {
    private int maPhong;
    private String tenPhong;
    private double donGiaCoBan;
    private String moTa;

    public Phong() {}

    public Phong(int maPhong, String tenPhong, double donGiaCoBan, String moTa) {
        this.maPhong = maPhong;
        this.tenPhong = tenPhong;
        this.donGiaCoBan = donGiaCoBan;
        this.moTa = moTa;
    }

    public int getMaPhong() { return maPhong; }
    public void setMaPhong(int maPhong) { this.maPhong = maPhong; }
    public String getTenPhong() { return tenPhong; }
    public void setTenPhong(String tenPhong) { this.tenPhong = tenPhong; }
    public double getDonGiaCoBan() { return donGiaCoBan; }
    public void setDonGiaCoBan(double donGiaCoBan) { this.donGiaCoBan = donGiaCoBan; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
}