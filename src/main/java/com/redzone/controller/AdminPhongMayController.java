package com.redzone.controller;

import com.redzone.dao.PhongMayDAO;
import com.redzone.model.Phong;
import com.redzone.model.PhongMay;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/phong-may", "/admin/phong-may/action"})
public class AdminPhongMayController extends HttpServlet {
    private PhongMayDAO dao = new PhongMayDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("deleteMay".equals(action) || "delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deletePhongMay(id);
            response.sendRedirect(request.getContextPath() + "/admin/phong-may");
            return;
        } else if ("deletePhong".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deletePhong(id);
            response.sendRedirect(request.getContextPath() + "/admin/phong-may");
            return;
        }

        List<PhongMay> listMay = dao.getAllPhongMay();
        List<Phong> listPhong = dao.getAllPhong();
        request.setAttribute("phongMayList", listMay);
        request.setAttribute("phongList", listPhong);
        request.getRequestDispatcher("/views/admin/phong_may.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");

        if ("addMay".equals(type)) {
            int maPhong = Integer.parseInt(request.getParameter("maPhong"));
            String tenMay = request.getParameter("tenMay");
            String trangThai = request.getParameter("trangThai");
            dao.addMayTram(maPhong, tenMay, trangThai);
        } else if ("updateMay".equals(type)) {
            int maMay = Integer.parseInt(request.getParameter("maMay"));
            int maPhong = Integer.parseInt(request.getParameter("maPhong"));
            String tenMay = request.getParameter("tenMay");
            String trangThai = request.getParameter("trangThai");
            dao.updateMayTram(maMay, maPhong, tenMay, trangThai);
        } else if ("addPhong".equals(type)) {
            String tenPhong = request.getParameter("tenPhong");
            double donGia = Double.parseDouble(request.getParameter("donGia"));
            String moTa = request.getParameter("moTa");
            dao.addPhong(tenPhong, donGia, moTa);
        } else if ("updatePhong".equals(type)) {
            int maPhong = Integer.parseInt(request.getParameter("maPhong"));
            String tenPhong = request.getParameter("tenPhong");
            double donGia = Double.parseDouble(request.getParameter("donGia"));
            String moTa = request.getParameter("moTa");
            dao.updatePhong(maPhong, tenPhong, donGia, moTa);
        }
        response.sendRedirect(request.getContextPath() + "/admin/phong-may");
    }
}