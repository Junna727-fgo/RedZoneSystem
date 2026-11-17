package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/action"})
public class AdminUserController extends HttpServlet {
    private TaiKhoanDAO dao = new TaiKhoanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            if ("lock".equals(action)) {
                dao.updateTrangThai(id, 0);
            } else if ("unlock".equals(action) || "approve".equals(action)) {
                dao.updateTrangThai(id, 1);
            } else if ("delete".equals(action)) {
                dao.deleteUser(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        List<TaiKhoan> list = dao.getAllUsers();
        request.setAttribute("userList", list);
        request.getRequestDispatcher("/views/admin/user_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");

        if ("add".equals(type)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            double balance = Double.parseDouble(request.getParameter("balance"));

            TaiKhoan tk = new TaiKhoan(0, user, pass, fullName, role, 1, balance);
            dao.addUser(tk);
        } else if ("update".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            double balance = Double.parseDouble(request.getParameter("balance"));
            dao.updateUser(id, fullName, role, balance);
        } else if ("reset".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String newPass = request.getParameter("newPassword");
            dao.resetPassword(id, newPass);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}