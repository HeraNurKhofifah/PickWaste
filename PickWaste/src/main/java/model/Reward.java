/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author heaaa
 */
public class Reward {
    private int id;
    private int userId;
    private String namaReward;
    private int poinTukar;
    private String tanggal;

   
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getNamaReward() { return namaReward; }
    public void setNamaReward(String namaReward) { this.namaReward = namaReward; }
    
    public int getPoinTukar() { return poinTukar; }
    public void setPoinTukar(int poinTukar) { this.poinTukar = poinTukar; }
    
    public String getTanggal() { return tanggal; }
    public void setTanggal(String tanggal) { this.tanggal = tanggal; }
}
