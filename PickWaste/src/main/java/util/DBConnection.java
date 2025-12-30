package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection{
    public static Connection getConnection(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            String url ="jdbc:mysql://localhost:3306/pickwaste_db?useSSL=false&serverTimezone=Asia/Jakarta&allowPublicKeyRetrieval=true";
            String user ="root";
            String password ="";
            
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e){
            System.out.println("Koneksi gagal :"+ e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}