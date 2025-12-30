/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author heaaa
 */


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ChatMessage;
import util.DBConnection;

public class ChatDAO {

    // 1. Kirim Pesan
    public boolean kirimPesan(ChatMessage msg) {
        String sql = "INSERT INTO chat_messages (id_penjemputan, sender_id, receiver_id, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, msg.getIdPenjemputan());
            ps.setInt(2, msg.getSenderId());
            ps.setInt(3, msg.getReceiverId());
            ps.setString(4, msg.getMessage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Ambil Riwayat Chat berdasarkan ID Penjemputan
    public List<ChatMessage> getChatHistory(int idPenjemputan) {
        List<ChatMessage> list = new ArrayList<>();
        // Join dengan tabel pengguna untuk dapat nama pengirim
        String sql = "SELECT c.*, p.nama FROM chat_messages c " +
                     "JOIN pengguna p ON c.sender_id = p.id " +
                     "WHERE c.id_penjemputan = ? ORDER BY c.created_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenjemputan);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChatMessage m = new ChatMessage();
                m.setId(rs.getInt("id"));
                m.setIdPenjemputan(rs.getInt("id_penjemputan"));
                m.setSenderId(rs.getInt("sender_id"));
                m.setReceiverId(rs.getInt("receiver_id"));
                m.setMessage(rs.getString("message"));
                m.setCreatedAt(rs.getString("created_at")); // Timestamp to String
                m.setSenderName(rs.getString("nama"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}