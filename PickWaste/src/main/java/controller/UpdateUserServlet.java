/* File: src/java/controller/UpdateUserServlet.java */
package controller;

import dao.PenggunaDAO;
import model.Pengguna; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/UpdateUserServlet"})
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        
        Pengguna user = (Pengguna) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        PenggunaDAO dao = new PenggunaDAO();
        String role = (String) session.getAttribute("role");
        String redirectPage = "user".equals(role) ? "dashboardUser.jsp" : "dashboardSampick.jsp";

        if ("updateProfile".equals(action)) {
          
            String nama = request.getParameter("nama");
            String email = request.getParameter("email");
            String noHp = request.getParameter("no_hp");
            String alamat = request.getParameter("alamat");
            String tglLahir = request.getParameter("tgl_lahir"); 

       
            boolean success = dao.updateProfileFull(user.getId(), nama, email, noHp, tglLahir, alamat);
            
            if (success) {
                
                user.setNama(nama);
                user.setEmail(email);
                user.setNoHp(noHp);
                user.setAlamat(alamat);
              
                
                session.setAttribute("user", user); 
                response.sendRedirect(redirectPage + "?status=profileUpdated");
            } else {
                response.sendRedirect(redirectPage + "?status=error");
            }

        } else if ("changePassword".equals(action)) {
            
            String passLama = request.getParameter("passwordLama");
            String passBaru = request.getParameter("passwordBaru");
            
           
            if (!user.getPassword().equals(passLama)) {
                response.sendRedirect(redirectPage + "?status=wrongOldPass");
                return;
            }


            boolean success = dao.updatePassword(user.getId(), passBaru);
            
            if (success) {
                user.setPassword(passBaru);
                session.setAttribute("user", user);
                response.sendRedirect(redirectPage + "?status=passUpdated");
            } else {
                response.sendRedirect(redirectPage + "?status=error");
            }
        }
    }
}