/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller;

import dao.RewardDAO;
import dao.PenjemputanDAO; 
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
            
            int userId = Integer.parseInt(request.getParameter("userId"));
            int cost = Integer.parseInt(request.getParameter("cost"));
            String rewardName = request.getParameter("rewardName");
            
            PenjemputanDAO dao = new PenjemputanDAO();
            RewardDAO rewardDAO = new RewardDAO();
            
            
            int totalMasuk = dao.getTotalPoin(userId);
            int totalKeluar = rewardDAO.getTotalPoinDitukar(userId);
            int currentBalance = totalMasuk - totalKeluar;
            
            
            if (currentBalance >= cost) {
                
                boolean success = rewardDAO.tukarPoin(userId, rewardName, cost);
                
                if(success) {
                    
                    response.sendRedirect("dashboardUser.jsp?status=redeemSuccess");
                } else {
                   
                    response.sendRedirect("dashboardUser.jsp?status=errorDB");
                }
            } else {
               
                response.sendRedirect("dashboardUser.jsp?status=notEnoughPoints");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            response.sendRedirect("dashboardUser.jsp?status=error");
        }
    }
}