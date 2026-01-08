/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.PenggunaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 

        PenggunaDAO dao = new PenggunaDAO();

        
        boolean emailExist = dao.isEmailExist(email);

        if (emailExist) {
            
            response.sendRedirect("register.jsp?error=email");
        } else {
            
            boolean success = dao.insert(nama, email, password, role);

            if (success) {
                
                response.sendRedirect("login.jsp?register=success");
            } else {
                
                response.sendRedirect("register.jsp?error=failed");
            }
        }
    }
}

