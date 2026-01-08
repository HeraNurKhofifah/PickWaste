<%-- 
    Document    : dashboardUser
    Description : USER DASHBOARD 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Masyarakat" %>
<%@page import="model.Pengguna" %> 
<%@page import="model.Penjemputan" %>
<%@page import="dao.PenjemputanDAO" %>
<%@page import="dao.RewardDAO" %>
<%@page import="dao.PenggunaDAO" %> 
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page session="true" %>

<%
  
    Object userObj = session.getAttribute("user");
    if (userObj == null || !(userObj instanceof Masyarakat)) {
        response.sendRedirect("login.jsp"); return;
    }
    Masyarakat user = (Masyarakat) userObj;

  
    String lang = request.getParameter("lang");
    String sessionLang = (String) session.getAttribute("appLang");
    if (lang != null && !lang.isEmpty()) { 
        session.setAttribute("appLang", lang); 
        sessionLang = lang; 
    } else if (sessionLang == null) { 
        sessionLang = "id"; 
        session.setAttribute("appLang", "id");
    }

    boolean isEn = "en".equals(sessionLang);
    Map<String, String> t = new HashMap<>();

    
    if (isEn) {
        t.put("menu_dash", "Dashboard"); t.put("menu_sch", "Schedule Pickup"); t.put("menu_hist", "History"); t.put("menu_rew", "Rewards"); t.put("menu_set", "Settings");
        t.put("welcome", "Welcome back"); t.put("sub_welcome", "Let's make the world cleaner.");
        t.put("card_req", "Total Requests"); t.put("card_bal", "Point Balance"); t.put("card_stat", "Latest Status");
        t.put("act_title", "Recent Activity"); t.put("act_view", "View All");
        t.put("btn_pickup", "Pickup"); 
        t.put("status_wait", "Searching Officer..."); t.put("status_wait_desc", "Your request is being processed. Please wait.");
        t.put("status_otw", "Officer on the way..."); t.put("status_est", "Est. Time");
        t.put("chat_btn", "Chat Officer"); t.put("stat_none", "No activity yet.");

        t.put("form_title", "Schedule Pickup"); t.put("form_desc", "Easily schedule your waste pickup time and location.");
        t.put("form_date", "Date"); t.put("form_time", "Time"); t.put("form_loc", "Pickup Location");
        t.put("form_type", "Waste Type"); t.put("form_note", "Notes for Courier (Optional)"); t.put("form_note_ph", "E.g., Black gate, broken doorbell, etc.");
        t.put("form_btn", "Confirm Schedule");
        t.put("waste_org", "Organic Waste"); t.put("waste_org_desc", "Food scraps, leaves, wet kitchen waste.");
        t.put("waste_anorg", "Inorganic Waste"); t.put("waste_anorg_desc", "Plastic, paper, metal, glass, e-waste.");
        
        t.put("sum_title", "Order Summary"); t.put("sum_loc", "Your Location"); t.put("sum_dest", "Destination (Waste Bank)");
        t.put("fee_base", "Base Fee"); t.put("fee_dist", "Distance Fee"); t.put("fee_serv", "Service Fee"); t.put("fee_disc", "Member Discount");
        t.put("fee_total", "Total Estimate"); t.put("sum_disclaimer", "By clicking the button, you agree to the Terms & Conditions.");
        t.put("tip_title", "Saving Tip"); t.put("tip_desc", "Collect at least <b>5kg</b> of waste to get maximum points!");

       
        t.put("rew_title", "Wallet & Rewards");
        t.put("rew_subtitle", "Redeem points from your environmental contribution for attractive prizes.");
        t.put("rew_total_avail", "TOTAL POINTS AVAILABLE");
        t.put("rew_add_pt", "Add Points");
        t.put("rew_hist", "History");
        t.put("rew_btn", "Redeem");
        t.put("rew_filter_all", "All"); t.put("rew_filter_wallet", "E-Wallet"); t.put("rew_filter_shop", "Voucher"); t.put("rew_filter_donate", "Donation");
        t.put("rew_sort", "Sort by: Lowest Point");
        
        t.put("prof_title", "User Profile"); t.put("prof_header_info", "Personal Information"); t.put("prof_edit", "Edit");
        t.put("prof_fname", "First Name"); t.put("prof_lname", "Last Name"); 
        t.put("prof_email", "Email"); t.put("prof_phone", "Phone Number"); 
        t.put("prof_dob", "Date of Birth"); t.put("prof_main_addr", "Main Address"); 
        t.put("prof_btn_pin", "Pin Location"); t.put("prof_member_stat", "Points to Gold Member");
        t.put("btn_save", "Save Changes"); t.put("btn_cancel", "Cancel");

        t.put("set_priv_title", "Privacy Settings"); t.put("set_priv_desc", "Control how your data is displayed and used.");
        t.put("set_vis_title", "Pickup History Visibility"); t.put("set_vis_desc", "Allow neighbors to see your contribution stats on leaderboard.");
        t.put("set_ana_title", "Allow Location Analytics"); t.put("set_ana_desc", "Help us optimize pickup routes with anonymous location data.");
        
        t.put("set_notif_title", "Notifications"); t.put("set_notif_desc", "Manage what you want to hear from us.");
        t.put("set_dnd", "Do Not Disturb Mode"); t.put("set_dnd_desc", "Mute all notifications except urgent ones.");
        t.put("set_notif_type", "Notification Types");
        t.put("set_n_sch", "Pickup Schedule Reminder"); t.put("set_n_pt", "Points & Rewards Updates"); t.put("set_n_news", "Environmental News & Tips");
        
        t.put("set_app_title", "Appearance & Language");
        t.put("set_lang", "App Language"); t.put("set_theme", "Display Theme");
        t.put("theme_light", "Light"); t.put("theme_dark", "Dark");
        
        t.put("set_danger", "Danger Zone");
        t.put("set_del_acc", "Delete Account"); t.put("set_del_btn", "Delete My Account");
        t.put("set_del_desc", "Deleting account is permanent. All points will be lost.");

        t.put("set_sec_title", "Account Security"); t.put("set_pass", "Change Password"); 
        t.put("set_curr_pass", "Current Password"); t.put("set_new_pass", "New Password");
        
        t.put("alert_fail_title", "Failed!"); t.put("alert_confirm_redeem", "Redeem this reward?"); t.put("btn_yes", "Yes, Redeem!");
        t.put("alert_pt_insuf", "Insufficient points."); t.put("alert_del_confirm", "Are you sure?"); t.put("alert_del_text", "This action cannot be undone!");
        
        t.put("notif_title_bar", "Notifications"); t.put("notif_mark", "Mark as read"); t.put("notif_empty", "No new notifications");
        t.put("notif_req_title", "Request Received"); t.put("notif_otw_title", "Officer OTW");
        t.put("dash_sep_title", "Separate Wet & Dry Waste"); 
        t.put("dash_sep_desc", "Separating organic (wet) from inorganic (dry) waste facilitates recycling and prevents odors.");
        t.put("learn_more", "Learn More");
        t.put("card_recycle", "Recycled Waste"); t.put("card_carbon", "Carbon Saved"); t.put("card_carbon_desc", "Equivalent to planting <b>2 trees</b>.");
    } else {
        t.put("menu_dash", "Dashboard"); t.put("menu_sch", "Jadwal Jemput"); t.put("menu_hist", "Riwayat"); t.put("menu_rew", "Hadiah"); t.put("menu_set", "Pengaturan");
        
        t.put("welcome", "Selamat Datang"); t.put("sub_welcome", "Mari buat dunia lebih bersih.");
        t.put("card_req", "Total Request"); t.put("card_bal", "Saldo Poin"); t.put("card_stat", "Status Terakhir");
        t.put("card_recycle", "Sampah Daur Ulang"); t.put("card_carbon", "Jejak Karbon Hemat"); t.put("card_carbon_desc", "Setara menanam <b>2 pohon</b>.");
        t.put("act_title", "Aktivitas Terakhir"); t.put("act_view", "Lihat Semua");
        t.put("btn_pickup", "Jemput"); 
        t.put("status_wait", "Mencari Petugas..."); t.put("status_wait_desc", "Permintaan sedang diproses. Mohon tunggu.");
        t.put("status_otw", "Petugas menuju lokasi..."); t.put("status_est", "Estimasi");
        t.put("chat_btn", "Chat Petugas"); t.put("stat_none", "Belum ada aktivitas.");

        t.put("form_title", "Jadwalkan Penjemputan"); t.put("form_desc", "Atur waktu dan lokasi penjemputan sampah Anda dengan mudah.");
        t.put("form_date", "Tanggal"); t.put("form_time", "Waktu"); t.put("form_loc", "Lokasi Penjemputan");
        t.put("form_type", "Jenis Sampah"); t.put("form_note", "Catatan Tambahan (Opsional)"); t.put("form_note_ph", "Misal: Pagar hitam, bel rusak, dll.");
        t.put("form_btn", "Konfirmasi Jadwal");
        t.put("waste_org", "Sampah Organik"); t.put("waste_org_desc", "Sisa makanan, dedaunan, sampah dapur basah.");
        t.put("waste_anorg", "Sampah Anorganik"); t.put("waste_anorg_desc", "Plastik, kertas, logam, kaca, elektronik bekas.");

        t.put("sum_title", "Ringkasan Pesanan"); t.put("sum_loc", "Lokasi Anda"); t.put("sum_dest", "Tujuan (Bank Sampah)");
        t.put("fee_base", "Biaya Dasar"); t.put("fee_dist", "Biaya Jarak"); t.put("fee_serv", "Biaya Layanan"); t.put("fee_disc", "Potongan Member");
        t.put("fee_total", "Total Estimasi"); t.put("sum_disclaimer", "Dengan menekan tombol, Anda menyetujui S&K layanan.");
        t.put("tip_title", "Tips Hemat"); t.put("tip_desc", "Kumpulkan minimal <b>5kg</b> sampah untuk mendapatkan poin maksimal!");

      
        t.put("rew_title", "Dompet Poin & Reward");
        t.put("rew_subtitle", "Tukarkan poin hasil kontribusi lingkunganmu dengan berbagai hadiah menarik.");
        t.put("rew_total_avail", "TOTAL POIN TERSEDIA");
        t.put("rew_add_pt", "Tambah Poin");
        t.put("rew_hist", "Riwayat Transaksi");
        t.put("rew_btn", "Tukar");
        t.put("rew_filter_all", "Semua"); t.put("rew_filter_wallet", "E-Wallet"); t.put("rew_filter_shop", "Voucher Belanja"); t.put("rew_filter_donate", "Donasi");
        t.put("rew_sort", "Urutkan: Poin Terendah");

        t.put("prof_title", "Profil Pengguna"); t.put("prof_header_info", "Informasi Pribadi"); t.put("prof_edit", "Ubah");
        t.put("prof_fname", "Nama Depan"); t.put("prof_lname", "Nama Belakang"); 
        t.put("prof_email", "Email"); t.put("prof_phone", "No Handphone"); 
        t.put("prof_dob", "Tanggal Lahir"); t.put("prof_main_addr", "Alamat Utama"); 
        t.put("prof_btn_pin", "Pin Lokasi"); t.put("prof_member_stat", "Poin menuju Member Gold");
        t.put("btn_save", "Simpan Perubahan"); t.put("btn_cancel", "Batal");

        t.put("set_priv_title", "Pengaturan Privasi"); t.put("set_priv_desc", "Kontrol bagaimana data Anda ditampilkan dan digunakan.");
        t.put("set_vis_title", "Visibilitas Riwayat"); t.put("set_vis_desc", "Izinkan tetangga melihat statistik kontribusi sampah Anda di leaderboard.");
        t.put("set_ana_title", "Izinkan Analitik Lokasi"); t.put("set_ana_desc", "Bantu kami mengoptimalkan rute penjemputan dengan data lokasi anonim.");
        
        t.put("set_notif_title", "Notifikasi"); t.put("set_notif_desc", "Kelola apa yang ingin Anda dengar dari kami.");
        t.put("set_dnd", "Mode Jangan Ganggu"); t.put("set_dnd_desc", "Senyapkan semua notifikasi kecuali yang mendesak.");
        t.put("set_notif_type", "Jenis Notifikasi");
        t.put("set_n_sch", "Pengingat Jadwal"); t.put("set_n_pt", "Update Poin & Rewards"); t.put("set_n_news", "Berita Lingkungan & Tips");
        
        t.put("set_app_title", "Tampilan & Bahasa");
        t.put("set_lang", "Bahasa Aplikasi"); t.put("set_theme", "Tema Tampilan");
        t.put("theme_light", "Terang"); t.put("theme_dark", "Gelap");
        
        t.put("set_danger", "Zona Bahaya");
        t.put("set_del_acc", "Hapus Akun"); t.put("set_del_btn", "Hapus Akun Saya");
        t.put("set_del_desc", "Menghapus akun Anda bersifat permanen. Semua poin yang tersisa akan hangus.");
        
        t.put("set_sec_title", "Keamanan Akun"); t.put("set_pass", "Ganti Password"); 
        t.put("set_curr_pass", "Password Saat Ini"); t.put("set_new_pass", "Password Baru");

        t.put("alert_fail_title", "Gagal!"); t.put("alert_confirm_redeem", "Tukar hadiah ini?"); t.put("btn_yes", "Ya, Tukar!");
        t.put("alert_pt_insuf", "Poin Anda kurang."); t.put("alert_del_confirm", "Hapus Akun?"); t.put("alert_del_text", "Tindakan ini tidak dapat dibatalkan!");
        
        t.put("notif_title_bar", "Notifikasi"); t.put("notif_mark", "Tandai baca"); t.put("notif_empty", "Tidak ada notifikasi baru");
        t.put("notif_req_title", "Permintaan Diterima"); t.put("notif_otw_title", "Petugas Menuju Lokasi");
        t.put("dash_sep_title", "Pisahkan Sampah Basah & Kering"); 
        t.put("dash_sep_desc", "Memisahkan sampah organik (basah) dari anorganik (kering) memudahkan proses daur ulang dan mencegah bau.");
        t.put("learn_more", "Pelajari Lebih Lanjut");
    }

  
    PenjemputanDAO dao = new PenjemputanDAO();
    RewardDAO rewardDAO = new RewardDAO();
    PenggunaDAO pDao = new PenggunaDAO(); 
    
    List<Penjemputan> activeList = new ArrayList<>();
    List<Penjemputan> historyList = new ArrayList<>();
    int currentBalance = 0;
    
    
    double activeDestLat = 0;
    double activeDestLng = 0;
    boolean hasActiveProcess = false;
    
    
    String fullName = (user.getNama() != null) ? user.getNama() : "User";
    String firstName = fullName;
    String lastName = "";
    if(fullName.contains(" ")){
        int idx = fullName.lastIndexOf(" ");
        firstName = fullName.substring(0, idx);
        lastName = fullName.substring(idx + 1);
    }
    
    try {
        List<Penjemputan> allList = dao.getByUserId(user.getId());
        int totalMasuk = dao.getTotalPoin(user.getId());
        int totalKeluar = rewardDAO.getTotalPoinDitukar(user.getId());
        currentBalance = totalMasuk - totalKeluar;
        
        for(Penjemputan p : allList) {
            if ("Pending".equalsIgnoreCase(p.getStatus()) || "Proses".equalsIgnoreCase(p.getStatus())) { 
                activeList.add(p);
                if("Proses".equalsIgnoreCase(p.getStatus())) {
                    hasActiveProcess = true;
               
                    activeDestLat = p.getLatitude(); 
                    activeDestLng = p.getLongitude();
                    
                    if(activeDestLat == 0) activeDestLat = -7.2575;
                    if(activeDestLng == 0) activeDestLng = 112.7521;
                }
            } else {
                historyList.add(p);
            }
        }
    } catch(Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="<%= sessionLang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | PickWaste</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>

        :root { --primary: #00d25b; --primary-dark: #00b850; --bg-body: #f8f9fa; --bg-card: #ffffff; --text-main: #2d3436; --text-grey: #a4b0be; --shadow: 0 4px 20px rgba(0,0,0,0.05); --radius: 16px; --border-color: #eee; }
        

        body.dark-mode { --bg-body: #121212; --bg-card: #1e1e1e; --text-main: #ffffff; --text-grey: #b0b0b0; --shadow: 0 4px 20px rgba(0,0,0,0.3); --border-color: #333; }
        
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; transition: background 0.3s, color 0.3s; }
        a { text-decoration: none; color: inherit; }


        .sidebar { width: 260px; background: var(--bg-card); padding: 30px; display: flex; flex-direction: column; justify-content: space-between; position: fixed; height: 100vh; border-right: 1px solid var(--border-color); z-index: 100; transition: background 0.3s; }
        .brand { font-size: 1.5rem; font-weight: 800; color: #112413; display: flex; align-items: center; gap: 10px; margin-bottom: 40px; } .brand i { color: var(--primary); }
        body.dark-mode .brand { color: var(--primary); }
        .menu-list { list-style: none; }
        .menu-item { display: flex; align-items: center; gap: 15px; padding: 14px 20px; color: #888; font-weight: 500; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; cursor: pointer; }
        .menu-item:hover, .menu-item.active { background: #e6fcf0; color: var(--primary); font-weight: 600; }
        body.dark-mode .menu-item:hover, body.dark-mode .menu-item.active { background: #004d22; color: #66ff99; }
        
        .user-mini { display: flex; align-items: center; gap: 12px; padding-top: 20px; border-top: 1px solid var(--border-color); cursor:pointer; }
        .avatar-mini { width: 45px; height: 45px; background: #e6fcf0; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.1rem; }

  
        .main-content { margin-left: 260px; flex: 1; padding: 30px 50px; width: calc(100% - 260px); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { font-size: 1.8rem; font-weight: 700; margin-bottom: 5px; }
        .header-controls { display: flex; align-items: center; gap: 20px; }
        .icon-btn { width: 45px; height: 45px; background: var(--bg-card); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--text-grey); border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s; position: relative; }
        .notif-dot { position: absolute; top: 10px; right: 10px; width: 8px; height: 8px; background: #ff4757; border-radius: 50%; border: 2px solid white; }

        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 30px; }
        .stat-card { background: var(--bg-card); padding: 25px; border-radius: var(--radius); border: 1px solid var(--border-color); position: relative; overflow: hidden; }
        .stat-label { font-size: 0.9rem; color: var(--text-grey); margin-bottom: 10px; }
        .stat-value { font-size: 2rem; font-weight: 700; color: var(--text-main); margin-bottom: 5px; }
        .stat-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-green-light { background: #e6fcf0; color: var(--primary); }
        body.dark-mode .badge-green-light { background: #004d22; color: #66ff99; }
        .stat-icon-bg { position: absolute; top: 20px; right: 20px; width: 40px; height: 40px; background: #f8f9fa; border-radius: 10px; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 1.2rem; }
        body.dark-mode .stat-icon-bg { background: #333; }
        
        .cta-banner { background: #e6fcf0; border: 1px solid #c3f0d4; padding: 30px; border-radius: var(--radius); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        body.dark-mode .cta-banner { background: #004d22; border-color: #006b2e; }
        
        .btn-primary { background: var(--primary); color: white; padding: 12px 30px; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; font-size: 0.95rem; }
        .btn-primary:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0, 210, 91, 0.3); }
        
        .section-card { background: var(--bg-card); padding: 25px; border-radius: var(--radius); border: 1px solid var(--border-color); margin-bottom: 25px; }
        .view-section { display: none; animation: fadeIn 0.3s; }
        .view-section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    
        .reward-header-card { background: #1a4d2e; color: white; padding: 35px; border-radius: var(--radius); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; box-shadow: 0 10px 25px rgba(26, 77, 46, 0.2); }
        .rh-left h4 { font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; opacity: 0.8; }
        .rh-left h1 { font-size: 3.5rem; font-weight: 800; margin: 0; letter-spacing: -1px; }
        .rh-left small { font-size: 1.5rem; font-weight: 400; }
        .rh-right { display: flex; flex-direction: column; gap: 10px; }
        .btn-add-pts { background: #00d25b; color: white; border: none; padding: 12px 25px; border-radius: 8px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .btn-history { background: rgba(255,255,255,0.1); color: white; border: 1px solid rgba(255,255,255,0.3); padding: 12px 25px; border-radius: 8px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        
        .reward-filter { display: flex; gap: 10px; margin-bottom: 25px; align-items: center; flex-wrap: wrap; }
        .filter-pill { padding: 8px 20px; border-radius: 20px; background: var(--bg-card); border: 1px solid var(--border-color); font-size: 0.9rem; font-weight: 600; color: var(--text-grey); cursor: pointer; transition: 0.3s; }
        .filter-pill.active { background: #2d3436; color: white; border-color: #2d3436; }
        body.dark-mode .filter-pill.active { background: white; color: black; }
        
        .reward-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .reward-card { background: var(--bg-card); border-radius: 16px; overflow: hidden; border: 1px solid var(--border-color); transition: 0.3s; display: flex; flex-direction: column; }
        .reward-card:hover { transform: translateY(-5px); box-shadow: var(--shadow); }
        .rc-top { height: 140px; display: flex; flex-direction: column; align-items: center; justify-content: center; position: relative; }
        .rc-top i { font-size: 2.5rem; margin-bottom: 10px; }
        .rc-top h3 { font-size: 1.2rem; font-weight: 700; margin: 0; }
        .rc-body { padding: 20px; flex: 1; display: flex; flex-direction: column; }
        .rc-cat { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; background: #f0f0f0; padding: 4px 8px; border-radius: 6px; align-self: flex-start; margin-bottom: 10px; color: #555; }
        .rc-title { font-size: 1rem; font-weight: 700; margin-bottom: 5px; color: var(--text-main); }
        .rc-desc { font-size: 0.8rem; color: var(--text-grey); margin-bottom: 20px; line-height: 1.4; flex: 1; }
        .rc-footer { display: flex; justify-content: space-between; align-items: center; margin-top: auto; }
        .rc-cost { font-weight: 700; color: #f1c40f; display: flex; align-items: center; gap: 5px; font-size: 0.95rem; }
        .btn-redeem { background: #2d3436; color: white; border: none; padding: 8px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 0.85rem; }
        body.dark-mode .btn-redeem { background: #fff; color: black; }

        
        .setting-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; padding: 25px; margin-bottom: 25px; }
        .st-header { margin-bottom: 20px; }
        .st-header h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 5px; color: var(--text-main); }
        .st-header p { font-size: 0.85rem; color: var(--text-grey); margin: 0; }
        .st-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid var(--border-color); }
        .st-row:last-child { border-bottom: none; }
        .st-info h4 { font-size: 0.95rem; font-weight: 600; color: var(--text-main); margin-bottom: 4px; }
        .st-info p { font-size: 0.8rem; color: var(--text-grey); max-width: 90%; line-height: 1.4; }

        
        .switch { position: relative; display: inline-block; width: 48px; height: 28px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #e0e0e0; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 22px; width: 22px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        input:checked + .slider { background-color: #00d25b; }
        input:checked + .slider:before { transform: translateX(20px); }

        .check-group { margin-top: 15px; }
        .check-label { font-size: 0.75rem; font-weight: 700; color: var(--primary); letter-spacing: 1px; margin-bottom: 10px; display: block; text-transform: uppercase; }
        .check-item { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; cursor: pointer; }
        .check-item input { width: 18px; height: 18px; accent-color: var(--primary); cursor: pointer; }
        .check-item span { font-size: 0.9rem; font-weight: 500; color: var(--text-main); }

        .theme-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-top: 10px; }
        .theme-box { border: 2px solid var(--border-color); border-radius: 12px; padding: 10px; cursor: pointer; transition: 0.2s; background: var(--bg-card); }
        .theme-box:hover { border-color: #ccc; }
        .theme-box.active { border-color: var(--primary); background: #f0fdf4; }
        body.dark-mode .theme-box.active { background: #004d22; }
        .t-preview { height: 60px; border-radius: 8px; margin-bottom: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); position: relative; }
        .t-light { background: #fff; border: 1px solid #eee; }
        .t-light::after { content:''; position:absolute; top:15px; left:10px; width:60%; height:8px; background:#f0f0f0; border-radius:4px; }
        .t-dark { background: #2d3436; border: 1px solid #2d3436; }
        .t-dark::after { content:''; position:absolute; top:15px; left:10px; width:60%; height:8px; background:#444; border-radius:4px; }
        .t-name { font-size: 0.85rem; font-weight: 600; color: var(--text-main); display: flex; align-items: center; gap: 6px; }

        .danger-zone { 
            border: 1px solid #ff4757; 
            background: rgba(255, 71, 87, 0.05); 
            border-radius: 16px; 
            padding: 25px; 
            margin-top: 30px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        .dz-text h4 { color: var(--text-main); margin-bottom: 5px; font-weight: 700; font-size: 1rem; display: flex; align-items: center; gap: 8px; }
        .dz-text h4 i { color: #ff4757; }
        body.dark-mode .dz-text h4 { color: #fff; }
        .dz-text p { font-size: 0.85rem; color: #ff4757; margin: 0; }
        .btn-danger-outline { background: transparent; color: #ff4757; border: 1px solid #ff4757; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.3s; font-size: 0.9rem; }
        .btn-danger-outline:hover { background: #ff4757; color: white; }
        
        .settings-footer { margin-top: 40px; display: flex; justify-content: flex-end; gap: 15px; padding-top: 20px; border-top: 1px solid var(--border-color); }
        .btn-cancel { background: white; border: 1px solid #ddd; color: #555; padding: 12px 30px; border-radius: 10px; font-weight: 600; cursor: pointer; font-size: 0.9rem; transition:0.3s; }
        .btn-cancel:hover { background: rgba(0,0,0,0.05); color: var(--text-main); border-color: var(--text-main); }
        body.dark-mode .btn-cancel { background: transparent; border-color: #555; color: #bbb; }
        body.dark-mode .btn-cancel:hover { background: rgba(255,255,255,0.05); color: white; border-color: white; }

        .schedule-layout { display: flex; gap: 30px; align-items: flex-start; } .schedule-form { flex: 2; } .schedule-summary { flex: 1; position: sticky; top: 30px; }
        .waste-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .waste-option { border: 2px solid var(--border-color); border-radius: 12px; padding: 20px; cursor: pointer; transition: 0.2s; display: flex; flex-direction: column; gap: 10px; position: relative; }
        .waste-option:hover { border-color: #ddd; }
        .waste-option.selected { border-color: var(--primary); background: #f9fdfa; }
        body.dark-mode .waste-option.selected { background: #003317; }
        .waste-icon { width: 40px; height: 40px; background: #e6fcf0; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .radio-check { position: absolute; top: 20px; right: 20px; width: 20px; height: 20px; border: 2px solid #ddd; border-radius: 50%; }
        .waste-option.selected .radio-check { border-color: var(--primary); background: var(--primary); box-shadow: inset 0 0 0 4px white; }
        
        .summary-card { background: var(--bg-card); padding: 25px; border-radius: var(--radius); border: 1px solid var(--border-color); }
        .timeline { position: relative; padding-left: 20px; margin: 20px 0; border-left: 2px solid #eee; }
        .timeline-item { position: relative; margin-bottom: 20px; }
        .timeline-dot { position: absolute; left: -26px; width: 10px; height: 10px; background: var(--primary); border-radius: 50%; border: 4px solid white; box-shadow: 0 0 0 1px #eee; }
        .price-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.9rem; color: var(--text-grey); }
        .price-row.total { font-size: 1.2rem; font-weight: 700; color: var(--text-main); border-top: 1px solid var(--border-color); padding-top: 15px; margin-top: 15px; align-items: center; }
        .tips-box { background: #e6fcf0; padding: 15px; border-radius: 12px; display: flex; gap: 15px; margin-top: 20px; font-size: 0.85rem; color: #006b2e; }
        
        #map { height: 250px; border-radius: 12px; margin-top: 15px; border: 1px solid var(--border-color); }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 0.9rem; background: var(--bg-body); color: var(--text-main); transition: 0.3s; }
        .form-control:focus { border-color: var(--primary); outline: none; }
        
        table { width: 100%; border-collapse: collapse; } th, td { padding: 15px; text-align: left; border-bottom: 1px solid var(--border-color); color: var(--text-main); }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-green { background: #e6fcf0; color: #00d25b; } .badge-yellow { background: #fff7d1; color: #f1c40f; }
        
        .active-order-card { background: var(--bg-card); border-radius: var(--radius); padding: 25px; border:1px solid var(--border-color); margin-bottom: 20px; border-left: 5px solid #f1c40f; }
        .active-order-card.proses { border-left-color: var(--primary); }
        
        
        .profile-header-card { background: var(--bg-card); padding: 30px; border-radius: var(--radius); border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .ph-user { display: flex; align-items: center; gap: 20px; }
        .ph-avatar-box { position: relative; }
        .ph-avatar { width: 90px; height: 90px; background: #ddd; border-radius: 50%; background-image: url('https://ui-avatars.com/api/?name=<%= user.getNama().replace(" ", "+") %>&background=random&size=128'); background-size: cover; border: 4px solid white; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: background-image 0.3s; }
        .ph-edit-btn { position: absolute; bottom: 0; right: 0; background: var(--primary); color: white; width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; border: 2px solid white; cursor: pointer; }
        .ph-info h2 { margin-bottom: 2px; font-size: 1.4rem; color: var(--text-main); }
        .ph-info p { color: var(--text-grey); font-size: 0.9rem; margin-top: 0; }
        .ph-points { text-align: right; min-width: 200px; }
        .point-badge { background: #e6fcf0; color: #112413; padding: 10px 20px; border-radius: 12px; display: inline-block; margin-bottom: 10px; border: 1px solid #c3f0d4; }
        .point-val { font-size: 1.5rem; font-weight: 800; color: #112413; }
        .progress-bar { height: 6px; background: #eee; border-radius: 10px; overflow: hidden; margin-top: 5px; }
        .progress-fill { height: 100%; background: var(--primary); border-radius: 10px; width: <%= Math.min((currentBalance * 100) / 5000, 100) %>%; } 

        
        .chat-modal { position: fixed; bottom: 20px; right: 20px; width: 350px; background: var(--bg-card); border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); z-index: 5000; display: none; flex-direction: column; border: 1px solid var(--border-color); overflow: hidden; }
        .chat-modal.show { display: flex; animation: slideUp 0.3s; }
        .chat-header { background: var(--primary); color: white; padding: 15px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
        .chat-body { height: 300px; overflow-y: auto; padding: 15px; background: var(--bg-body); display: flex; flex-direction: column; gap: 12px; }
        .chat-footer { padding: 10px; background: var(--bg-card); border-top: 1px solid var(--border-color); display: flex; gap: 10px; }
        .chat-input { flex: 1; border: 1px solid var(--border-color); padding: 8px 15px; border-radius: 20px; outline: none; background: var(--bg-body); color: var(--text-main); }
        .chat-row { display: flex; align-items: flex-end; gap: 8px; width: 100%; }
        .chat-row.me { flex-direction: row-reverse; }
        .chat-row.other { flex-direction: row; }
        .chat-avatar { width: 32px; height: 32px; border-radius: 50%; background-size: cover; background-color: #ddd; flex-shrink: 0; border: 2px solid white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .chat-content { max-width: 75%; display: flex; flex-direction: column; }
        .chat-row.me .chat-content { align-items: flex-end; }
        .chat-row.other .chat-content { align-items: flex-start; }
        .chat-name { font-size: 0.7rem; color: var(--text-grey); margin-bottom: 3px; font-weight: 600; }
        .bubble { padding: 10px 15px; border-radius: 15px; font-size: 0.9rem; line-height: 1.4; word-wrap: break-word; position: relative; }
        .bubble-me { background: #e6fcf0; color: #006b2e; border-bottom-right-radius: 2px; text-align: right; }
        .bubble-other { background: var(--bg-card); border: 1px solid var(--border-color); border-bottom-left-radius: 2px; color: var(--text-main); text-align: left; }
        body.dark-mode .bubble-other { background: #2d3436; border-color: #444; color: #eee; }

        .dropdown { position: absolute; top: 70px; right: 80px; width: 320px; background: white; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); z-index: 2000; display: none; padding: 10px 0; }
        .dropdown.show { display: block; animation: fadeIn 0.2s; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 3000; display: none; justify-content: center; align-items: center; backdrop-filter: blur(3px); }
        .modal-overlay.show { display: flex; animation: fadeIn 0.3s; }
        .modal-box { background: white; width: 600px; padding: 30px; border-radius: 20px; position: relative; max-height: 80vh; display: flex; flex-direction: column; }
        .close-btn { position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem; color: #888; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: var(--text-main); }
        #routingMap, #viewMap { height: 300px; width: 100%; border-radius: 12px; z-index: 1; }

        @media (max-width: 992px) { .sidebar { display: none; } .main-content { margin-left: 0; width: 100%; padding: 20px; } .stats-grid { grid-template-columns: 1fr; } .schedule-layout { flex-direction: column; } .reward-header-card { flex-direction: column; text-align: center; gap: 20px; } .rh-left, .rh-right { width: 100%; } .reward-grid { grid-template-columns: 1fr; } .profile-header-card { flex-direction: column; text-align: center; gap: 20px; } .ph-user { flex-direction: column; } .ph-points { text-align: center; width: 100%; } .form-grid { grid-template-columns: 1fr; } .danger-zone { flex-direction: column; align-items: flex-start; gap: 15px; } }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div>
            <div class="brand"><i class="fas fa-recycle"></i> PickWaste</div>
            <ul class="menu-list">
                <li onclick="switchView('home')" class="menu-item active" id="menu-home"><i class="fas fa-th-large"></i> <%= t.get("menu_dash") %></li>
                <li onclick="switchView('schedule')" class="menu-item" id="menu-schedule"><i class="fas fa-calendar-alt"></i> <%= t.get("menu_sch") %></li>
                <li onclick="switchView('history')" class="menu-item" id="menu-history"><i class="fas fa-history"></i> <%= t.get("menu_hist") %></li>
                <li onclick="switchView('rewards')" class="menu-item" id="menu-rewards"><i class="fas fa-gift"></i> <%= t.get("menu_rew") %></li>
                <li onclick="switchView('settings')" class="menu-item" id="menu-settings"><i class="fas fa-cog"></i> <%= t.get("menu_set") %></li>
            </ul>
        </div>
        <div class="user-mini" onclick="switchView('profile')">
            <div class="avatar-mini"><%= user.getNama().substring(0,1) %></div>
            <div style="flex:1;"><div style="font-weight:700; font-size:0.9rem;"><%= user.getNama() %></div><div style="font-size:0.8rem; color:var(--text-grey);">User</div></div>
            <a href="LogoutServlet" style="color:#ff4757;"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="header">
            <div>
                <h1 style="display:flex; align-items:center; gap:10px;"><%= t.get("welcome") %>, <%= user.getNama().split(" ")[0] %>! <span style="font-size:1.5rem;">👋</span></h1>
                <p style="color:var(--text-grey);"><%= t.get("sub_welcome") %></p>
            </div>
            <div class="header-controls">
                <input type="text" placeholder="<%= isEn ? "Search history..." : "Cari riwayat..." %>" class="form-control" style="width:200px;">
                <div class="icon-btn" onclick="toggleNotifDropdown()">
                    <i class="far fa-bell"></i>
                    <% if(!activeList.isEmpty()) { %><div class="notif-dot"></div><% } %>
                </div>
            </div>
        </header>

        <div id="view-home" class="view-section active">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_bal") %></div>
                    <div class="stat-value"><%= String.format("%,d", currentBalance) %></div>
                    <div class="stat-badge badge-green-light">+<%= dao.getTotalPoin(user.getId()) %> <%= isEn ? "this week" : "minggu ini" %></div>
                    <div class="stat-icon-bg"><i class="fas fa-coins"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_recycle") %></div>
                    <div class="stat-value">12.5 <span style="font-size:1rem; font-weight:500;">kg</span></div>
                    <div class="stat-icon-bg" style="color:#4a90e2; background:#e3f2fd;"><i class="fas fa-recycle"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_carbon") %></div>
                    <div class="stat-value">5.2 <span style="font-size:1rem; font-weight:500;">kg CO2</span></div>
                    <div class="stat-icon-bg" style="color:#2ecc71; background:#eafff3;"><i class="fas fa-leaf"></i></div>
                </div>
            </div>

            <div style="display:grid; grid-template-columns: 2fr 1fr; gap:30px;">
                <div>
                    <div class="cta-banner">
                        <div>
                            <h3 style="margin-bottom:8px;"><i class="fas fa-truck" style="margin-right:8px;"></i> <%= t.get("form_title") %></h3>
                            <p style="color:var(--text-grey); font-size:0.9rem;"><%= t.get("form_desc") %></p>
                        </div>
                        <button onclick="switchView('schedule')" class="btn-primary" style="white-space:nowrap;">
                            <i class="fas fa-plus"></i> <%= t.get("btn_pickup") %>
                        </button>
                    </div>

                    <div class="section-card">
                        <div style="display:flex; justify-content:space-between; margin-bottom:20px;">
                            <h3><%= t.get("act_title") %></h3>
                            <a href="#" onclick="switchView('history')" style="color:var(--primary); font-weight:600; font-size:0.9rem;"><%= t.get("act_view") %></a>
                        </div>
                        
                        <% if(!activeList.isEmpty()) { 
                            for(Penjemputan p : activeList) { 
                                boolean isProses = "Proses".equalsIgnoreCase(p.getStatus());
                                
                                // AMBIL NAMA PETUGAS ASLI
                                String officerName = "Petugas";
                                if(p.getOfficerId() > 0) {
                                    Pengguna off = new PenggunaDAO().getPenggunaById(p.getOfficerId());
                                    if(off != null && off.getNama() != null) officerName = off.getNama();
                                }
                        %>
                        <div class="active-order-card <%= isProses ? "proses" : "pending" %>">
                             <div style="display:flex; justify-content:space-between; margin-bottom:10px;">
                                <div><i class="far fa-calendar"></i> <%= p.getTanggal() %></div>
                                <span class="badge badge-<%= isProses ? "green" : "yellow" %>"><%= isProses ? (isEn ? "In Progress" : "Proses") : (isEn ? "Pending" : "Menunggu") %></span>
                             </div>
                             <h4><%= isProses ? t.get("status_otw") : t.get("status_wait") %></h4>
                             <% if(isProses) { %>
                                <div style="font-size:0.9rem; color:#006b2e; margin-bottom:5px;"><i class="fas fa-user-shield"></i> <%= officerName %></div>
                                <div id="trackingMap" style="height:150px; margin-top:10px; border-radius:10px;"></div>
                                <button onclick="openChat(<%= p.getId() %>, <%= p.getOfficerId() %>, '<%= officerName %>')" class="btn-primary" style="margin-top:10px; width:100%; justify-content:center;"><%= t.get("chat_btn") %></button>
                             <% } %>
                        </div>
                        <% }} %>

                        <table>
                            <tbody>
                                <% if(historyList.isEmpty()) { %><tr><td colspan="4" style="text-align:center;"><%= t.get("stat_none") %></td></tr><% } else { 
                                   int limit = Math.min(historyList.size(), 3); for(int i=0; i<limit; i++) { Penjemputan p = historyList.get(i); 
                                %>
                                <tr>
                                    <td><div style="font-weight:600;"><%= p.getTanggal() %></div><div style="font-size:0.8rem; color:var(--text-grey);"><%= p.getAlamat().split("\\|")[0] %></div></td>
                                    <td><%= p.getStatus().equalsIgnoreCase("Selesai") ? p.getBerat()+" kg" : "-" %></td>
                                    <td style="color:var(--primary); font-weight:700;">+<%= p.getPoin() %></td>
                                    <td><span class="badge badge-green"><%= isEn && "Selesai".equalsIgnoreCase(p.getStatus()) ? "Completed" : p.getStatus() %></span></td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div>
                    <div class="section-card" style="background:#112413; color:white; border:none;">
                        <div style="font-size:3rem; margin-bottom:10px; color:var(--primary);"><i class="fas fa-recycle"></i></div>
                        <h4><%= t.get("dash_sep_title") %></h4>
                        <p style="font-size:0.85rem; opacity:0.8; line-height:1.6; margin:15px 0;"><%= t.get("dash_sep_desc") %></p>
                        <a href="#" onclick="Swal.fire('<%= t.get("learn_more") %>', '<%= t.get("dash_sep_desc") %>', 'info'); return false;" style="color:white; font-size:0.85rem; font-weight:600; display:flex; align-items:center; gap:5px;"><%= t.get("learn_more") %> <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <div id="view-schedule" class="view-section">
            <h2 style="margin-bottom:10px;"><%= t.get("form_title") %></h2>
            <p style="color:var(--text-grey); margin-bottom:30px;"><%= t.get("form_desc") %></p>
            
            <form action="PenjemputanServlet" method="post" onsubmit="combineDateTime()">
                <input type="hidden" name="userId" value="<%= user.getId() %>">
                <input type="hidden" name="tanggal" id="finalTanggal">
                <input type="hidden" name="latitude" id="latitude">
                <input type="hidden" name="longitude" id="longitude">
                <input type="hidden" name="jarak_km" id="inputJarak" value="0">
                <input type="hidden" name="estimasi_harga" id="inputHarga" value="0">
                <input type="hidden" name="jenis_sampah" id="inputJenisSampah" value="Organik">

                <div class="schedule-layout">
                    <div class="schedule-form">
                        <div class="section-card">
                            <div class="section-title"><span class="step-number">1</span> <%= t.get("form_type") %></div>
                            <div class="waste-grid">
                                <div class="waste-option selected" onclick="selectWaste(this, 'Organik')">
                                    <div class="radio-check"></div>
                                    <div class="waste-icon"><i class="fas fa-leaf"></i></div>
                                    <div style="font-weight:600;"><%= t.get("waste_org") %></div>
                                    <div style="font-size:0.8rem; color:var(--text-grey);"><%= t.get("waste_org_desc") %></div>
                                </div>
                                <div class="waste-option" onclick="selectWaste(this, 'Anorganik')">
                                    <div class="radio-check"></div>
                                    <div class="waste-icon" style="background:#e3f2fd; color:#45aaf2;"><i class="fas fa-box-open"></i></div>
                                    <div style="font-weight:600;"><%= t.get("waste_anorg") %></div>
                                    <div style="font-size:0.8rem; color:var(--text-grey);"><%= t.get("waste_anorg_desc") %></div>
                                </div>
                            </div>
                        </div>

                        <div class="section-card">
                            <div class="section-title"><span class="step-number">2</span> <%= t.get("form_loc") %></div>
                            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                                <div>
                                    <label style="font-size:0.85rem; font-weight:600; margin-bottom:5px; display:block;"><%= t.get("form_date") %></label>
                                    <input type="date" id="inputDate" class="form-control" required>
                                </div>
                                <div>
                                    <label style="font-size:0.85rem; font-weight:600; margin-bottom:5px; display:block;"><%= t.get("form_time") %></label>
                                    <input type="time" id="inputTime" class="form-control" required>
                                </div>
                            </div>
                            <div style="position:relative;">
                                <input type="text" name="alamat_raw" class="form-control" placeholder="<%= isEn ? "Search location..." : "Cari lokasi..." %>" style="padding-left:40px;" required>
                                <i class="fas fa-search" style="position:absolute; left:15px; top:13px; color:#aaa;"></i>
                            </div>
                            <div id="map"></div>
                            <div style="margin-top:20px;">
                                <label style="font-size:0.85rem; font-weight:600;"><%= t.get("form_note") %></label>
                                <textarea name="catatan" class="form-control" rows="2" placeholder="<%= t.get("form_note_ph") %>"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="schedule-summary">
                        <div class="summary-card">
                            <h3 style="font-size:1rem; margin-bottom:20px;"><%= t.get("sum_title") %></h3>
                            <div class="timeline">
                                <div class="timeline-item">
                                    <div class="timeline-dot" style="border-color:#e6fcf0;"></div>
                                    <div style="font-size:0.8rem; color:var(--text-grey);"><%= t.get("sum_loc") %></div>
                                    <div style="font-size:0.9rem; font-weight:600;" id="summaryAlamat"><%= isEn ? "Select on map..." : "Pilih di peta..." %></div>
                                </div>
                                <div class="timeline-item" style="margin-bottom:0;">
                                    <div class="timeline-dot" style="border-color:#e3f2fd; background:#45aaf2;"></div>
                                    <div style="font-size:0.8rem; color:var(--text-grey);"><%= t.get("sum_dest") %></div>
                                    <div style="font-size:0.9rem; font-weight:600;">Pickwaste Center Surabaya</div>
                                    <div style="font-size:0.8rem; color:var(--primary);" id="summaryJarak">0 km</div>
                                </div>
                            </div>
                            <hr style="border:0; border-top:1px dashed var(--border-color); margin:20px 0;">
                            <div class="price-row"><span><%= t.get("fee_base") %></span><span>Rp 5.000</span></div>
                            <div class="price-row"><span><%= t.get("fee_dist") %></span><span id="biayaJarak">Rp 0</span></div>
                            <div class="price-row"><span><%= t.get("fee_serv") %></span><span>Rp 2.000</span></div>
                            <div class="price-row" style="color:var(--primary);"><span><%= t.get("fee_disc") %></span><span>-Rp 2.000</span></div>
                            <div class="price-row total">
                                <span><%= t.get("fee_total") %></span>
                                <span style="font-size:1.4rem;" id="displayHargaText">Rp 5.000</span>
                            </div>
                            <button type="submit" class="btn-primary" style="width:100%; justify-content:center; margin-top:20px; font-size:1rem;">
                                <%= t.get("form_btn") %> <i class="fas fa-arrow-right"></i>
                            </button>
                            <div style="text-align:center; font-size:0.75rem; color:#aaa; margin-top:10px;">
                                <%= t.get("sum_disclaimer") %>
                            </div>
                        </div>
                        <div class="tips-box">
                            <i class="far fa-lightbulb" style="font-size:1.2rem; margin-top:2px;"></i>
                            <div><b><%= t.get("tip_title") %></b><br><%= t.get("tip_desc") %></div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div id="view-history" class="view-section">
             <h2 style="margin-bottom:20px;"><%= t.get("menu_hist") %></h2>
             <div class="section-card">
                <table>
                    <thead><tr><th><%= t.get("form_date") %></th><th>Detail</th><th>Status</th><th>Berat</th><th>Poin</th></tr></thead>
                    <tbody>
                        <% for(Penjemputan p : historyList) { 
                           String jenis = "Sampah"; if(p.getAlamat().contains("Jenis:")) jenis = p.getAlamat().split("Jenis:")[1].split("\\|")[0]; 
                        %>
                        <tr><td><%= p.getTanggal() %></td><td><div style="font-weight:600;"><%= jenis %></div><div style="font-size:0.8rem; color:var(--text-grey);">Note: <%= p.getAlamat().contains("Note:") ? p.getAlamat().split("Note:")[1] : "-" %></div></td><td><span class="badge badge-<%= p.getStatus().equalsIgnoreCase("Selesai")?"green":"yellow" %>"><%= p.getStatus() %></span></td><td><%= p.getStatus().equalsIgnoreCase("Selesai") ? p.getBerat()+" kg" : "-" %></td><td style="color:var(--primary); font-weight:700;"><%= p.getStatus().equalsIgnoreCase("Selesai") ? "+"+p.getPoin() : "-" %></td></tr>
                        <% } %>
                    </tbody>
                </table>
             </div>
        </div>

        <div id="view-rewards" class="view-section">
             <div class="reward-header-card">
                 <div class="rh-left">
                     <h4><%= t.get("rew_total_avail") %></h4>
                     <h1><%= String.format("%,d", currentBalance) %> <small>Pts</small></h1>
                 </div>
                 <div class="rh-right">
                     <button onclick="switchView('schedule')" class="btn-add-pts"><i class="fas fa-plus-circle"></i> <%= t.get("rew_add_pt") %></button>
                     <button class="btn-history"><i class="fas fa-history"></i> <%= t.get("rew_hist") %></button>
                 </div>
             </div>

             <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                 <div class="reward-filter">
                     <button class="filter-pill active"><%= t.get("rew_filter_all") %></button>
                     <button class="filter-pill"><%= t.get("rew_filter_wallet") %></button>
                     <button class="filter-pill"><%= t.get("rew_filter_shop") %></button>
                     <button class="filter-pill"><%= t.get("rew_filter_donate") %></button>
                 </div>
                 <div style="font-size:0.85rem; color:var(--text-grey); font-weight:600;"><%= t.get("rew_sort") %> <i class="fas fa-chevron-down"></i></div>
             </div>

             <div class="reward-grid">
                <% 
                   String[] vNames = {"Saldo DANA 25K", "Voucher Alfamart", "Donasi 1 Pohon", "Token Listrik 20K", "Kopi Kenangan", "Pulsa All Operator"};
                   int[] vCosts = {2500, 4800, 1000, 2100, 850, 1100};
                   String[] vCats = {"E-WALLET", "BELANJA", "LINGKUNGAN", "TAGIHAN", "F&B", "PULSA"};
                   String[] vBgColors = {"#e3f2fd", "#fff3e0", "#e6fcf0", "#fff7d1", "#f5f5f5", "#f3e5f5"};
                   String[] vIcons = {"wallet", "shopping-cart", "tree", "bolt", "coffee", "mobile-alt"};
                   String[] vDescs = {"Tukar poin jadi saldo dompet digital.", "Potongan belanja di minimarket.", "Donasikan poinmu untuk menanam pohon.", "Isi ulang token listrik PLN prabayar.", "Nikmati kopi favoritmu diskon 50%.", "Pulsa reguler 10rb semua operator."};

                   for(int k=0; k<6; k++){ 
                %>
                   <div class="reward-card">
                       <div class="rc-top" style="background:<%= vBgColors[k] %>;">
                           <i class="fas fa-<%= vIcons[k] %>" style="color:var(--text-main); opacity:0.7;"></i>
                           <h3>Rp <%= String.format("%,.0f", (double)vCosts[k]*10) %></h3>
                       </div>
                       <div class="rc-body">
                           <span class="rc-cat"><%= vCats[k] %></span>
                           <div class="rc-title"><%= vNames[k] %></div>
                           <div class="rc-desc"><%= vDescs[k] %></div>
                           <div class="rc-footer">
                               <div class="rc-cost"><i class="fas fa-coins"></i> <%= String.format("%,d", vCosts[k]) %></div>
                               <form action="RedeemServlet" method="post" id="redeem-form-<%=k%>">
                                   <input type="hidden" name="userId" value="<%= user.getId() %>">
                                   <input type="hidden" name="cost" value="<%= vCosts[k] %>">
                                   <input type="hidden" name="rewardName" value="<%= vNames[k] %>">
                                   <button type="button" onclick="checkAndRedeem('<%= vNames[k] %>', <%= vCosts[k] %>, <%= currentBalance %>, 'redeem-form-<%=k%>')" class="btn-redeem"><%= t.get("rew_btn") %></button>
                               </form>
                           </div>
                       </div>
                   </div>
                <% } %>
             </div>
        </div>
        
        <div id="view-profile" class="view-section">
            <form action="UpdateUserServlet" method="post" id="profileForm">
                <input type="hidden" name="action" value="updateProfile">
                <input type="hidden" name="nama" id="combinedName">

                <div class="profile-header-card">
                    <div class="ph-user">
                        <div class="ph-avatar-box">
                            <div class="ph-avatar" id="avatarPreview"></div>
                            <div class="ph-edit-btn" onclick="changeAvatar()"><i class="fas fa-camera"></i></div>
                        </div>
                        <div class="ph-info">
                            <h2><%= user.getNama() %></h2>
                            <p><i class="far fa-envelope"></i> <%= user.getEmail() %></p>
                        </div>
                    </div>
                    <div class="ph-points">
                        <div class="point-badge">
                            <small style="display:block; font-size:0.7rem; color:#555; text-transform:uppercase;"><%= t.get("card_bal") %></small>
                            <span class="point-val"><%= String.format("%,d", currentBalance) %></span> <small>pts</small>
                        </div>
                        <div style="font-size:0.75rem; color:var(--text-grey);">350 <%= t.get("prof_member_stat") %></div>
                        <div class="progress-bar"><div class="progress-fill"></div></div>
                    </div>
                </div>

                <div class="section-card">
                    <div style="display:flex; justify-content:space-between; margin-bottom:20px;">
                        <h3 style="font-size:1.1rem; font-weight:700;"><i class="fas fa-id-card" style="color:var(--primary); margin-right:8px;"></i> <%= t.get("prof_header_info") %></h3>
                        <a href="#" style="color:var(--primary); font-weight:600; font-size:0.9rem;"><%= t.get("prof_edit") %></a>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label><%= t.get("prof_fname") %></label>
                            <input type="text" id="inputFname" value="<%= firstName %>" class="form-control">
                        </div>
                        <div class="form-group">
                            <label><%= t.get("prof_lname") %></label>
                            <input type="text" id="inputLname" value="<%= lastName %>" class="form-control">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label><%= t.get("prof_email") %></label>
                            <input type="email" name="email" value="<%= user.getEmail() %>" class="form-control">
                        </div>
                        <div class="form-group">
                            <label><%= t.get("prof_phone") %></label>
                            <input type="text" name="no_hp" value="<%= (user.getNoHp() != null) ? user.getNoHp() : "" %>" class="form-control">
                        </div>
                    </div>

                    <div class="form-group">
                        <label><%= t.get("prof_main_addr") %></label>
                        <textarea name="alamat" class="form-control" rows="2"><%= (user.getAlamat() != null) ? user.getAlamat() : "" %></textarea>
                        <div class="map-preview">
                            <div class="map-overlay"></div>
                            <div class="btn-map-pin"><i class="fas fa-map-marker-alt"></i> <%= t.get("prof_btn_pin") %></div>
                        </div>
                    </div>
                </div>

                <div class="settings-footer">
                    <button type="button" class="btn-cancel" onclick="switchView('home')"><%= t.get("btn_cancel") %></button>
                    <button type="button" onclick="submitProfile()" class="btn-primary" style="padding:12px 40px;"><%= t.get("btn_save") %></button>
                </div>
            </form>
        </div>

        <div id="view-settings" class="view-section">
            <form action="UpdateUserServlet" method="post">
                <input type="hidden" name="action" value="updateSettings">

                <div class="setting-card">
                    <div class="st-header">
                        <h3><%= t.get("set_priv_title") %></h3>
                        <p><%= t.get("set_priv_desc") %></p>
                    </div>
                    
                    <div class="st-row">
                        <div class="st-info">
                            <h4><%= t.get("set_vis_title") %></h4>
                            <p><%= t.get("set_vis_desc") %></p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="visibilitas" checked>
                            <span class="slider"></span>
                        </label>
                    </div>
                    
                    <div class="st-row">
                        <div class="st-info">
                            <h4><%= t.get("set_ana_title") %></h4>
                            <p><%= t.get("set_ana_desc") %></p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="analitik">
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <div class="setting-card">
                    <div class="st-header">
                        <h3><%= t.get("set_notif_title") %></h3>
                        <p><%= t.get("set_notif_desc") %></p>
                    </div>

                    <div class="st-row" style="border-bottom: 1px solid #eee; margin-bottom: 20px; padding-bottom: 20px;">
                        <div class="st-info">
                            <h4 style="display:flex; align-items:center; gap:8px;"><i class="fas fa-minus-circle"></i> <%= t.get("set_dnd") %></h4>
                            <p><%= t.get("set_dnd_desc") %></p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" name="dnd_mode">
                            <span class="slider"></span>
                        </label>
                    </div>

                    <div class="check-group">
                        <span class="check-label"><%= t.get("set_notif_type") %></span>
                        <label class="check-item">
                            <input type="checkbox" name="notif_jadwal" checked>
                            <span><%= t.get("set_n_sch") %></span>
                        </label>
                        <label class="check-item">
                            <input type="checkbox" name="notif_poin" checked>
                            <span><%= t.get("set_n_pt") %></span>
                        </label>
                        <label class="check-item">
                            <input type="checkbox" name="notif_berita">
                            <span><%= t.get("set_n_news") %></span>
                        </label>
                    </div>
                </div>

                <div class="setting-card">
                    <div class="st-header">
                        <h3><%= t.get("set_app_title") %></h3>
                    </div>

                    <div style="margin-bottom:25px;">
                        <label style="display:block; font-weight:600; font-size:0.85rem; margin-bottom:8px; color:var(--text-main);">
                            <%= t.get("set_lang") %>
                        </label>
                        <select class="form-control" style="background:var(--bg-body);" onchange="window.location.href='dashboardUser.jsp?lang='+this.value">
                            <option value="id" <%= "id".equals(sessionLang) ? "selected" : "" %>>Bahasa Indonesia</option>
                            <option value="en" <%= "en".equals(sessionLang) ? "selected" : "" %>>English (US)</option>
                        </select>
                    </div>

                    <div>
                        <label style="display:block; font-weight:600; font-size:0.85rem; margin-bottom:8px; color:var(--text-main);">
                            <%= t.get("set_theme") %>
                        </label>
                        <div class="theme-grid">
                            <div id="theme-light" class="theme-box active" onclick="toggleTheme('light')">
                                <div class="t-preview t-light"></div>
                                <div class="t-name"><i class="fas fa-sun"></i> <%= t.get("theme_light") %></div>
                            </div>
                            <div id="theme-dark" class="theme-box" onclick="toggleTheme('dark')">
                                <div class="t-preview t-dark"></div>
                                <div class="t-name"><i class="fas fa-moon"></i> <%= t.get("theme_dark") %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="setting-card">
                    <div class="st-header">
                        <h3><%= t.get("set_sec_title") %></h3>
                        <p><%= t.get("set_pass") %></p>
                    </div>
                    <form action="UpdateUserServlet" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="form-grid">
                            <div class="form-group">
                                <label><%= t.get("set_curr_pass") %></label>
                                <input type="password" name="passwordLama" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label><%= t.get("set_new_pass") %></label>
                                <input type="password" name="passwordBaru" class="form-control" required>
                            </div>
                        </div>
                        <button type="submit" class="btn-primary" style="margin-top:10px;"><%= t.get("btn_save") %></button>
                    </form>
                </div>

                <div class="danger-zone">
                    <div class="dz-text">
                        <h4><i class="fas fa-exclamation-triangle"></i> <%= t.get("set_danger") %></h4>
                        <h4><%= t.get("set_del_acc") %></h4>
                        <p><%= t.get("set_del_desc") %></p>
                    </div>
                    <button type="button" onclick="konfirmasiHapus()" class="btn-danger-outline">
                        <%= t.get("set_del_btn") %>
                    </button>
                </div>
            </form>
        </div>

    </main>

    <div id="notifDropdown" class="dropdown" style="position: absolute; top: 80px; right: 60px; width: 320px; background: white; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); z-index: 2000; display: none; padding: 10px 0;">
        <div style="padding: 10px 20px; font-weight: 700; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between;">
            <span><%= t.get("notif_title_bar") %></span> 
            <span style="font-size:0.75rem; color:var(--primary); cursor:pointer;"><%= t.get("notif_mark") %></span>
        </div>
        <% if(activeList.isEmpty()){ %>
            <div style="color:#999; text-align:center; padding:20px;"><%= t.get("notif_empty") %></div>
        <% } else { 
           for(Penjemputan p : activeList) { 
               boolean isProses = "Proses".equalsIgnoreCase(p.getStatus());
               String title = isProses ? t.get("notif_otw_title") : t.get("notif_req_title");
        %>
            <div style="padding:15px 20px; border-bottom:1px solid #f9f9f9; cursor:pointer;" onclick="switchView('home')">
                <div style="font-weight:600; font-size:0.9rem;"><%= title %></div>
                <div style="font-size:0.8rem; color:#888;"><%= p.getTanggal() %></div>
            </div>
        <% }} %>
    </div>
    
    <div id="chatModal" class="chat-modal">
        <div class="chat-header"><span id="chatOfficerName">Chat Officer</span><span style="cursor:pointer;" onclick="closeChat()">&times;</span></div>
        <div class="chat-body" id="chatContainer"><div style="text-align:center; margin-top:50px; color:#ccc;">...</div></div>
        <div class="chat-footer"><input type="text" id="chatInput" class="chat-input" placeholder="..." onkeydown="handleEnter(event)"><button onclick="sendMessage()" style="background:var(--primary); border:none; width:35px; height:35px; border-radius:50%; color:white; cursor:pointer;"><i class="fas fa-paper-plane"></i></button></div>
        <input type="hidden" id="chatJemputId"><input type="hidden" id="chatReceiverId"><input type="hidden" id="myUserId" value="<%= user.getId() %>">
    </div>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.js"></script>
    <script>
        var map, marker, mapInitialized = false, trackingMap;
       
        var basecampLat = -7.2650; 
        var basecampLng = 112.7600;
        
        
        <% 
           for(Penjemputan p : activeList) {
               if("Proses".equalsIgnoreCase(p.getStatus())) {
                   hasActiveProcess = true;
                   activeDestLat = p.getLatitude(); 
                   activeDestLng = p.getLongitude();
                   if(activeDestLat == 0) activeDestLat = -7.2575;
                   if(activeDestLng == 0) activeDestLng = 112.7521;
                   break; 
               }
           }
        %>

        function selectWaste(element, value) {
            document.querySelectorAll('.waste-option').forEach(el => el.classList.remove('selected'));
            element.classList.add('selected');
            document.getElementById('inputJenisSampah').value = value;
        }

        function switchView(viewName) {
            document.querySelectorAll('.view-section').forEach(e => e.classList.remove('active'));
            document.querySelectorAll('.menu-item').forEach(e => e.classList.remove('active'));
            document.getElementById('view-' + viewName).classList.add('active');
            var menu = document.getElementById('menu-' + viewName);
            if(menu) menu.classList.add('active');
            
            if(viewName === 'schedule') { 
                if(!mapInitialized) { setTimeout(initMap, 200); mapInitialized = true; } 
                else { setTimeout(function(){ map.invalidateSize(); }, 200); } 
            }
            if(viewName === 'home' && trackingMap) { setTimeout(function(){ trackingMap.invalidateSize(); }, 200); }
        }

        function toggleTheme(mode) {
            if(mode === 'dark') {
                document.body.classList.add('dark-mode');
                document.getElementById('theme-dark').classList.add('active');
                document.getElementById('theme-light').classList.remove('active');
                localStorage.setItem('theme', 'dark');
            } else {
                document.body.classList.remove('dark-mode');
                document.getElementById('theme-light').classList.add('active');
                document.getElementById('theme-dark').classList.remove('active');
                localStorage.setItem('theme', 'light');
            }
        }

        function konfirmasiHapus() {
            Swal.fire({
                title: '<%= t.get("alert_del_confirm") %>',
                text: '<%= t.get("alert_del_text") %>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '<%= isEn ? "Yes, Delete!" : "Ya, Hapus!" %>',
                cancelButtonText: '<%= t.get("btn_cancel") %>'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'UpdateUserServlet?action=deleteAccount&id=<%= user.getId() %>';
                }
            });
        }

        function initMap() {
            map = L.map('map').setView([-7.2575, 112.7521], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
            var addrInput = document.getElementsByName('alamat_raw')[0];
            
            map.on('click', function(e) { 
                if(marker) map.removeLayer(marker); 
                marker = L.marker(e.latlng).addTo(map); 
                document.getElementById('latitude').value = e.latlng.lat; 
                document.getElementById('longitude').value = e.latlng.lng; 
                
                fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat='+e.latlng.lat+'&lon='+e.latlng.lng)
                .then(r => r.json()).then(data => { 
                    if(data && data.display_name) {
                        addrInput.value = data.display_name; 
                        document.getElementById('summaryAlamat').innerText = data.display_name.substring(0, 30) + "...";
                    }
                }); 
                
                var from = L.latLng(basecampLat, basecampLng);
                var to = e.latlng;
                var distKm = from.distanceTo(to) / 1000;
                var basePrice = 5000; var serviceFee = 2000; var discount = 2000;
                var distPrice = Math.round(distKm * 2000);
                var totalPrice = basePrice + distPrice + serviceFee - discount;
                if(totalPrice < 5000) totalPrice = 5000;

                document.getElementById('biayaJarak').innerText = "Rp " + distPrice.toLocaleString('id-ID');
                document.getElementById('summaryJarak').innerText = distKm.toFixed(1) + " km";
                document.getElementById('displayHargaText').innerText = "Rp " + totalPrice.toLocaleString('id-ID');
                document.getElementById('inputJarak').value = distKm.toFixed(2);
                document.getElementById('inputHarga').value = totalPrice;
            });
            
            let timeout = null; 
            addrInput.addEventListener('input', function() { 
                clearTimeout(timeout); 
                timeout = setTimeout(function() { 
                    var q = addrInput.value; 
                    if(q.length > 5) { 
                        fetch('https://nominatim.openstreetmap.org/search?format=json&q='+q).then(r => r.json()).then(data => { 
                            if(data && data.length > 0) { 
                                var lat = data[0].lat, lon = data[0].lon; 
                                map.setView([lat, lon], 16); 
                                if(marker) map.removeLayer(marker); 
                                marker = L.marker([lat, lon]).addTo(map); 
                                document.getElementById('latitude').value = lat; 
                                document.getElementById('longitude').value = lon; 
                                document.getElementById('summaryAlamat').innerText = q.substring(0, 30) + "...";
                            } 
                        }); 
                    } 
                }, 1000); 
            });
        }

        function combineDateTime() { 
            var d=document.getElementById("inputDate").value;
            var t=document.getElementById("inputTime").value; 
            document.getElementById("finalTanggal").value = d+"T"+t; 
            var a=document.getElementsByName("alamat_raw")[0].value;
            var j=document.getElementById("inputJenisSampah").value; 
            var c=document.getElementsByName("catatan")[0].value; 
            var i=document.createElement('input'); i.type='hidden'; i.name='alamat'; 
            i.value=a+" | Jenis: "+j+" | Note: "+c; 
            document.forms[0].appendChild(i); 
        }

        function checkAndRedeem(name, cost, balance, formId) {
            if (balance < cost) {
                Swal.fire({ title: '<%= t.get("alert_fail_title") %>', text: '<%= t.get("alert_pt_insuf") %>', icon: 'error', confirmButtonColor: '#d33' });
            } else {
                Swal.fire({ title: '<%= t.get("alert_confirm_redeem") %>', text: name + ' (' + cost + ' Pts)', icon: 'question', showCancelButton: true, confirmButtonColor: '#00d25b', cancelButtonColor: '#d33', confirmButtonText: '<%= t.get("btn_yes") %>', cancelButtonText: '<%= t.get("btn_cancel") %>' }).then((result) => { if (result.isConfirmed) { document.getElementById(formId).submit(); } });
            }
        }
        
        function toggleNotifDropdown() { document.getElementById('notifDropdown').style.display = document.getElementById('notifDropdown').style.display === 'block' ? 'none' : 'block'; }
        
        
        function submitProfile() {
            var f = document.getElementById('inputFname').value;
            var l = document.getElementById('inputLname').value;
            document.getElementById('combinedName').value = f + (l ? " " + l : "");
            document.getElementById('profileForm').submit();
        }
        
        function changeAvatar() {
            var newName = prompt("<%= isEn ? "Enter name for avatar seed:" : "Masukkan nama untuk avatar:" %>");
            if(newName) {
               document.getElementById('avatarPreview').style.backgroundImage = "url('https://ui-avatars.com/api/?name=" + newName.replace(" ","+") + "&background=random&size=128')";
            }
        }

        
        var chatInterval;
        function openChat(idJemput, officerId, officerName) {
            if(officerId == 0) { Swal.fire("Info", "Menunggu petugas mengambil order ini...", "info"); return; }
            document.getElementById('chatJemputId').value = idJemput;
            document.getElementById('chatReceiverId').value = officerId;
            document.getElementById('chatOfficerName').innerText = officerName;
            document.getElementById('chatModal').classList.add('show');
            loadMessages();
            if(chatInterval) clearInterval(chatInterval);
            chatInterval = setInterval(loadMessages, 3000);
        }
        function closeChat() { document.getElementById('chatModal').classList.remove('show'); if(chatInterval) clearInterval(chatInterval); }
        function loadMessages() {
            var idJemput = document.getElementById('chatJemputId').value;
            var myId = document.getElementById('myUserId').value;
            fetch('ChatServlet?id_penjemputan=' + idJemput).then(response => response.json()).then(data => {
                var html = '';
                if(data.length === 0) { html = '<div style="text-align:center; color:#ccc; font-size:0.8rem; margin-top:20px;">Belum ada pesan.</div>'; } else {
                    data.forEach(msg => {
                        var isMe = (msg.sender_id == myId);
                        var rowClass = isMe ? 'me' : 'other';
                        var bubbleClass = isMe ? 'bubble-me' : 'bubble-other';
                    
                        var senderName = isMe ? 'Saya' : document.getElementById('chatOfficerName').innerText;
                        var avatarName = senderName.replace(" ", "+");
                        var avatarUrl = 'https://ui-avatars.com/api/?name=' + avatarName + '&background=random&size=64';

                        html += '<div class="chat-row ' + rowClass + '">';
                        html += '  <div class="chat-avatar" style="background-image: url(\'' + avatarUrl + '\');"></div>';
                        html += '  <div class="chat-content">';
                        html += '    <div class="chat-name">' + senderName + '</div>';
                        html += '    <div class="bubble ' + bubbleClass + '">' + msg.message + '</div>';
                        html += '  </div>';
                        html += '</div>';
                    });
                }
                var container = document.getElementById('chatContainer');
                container.innerHTML = html;
                container.scrollTop = container.scrollHeight;
            });
        }
        function sendMessage() {
            var idJemput = document.getElementById('chatJemputId').value;
            var receiverId = document.getElementById('chatReceiverId').value;
            var inputField = document.getElementById('chatInput');
            var msg = inputField.value.trim();

            if (!msg) return;

            fetch('ChatServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id_penjemputan=' + idJemput + '&receiver_id=' + receiverId + '&message=' + encodeURIComponent(msg)
            }).then(res => {
                if (res.ok) {
                    inputField.value = ''; 
                    loadMessages();
                }
            });
        }
        function handleEnter(e) { 
            if (e.key === 'Enter') {
                e.preventDefault(); 
                sendMessage(); 
            }
        }

        window.onclick = function(e) { 
            if (!e.target.closest('.icon-btn') && !e.target.closest('.dropdown') && !e.target.closest('.chat-modal') && !e.target.closest('.swal2-container')) { 
                document.getElementById('notifDropdown').style.display = 'none'; 
            } 
        }

        document.addEventListener("DOMContentLoaded", function() {
            
            var savedTheme = localStorage.getItem('theme');
            if(savedTheme === 'dark') toggleTheme('dark'); else toggleTheme('light');

            <% if(hasActiveProcess) { %>
            if(document.getElementById('trackingMap')) {
                
                var officerIcon = L.divIcon({
                    className: 'custom-map-icon',
                    html: '<div style="background:#00d25b; width:40px; height:40px; border-radius:50%; border:2px solid white; box-shadow:0 2px 5px rgba(0,0,0,0.3); display:flex; justify-content:center; align-items:center; color:white; font-size:1.2rem;"><i class="fas fa-motorcycle"></i></div>',
                    iconSize: [40, 40],
                    iconAnchor: [20, 20]
                });

                
                var userIcon = L.divIcon({
                    className: 'custom-map-icon',
                    html: '<div style="background:#ff4757; width:40px; height:40px; border-radius:50%; border:2px solid white; box-shadow:0 2px 5px rgba(0,0,0,0.3); display:flex; justify-content:center; align-items:center; color:white; font-size:1.2rem;"><i class="fas fa-user"></i></div>',
                    iconSize: [40, 40],
                    iconAnchor: [20, 20]
                });

                var start = [-7.2650, 112.7600]; // Basecamp (Start)
                var end = [<%= activeDestLat %>, <%= activeDestLng %>]; // User Location (End)
                
                trackingMap = L.map('trackingMap').setView(end, 14);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(trackingMap);
                
                L.Routing.control({ 
                    waypoints: [L.latLng(start), L.latLng(end)], 
                    routeWhileDragging: false, 
                    show: false, 
                    addWaypoints: false, 
                    draggableWaypoints: false,
                    lineOptions: { styles: [{color: '#00d25b', opacity: 0.8, weight: 6}] },
                    createMarker: function(i, wp, nWps) {
                        if (i === 0) {
                            return L.marker(wp.latLng, { icon: officerIcon }); // Start = Petugas (Motor)
                        } else {
                            return L.marker(wp.latLng, { icon: userIcon }); // End = User (Orang)
                        }
                    }
                }).addTo(trackingMap);
            }
            <% } %>
        });
    </script>
</body>
</html>