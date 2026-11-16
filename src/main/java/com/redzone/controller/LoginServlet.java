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
        if (tk != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", tk);
            if ("Admin".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect("admin/dashboard");
            } else if ("IT".equalsIgnoreCase(tk.getRole())) {
                response.sendRedirect("views/it/it_dashboard.jsp");
            } else {
                response.sendRedirect("views/member/user_dashboard.jsp");
            }
        } else {
            response.sendRedirect("index.jsp?error=invalid");
        }
    }
}
