package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String cccd = request.getParameter("cccd");

        TaiKhoanDAO dao = new TaiKhoanDAO();

        if (dao.checkUserExist(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (dao.registerUser(username, password, hoTen, sdt, cccd)) {
            request.setAttribute("msg", "Đăng ký thành công! Hãy đăng nhập.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi lưu Database!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}