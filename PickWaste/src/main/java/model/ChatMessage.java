/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author heaaa
 */

public class ChatMessage {
    private int id;
    private int idPenjemputan;
    private int senderId;
    private int receiverId;
    private String message;
    private String createdAt;
    
    // Nama pengirim (opsional, untuk tampilan)
    private String senderName; 

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPenjemputan() { return idPenjemputan; }
    public void setIdPenjemputan(int idPenjemputan) { this.idPenjemputan = idPenjemputan; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
}
