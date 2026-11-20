package com.redzone.filter;

import com.redzone.model.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String path = req.getRequestURI().substring(contextPath.length());

        // 1. Cho phép truy cập trang công khai và tài nguyên tĩnh
        boolean isPublic = path.isEmpty() || path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/register.jsp")
                || path.equals("/logout")
                || path.startsWith("/assets/")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.endsWith(".css") || path.endsWith(".js")
                || path.endsWith(".png") || path.endsWith(".jpg")
                || path.endsWith(".jpeg") || path.endsWith(".gif")
                || path.endsWith(".svg") || path.endsWith(".ico")
                || path.endsWith(".woff") || path.endsWith(".woff2");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Chặn cache trình duyệt (đăng xuất rồi bấm Back sẽ không xem lại được trang cũ)
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        // 3. Kiểm tra Session đăng nhập
        HttpSession session = req.getSession(false);
        TaiKhoan tk = null;
        if (session != null) {
            tk = (TaiKhoan) session.getAttribute("user");
            if (tk == null) {
                tk = (TaiKhoan) session.getAttribute("userLog");
            }
        }

        if (tk == null) {
            res.sendRedirect(contextPath + "/index.jsp?error=login_required");
            return;
        }

        // 4. Kiểm tra phân quyền (Role-based Access Control)
        String role = tk.getRole() != null ? tk.getRole().trim() : "";

        boolean isAdminPath = path.equals("/admin")
                || path.startsWith("/admin/")
                || path.startsWith("/views/admin/");

        boolean isItPath = path.equals("/it")
                || path.startsWith("/it/")
                || path.startsWith("/views/it/");

        boolean isMemberPath = path.equals("/profile")
                || path.equals("/profile.jsp")
                || path.startsWith("/member/")
                || path.startsWith("/user/")
                || path.startsWith("/views/member/")
                || path.startsWith("/views/user/");

        if (isAdminPath && !"Admin".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/index.jsp?error=unauthorized");
            return;
        }

        if (isItPath && !"IT".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/index.jsp?error=unauthorized");
            return;
        }

        if (isMemberPath && !"Member".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/index.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }
}