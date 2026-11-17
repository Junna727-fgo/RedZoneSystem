package com.redzone.controller;

import com.redzone.dao.ITManagementDAO;
import com.redzone.model.BienBanBaoTri;
import com.redzone.model.TaiKhoan;
import com.redzone.model.ThietBiPhanCung;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
@WebServlet("/it/dashboard")
public class ITDashboardController extends HttpServlet {
    private final ITManagementDAO itDAO = new ITManagementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nạp dữ liệu hiển thị lên giao diện IT
        request.setAttribute("listMayTram", itDAO.getAllMayTram());
        request.setAttribute("listThietBi", itDAO.getAllThietBi());
        request.setAttribute("listBienBan", itDAO.getAllBienBan());

        request.getRequestDispatcher("/views/it/it_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        HttpSession session = request.getSession(false);
        TaiKhoan currentUser = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;
        int maTKLap = (currentUser != null) ? currentUser.getMaTK() : 1; // Lấy MaTK của IT đang đăng nhập

        if ("updateMayStatus".equals(action)) {
            int maMay = Integer.parseInt(request.getParameter("maMay"));
            String trangThai = request.getParameter("trangThai");
            itDAO.updateTrangThaiMay(maMay, trangThai);

        } else if ("addThietBi".equals(action)) {
            ThietBiPhanCung tb = new ThietBiPhanCung();
            tb.setMaMay(Integer.parseInt(request.getParameter("maMay")));
            tb.setTenThietBi(request.getParameter("tenThietBi"));
            tb.setSoSerial(request.getParameter("soSerial"));
            tb.setTinhTrang(request.getParameter("tinhTrang"));
            tb.setMoTaSuCo(request.getParameter("moTaSuCo"));
            itDAO.addThietBi(tb);

        } else if ("updateThietBi".equals(action)) {
            int maThietBi = Integer.parseInt(request.getParameter("maThietBi"));
            String tinhTrang = request.getParameter("tinhTrang");
            String moTaSuCo = request.getParameter("moTaSuCo");
            itDAO.updateTinhTrangThietBi(maThietBi, tinhTrang, moTaSuCo);

        } else if ("lapBienBan".equals(action)) {
            BienBanBaoTri bb = new BienBanBaoTri();
            bb.setMaMay(Integer.parseInt(request.getParameter("maMay")));
            String maTBStr = request.getParameter("maThietBi");
            bb.setMaThietBi((maTBStr != null && !maTBStr.isEmpty()) ? Integer.parseInt(maTBStr) : null);
            bb.setMaTKLap(maTKLap);
            bb.setMoTaSuCo(request.getParameter("moTaSuCo"));
            bb.setChiPhi(Double.parseDouble(request.getParameter("chiPhi")));
            itDAO.lapBienBanBaoTri(bb);

        } else if ("hoanTatBaoTri".equals(action)) {
            int maBienBan = Integer.parseInt(request.getParameter("maBienBan"));
            int maMay = Integer.parseInt(request.getParameter("maMay"));
            double chiPhi = Double.parseDouble(request.getParameter("chiPhi"));
            itDAO.hoanTatBaoTri(maBienBan, maMay, chiPhi);
        }

        response.sendRedirect(request.getContextPath() + "/it/dashboard");
    }
}