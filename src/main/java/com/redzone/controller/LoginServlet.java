package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import com.redzone.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private TaiKhoanDAO dao = new TaiKhoanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String remember = request.getParameter("remember");

        String hashedPass = PasswordUtil.hashSHA256(pass);
        TaiKhoan tk = dao.checkLogin(user, hashedPass);

        if (tk != null) {
            // 1. Lưu Session (tự hết hạn sau 30 phút)
            HttpSession session = request.getSession(true);
            session.setAttribute("user", tk);
            session.setAttribute("userLog", tk);
            session.setMaxInactiveInterval(30 * 60);

            // 2. Xử lý Cookie (lưu 7 ngày nếu tích chọn, ngược lại xóa)
            String cookiePath = request.getContextPath().isEmpty() ? "/" : request.getContextPath();
            Cookie cUser = new Cookie("c_user", URLEncoder.encode(user.trim(), StandardCharsets.UTF_8));
            Cookie cRemember = new Cookie("c_remember", "true");
            cUser.setPath(cookiePath);
            cRemember.setPath(cookiePath);
            cUser.setHttpOnly(true);
            cRemember.setHttpOnly(true);

            if ("on".equals(remember)) {
                int sevenDays = 7 * 24 * 60 * 60;
                cUser.setMaxAge(sevenDays);
                cRemember.setMaxAge(sevenDays);
            } else {
                cUser.setMaxAge(0);
                cRemember.setMaxAge(0);
            }
            response.addCookie(cUser);
            response.addCookie(cRemember);

            // 3. Phân luồng theo Role
            if ("Admin".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("IT".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect(request.getContextPath() + "/it/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid");
        }
    }
}