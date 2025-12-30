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
    
    // ⚠️ PENTING: Sesuaikan username & password database kamu di sini
    private String url = "jdbc:mysql://localhost:3306/pickwaste_db"; 
    private String username = "root";
    private String password = ""; 

    // Helper untuk koneksi ke database
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection(url, username, password);
    }

    // 1. HITUNG TOTAL POIN KELUAR (YANG SUDAH DITUKAR)
    // Ini dipakai di Dashboard untuk menghitung sisa saldo (Total Masuk - Total Keluar)
    public int getTotalPoinDitukar(int userId) {
        int total = 0;
        // Pastikan nama kolom 'id_masyarakat' sesuai dengan yang kamu buat di tabel riwayat_penukaran
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

    // 2. PROSES TUKAR POIN (SIMPAN KE DB)
    // Ini dipanggil saat tombol "Tukar" diklik
    public boolean tukarPoin(int userId, String rewardName, int cost) {
        String query = "INSERT INTO riwayat_penukaran (id_masyarakat, nama_reward, poin) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ps.setString(2, rewardName);
            ps.setInt(3, cost);
            
            int row = ps.executeUpdate();
            return row > 0; // Berhasil jika ada baris data baru yang masuk
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}