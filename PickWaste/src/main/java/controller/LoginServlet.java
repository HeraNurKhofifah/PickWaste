package controller;

import dao.PenggunaDAO;
import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PenggunaDAO dao = new PenggunaDAO();
        Pengguna user = dao.login(email, password);

        if (user != null) {
          
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
           
            String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "";

           
            session.setAttribute("role", role); 

          
            if ("user".equals(role) || "masyarakat".equals(role)) {
                response.sendRedirect("dashboardUser.jsp");
            } 
            else if ("petugas".equals(role) || "sampick".equals(role)) {
                response.sendRedirect("dashboardSampick.jsp");
            } 
            else {
                request.setAttribute("errorMessage", "Role akun tidak valid: " + role);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            
            request.setAttribute("errorMessage", "Email atau Password salah!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}