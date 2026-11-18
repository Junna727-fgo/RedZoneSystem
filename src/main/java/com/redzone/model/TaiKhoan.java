package com.redzone.model;

public class TaiKhoan {
    private int maTK;
    private int maVaiTro;
    private String username;
    private String hoTen;
    private String role;
    private String trangThai;

    public TaiKhoan() {
    }

    public TaiKhoan(int maTK, int maVaiTro, String username, String hoTen, String role, String trangThai) {
        this.maTK = maTK;
        this.maVaiTro = maVaiTro;
        this.username = username;
        this.hoTen = hoTen;
        this.role = role;
        this.trangThai = trangThai;
    }

    public int getMaTK() { return maTK; }
    public void setMaTK(int maTK) { this.maTK = maTK; }
    public int getMaVaiTro() { return maVaiTro; }
    public void setMaVaiTro(int maVaiTro) { this.maVaiTro = maVaiTro; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}