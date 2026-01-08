
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
        
        
        HttpSession session = request.getSession();
        Pengguna officer = (Pengguna) session.getAttribute("user");
        
        if (officer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        
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
            
                boolean success = jemputDao.ambilOrder(idPenjemputan, officer.getId()); 
                
                if (success) {
                    response.sendRedirect("dashboardSampick.jsp?status=taken");
                } else {
                    response.sendRedirect("dashboardSampick.jsp?status=failed");
                }
                
            } else if ("selesai".equals(action)) {
                
                String beratStr = request.getParameter("berat");
                if(beratStr == null || beratStr.isEmpty()) beratStr = "0";
                double berat = Double.parseDouble(beratStr);
                
                
                int poinUser = (int) (berat * 500);
                
               
                boolean taskSuccess = jemputDao.selesaikanOrder(idPenjemputan, berat, poinUser);
                
                if (taskSuccess) {
                    
                    int idUserPemilik = jemputDao.getUserIdByPenjemputan(idPenjemputan);
                    
                    
                    if(idUserPemilik > 0) {
                        userDao.tambahPoin(idUserPemilik, poinUser);
                    }

                   
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