/*
 * File: src/java/dao/PenggunaDAO.java
 */
package dao;

import java.sql.*;
import model.Pengguna;
import model.Masyarakat; 
import util.DBConnection;

public class PenggunaDAO {

    
    public boolean insert(String nama, String email, String password, String role) {
        String sql = "INSERT INTO pengguna (nama, email, password, role, poin) VALUES (?, ?, ?, ?, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean isEmailExist(String email) {
        String sql = "SELECT id FROM pengguna WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public Pengguna login(String email, String password) {
        Pengguna p = null;
       
        String sql = "SELECT * FROM pengguna WHERE email=? AND password=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                
                if ("user".equals(role) || "masyarakat".equals(role)) {
                    p = new Masyarakat(); 
                } else {
                    p = new Pengguna();
                }

                
                p.setId(rs.getInt("id"));
                p.setNama(rs.getString("nama"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password")); 
                p.setRole(role);
                
               
                p.setNoHp(rs.getString("no_hp"));
                p.setAlamat(rs.getString("alamat"));
                p.setPoin(rs.getInt("poin"));
                
                
                
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

   
    public boolean updateProfileFull(int id, String nama, String email, String noHp, String tglLahir, String alamat) {
        String sql = "UPDATE pengguna SET nama=?, email=?, no_hp=?, tgl_lahir=?, alamat=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, noHp);
            
            
            if (tglLahir == null || tglLahir.trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setString(4, tglLahir); 
            }
            
            ps.setString(5, alamat);
            ps.setInt(6, id);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

   
    public boolean updatePassword(int id, String passwordBaru) {
        String sql = "UPDATE pengguna SET password=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, passwordBaru);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean tambahPoin(int userId, int poinTambahan) {
        String sql = "UPDATE pengguna SET poin = poin + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poinTambahan);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
   
    public Pengguna getPenggunaById(int id) {
        Pengguna p = null;
        String sql = "SELECT * FROM pengguna WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Pengguna();
                p.setId(rs.getInt("id"));
                p.setNama(rs.getString("nama"));
                p.setEmail(rs.getString("email"));
                p.setNoHp(rs.getString("no_hp"));
                p.setAlamat(rs.getString("alamat"));
                p.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
}