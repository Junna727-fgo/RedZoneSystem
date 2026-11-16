package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        TaiKhoanDAO dao = new TaiKhoanDAO();
        TaiKhoan tk = dao.checkLogin(user, pass);

        if (tk != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userLog", tk); // Lưu session

            // Điều hướng theo Role
            if (tk.getRole().equals("Admin")) response.sendRedirect("views/admin/admin_dashboard.jsp");
            else if (tk.getRole().equals("IT")) response.sendRedirect("views/it/it_dashboard.jsp");
            else response.sendRedirect("views/member/user_dashboard.jsp");
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}