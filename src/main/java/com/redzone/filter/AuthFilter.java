package com.redzone.filter;

import com.redzone.model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/views/*") // Chặn mọi request đi vào thư mục views
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        TaiKhoan tk = (TaiKhoan) session.getAttribute("userLog");
        String uri = req.getRequestURI();

        // 1. Chưa đăng nhập -> Đuổi về trang chủ
        if (tk == null) {
            req.setAttribute("error", "Bạn phải đăng nhập để xem trang này!");
            req.getRequestDispatcher("/index.jsp").forward(req, res);
            return;
        }

        // 2. Đã đăng nhập nhưng đi sai Role -> Đuổi về Dashboard của họ
        if (uri.contains("/admin/") && !tk.getRole().equals("Admin")) {
            res.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        if (uri.contains("/it/") && !tk.getRole().equals("IT") && !tk.getRole().equals("Admin")) {
            res.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        chain.doFilter(request, response); // Hợp lệ thì cho đi tiếp
    }
}