//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.redzone.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=QUAN_LY_PHONG_GAME;encrypt=false";
    private static final String USER = "sa";
    private static final String PASS = "12345";

    public DBConnection() {
    }

    public static Connection getConnection() {
        Connection conn = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=QUAN_LY_PHONG_GAME;encrypt=false", "sa", "12345");
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
