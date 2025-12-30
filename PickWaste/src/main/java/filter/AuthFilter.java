/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

// PERBAIKAN 1: Tambahkan .jsp pada dashboardSampick
@WebFilter(urlPatterns = { "/dashboardUser.jsp", "/dashboardSampick.jsp" })
public class AuthFilter implements Filter { // PERBAIKAN 2: Hapus kata kunci 'abstract'

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Method ini wajib ada untuk javax.servlet.Filter, meski kosong
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        // 1. Cek apakah session ada
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // 2. Ambil Role
        String role = (String) session.getAttribute("role"); // role isinya "user" atau "sampick"
        String uri = req.getRequestURI();

        // 3. Proteksi Halaman User
        // PERBAIKAN 3: Ganti "role" menjadi "user" sesuai database/register
        if (uri.contains("dashboardUser.jsp") && !role.equals("user")) {
            res.sendRedirect("login.jsp"); // Salah kamar, tendang keluar
            return;
        }

        // 4. Proteksi Halaman Petugas (Sampick)
        if (uri.contains("dashboardSampick.jsp") && !role.equals("sampick")) {
            res.sendRedirect("login.jsp");
            return;
        }

        // Lolos validasi, lanjut ke halaman tujuan
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Method ini wajib ada untuk javax.servlet.Filter, meski kosong
    }
}