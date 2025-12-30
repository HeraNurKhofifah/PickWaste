/*
 * File: src/java/dao/PenjemputanDAO.java
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Penjemputan;
import util.DBConnection;

public class PenjemputanDAO {

    // 1. TAMBAH JADWAL (Dari PenjemputanServlet)
    public boolean tambahPenjemputan(Penjemputan p) {
        String sql = "INSERT INTO penjemputan (user_id, alamat, tanggal, status, latitude, longitude, jarak_km, estimasi_harga, metode_pembayaran, berat, poin) " +
                     "VALUES (?, ?, ?, 'Pending', ?, ?, ?, ?, ?, 0, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, p.getUserId());
            ps.setString(2, p.getAlamat());
            ps.setString(3, p.getTanggal()); // Format YYYY-MM-DD HH:MM:SS
            ps.setDouble(4, p.getLatitude());
            ps.setDouble(5, p.getLongitude());
            ps.setDouble(6, p.getJarakKm());
            ps.setDouble(7, p.getEstimasiHarga());
            ps.setString(8, p.getMetodePembayaran());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. AMBIL SEMUA DATA (Untuk Dashboard Petugas)
    public List<Penjemputan> getAllPenjemputan() {
        List<Penjemputan> list = new ArrayList<>();
        String sql = "SELECT * FROM penjemputan ORDER BY tanggal DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToPenjemputan(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. AMBIL DATA BY USER ID (Untuk Dashboard User)
    public List<Penjemputan> getByUserId(int userId) {
        List<Penjemputan> list = new ArrayList<>();
        String sql = "SELECT * FROM penjemputan WHERE user_id = ? ORDER BY tanggal DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToPenjemputan(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. UPDATE: PETUGAS AMBIL ORDER
    public boolean ambilOrder(int idJemput, int idOfficer) {
        String sql = "UPDATE penjemputan SET status='Proses', officer_id=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idOfficer);
            ps.setInt(2, idJemput);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. UPDATE: PETUGAS SELESAIKAN ORDER
    public boolean selesaikanOrder(int idJemput, double berat, int poin) {
        String sql = "UPDATE penjemputan SET status='Selesai', berat=?, poin=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, berat);
            ps.setInt(2, poin);
            ps.setInt(3, idJemput);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. CARI ID USER DARI TRANSAKSI (Untuk tambah poin user)
    public int getUserIdByPenjemputan(int idJemput) {
        String sql = "SELECT user_id FROM penjemputan WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idJemput);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; 
    }

    // 7. HITUNG TOTAL POIN DARI RIWAYAT (Untuk display di dashboard user)
    public int getTotalPoin(int userId) {
        String sql = "SELECT SUM(poin) FROM penjemputan WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // --- HELPER FUNCTION (Agar tidak nulis ulang) ---
    private Penjemputan mapResultSetToPenjemputan(ResultSet rs) throws SQLException {
        Penjemputan p = new Penjemputan();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        
        int offId = rs.getInt("officer_id");
        if (!rs.wasNull()) { p.setOfficerId(offId); }
        
        p.setAlamat(rs.getString("alamat"));
        
        // Handle Tanggal (Timestamp ke String)
        Timestamp ts = rs.getTimestamp("tanggal");
        p.setTanggal(ts != null ? ts.toString().substring(0, 16) : "-"); // Ambil YYYY-MM-DD HH:MM
        
        p.setStatus(rs.getString("status"));
        p.setBerat(rs.getDouble("berat"));
        p.setPoin(rs.getInt("poin"));
        p.setLatitude(rs.getDouble("latitude"));
        p.setLongitude(rs.getDouble("longitude"));
        
        // Handle Kolom Baru (Try-Catch agar kompatibel jika kolom blm dibuat)
        try {
            p.setJarakKm(rs.getDouble("jarak_km"));
            p.setEstimasiHarga(rs.getDouble("estimasi_harga"));
            p.setMetodePembayaran(rs.getString("metode_pembayaran"));
        } catch (SQLException e) {
            // Kolom mungkin belum ada di DB, set default
            p.setJarakKm(0);
            p.setEstimasiHarga(0);
            p.setMetodePembayaran("-");
        }
        
        return p;
    }
}