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
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                dao.deleteDichVu(Integer.parseInt(idStr.trim()));
            }
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
            return;
        } else if ("seedGear".equals(action)) {
            // Nạp nhanh 6 mẫu Gaming Gear mặc định đồng bộ với MemberPortalServlet
            dao.addDichVu(new DichVu(0, "Chuột Logitech G Pro X Superlight", 15000, 10, "GEAR"));
            dao.addDichVu(new DichVu(0, "Chuột Razer DeathAdder V3 Pro", 15000, 8, "GEAR"));
            dao.addDichVu(new DichVu(0, "Bàn phím cơ Corsair K70 RGB", 15000, 10, "GEAR"));
            dao.addDichVu(new DichVu(0, "Bàn phím cơ Wooting 60HE (Rapid Trigger)", 25000, 5, "GEAR"));
            dao.addDichVu(new DichVu(0, "Tai nghe HyperX Cloud II Wireless", 10000, 12, "GEAR"));
            dao.addDichVu(new DichVu(0, "Combo Chuột G Pro X + Phím Wooting 60HE", 35000, 5, "GEAR"));
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=gear");
            return;
        }

        List<DichVu> allList = dao.getAllDichVu();
        List<DichVu> monLeList = new ArrayList<>();
        List<DichVu> comboList = new ArrayList<>();
        List<DichVu> gearList = new ArrayList<>();

        for (DichVu dv : allList) {
            if ("COMBO".equalsIgnoreCase(dv.getDanhMuc())) {
                comboList.add(dv);
            } else if ("GEAR".equalsIgnoreCase(dv.getDanhMuc())) {
                gearList.add(dv);
            } else {
                monLeList.add(dv);
            }
        }

        request.setAttribute("dichVuList", monLeList);
        request.setAttribute("comboList", comboList);
        request.setAttribute("gearList", gearList);
        request.getRequestDispatcher("/views/admin/dich_vu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");
        String danhMuc = request.getParameter("danhMuc");

        if ("add".equals(type)) {
            String tenMon = request.getParameter("tenMon");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));

            DichVu dv = new DichVu(0, tenMon, gia, soLuongTon, danhMuc);
            dao.addDichVu(dv);
        } else if ("update".equals(type)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                String tenMon = request.getParameter("tenMon");
                double gia = Double.parseDouble(request.getParameter("gia"));
                int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));

                DichVu dv = new DichVu(id, tenMon, gia, soLuongTon, danhMuc);
                dao.updateDichVu(dv);
            }
        }

        if ("GEAR".equalsIgnoreCase(danhMuc)) {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=gear");
        } else if ("COMBO".equalsIgnoreCase(danhMuc)) {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu?tab=combo");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dich-vu");
        }
    }
}