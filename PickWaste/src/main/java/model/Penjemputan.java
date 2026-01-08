/*
 * File: src/java/model/Penjemputan.java
 */
package model;

public class Penjemputan {
    private int id;
    private int userId;
    private int officerId;       
    private String alamat;
    private String tanggal;
    private String status;
    private double berat;
    private int poin;
    private double latitude;
    private double longitude;
    
    
    private double jarakKm;       
    private double estimasiHarga;  
    private String metodePembayaran; 

    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getOfficerId() { return officerId; }
    public void setOfficerId(int officerId) { this.officerId = officerId; }

    public String getAlamat() { return alamat; }
    public void setAlamat(String alamat) { this.alamat = alamat; }

    public String getTanggal() { return tanggal; }
    public void setTanggal(String tanggal) { this.tanggal = tanggal; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getBerat() { return berat; }
    public void setBerat(double berat) { this.berat = berat; }

    public int getPoin() { return poin; }
    public void setPoin(int poin) { this.poin = poin; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    
    public double getJarakKm() { return jarakKm; }
    public void setJarakKm(double jarakKm) { this.jarakKm = jarakKm; }

    public double getEstimasiHarga() { return estimasiHarga; }
    public void setEstimasiHarga(double estimasiHarga) { this.estimasiHarga = estimasiHarga; }

    public String getMetodePembayaran() { return metodePembayaran; }
    public void setMetodePembayaran(String metodePembayaran) { this.metodePembayaran = metodePembayaran; }
}