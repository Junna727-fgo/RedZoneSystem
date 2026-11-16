package com.redzone.model;

public class TaiKhoan {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String role; // Admin, IT, Member
    private int trangThai; // 1: Hoạt động, 0: Khóa, 2: Chờ duyệt
    private double balance;

    public TaiKhoan() {}

    public TaiKhoan(int id, String username, String password, String fullName, String role, int trangThai, double balance) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.trangThai = trangThai;
        this.balance = balance;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }
}
