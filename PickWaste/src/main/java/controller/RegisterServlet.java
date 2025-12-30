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

        // Ambil data dari form register.jsp
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // user / sampick

        PenggunaDAO dao = new PenggunaDAO();

        // Cek apakah email sudah terdaftar
        boolean emailExist = dao.isEmailExist(email);

        if (emailExist) {
            // Jika email sudah ada → kembali ke register
            response.sendRedirect("register.jsp?error=email");
        } else {
            // Simpan ke database
            boolean success = dao.insert(nama, email, password, role);

            if (success) {
                // Berhasil register → ke login
                response.sendRedirect("login.jsp?register=success");
            } else {
                // Gagal insert
                response.sendRedirect("register.jsp?error=failed");
            }
        }
    }
}

