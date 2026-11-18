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
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        TaiKhoanDAO dao = new TaiKhoanDAO();
        TaiKhoan tk = dao.checkLogin(user, pass);

        if (tk != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userLog", tk);

            String contextPath = request.getContextPath();
            if ("Admin".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect(contextPath + "/admin/users");
            } else if ("IT".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect(contextPath + "/it/dashboard");
            } else {
                response.sendRedirect(contextPath + "/member");
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}