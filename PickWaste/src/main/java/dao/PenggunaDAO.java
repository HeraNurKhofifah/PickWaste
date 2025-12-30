/*
 * File: src/java/dao/PenggunaDAO.java
 */
package dao;

import java.sql.*;
import model.Pengguna;
import model.Masyarakat; // PENTING: Import ini wajib ada untuk Login User
import util.DBConnection;

public class PenggunaDAO {

    // --- 1. REGISTER (Insert Data Baru) ---
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

    // --- 2. CEK EMAIL (Validasi Register) ---
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

    // --- 3. LOGIN (DIPERBARUI: Mengambil Data Lengkap) ---
    public Pengguna login(String email, String password) {
        Pengguna p = null;
        // Query mengambil semua kolom termasuk data profil tambahan
        String sql = "SELECT * FROM pengguna WHERE email=? AND password=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                // Casting Objek sesuai Role (Penting untuk Dashboard User)
                if ("user".equals(role) || "masyarakat".equals(role)) {
                    p = new Masyarakat(); 
                } else {
                    p = new Pengguna();
                }

                // Set Data Utama
                p.setId(rs.getInt("id"));
                p.setNama(rs.getString("nama"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password")); // Disimpan untuk validasi ganti pass
                p.setRole(role);
                
                // Set Data Profil Tambahan (Handle nilai NULL dari database)
                p.setNoHp(rs.getString("no_hp"));
                p.setAlamat(rs.getString("alamat"));
                p.setPoin(rs.getInt("poin"));
                
                // Handle Tanggal Lahir (Jika ada kolom tgl_lahir di DB)
                try {
                    Date tgl = rs.getDate("tgl_lahir");
                    if (tgl != null) {
                        p.setTglLahir(tgl.toString());
                    } else {
                        p.setTglLahir(""); 
                    }
                } catch (SQLException ex) {
                    // Jika kolom tgl_lahir belum dibuat di DB, abaikan agar tidak error total
                    System.out.println("Kolom tgl_lahir belum ada: " + ex.getMessage());
                    p.setTglLahir("");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    // --- 4. UPDATE PROFIL LENGKAP (FITUR BARU) ---
    // Digunakan di menu Settings -> Profil Pengguna
    public boolean updateProfileFull(int id, String nama, String email, String noHp, String tglLahir, String alamat) {
        String sql = "UPDATE pengguna SET nama=?, email=?, no_hp=?, tgl_lahir=?, alamat=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, noHp);
            
            // Handle Tanggal Lahir (Jika kosong, set NULL di database)
            if (tglLahir == null || tglLahir.trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setString(4, tglLahir); // Format string yyyy-MM-dd diterima MySQL
            }
            
            ps.setString(5, alamat);
            ps.setInt(6, id);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 5. GANTI PASSWORD ---
    // Digunakan di menu Settings -> Keamanan Akun
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

    // --- 6. TAMBAH POIN ---
    // Digunakan saat Petugas menyelesaikan tugas
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
}