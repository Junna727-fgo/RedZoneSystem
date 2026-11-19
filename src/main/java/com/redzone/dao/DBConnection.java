package com.redzone.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=QUAN_LY_PHONG_GAME;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123456789";

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

    public static void main(String[] args) {
        getConnection();
    }
}