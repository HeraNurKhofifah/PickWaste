<%-- 
    Document   : dashboardUser
    Description: FINAL REVISION - Fixed Settings/Profile + Rewards Restored to Original Design
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Masyarakat" %>
<%@page import="model.Penjemputan" %>
<%@page import="dao.PenjemputanDAO" %>
<%@page import="dao.RewardDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page session="true" %>

<%
    // --- 1. CEK SESI USER ---
    Object userObj = session.getAttribute("user");
    if (userObj == null || !(userObj instanceof Masyarakat)) {
        response.sendRedirect("login.jsp"); return;
    }
    Masyarakat user = (Masyarakat) userObj;

    // --- 2. LOGIKA BAHASA ---
    String lang = request.getParameter("lang");
    String sessionLang = (String) session.getAttribute("appLang");
    if (lang != null) { session.setAttribute("appLang", lang); sessionLang = lang; } 
    else if (sessionLang == null) { sessionLang = "id"; }

    boolean isEn = "en".equals(sessionLang);
    Map<String, String> t = new HashMap<>();

    if (isEn) {
        t.put("menu_dash", "Dashboard"); t.put("menu_sch", "Schedule Pickup"); t.put("menu_hist", "History"); t.put("menu_rew", "Rewards"); t.put("menu_set", "Settings");
        t.put("welcome", "Welcome back"); t.put("sub_welcome", "Let's make the world cleaner.");
        t.put("card_req", "Total Requests"); t.put("card_bal", "Point Balance"); t.put("card_stat", "Latest Status");
        t.put("act_title", "Recent Activity"); t.put("act_view", "View All");
        t.put("btn_pickup", "Pickup"); t.put("status_wait", "Searching Officer..."); t.put("status_wait_desc", "Your request is being processed. Please wait.");
        t.put("status_otw", "Officer on the way..."); t.put("status_est", "Est. Time");
        t.put("form_title", "Schedule Pickup"); t.put("form_date", "Date"); t.put("form_time", "Time"); t.put("form_loc", "Location");
        t.put("form_type", "Waste Type"); t.put("form_note", "Notes"); t.put("form_btn", "Schedule Now");
        t.put("rew_title", "Redeem Points"); t.put("rew_btn", "Redeem"); t.put("rew_add_pt", "Add Points");
        t.put("set_gen", "General Settings"); t.put("set_lang", "App Language"); t.put("set_sec", "Account Security"); t.put("set_prof_priv", "Private Profile");
        t.put("set_pass", "Change Password"); t.put("set_curr_pass", "Current Password"); t.put("set_new_pass", "New Password"); t.put("set_upd_pass", "Update Password");
        t.put("prof_title", "User Profile"); t.put("lbl_name", "Full Name"); t.put("lbl_email", "Email"); t.put("lbl_hp", "Phone Number"); t.put("lbl_dob", "Date of Birth"); t.put("lbl_addr", "Full Address"); t.put("btn_save", "Save Changes");
        t.put("notif_title", "Notifications"); t.put("notif_mark", "Mark as read"); t.put("notif_item_title", "Driver on the way"); t.put("notif_item_desc", "Budi is heading to your location.");
        t.put("help_title", "Help Center"); t.put("help_search", "Search your issue..."); t.put("help_wa", "Contact via WhatsApp");
        t.put("alert_suc_title", "Success!"); t.put("alert_fail_title", "Failed!");
        t.put("alert_redeem_suc", "Points redeemed successfully."); t.put("alert_redeem_fail", "Insufficient points."); t.put("alert_sch_suc", "Pickup scheduled.");
        t.put("alert_pt_insuf", "You need more points."); t.put("alert_confirm_redeem", "Redeem this reward?"); t.put("btn_yes", "Yes, Redeem!"); t.put("btn_cancel", "Cancel");
        t.put("stat_pending", "Pending"); t.put("stat_process", "In Progress"); t.put("stat_done", "Completed"); t.put("stat_none", "No activity yet.");
        t.put("ao_title", "Active Orders"); t.put("chat_btn", "Chat Officer");
        t.put("notif_req_title", "Request Received"); t.put("notif_req_desc", "Waiting for officer...");
        t.put("notif_otw_title", "Officer OTW"); t.put("notif_otw_desc", "Prepare your waste.");
        t.put("notif_empty", "No new notifications");
    } else {
        t.put("menu_dash", "Dashboard"); t.put("menu_sch", "Jadwal Jemput"); t.put("menu_hist", "Riwayat"); t.put("menu_rew", "Hadiah"); t.put("menu_set", "Pengaturan");
        t.put("welcome", "Selamat Datang"); t.put("sub_welcome", "Mari buat dunia lebih bersih.");
        t.put("card_req", "Total Request"); t.put("card_bal", "Saldo Poin"); t.put("card_stat", "Status Terakhir");
        t.put("act_title", "Aktivitas Terakhir"); t.put("act_view", "Lihat Semua");
        t.put("btn_pickup", "Jemput"); t.put("status_wait", "Mencari Petugas..."); t.put("status_wait_desc", "Permintaan sedang diproses. Mohon tunggu.");
        t.put("status_otw", "Petugas menuju lokasi..."); t.put("status_est", "Estimasi");
        t.put("form_title", "Jadwalkan Penjemputan"); t.put("form_date", "Tanggal"); t.put("form_time", "Waktu"); t.put("form_loc", "Lokasi Penjemputan");
        t.put("form_type", "Jenis Sampah"); t.put("form_note", "Catatan Tambahan"); t.put("form_btn", "Jadwalkan Sekarang");
        t.put("rew_title", "Tukarkan Poin"); t.put("rew_btn", "Tukar"); t.put("rew_add_pt", "Tambah Poin");
        t.put("set_gen", "Pengaturan Umum"); t.put("set_lang", "Bahasa Aplikasi"); t.put("set_sec", "Keamanan Akun"); t.put("set_prof_priv", "Profil Privat (Hanya saya)");
        t.put("set_pass", "Ganti Password"); t.put("set_curr_pass", "Password Saat Ini"); t.put("set_new_pass", "Password Baru"); t.put("set_upd_pass", "Update Password");
        t.put("prof_title", "Profil Pengguna"); t.put("lbl_name", "Nama Lengkap"); t.put("lbl_email", "Email"); t.put("lbl_hp", "No Handphone"); t.put("lbl_dob", "Tanggal Lahir"); t.put("lbl_addr", "Alamat Lengkap"); t.put("btn_save", "Simpan Perubahan");
        t.put("notif_title", "Notifikasi"); t.put("notif_mark", "Tandai baca"); t.put("notif_item_title", "Driver Menuju Lokasi"); t.put("notif_item_desc", "Budi sedang dalam perjalanan.");
        t.put("help_title", "Bantuan"); t.put("help_search", "Cari masalah Anda (misal: poin)..."); t.put("help_wa", "Hubungi via WhatsApp");
        t.put("alert_suc_title", "Berhasil!"); t.put("alert_fail_title", "Gagal!");
        t.put("alert_redeem_suc", "Poin berhasil ditukarkan."); t.put("alert_redeem_fail", "Poin Anda tidak mencukupi."); t.put("alert_sch_suc", "Jadwal penjemputan dibuat.");
        t.put("alert_pt_insuf", "Poin Anda kurang."); t.put("alert_confirm_redeem", "Tukar hadiah ini?"); t.put("btn_yes", "Ya, Tukar!"); t.put("btn_cancel", "Batal");
        t.put("stat_pending", "Menunggu"); t.put("stat_process", "Proses"); t.put("stat_done", "Selesai"); t.put("stat_none", "Belum ada aktivitas.");
        t.put("ao_title", "Order Berjalan"); t.put("chat_btn", "Chat Petugas");
        t.put("notif_req_title", "Permintaan Diterima"); t.put("notif_req_desc", "Menunggu petugas...");
        t.put("notif_otw_title", "Petugas Menuju Lokasi"); t.put("notif_otw_desc", "Siapkan sampah Anda.");
        t.put("notif_empty", "Tidak ada notifikasi baru");
    }

    // --- 3. LOAD DATA ---
    PenjemputanDAO dao = new PenjemputanDAO();
    RewardDAO rewardDAO = new RewardDAO();
    List<Penjemputan> activeList = new ArrayList<>();
    List<Penjemputan> historyList = new ArrayList<>();
    
    int currentBalance = 0;
    boolean showMap = false;        
    boolean showWaiting = false;    
    
    try {
        List<Penjemputan> allList = dao.getByUserId(user.getId());
        int totalMasuk = dao.getTotalPoin(user.getId());
        int totalKeluar = rewardDAO.getTotalPoinDitukar(user.getId());
        currentBalance = totalMasuk - totalKeluar;
        
        for(Penjemputan p : allList) {
            if ("Pending".equalsIgnoreCase(p.getStatus()) || "Proses".equalsIgnoreCase(p.getStatus())) { 
                activeList.add(p);
                if ("Pending".equalsIgnoreCase(p.getStatus())) showWaiting = true;
                if ("Proses".equalsIgnoreCase(p.getStatus())) { showMap = true; showWaiting = false; }
            } else {
                historyList.add(p);
            }
        }
    } catch(Exception e) { e.printStackTrace(); }
    
    String rawStatus = (!activeList.isEmpty()) ? activeList.get(0).getStatus() : (!historyList.isEmpty() ? historyList.get(0).getStatus() : "-");
    String displayStatus = rawStatus;
    if(isEn) {
        if("Pending".equalsIgnoreCase(rawStatus)) displayStatus = "Pending";
        else if("Proses".equalsIgnoreCase(rawStatus)) displayStatus = "In Progress";
        else if("Selesai".equalsIgnoreCase(rawStatus)) displayStatus = "Completed";
    } else {
        if("Pending".equalsIgnoreCase(rawStatus)) displayStatus = "Menunggu"; 
    }
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
        /* --- CSS VARIABLES --- */
        :root { --primary: #00d25b; --primary-dark: #00b850; --bg-body: #f4f7f6; --bg-card: #ffffff; --text-main: #2d3436; --text-grey: #a4b0be; --shadow: 0 10px 30px rgba(0,0,0,0.03); --radius: 15px; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; }
        a { text-decoration: none; color: inherit; }

        /* SIDEBAR */
        .sidebar { width: 260px; background: var(--bg-card); padding: 30px; display: flex; flex-direction: column; justify-content: space-between; position: fixed; height: 100vh; box-shadow: 2px 0 20px rgba(0,0,0,0.02); z-index: 100; }
        .brand { font-size: 1.4rem; font-weight: 800; color: #112413; display: flex; align-items: center; gap: 10px; margin-bottom: 40px; } .brand i { color: var(--primary); }
        .menu-list { list-style: none; }
        .menu-item { display: flex; align-items: center; gap: 15px; padding: 14px 20px; color: #666; font-weight: 500; border-radius: 12px; margin-bottom: 8px; transition: 0.3s; cursor: pointer; }
        .menu-item:hover, .menu-item.active { background: #e6fcf0; color: var(--primary); font-weight: 600; }
        .menu-item i { width: 20px; text-align: center; }
        .user-mini { display: flex; align-items: center; gap: 12px; padding-top: 20px; border-top: 1px solid #eee; cursor:pointer; }
        .avatar-mini { width: 40px; height: 40px; background: #e6fcf0; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        
        /* MAIN CONTENT */
        .main-content { margin-left: 260px; flex: 1; padding: 30px 40px; width: calc(100% - 260px); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { font-size: 1.6rem; font-weight: 700; margin-bottom: 5px; }
        .header p { color: var(--text-grey); font-size: 0.9rem; }
        .header-controls { display: flex; align-items: center; gap: 20px; }
        .poin-badge { background: white; padding: 8px 16px; border-radius: 30px; font-weight: 700; color: var(--primary); box-shadow: var(--shadow); display: flex; align-items: center; gap: 8px; border: 1px solid #eee; }
        .icon-btn { width: 40px; height: 40px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #666; box-shadow: var(--shadow); cursor: pointer; transition: 0.2s; position: relative; }
        .icon-btn:hover { color: var(--primary); transform: translateY(-2px); }
        .notif-dot { position: absolute; top: 8px; right: 8px; width: 8px; height: 8px; background: #ff4757; border-radius: 50%; border: 2px solid white; }
        .btn-primary { background: var(--primary); color: white; padding: 10px 25px; border-radius: 30px; font-weight: 600; border: none; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 15px rgba(0, 210, 91, 0.3); display: flex; align-items: center; gap: 8px; }
        .btn-primary:hover { background: var(--primary-dark); transform: translateY(-2px); }

        /* CARDS & LAYOUT */
        .cards-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 25px; border-radius: var(--radius); box-shadow: var(--shadow); display: flex; align-items: center; gap: 20px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        .table-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; color: #888; font-weight: 500; font-size: 0.85rem; border-bottom: 1px solid #eee; }
        td { padding: 15px; font-size: 0.95rem; border-bottom: 1px solid #f9f9f9; }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-green { background: #e6fcf0; color: #00d25b; }
        .badge-yellow { background: #fff7d1; color: #f1c40f; }

        .active-order-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); margin-bottom: 20px; border-left: 5px solid #f1c40f; }
        .active-order-card.proses { border-left-color: var(--primary); }
        .ao-header { display:flex; justify-content:space-between; margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:10px;}
        .waiting-box { background: white; padding: 40px; border-radius: var(--radius); box-shadow: var(--shadow); text-align: center; margin-bottom: 30px; border-top: 4px solid #f1c40f; }
        .pulse-icon { font-size: 3rem; color: #f1c40f; margin-bottom: 15px; animation: pulse 1.5s infinite; }

        .chat-modal { position: fixed; bottom: 20px; right: 20px; width: 350px; background: white; border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); z-index: 5000; display: none; flex-direction: column; border: 1px solid #eee; overflow: hidden; }
        .chat-modal.show { display: flex; animation: slideUp 0.3s; }
        .chat-header { background: var(--primary); color: white; padding: 15px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
        .chat-body { height: 300px; overflow-y: auto; padding: 15px; background: #f9f9f9; display: flex; flex-direction: column; gap: 10px; }
        .chat-footer { padding: 10px; background: white; border-top: 1px solid #eee; display: flex; gap: 10px; }
        .chat-input { flex: 1; border: 1px solid #ddd; padding: 8px 15px; border-radius: 20px; outline: none; }
        .bubble { padding: 10px 15px; border-radius: 15px; max-width: 80%; font-size: 0.9rem; line-height: 1.4; word-wrap: break-word; }
        .bubble-me { background: #e6fcf0; color: #006b2e; align-self: flex-end; border-bottom-right-radius: 2px; }
        .bubble-other { background: white; border: 1px solid #eee; align-self: flex-start; border-bottom-left-radius: 2px; }

        .form-section { background: white; padding: 30px; border-radius: var(--radius); box-shadow: var(--shadow); max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #eee; border-radius: 10px; background: #fcfcfc; }
        .row-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .price-display { background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center; margin-top: 10px; border: 1px dashed #ccc; }

        .settings-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #f5f5f5; }
        .switch { position: relative; display: inline-block; width: 50px; height: 26px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 4px; bottom: 4px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(24px); }

        #trackingMap, #map { height: 300px; width: 100%; border-radius: 12px; z-index: 1; }
        #map { height: 250px; margin-top: 10px; }
        
        .view-section { display: none; animation: slideUp 0.4s ease-out; } .view-section.active { display: block; }
        @keyframes slideUp { from { opacity:0; transform: translateY(20px); } to { opacity:1; transform: translateY(0); } }
        @keyframes pulse { 0% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.1); opacity: 0.7; } 100% { transform: scale(1); opacity: 1; } }

        /* NOTIFICATION DROPDOWN */
        .dropdown { position: absolute; top: 70px; right: 80px; width: 320px; background: white; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); z-index: 2000; display: none; padding: 10px 0; }
        .dropdown.show { display: block; animation: fadeIn 0.2s; }
        .dropdown-header { padding: 10px 20px; font-weight: 700; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between; }
        .dropdown-item { padding: 15px 20px; border-bottom: 1px solid #f9f9f9; cursor: pointer; display: flex; gap: 12px; }
        .dropdown-item:hover { background: #f9f9f9; }
        
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 3000; display: none; justify-content: center; align-items: center; backdrop-filter: blur(3px); }
        .modal-overlay.show { display: flex; animation: fadeIn 0.3s; }
        .modal-box { background: white; width: 500px; padding: 30px; border-radius: 20px; position: relative; max-height: 80vh; display:flex; flex-direction:column; }
        .close-btn { position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem; color: #888; }
        
        /* MAP & FORMS */
        .tracking-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); margin-bottom: 30px; border-left: 5px solid var(--primary); }
        .track-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .driver-info { display: flex; gap: 15px; align-items: center; }
        .driver-pic { width: 50px; height: 50px; border-radius: 50%; background: #eee; }
        #trackingMap, #map { height: 300px; width: 100%; border-radius: 12px; z-index: 1; }
        #map { height: 250px; margin-top: 10px; }
        .waiting-box { background: white; padding: 40px; border-radius: var(--radius); box-shadow: var(--shadow); text-align: center; margin-bottom: 30px; border-top: 4px solid #f1c40f; }
        .pulse-icon { font-size: 3rem; color: #f1c40f; margin-bottom: 15px; animation: pulse 1.5s infinite; }
        
        .form-section { background: white; padding: 30px; border-radius: var(--radius); box-shadow: var(--shadow); max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #eee; border-radius: 10px; font-family: inherit; background: #fcfcfc; }
        .row-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .price-display { background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center; margin-top: 10px; border: 1px dashed #ccc; }

        /* REWARDS STYLES (ORIGINAL) */
        .banner-points { background: linear-gradient(135deg, #112413 0%, #1e3c21 100%); color: white; padding: 30px; border-radius: var(--radius); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .voucher-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        .v-card { background: white; padding: 20px; border-radius: var(--radius); box-shadow: var(--shadow); text-align: center; transition: 0.3s; }
        .v-card:hover { transform: translateY(-5px); }
        .v-icon { width: 50px; height: 50px; margin: 0 auto 15px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .btn-cs-wa { display: flex; align-items: center; justify-content: center; gap: 10px; background: #25D366; color: white; text-decoration: none; padding: 12px; border-radius: 10px; font-weight: 700; width: 100%; transition: 0.3s; margin-top: auto; }
        .btn-cs-wa:hover { background: #1ebc57; transform: translateY(-2px); color: white; }
        
        /* SETTINGS STYLES */
        .settings-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #f5f5f5; }
        .switch { position: relative; display: inline-block; width: 50px; height: 26px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 4px; bottom: 4px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(24px); }

        /* ACTIVE ORDER */
        .active-order-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); margin-bottom: 20px; border-left: 5px solid #f1c40f; }
        .active-order-card.proses { border-left-color: var(--primary); }
        .ao-header { display:flex; justify-content:space-between; margin-bottom:10px; border-bottom:1px solid #eee; padding-bottom:10px;}

        /* CHAT MODAL */
        .chat-modal { position: fixed; bottom: 20px; right: 20px; width: 350px; background: white; border-radius: 15px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); z-index: 5000; display: none; flex-direction: column; border: 1px solid #eee; overflow: hidden; }
        .chat-modal.show { display: flex; animation: slideUp 0.3s; }
        .chat-header { background: var(--primary); color: white; padding: 15px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
        .chat-body { height: 300px; overflow-y: auto; padding: 15px; background: #f9f9f9; display: flex; flex-direction: column; gap: 10px; }
        .chat-footer { padding: 10px; background: white; border-top: 1px solid #eee; display: flex; gap: 10px; }
        .chat-input { flex: 1; border: 1px solid #ddd; padding: 8px 15px; border-radius: 20px; outline: none; }
        .bubble { padding: 10px 15px; border-radius: 15px; max-width: 80%; font-size: 0.9rem; line-height: 1.4; word-wrap: break-word; }
        .bubble-me { background: #e6fcf0; color: #006b2e; align-self: flex-end; border-bottom-right-radius: 2px; }
        .bubble-other { background: white; border: 1px solid #eee; align-self: flex-start; border-bottom-left-radius: 2px; }

        .view-section { display: none; animation: slideUp 0.4s ease-out; } .view-section.active { display: block; }
        @keyframes slideUp { from { opacity:0; transform: translateY(20px); } to { opacity:1; transform: translateY(0); } }
        @keyframes pulse { 0% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.1); opacity: 0.7; } 100% { transform: scale(1); opacity: 1; } }
        .leaflet-routing-container { display: none !important; }
        .motor-icon, .user-home-icon { width: 40px; height: 40px; background: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.2); font-size: 1.2rem; }
        .motor-icon { color: var(--primary); border: 2px solid var(--primary); } .user-home-icon { color: #ff4757; border: 2px solid #ff4757; }
        
        .dropdown { position: absolute; top: 70px; right: 80px; width: 320px; background: white; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); z-index: 2000; display: none; padding: 10px 0; }
        .dropdown.show { display: block; animation: fadeIn 0.2s; }
        .dropdown-header { padding: 10px 20px; font-weight: 700; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between; }
        .dropdown-item { padding: 15px 20px; border-bottom: 1px solid #f9f9f9; cursor: pointer; display: flex; gap: 12px; }
        .dropdown-item:hover { background: #f9f9f9; }
        
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 3000; display: none; justify-content: center; align-items: center; backdrop-filter: blur(3px); }
        .modal-overlay.show { display: flex; animation: fadeIn 0.3s; }
        .modal-box { background: white; width: 500px; padding: 30px; border-radius: 20px; position: relative; max-height: 80vh; display:flex; flex-direction:column; }
        .close-btn { position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem; color: #888; }
        
        .help-search-input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; background: #f9f9f9; margin-bottom: 15px; font-family: inherit; }
        .help-scroll-area { overflow-y: auto; flex:1; padding-right: 5px; margin-bottom: 20px; }
        .help-scroll-area::-webkit-scrollbar { width: 5px; } .help-scroll-area::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }
        
        .faq-item { margin-bottom: 10px; border-bottom: 1px solid #f0f0f0; }
        .faq-question { font-weight: 600; cursor: pointer; padding: 10px 0; display: flex; justify-content: space-between; align-items: center; color: #333; }
        .faq-question:hover { color: var(--primary); }
        .faq-answer { font-size: 0.9rem; color: #666; max-height: 0; overflow: hidden; transition: max-height 0.3s ease-out; padding-left: 10px; border-left: 3px solid var(--primary); }
        .faq-item.active .faq-answer { max-height: 200px; padding-bottom: 10px; }
        .faq-item.active .faq-question i { transform: rotate(90deg); transition: 0.3s; }
        
        .btn-cs-wa { display: flex; align-items: center; justify-content: center; gap: 10px; background: #25D366; color: white; text-decoration: none; padding: 12px; border-radius: 10px; font-weight: 700; width: 100%; transition: 0.3s; margin-top: auto; }
        .btn-cs-wa:hover { background: #1ebc57; transform: translateY(-2px); color: white; }
        
        @media (max-width: 992px) { .sidebar { display: none; } .main-content { margin-left: 0; width: 100%; padding: 20px; } .cards-grid { grid-template-columns: 1fr; } }
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
            <div style="flex:1;"><div style="font-weight:700; font-size:0.9rem;"><%= user.getNama() %></div><div style="font-size:0.8rem; color:#888;">User</div></div>
            <a href="LogoutServlet" style="color:#ff4757;"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="header">
            <div><h1><%= t.get("welcome") %>, <%= user.getNama() %>!</h1><p><%= t.get("sub_welcome") %></p></div>
            <div class="header-controls">
                <div class="icon-btn" onclick="toggleNotifDropdown()">
                    <i class="far fa-bell"></i>
                    <% if(!activeList.isEmpty()) { %>
                        <div class="notif-dot"></div>
                    <% } %>
                </div>
                <div class="icon-btn" onclick="toggleHelpModal()"><i class="far fa-question-circle"></i></div>
                <div class="poin-badge"><i class="fas fa-coins"></i> <%= currentBalance %> Pts</div>
                <button onclick="switchView('schedule')" class="btn-primary"><i class="fas fa-plus"></i> <%= t.get("btn_pickup") %></button>
            </div>
        </header>

        <div id="view-home" class="view-section active">
            <div class="cards-grid">
                <div class="card"><div class="card-icon" style="background:#e3f2fd; color:#45aaf2;"><i class="fas fa-truck"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_req") %></div><div style="font-size:1.5rem; font-weight:700;"><%= activeList.size() + historyList.size() %></div></div></div>
                <div class="card"><div class="card-icon" style="background:#e6fcf0; color:#00d25b;"><i class="fas fa-coins"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_bal") %></div><div style="font-size:1.5rem; font-weight:700;"><%= currentBalance %></div></div></div>
                <div class="card"><div class="card-icon" style="background:#f3e5f5; color:#9c27b0;"><i class="fas fa-bullseye"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_stat") %></div><div style="font-size:1rem; font-weight:700;"><%= displayStatus %></div></div></div>
            </div>

            <% if(!activeList.isEmpty()) { %>
                <h3 style="margin-bottom:15px;"><%= t.get("ao_title") %></h3>
                <% for(Penjemputan p : activeList) { 
                    boolean isProses = "Proses".equalsIgnoreCase(p.getStatus());
                    String statusLabel = isProses ? (isEn ? "In Progress" : "Proses") : (isEn ? "Pending" : "Menunggu");
                %>
                <div class="active-order-card <%= isProses ? "proses" : "pending" %>">
                    <div class="ao-header">
                        <div><i class="far fa-calendar"></i> <%= p.getTanggal() %></div>
                        <span class="badge badge-<%= isProses ? "green" : "yellow" %>"><%= statusLabel %></span>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <h4 style="margin-bottom:5px;"><%= isProses ? t.get("status_otw") : t.get("status_wait") %></h4>
                            <p style="color:#666; font-size:0.9rem;"><i class="fas fa-map-marker-alt" style="color:#e74c3c;"></i> <%= p.getAlamat().split("\\|")[0] %></p>
                            <div style="font-size:0.85rem; margin-top:5px; color:#555;">
                                <strong>Tunai: Rp <%= String.format("%,.0f", p.getEstimasiHarga()) %></strong> (Jarak: <%= String.format("%.2f", p.getJarakKm()) %> km)
                            </div>
                        </div>
                        <% if(isProses) { %>
                            <button onclick="openChat(<%= p.getId() %>, <%= p.getOfficerId() %>, 'Petugas')" class="btn-primary" style="background:#3498db; padding:8px 20px;">
                                <i class="fas fa-comments"></i> <%= t.get("chat_btn") %>
                            </button>
                        <% } else { %>
                            <div class="pulse-icon" style="color:#f1c40f; font-size:2rem;"><i class="fas fa-search"></i></div>
                        <% } %>
                    </div>
                    <% if(isProses) { %><div id="trackingMap" style="height:200px; margin-top:15px;"></div><% } %>
                </div>
                <% } %>
            <% } else if(showWaiting && !showMap) { %>
                <div class="waiting-box"><div class="pulse-icon"><i class="fas fa-search-location"></i></div><h3><%= t.get("status_wait") %></h3><p style="color:#888;"><%= t.get("status_wait_desc") %></p></div>
            <% } %>

            <div class="table-card">
                <div class="sec-header"><h3><%= t.get("act_title") %></h3><a href="#" onclick="switchView('history')" style="color:var(--primary); font-weight:600;"><%= t.get("act_view") %></a></div>
                <table>
                    <thead><tr><th><%= t.get("form_date") %></th><th><%= t.get("form_loc") %></th><th>Status</th><th>Poin</th></tr></thead>
                    <tbody>
                        <% if(historyList.isEmpty()) { %><tr><td colspan="4" style="text-align:center;"><%= t.get("stat_none") %></td></tr><% } else { 
                            int limit = Math.min(historyList.size(), 5); for(int i=0; i<limit; i++) { Penjemputan p = historyList.get(i); 
                           String displayAddr = p.getAlamat().contains("|") ? p.getAlamat().split("\\|")[0] : p.getAlamat();
                           String displayRowStatus = isEn && "Selesai".equalsIgnoreCase(p.getStatus()) ? "Completed" : p.getStatus();
                        %>
                        <tr><td><%= p.getTanggal() %></td><td style="max-width:200px; overflow:hidden; white-space:nowrap;"><%= displayAddr %></td><td><span class="badge badge-<%= p.getStatus().equalsIgnoreCase("Selesai")?"green":"yellow" %>"><%= displayRowStatus %></span></td><td style="color:var(--primary); font-weight:700;">+<%= p.getPoin() %></td></tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-schedule" class="view-section">
            <div class="form-section">
                <h2 style="margin-bottom:25px;"><%= t.get("form_title") %></h2>
                <form action="PenjemputanServlet" method="post" onsubmit="combineDateTime()">
                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                    <input type="hidden" name="tanggal" id="finalTanggal">
                    <input type="hidden" name="latitude" id="latitude">
                    <input type="hidden" name="longitude" id="longitude">
                    <input type="hidden" name="jarak_km" id="inputJarak" value="0">
                    <input type="hidden" name="estimasi_harga" id="inputHarga" value="0">

                    <div class="row-grid">
                        <div class="form-group"><label class="form-label"><%= t.get("form_date") %></label><input type="date" id="inputDate" class="form-control" required></div>
                        <div class="form-group"><label class="form-label"><%= t.get("form_time") %></label><input type="time" id="inputTime" class="form-control" required></div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"><%= t.get("form_loc") %> (Geser Pin untuk Cek Harga)</label>
                        <input type="text" name="alamat_raw" class="form-control" placeholder="Cari alamat..." required>
                        <div id="map"></div>
                        <div class="price-display">
                            <div style="font-size:0.9rem; color:#666;">Estimasi Biaya (Tunai)</div>
                            <div id="displayHargaText" style="font-size:1.5rem; font-weight:700; color:#333;">Rp 0</div>
                            <small id="displayJarakText" style="color:#888;">Jarak: 0 km</small>
                        </div>
                    </div>

                    <div class="form-group"><label class="form-label"><%= t.get("form_type") %></label><select name="jenis_sampah" class="form-control"><option value="Organik">Organik</option><option value="Anorganik">Anorganik</option><option value="Campuran">Campuran</option></select></div>
                    <div class="form-group"><label class="form-label"><%= t.get("form_note") %></label><textarea name="catatan" class="form-control" rows="3"></textarea></div>
                    <button type="submit" class="btn-primary" style="width:100%; justify-content:center;"><%= t.get("form_btn") %></button>
                </form>
            </div>
        </div>

        <div id="view-history" class="view-section">
            <h2 style="margin-bottom:20px;"><%= t.get("menu_hist") %></h2>
            <div class="table-card">
                <table>
                    <thead><tr><th><%= t.get("form_date") %></th><th>Detail</th><th>Status</th><th>Berat</th><th>Poin</th></tr></thead>
                    <tbody>
                        <% for(Penjemputan p : historyList) { 
                           String jenis = "Sampah"; if(p.getAlamat().contains("Jenis:")) jenis = p.getAlamat().split("Jenis:")[1].split("\\|")[0]; 
                           String displayRowStatus = isEn && "Selesai".equalsIgnoreCase(p.getStatus()) ? "Completed" : p.getStatus();
                        %>
                        <tr><td><%= p.getTanggal() %></td><td><div style="font-weight:600;"><%= jenis %></div><div style="font-size:0.8rem; color:#888;">Note: <%= p.getAlamat().contains("Note:") ? p.getAlamat().split("Note:")[1] : "-" %></div></td><td><span class="badge badge-<%= p.getStatus().equalsIgnoreCase("Selesai")?"green":"yellow" %>"><%= displayRowStatus %></span></td><td><%= p.getStatus().equalsIgnoreCase("Selesai") ? p.getBerat()+" kg" : "-" %></td><td style="color:var(--primary); font-weight:700;"><%= p.getStatus().equalsIgnoreCase("Selesai") ? "+"+p.getPoin() : "-" %></td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-rewards" class="view-section">
            <div class="banner-points">
                <div><div style="opacity:0.8;"><%= t.get("card_bal") %></div><div style="font-size:2.5rem; font-weight:700;"><%= currentBalance %></div></div>
                <button onclick="switchView('schedule')" style="background:white; color:#112413; border:none; padding:10px 20px; border-radius:20px; font-weight:700; cursor:pointer;"><%= t.get("rew_add_pt") %></button>
            </div>
            <h3 style="margin-bottom:20px;"><%= t.get("rew_title") %></h3>
            <div class="voucher-grid">
                <% String[] vNames = {"Voucher 50K", "DANA 25K", "GoPay 25K", "OVO 25K", "PLN 50K", "Alfamart 100K"};
                   int[] vCosts = {500, 250, 250, 250, 500, 1000};
                   String[] vColors = {"#e6fcf0", "#e3f2fd", "#e3f2fd", "#f3e5f5", "#fff3e0", "#fff0f1"};
                   String[] vIconColors = {"#00d25b", "#45aaf2", "#00a8ff", "#9b59b6", "#f1c40f", "#fc5c65"};
                   String[] vIcons = {"shopping-basket", "wallet", "motorcycle", "mobile-alt", "bolt", "gift"};
                   for(int k=0; k<6; k++){ %>
                   <div class="v-card">
                       <div class="v-icon" style="background:<%=vColors[k]%>; color:<%=vIconColors[k]%>"><i class="fas fa-<%=vIcons[k]%>"></i></div>
                       <h4><%= vNames[k] %></h4><p style="color:#888; font-size:0.9rem; margin-bottom:15px;"><%= vCosts[k] %> Poin</p>
                       <form action="RedeemServlet" method="post" id="redeem-form-<%=k%>">
                           <input type="hidden" name="userId" value="<%= user.getId() %>">
                           <input type="hidden" name="cost" value="<%= vCosts[k] %>">
                           <input type="hidden" name="rewardName" value="<%= vNames[k] %>">
                           <button type="button" onclick="checkAndRedeem('<%= vNames[k] %>', <%= vCosts[k] %>, <%= currentBalance %>, 'redeem-form-<%=k%>')" class="btn-primary" style="width:100%; justify-content:center; font-size:0.85rem;"><%= t.get("rew_btn") %></button>
                       </form>
                   </div>
                <% } %>
            </div>
        </div>

        <div id="view-profile" class="view-section">
            <div class="form-section">
                <h2><%= t.get("prof_title") %></h2><hr style="margin:20px 0; border:0; border-top:1px solid #eee;">
                <form action="UpdateUserServlet" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="row-grid">
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_name") %></label><input type="text" name="nama" value="<%= user.getNama() %>" class="form-control" required></div>
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_email") %></label><input type="email" name="email" value="<%= user.getEmail() %>" class="form-control" required></div>
                    </div>
                    <div class="row-grid">
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_hp") %></label><input type="text" name="no_hp" value="<%= (user.getNoHp() == null || user.getNoHp().equals("-")) ? "" : user.getNoHp() %>" placeholder="+62..." class="form-control"></div>
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_dob") %></label><input type="date" name="tgl_lahir" value="<%= (user.getTglLahir() != null) ? user.getTglLahir() : "" %>" class="form-control"></div>
                    </div>
                    <div class="form-group"><label class="form-label"><%= t.get("lbl_addr") %></label><textarea name="alamat" class="form-control" rows="3"><%= (user.getAlamat() == null || user.getAlamat().equals("-")) ? "" : user.getAlamat() %></textarea></div>
                    <button class="btn-primary"><%= t.get("btn_save") %></button>
                </form>
            </div>
        </div>

        <div id="view-settings" class="view-section">
            <div class="form-section" style="margin-bottom:30px;">
                <div class="settings-header" style="font-weight:700; margin-bottom:15px; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-sliders-h" style="color:#3498db;"></i> <%= t.get("set_gen") %>
                </div>
                <div class="settings-row">
                    <div><%= t.get("set_lang") %></div>
                    <select class="form-control" style="width:150px;" onchange="window.location.href='dashboardUser.jsp?lang='+this.value">
                        <option value="id" <%= "id".equals(sessionLang)?"selected":"" %>>Indonesia</option>
                        <option value="en" <%= "en".equals(sessionLang)?"selected":"" %>>English</option>
                    </select>
                </div>
            </div>
            
            <div class="form-section">
                <div class="settings-header" style="font-weight:700; margin-bottom:15px; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-shield-alt" style="color:#9b59b6;"></i> <%= t.get("set_sec") %>
                </div>
                
                <div class="settings-row">
                    <div><%= t.get("set_prof_priv") %></div>
                    <label class="switch"><input type="checkbox" checked><span class="slider"></span></label>
                </div>
                
                <div style="margin-top:20px; padding-top:20px; border-top:1px solid #f5f5f5;">
                    <h4 style="margin-bottom:15px;"><%= t.get("set_pass") %></h4>
                    
                    <form action="UpdateUserServlet" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="row-grid">
                            <div class="form-group"><label class="form-label"><%= t.get("set_curr_pass") %></label><input type="password" name="passwordLama" class="form-control" required></div>
                            <div class="form-group"><label class="form-label"><%= t.get("set_new_pass") %></label><input type="password" name="passwordBaru" class="form-control" required></div>
                        </div>
                        <button class="btn-primary" style="background:#333;"><%= t.get("set_upd_pass") %></button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <div id="notifDropdown" class="dropdown">
        <div class="dropdown-header">
            <span><%= t.get("notif_title") %></span> 
            <span style="font-size:0.75rem; color:var(--primary); cursor:pointer;"><%= t.get("notif_mark") %></span>
        </div>
        
        <% if(activeList.isEmpty()){ %>
            <div class="dropdown-item" style="color:#999; justify-content:center; padding:20px;">
                <%= t.get("notif_empty") %>
            </div>
        <% } else { 
           for(Penjemputan p : activeList) { 
               boolean isProses = "Proses".equalsIgnoreCase(p.getStatus());
               String title = isProses ? t.get("notif_otw_title") : t.get("notif_req_title");
               String desc = isProses ? t.get("notif_otw_desc") : t.get("notif_req_desc");
               String icon = isProses ? "fa-truck" : "fa-clock";
               String color = isProses ? "background:#e6fcf0; color:#00d25b;" : "background:#fff7d1; color:#f1c40f;";
        %>
            <div class="dropdown-item" onclick="switchView('home')">
                <div style="width:35px; height:35px; border-radius:50%; display:flex; align-items:center; justify-content:center; <%= color %>">
                    <i class="fas <%= icon %>"></i>
                </div>
                <div>
                    <div style="font-weight:600; font-size:0.9rem;"><%= title %></div>
                    <div style="font-size:0.8rem; color:#888;"><%= desc %></div>
                </div>
            </div>
        <% }} %>
    </div>
    <div id="helpModalOverlay" class="modal-overlay">
        <div class="modal-box">
            <span class="close-btn" onclick="toggleHelpModal()">&times;</span>
            <h2 style="margin-bottom:20px;"><%= t.get("help_title") %></h2>
            <input type="text" id="helpSearch" class="help-search-input" placeholder="<%= t.get("help_search") %>">
            <div class="help-scroll-area">
                <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)">Bagaimana cara dapat poin? / How to get points? <i class="fas fa-chevron-right"></i></div><div class="faq-answer">1kg = 500 Poin.</div></div>
                <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)">Lupa Password? / Forgot Password? <i class="fas fa-chevron-right"></i></div><div class="faq-answer">Settings > Security.</div></div>
            </div>
            <a href="https://wa.me/6281234567890" target="_blank" class="btn-cs-wa"><i class="fab fa-whatsapp" style="font-size:1.2rem;"></i> <%= t.get("help_wa") %></a>
        </div>
    </div>

    <div id="chatModal" class="chat-modal">
        <div class="chat-header"><span id="chatOfficerName">Chat Petugas</span><span style="cursor:pointer;" onclick="closeChat()">&times;</span></div>
        <div class="chat-body" id="chatContainer"><div style="text-align:center; margin-top:50px; color:#ccc;">Memuat pesan...</div></div>
        <div class="chat-footer">
            <input type="text" id="chatInput" class="chat-input" placeholder="Tulis pesan..." onkeypress="handleEnter(event)">
            <button onclick="sendMessage()" style="background:var(--primary); border:none; width:35px; height:35px; border-radius:50%; color:white; cursor:pointer;"><i class="fas fa-paper-plane"></i></button>
        </div>
        <input type="hidden" id="chatJemputId"><input type="hidden" id="chatReceiverId"><input type="hidden" id="myUserId" value="<%= user.getId() %>">
    </div>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.js"></script>
    <script>
        var map, marker, mapInitialized = false, trackingMap;
        var basecampLat = -7.2650; 
        var basecampLng = 112.7600;

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
        function toggleNotifDropdown() { var el = document.getElementById('notifDropdown'); el.classList.toggle('show'); document.getElementById('helpModalOverlay').classList.remove('show'); }
        function toggleHelpModal() { document.getElementById('helpModalOverlay').classList.toggle('show'); document.getElementById('notifDropdown').classList.remove('show'); }
        function toggleFaq(element) { element.parentElement.classList.toggle('active'); }
        
        document.getElementById('helpSearch').addEventListener('keyup', function() {
            let filter = this.value.toLowerCase();
            document.querySelectorAll('.faq-item').forEach(item => { item.style.display = item.innerText.toLowerCase().includes(filter) ? 'block' : 'none'; });
        });

        function checkAndRedeem(name, cost, balance, formId) {
            if (balance < cost) {
                Swal.fire({ title: '<%= t.get("alert_fail_title") %>', text: '<%= t.get("alert_pt_insuf") %>', icon: 'error', confirmButtonColor: '#d33' });
            } else {
                Swal.fire({ title: '<%= t.get("alert_confirm_redeem") %>', text: name + ' (' + cost + ' Pts)', icon: 'question', showCancelButton: true, confirmButtonColor: '#00d25b', cancelButtonColor: '#d33', confirmButtonText: '<%= t.get("btn_yes") %>', cancelButtonText: '<%= t.get("btn_cancel") %>' }).then((result) => { if (result.isConfirmed) { document.getElementById(formId).submit(); } });
            }
        }

        // --- MAP LOGIC ---
        function initMap() {
            map = L.map('map').setView([-7.2575, 112.7521], 13); L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
            var addrInput = document.getElementsByName('alamat_raw')[0];
            
            map.on('click', function(e) { 
                if(marker) map.removeLayer(marker); 
                marker = L.marker(e.latlng).addTo(map); 
                document.getElementById('latitude').value = e.latlng.lat; 
                document.getElementById('longitude').value = e.latlng.lng; 
                
                fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat='+e.latlng.lat+'&lon='+e.latlng.lng).then(r => r.json()).then(data => { if(data && data.display_name) addrInput.value = data.display_name; }); 
                
                var from = L.latLng(basecampLat, basecampLng);
                var to = e.latlng;
                var distMeters = from.distanceTo(to);
                var distKm = distMeters / 1000;
                var price = Math.round(distKm * 2000);
                if(price < 5000) price = 5000;
                
                document.getElementById('displayHargaText').innerText = "Rp " + price.toLocaleString('id-ID');
                document.getElementById('displayJarakText').innerText = "Jarak dari pusat: " + distKm.toFixed(2) + " km";
                document.getElementById('inputJarak').value = distKm.toFixed(2);
                document.getElementById('inputHarga').value = price;
            });
            
            let timeout = null; addrInput.addEventListener('input', function() { clearTimeout(timeout); timeout = setTimeout(function() { var q = addrInput.value; if(q.length > 5) { fetch('https://nominatim.openstreetmap.org/search?format=json&q='+q).then(r => r.json()).then(data => { if(data && data.length > 0) { var lat = data[0].lat, lon = data[0].lon; map.setView([lat, lon], 16); if(marker) map.removeLayer(marker); marker = L.marker([lat, lon]).addTo(map); document.getElementById('latitude').value = lat; document.getElementById('longitude').value = lon; } }); } }, 1000); });
        }
        function combineDateTime() { var d=document.getElementById("inputDate").value, t=document.getElementById("inputTime").value; document.getElementById("finalTanggal").value = d+"T"+t; var a=document.getElementsByName("alamat_raw")[0].value, j=document.getElementsByName("jenis_sampah")[0].value, c=document.getElementsByName("catatan")[0].value; var i=document.createElement('input'); i.type='hidden'; i.name='alamat'; i.value=a+" | Jenis: "+j+" | Note: "+c; document.forms[0].appendChild(i); }
        
        window.onclick = function(e) { if (!e.target.closest('.icon-btn') && !e.target.closest('.dropdown') && !e.target.closest('.modal-box') && !e.target.closest('.swal2-container')) { document.getElementById('notifDropdown').classList.remove('show'); if(e.target.classList.contains('modal-overlay')) document.getElementById('helpModalOverlay').classList.remove('show'); } }

        // --- CHAT LOGIC ---
        var chatInterval;
        function openChat(idJemput, officerId, officerName) {
            if(officerId == 0) { Swal.fire("Info", "Menunggu petugas mengambil order ini...", "info"); return; }
            document.getElementById('chatJemputId').value = idJemput;
            document.getElementById('chatReceiverId').value = officerId;
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
                if(data.length === 0) { html = '<div style="text-align:center; color:#ddd; font-size:0.8rem; margin-top:20px;">Belum ada pesan. Mulai percakapan!</div>'; } else {
                    data.forEach(msg => {
                        var isMe = (msg.sender_id == myId);
                        var cssClass = isMe ? 'bubble-me' : 'bubble-other';
                        var senderName = isMe ? 'Saya' : msg.sender_name;
                        html += '<div class="bubble ' + cssClass + '"><b>' + senderName + '</b><br>' + msg.message + '</div>';
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
            var msg = document.getElementById('chatInput').value;
            if(!msg) return;
            fetch('ChatServlet', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: 'id_penjemputan=' + idJemput + '&receiver_id=' + receiverId + '&message=' + encodeURIComponent(msg) }).then(res => { if(res.ok) { document.getElementById('chatInput').value = ''; loadMessages(); } });
        }
        function handleEnter(e) { if(e.key === 'Enter') sendMessage(); }

        // --- ALERTS ---
        document.addEventListener("DOMContentLoaded", function() {
            if(document.getElementById('trackingMap')) {
                var start = [-7.2650, 112.7600]; var end = [-7.2575, 112.7521];
                trackingMap = L.map('trackingMap').setView(end, 14);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(trackingMap);
                var iconMotor = L.divIcon({className: 'custom-icon', html: '<div class="motor-icon"><i class="fas fa-motorcycle"></i></div>', iconSize: [40,40]});
                var iconRumah = L.divIcon({className: 'custom-icon', html: '<div class="user-home-icon"><i class="fas fa-home"></i></div>', iconSize: [40,40]});
                L.marker(start, {icon: iconMotor}).addTo(trackingMap); L.marker(end, {icon: iconRumah}).addTo(trackingMap);
                L.Routing.control({ waypoints: [L.latLng(start), L.latLng(end)], routeWhileDragging: false, show: false, addWaypoints: false, draggableWaypoints: false, createMarker: function() { return null; }, lineOptions: { styles: [{color: '#00d25b', opacity: 0.8, weight: 6}] } }).addTo(trackingMap);
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            if (status === 'profileUpdated') { Swal.fire('Berhasil!', 'Profil Anda telah diperbarui.', 'success').then(() => window.history.replaceState(null, null, window.location.pathname)); }
            else if (status === 'passUpdated') { Swal.fire('Berhasil!', 'Password berhasil diganti.', 'success').then(() => window.history.replaceState(null, null, window.location.pathname)); }
            else if (status === 'wrongOldPass') { Swal.fire('Gagal!', 'Password lama Anda salah.', 'error').then(() => window.history.replaceState(null, null, window.location.pathname)); }
        });
    </script>
</body>
</html>