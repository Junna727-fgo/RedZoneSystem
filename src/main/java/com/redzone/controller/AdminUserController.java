package com.redzone.controller;

import com.redzone.dao.TaiKhoanDAO;
import com.redzone.model.TaiKhoan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TaiKhoanDAO dao = new TaiKhoanDAO();
        String action = request.getParameter("action");

        // Xử lý thao tác Khóa / Mở Khóa / Xóa của Admin
        if (action != null) {
            int id = Integer.parseInt(request.getParameter("id"));

            if (action.equals("lock")) {
                dao.updateTrangThaiTaiKhoan(id, "LOCKED");
            } else if (action.equals("unlock")) {
                dao.updateTrangThaiTaiKhoan(id, "ACTIVE");
            } else if (action.equals("delete")) {
                dao.deleteTaiKhoan(id);
            }

            // Xong việc thì tự động tải lại trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // Nếu không có thao tác gì -> Chỉ lấy danh sách hiển thị
        List<TaiKhoan> list = dao.getAllTaiKhoan();
        request.setAttribute("danhSachUser", list);
        request.getRequestDispatcher("/views/admin/user_list.jsp").forward(request, response);
    }
}