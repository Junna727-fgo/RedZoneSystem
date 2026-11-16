package com.redzone.controller;

import com.redzone.dao.DichVuDAO;
import com.redzone.model.DichVu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/dich-vu", "/admin/dich-vu/action"})
public class AdminDichVuController extends HttpServlet {
    private DichVuDAO dao = new DichVuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteDichVu(id);
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
            return;
        }

        List<DichVu> allList = dao.getAllDichVu();
        List<DichVu> monLeList = new ArrayList<>();
        List<DichVu> comboList = new ArrayList<>();

        for (DichVu dv : allList) {
            if ("COMBO".equalsIgnoreCase(dv.getDanhMuc())) {
                comboList.add(dv);
            } else {
                monLeList.add(dv);
            }
        }

        request.setAttribute("dichVuList", monLeList);
        request.setAttribute("comboList", comboList);
        request.getRequestDispatcher("/views/admin/dich_vu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");

        if ("add".equals(type)) {
            String tenMon = request.getParameter("tenMon");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            String danhMuc = request.getParameter("danhMuc");

            DichVu dv = new DichVu(0, tenMon, gia, soLuongTon, danhMuc);
            dao.addDichVu(dv);
        } else if ("update".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String tenMon = request.getParameter("tenMon");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            String danhMuc = request.getParameter("danhMuc");

            DichVu dv = new DichVu(id, tenMon, gia, soLuongTon, danhMuc);
            dao.updateDichVu(dv);
        }
        response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
    }
}