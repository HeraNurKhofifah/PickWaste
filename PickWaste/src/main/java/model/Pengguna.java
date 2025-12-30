/*
 * File: src/model/Pengguna.java
 */
/* File: src/java/model/Pengguna.java */
package model;

public class Pengguna {
    protected int id;
    protected String nama;
    protected String email;
    protected String password;
    protected String role;
    protected String noHp;
    protected String alamat;
    protected String tglLahir; // TAMBAHAN BARU
    protected int poin;

    public Pengguna() {}

    // ... (Getter Setter Lama biarkan saja) ...

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getNoHp() { return noHp; }
    public void setNoHp(String noHp) { this.noHp = noHp; }

    public String getAlamat() { return alamat; }
    public void setAlamat(String alamat) { this.alamat = alamat; }

    public int getPoin() { return poin; }
    public void setPoin(int poin) { this.poin = poin; }

    // --- GETTER SETTER BARU ---
    public String getTglLahir() { return tglLahir; }
    public void setTglLahir(String tglLahir) { this.tglLahir = tglLahir; }
}