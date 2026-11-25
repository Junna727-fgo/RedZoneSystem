package com.redzone.controller;

import com.redzone.dao.UserDAO;
import com.redzone.model.QrPaymentOrder;
import com.redzone.util.VietQRConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminQrApprovalController", urlPatterns = {"/admin/duyet-qr"})
public class AdminQrApprovalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        if (status == null || status.isEmpty()) status = "PENDING";
        if (type == null || type.isEmpty()) type = "ALL";

        UserDAO userDAO = new UserDAO();
        List<QrPaymentOrder> paymentList = userDAO.getPaymentOrdersForAdmin(status, type);
        List<QrPaymentOrder> allPending = userDAO.getPaymentOrdersForAdmin("PENDING", "ALL");

        int pendingCount = allPending.size();
        int pendingTopUp = 0;
        int pendingService = 0;
        BigDecimal pendingTotalAmount = BigDecimal.ZERO;

        for (QrPaymentOrder o : allPending) {
            if (o.getFinalAmount() != null) {
                pendingTotalAmount = pendingTotalAmount.add(o.getFinalAmount());
            }
            if ("TOPUP".equalsIgnoreCase(o.getPromoCode())) {
                pendingTopUp++;
            } else {
                pendingService++;
            }
        }

        request.setAttribute("paymentList", paymentList);
        request.setAttribute("currentStatus", status);
        request.setAttribute("currentType", type);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("pendingTopUp", pendingTopUp);
        request.setAttribute("pendingService", pendingService);
        request.setAttribute("pendingTotalAmount", pendingTotalAmount);

        request.setAttribute("bankId", VietQRConfig.BANK_ID);
        request.setAttribute("bankName", VietQRConfig.BANK_NAME);
        request.setAttribute("accountNo", VietQRConfig.ACCOUNT_NO);
        request.setAttribute("accountName", VietQRConfig.ACCOUNT_NAME);

        request.getRequestDispatcher("/views/admin/duyet_qr.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String orderIdRaw = request.getParameter("orderId");
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        if (status == null || status.isEmpty()) status = "PENDING";
        if (type == null || type.isEmpty()) type = "ALL";

        UserDAO userDAO = new UserDAO();
        String resultParam = "failed";

        try {
            int orderId = Integer.parseInt(orderIdRaw);
            if ("approve".equalsIgnoreCase(action)) {
                if (userDAO.approvePaymentOrder(orderId)) {
                    resultParam = "approved";
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                if (userDAO.rejectPaymentOrder(orderId)) {
                    resultParam = "rejected";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/admin/duyet-qr?status=" + status + "&type=" + type + "&msg=" + resultParam);
    }
}