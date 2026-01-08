/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author heaaa
 */

import dao.ChatDAO;
import model.ChatMessage;
import model.Pengguna;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {

    
    private String escapeJson(String data) {
        if (data == null) return "";
        return data.replace("\"", "\\\"").replace("\n", " ");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        String idJemputStr = request.getParameter("id_penjemputan");
        
        if (idJemputStr != null) {
            int idJemput = Integer.parseInt(idJemputStr);
            ChatDAO dao = new ChatDAO();
            List<ChatMessage> chats = dao.getChatHistory(idJemput);

           
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < chats.size(); i++) {
                ChatMessage c = chats.get(i);
                json.append("{")
                    .append("\"sender_id\":").append(c.getSenderId()).append(",")
                    .append("\"sender_name\":\"").append(escapeJson(c.getSenderName())).append("\",")
                    .append("\"message\":\"").append(escapeJson(c.getMessage())).append("\",")
                    .append("\"time\":\"").append(c.getCreatedAt()).append("\"")
                    .append("}");
                if (i < chats.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int idJemput = Integer.parseInt(request.getParameter("id_penjemputan"));
            int receiverId = Integer.parseInt(request.getParameter("receiver_id"));
            String pesan = request.getParameter("message");

            ChatMessage msg = new ChatMessage();
            msg.setIdPenjemputan(idJemput);
            msg.setSenderId(user.getId()); 
            msg.setReceiverId(receiverId);
            msg.setMessage(pesan);

            ChatDAO dao = new ChatDAO();
            boolean success = dao.kirimPesan(msg);

            if (success) {
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}