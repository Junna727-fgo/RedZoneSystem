package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private TaiKhoanDAO dao = new TaiKhoanDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        TaiKhoan tk = dao.checkLogin(user, pass);
        if ("Admin".equalsIgnoreCase(tk.getRole())) {
            // Gọi đến Admin Controller
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } else if ("IT".equalsIgnoreCase(tk.getRole())) {
            // SỬA Ở ĐÂY: Gọi đến IT Dashboard Controller thay vì file .jsp
            response.sendRedirect(request.getContextPath() + "/it/dashboard");

        } else {
            // SỬA LUÔN Ở ĐÂY: Gọi đến User/Member Controller
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
    }
}
