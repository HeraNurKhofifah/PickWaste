/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 *
 * @author heaaa
 */


public class RewardDAO {
    
    
    private String url = "jdbc:mysql://localhost:3306/pickwaste_db"; 
    private String username = "root";
    private String password = ""; 

    
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection(url, username, password);
    }


    public int getTotalPoinDitukar(int userId) {
        int total = 0;
       
        String query = "SELECT SUM(poin) AS total FROM riwayat_penukaran WHERE id_masyarakat = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

   
    public boolean tukarPoin(int userId, String rewardName, int cost) {
        String query = "INSERT INTO riwayat_penukaran (id_masyarakat, nama_reward, poin) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ps.setString(2, rewardName);
            ps.setInt(3, cost);
            
            int row = ps.executeUpdate();
            return row > 0; 
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}