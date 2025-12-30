/*
 * File: src/java/controller/OfficerActionServlet.java
 * Description: Menangani aksi Petugas (Ambil Order & Selesai Order + Hitung Poin User)
 */
package controller;

import dao.PenjemputanDAO;
import dao.PenggunaDAO;
import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "OfficerActionServlet", urlPatterns = {"/OfficerActionServlet"})
public class OfficerActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Sesi Petugas (Siapa yang sedang login?)
        HttpSession session = request.getSession();
        Pengguna officer = (Pengguna) session.getAttribute("user");
        
        if (officer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        // Validasi ID Penjemputan
        String idParam = request.getParameter("id_penjemputan");
        if(idParam == null || idParam.isEmpty()) {
            response.sendRedirect("dashboardSampick.jsp?status=error");
            return;
        }
        int idPenjemputan = Integer.parseInt(idParam);

        PenjemputanDAO jemputDao = new PenjemputanDAO();
        PenggunaDAO userDao = new PenggunaDAO();
        
        try {
            if ("ambil".equals(action)) {
                // --- KASUS 1: AMBIL ORDER ---
                // Simpan ID Petugas ke data penjemputan agar bisa Chat
                boolean success = jemputDao.ambilOrder(idPenjemputan, officer.getId()); 
                
                if (success) {
                    response.sendRedirect("dashboardSampick.jsp?status=taken");
                } else {
                    response.sendRedirect("dashboardSampick.jsp?status=failed");
                }
                
            } else if ("selesai".equals(action)) {
                // --- KASUS 2: SELESAIKAN ORDER ---
                
                // Ambil berat dari input form
                String beratStr = request.getParameter("berat");
                if(beratStr == null || beratStr.isEmpty()) beratStr = "0";
                double berat = Double.parseDouble(beratStr);
                
                // --- HITUNG POIN UNTUK USER (Masyarakat) ---
                // Rumus: 1 kg = 500 Poin
                int poinUser = (int) (berat * 500);
                
                // 1. Update Data Penjemputan (Set Status='Selesai', Berat, & Poin Transaksi)
                boolean taskSuccess = jemputDao.selesaikanOrder(idPenjemputan, berat, poinUser);
                
                if (taskSuccess) {
                    // 2. Cari Siapa Pemilik Sampah (User ID)
                    int idUserPemilik = jemputDao.getUserIdByPenjemputan(idPenjemputan);
                    
                    // 3. Tambahkan Poin ke Saldo User Pemilik Sampah
                    if(idUserPemilik > 0) {
                        userDao.tambahPoin(idUserPemilik, poinUser);
                    }

                    // Redirect Berhasil 
                    response.sendRedirect("dashboardSampick.jsp?status=finished");
                } else {
                    response.sendRedirect("dashboardSampick.jsp?status=error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboardSampick.jsp?status=error");
        }
    }
}