package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import com.redzone.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private TaiKhoanDAO dao = new TaiKhoanDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String fullName = request.getParameter("fullName");

        String hashedPass = PasswordUtil.hashSHA256(pass);
        TaiKhoan tk = new TaiKhoan(0, user, hashedPass, fullName, "Member", 2, 0.0); // 2: Chờ duyệt
        boolean success = dao.addUser(tk);
        if (success) {
            response.sendRedirect("index.jsp?success=registered");
        } else {
            response.sendRedirect("register.jsp?error=failed");
        }
    }
}