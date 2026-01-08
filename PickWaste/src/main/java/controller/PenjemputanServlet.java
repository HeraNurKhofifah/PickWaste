/*
 * File: src/java/controller/PenjemputanServlet.java
 */
package controller;

import dao.PenjemputanDAO;
import model.Penjemputan;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "PenjemputanServlet", urlPatterns = {"/PenjemputanServlet"})
public class PenjemputanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String userIdStr = request.getParameter("userId");
        String alamat = request.getParameter("alamat");
        String tanggalRaw = request.getParameter("tanggal");
        String latStr = request.getParameter("latitude");
        String longStr = request.getParameter("longitude");
        
        
        String jarakStr = request.getParameter("jarak_km");
        String hargaStr = request.getParameter("estimasi_harga");
        String metode = "Tunai"; 

      
        String tanggalFinal = "";
        if (tanggalRaw != null && !tanggalRaw.isEmpty()) {
            tanggalFinal = tanggalRaw.replace("T", " ") + ":00"; 
        }

        int userId = 0;
        double latitude = 0.0;
        double longitude = 0.0;
        double jarak = 0.0;
        double harga = 0.0;

        try {
            userId = Integer.parseInt(userIdStr);
            if (latStr != null && !latStr.isEmpty()) latitude = Double.parseDouble(latStr);
            if (longStr != null && !longStr.isEmpty()) longitude = Double.parseDouble(longStr);
            if (jarakStr != null && !jarakStr.isEmpty()) jarak = Double.parseDouble(jarakStr);
            if (hargaStr != null && !hargaStr.isEmpty()) harga = Double.parseDouble(hargaStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        
        Penjemputan p = new Penjemputan();
        p.setUserId(userId);
        p.setAlamat(alamat);
        p.setTanggal(tanggalFinal);
        p.setLatitude(latitude);
        p.setLongitude(longitude);
        

        p.setJarakKm(jarak);
        p.setEstimasiHarga(harga);
        p.setMetodePembayaran(metode);

      
        PenjemputanDAO dao = new PenjemputanDAO();
        boolean success = dao.tambahPenjemputan(p);

        if (success) {
            response.sendRedirect("dashboardUser.jsp?status=success");
        } else {
            response.sendRedirect("dashboardUser.jsp?status=failed");
        }
    }
}