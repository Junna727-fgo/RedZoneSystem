package com.redzone.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // URL kết nối đến DB QUAN_LY_PHONG_GAME
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=QUAN_LY_PHONG_GAME;encrypt=false";
    private static final String USER = "sa"; // Sửa thành username SQL Server của bạn
    private static final String PASS = "123456789"; // Sửa thành password SQL Server của bạn

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Kết nối CSDL QUAN_LY_PHONG_GAME thành công!");
        } catch (Exception e) {
            System.out.println("Lỗi kết nối CSDL: " + e.getMessage());
        }
        return conn;
    }

    // Hàm main để test chạy thử (Chuột phải -> Run)
    public static void main(String[] args) {
        getConnection();
    }
}