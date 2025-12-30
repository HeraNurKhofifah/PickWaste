/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller;

import dao.RewardDAO;
import dao.PenjemputanDAO; // Kita butuh ini untuk cek total poin masuk
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 *
 * @author heaaa
 */


@WebServlet(name = "RedeemServlet", urlPatterns = {"/RedeemServlet"})
public class RedeemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Ambil data yang dikirim dari form Dashboard
            int userId = Integer.parseInt(request.getParameter("userId"));
            int cost = Integer.parseInt(request.getParameter("cost"));
            String rewardName = request.getParameter("rewardName");
            
            PenjemputanDAO dao = new PenjemputanDAO();
            RewardDAO rewardDAO = new RewardDAO();
            
            // 2. Cek Saldo Poin Terkini (Poin Masuk - Poin Keluar)
            int totalMasuk = dao.getTotalPoin(userId);
            int totalKeluar = rewardDAO.getTotalPoinDitukar(userId);
            int currentBalance = totalMasuk - totalKeluar;
            
            // 3. Validasi: Apakah poin cukup?
            if (currentBalance >= cost) {
                // Jika Cukup: Simpan transaksi ke database
                boolean success = rewardDAO.tukarPoin(userId, rewardName, cost);
                
                if(success) {
                    // Berhasil: Balik ke dashboard dengan pesan sukses
                    response.sendRedirect("dashboardUser.jsp?status=redeemSuccess");
                } else {
                    // Gagal simpan ke DB
                    response.sendRedirect("dashboardUser.jsp?status=errorDB");
                }
            } else {
                // Jika Poin Tidak Cukup
                response.sendRedirect("dashboardUser.jsp?status=notEnoughPoints");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Jika ada error lain (misal koneksi putus)
            response.sendRedirect("dashboardUser.jsp?status=error");
        }
    }
}