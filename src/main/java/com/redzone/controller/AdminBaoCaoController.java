package com.redzone.controller;

import com.redzone.dao.ThongKeDAO;
import com.redzone.model.BaoCaoGiaoDich;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/bao-cao"})
public class AdminBaoCaoController extends HttpServlet {
    private ThongKeDAO dao = new ThongKeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        double doanhThuFnB = dao.getDoanhThuFnB();
        double doanhThuNap = dao.getDoanhThuNapTien();
        double totalRevenue = doanhThuFnB + doanhThuNap;
        int totalUsers = dao.getTotalUsers();
        int totalPhong = dao.getTotalPhongMay();

        request.setAttribute("doanhThuFnB", doanhThuFnB);
        request.setAttribute("doanhThuNap", doanhThuNap);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPhong", totalPhong);

        if ("/admin/bao-cao".equals(path)) {
            List<BaoCaoGiaoDich> listGD = dao.getChiTietDoanhThu();
            request.setAttribute("listGiaoDich", listGD);
            request.getRequestDispatcher("/views/admin/bao_cao.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/admin/admin_dashboard.jsp").forward(request, response);
        }
    }
}