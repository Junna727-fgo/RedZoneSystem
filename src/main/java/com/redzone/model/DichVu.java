package com.redzone.model;

public class DichVu {
    private int id;
    private String tenMon;
    private double gia;
    private int soLuongTon;
    private String danhMuc; // Đồ ăn, Nước uống, Thẻ cào

    public DichVu() {}

    public DichVu(int id, String tenMon, double gia, int soLuongTon, String danhMuc) {
        this.id = id;
        this.tenMon = tenMon;
        this.gia = gia;
        this.soLuongTon = soLuongTon;
        this.danhMuc = danhMuc;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTenMon() { return tenMon; }
    public void setTenMon(String tenMon) { this.tenMon = tenMon; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }
    public String getDanhMuct() { return danhMuc; }
    public void setDanhMuc(String danhMuc) { this.danhMuc = danhMuc; }
    public String getDanhMuc() { return danhMuc; }
}
