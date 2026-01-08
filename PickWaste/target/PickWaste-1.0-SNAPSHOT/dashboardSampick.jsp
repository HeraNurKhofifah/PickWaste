<%-- 
    Document    : dashboardSampick
    Description : OFFICER DASHBOARD 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Pengguna" %> 
<%@page import="model.Penjemputan" %>
<%@page import="dao.PenjemputanDAO" %>
<%@page import="dao.PenggunaDAO" %> 
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page session="true" %>

<%
    
    Object userObj = session.getAttribute("user");
    if (userObj == null || !(userObj instanceof Pengguna)) {
        response.sendRedirect("login.jsp"); 
        return;
    }
    
    Pengguna officer = (Pengguna) userObj;
    String role = (String) session.getAttribute("role"); 

    if (role == null || (!"petugas".equalsIgnoreCase(role) && !"sampick".equalsIgnoreCase(role))) {
        response.sendRedirect("login.jsp");
        return;
    }


    String lang = request.getParameter("lang");
    String sessionLang = (String) session.getAttribute("appLang");
    if (lang != null && !lang.isEmpty()) { 
        session.setAttribute("appLang", lang); 
        sessionLang = lang; 
    } else if (sessionLang == null) { 
        sessionLang = "id"; 
        session.setAttribute("appLang", "id");
    }

    Map<String, String> t = new HashMap<>();
    boolean isEn = "en".equals(sessionLang);
    

    if (isEn) {
        t.put("menu_dash", "Dashboard"); t.put("menu_task", "My Tasks"); t.put("menu_hist", "History");
        t.put("menu_inc", "Income"); t.put("menu_set", "Settings"); t.put("menu_prof", "Profile");
        
        t.put("inc_title", "My Income"); t.put("inc_sub", "Summary of your earnings and transaction history.");
        t.put("inc_card_bal", "Total Active Balance");
        t.put("inc_card_month", "Income This Month"); t.put("inc_card_sess", "Total Sessions");
        t.put("inc_vs_last", "vs last month"); t.put("inc_chart_title", "Income Chart");
        t.put("inc_tab_week", "Weekly"); t.put("inc_tab_month", "Monthly"); t.put("inc_tab_year", "Yearly");
        t.put("inc_hist_title", "Transaction History"); t.put("inc_view_all", "View All");
        
        t.put("welcome", "Hello"); t.put("sub_welcome", "Ready to clean the city today?");
        t.put("card_avail", "Available Orders"); t.put("card_prog", "In Progress"); t.put("card_total", "Total Income");
        t.put("btn_take", "Take Job"); t.put("btn_finish", "Finish"); t.put("btn_chat", "Chat");
        t.put("btn_map", "Map"); t.put("active_route", "Active Route");
        
        t.put("tab_date", "Date"); t.put("tab_loc", "Location"); t.put("tab_dist", "Dist."); t.put("tab_price", "Fee"); t.put("tab_act", "Action");
        t.put("tab_cust", "Customer"); t.put("tab_weight", "Weight"); t.put("tab_earn", "Earnings"); t.put("tab_status", "Status");
        t.put("stat_none", "No data available.");

        t.put("set_priv_title", "Privacy Settings"); t.put("set_priv_desc", "Control officer visibility.");
        t.put("set_vis_title", "Active Status Visibility"); t.put("set_vis_desc", "Allow users to see you on the map when online.");
        t.put("set_ana_title", "Route Optimization"); t.put("set_ana_desc", "Allow system to suggest best routes.");
        t.put("set_app_title", "Appearance & Language"); t.put("set_lang", "App Language"); t.put("set_theme", "Display Theme");
        t.put("theme_light", "Light"); t.put("theme_dark", "Dark");
        t.put("set_sec_title", "Account Security"); t.put("set_pass", "Change Password"); 
        t.put("set_curr_pass", "Current Password"); t.put("set_new_pass", "New Password");
        t.put("set_danger", "Danger Zone"); t.put("set_del_acc", "Delete Account"); t.put("set_del_btn", "Delete My Account");
        t.put("set_del_desc", "Deleting account is permanent. All points will be lost.");
        t.put("alert_del_confirm", "Are you sure?"); t.put("alert_del_text", "This action cannot be undone!");
        
        t.put("btn_save", "Save Changes"); t.put("btn_cancel", "Cancel"); t.put("set_logout", "Logout");
        
        t.put("alert_confirm_take", "Take this order?"); t.put("alert_finish_title", "Finish Order"); t.put("alert_finish_text", "Input waste weight (kg):");
        t.put("notif_title", "Notifications"); t.put("notif_mark", "Mark as read"); t.put("notif_empty", "No new notifications");
        
        t.put("prof_title", "User Profile"); t.put("prof_header_info", "Personal Information"); t.put("prof_edit", "Edit");
        t.put("prof_fname", "First Name"); t.put("prof_lname", "Last Name"); 
        t.put("prof_email", "Email"); t.put("prof_phone", "Phone Number"); t.put("prof_main_addr", "Basecamp Address"); 
        t.put("prof_btn_pin", "Pin Location"); t.put("prof_role", "Role"); t.put("role_name", "Field Officer");
    } else {
        // INDONESIA
        t.put("menu_dash", "Dashboard"); t.put("menu_task", "Tugas Saya"); t.put("menu_hist", "Riwayat");
        t.put("menu_inc", "Pendapatan"); t.put("menu_set", "Pengaturan"); t.put("menu_prof", "Profil");
        
        t.put("inc_title", "Pendapatan Saya"); t.put("inc_sub", "Ringkasan penghasilan dan riwayat transaksi penjemputan Anda.");
        t.put("inc_card_bal", "Total Saldo Aktif");
        t.put("inc_card_month", "Pendapatan Bulan Ini"); t.put("inc_card_sess", "Total Penjemputan");
        t.put("inc_vs_last", "vs bulan lalu"); t.put("inc_chart_title", "Grafik Pendapatan");
        t.put("inc_tab_week", "Mingguan"); t.put("inc_tab_month", "Bulanan"); t.put("inc_tab_year", "Tahunan");
        t.put("inc_hist_title", "Riwayat Transaksi"); t.put("inc_view_all", "Lihat Semua");

        t.put("welcome", "Halo"); t.put("sub_welcome", "Siap membersihkan kota hari ini?");
        t.put("card_avail", "Order Tersedia"); t.put("card_prog", "Sedang Proses"); t.put("card_total", "Total Pendapatan");
        t.put("btn_take", "Ambil"); t.put("btn_finish", "Selesai"); t.put("btn_chat", "Chat");
        t.put("btn_map", "Peta"); t.put("active_route", "Rute Aktif");
        
        t.put("tab_date", "Waktu"); t.put("tab_loc", "Lokasi"); t.put("tab_dist", "Jarak"); t.put("tab_price", "Ongkir"); t.put("tab_act", "Aksi");
        t.put("tab_cust", "Pelanggan"); t.put("tab_weight", "Berat"); t.put("tab_earn", "Pendapatan"); t.put("tab_status", "Status");
        t.put("stat_none", "Tidak ada data.");
        
        t.put("set_priv_title", "Pengaturan Privasi"); t.put("set_priv_desc", "Kontrol visibilitas petugas.");
        t.put("set_vis_title", "Visibilitas Status Aktif"); t.put("set_vis_desc", "Izinkan pengguna melihat Anda di peta saat online.");
        t.put("set_ana_title", "Optimasi Rute"); t.put("set_ana_desc", "Izinkan sistem menyarankan rute terbaik.");
        t.put("set_app_title", "Tampilan & Bahasa"); t.put("set_lang", "Bahasa Aplikasi"); t.put("set_theme", "Tema Tampilan");
        t.put("theme_light", "Terang"); t.put("theme_dark", "Gelap");
        t.put("set_sec_title", "Keamanan Akun"); t.put("set_pass", "Ganti Password"); 
        t.put("set_curr_pass", "Password Saat Ini"); t.put("set_new_pass", "Password Baru");
        t.put("set_danger", "Zona Bahaya"); t.put("set_del_acc", "Hapus Akun"); t.put("set_del_btn", "Hapus Akun Saya");
        t.put("set_del_desc", "Menghapus akun bersifat permanen. Semua poin akan hilang.");
        t.put("alert_del_confirm", "Hapus Akun?"); t.put("alert_del_text", "Tindakan ini tidak dapat dibatalkan!");
        
        t.put("btn_save", "Simpan Perubahan"); t.put("btn_cancel", "Batal"); t.put("set_logout", "Keluar");
        
        t.put("alert_confirm_take", "Ambil order ini?"); t.put("alert_finish_title", "Selesaikan Order"); t.put("alert_finish_text", "Masukkan berat sampah (kg):");
        t.put("notif_title", "Notifikasi"); t.put("notif_mark", "Tandai baca"); t.put("notif_empty", "Tidak ada notifikasi baru");
        
        t.put("prof_title", "Profil Pengguna"); t.put("prof_header_info", "Informasi Pribadi"); t.put("prof_edit", "Ubah");
        t.put("prof_fname", "Nama Depan"); t.put("prof_lname", "Nama Belakang"); 
        t.put("prof_email", "Email"); t.put("prof_phone", "No Handphone"); 
        t.put("prof_main_addr", "Alamat Basecamp"); t.put("prof_btn_pin", "Pin Lokasi"); 
        t.put("prof_role", "Peran"); t.put("role_name", "Petugas Lapangan");
    }

    
    final double MY_LAT = -7.2650; 
    final double MY_LNG = 112.7600;
    SimpleDateFormat sdfMonth = new SimpleDateFormat("yyyy-MM");
    String currentMonth = sdfMonth.format(new Date());

    PenjemputanDAO dao = new PenjemputanDAO();
    PenggunaDAO pDao = new PenggunaDAO(); 
    
    List<Penjemputan> allRequests = dao.getAllPenjemputan();
    if (allRequests == null) allRequests = new ArrayList<>();

    List<Penjemputan> pendingList = new ArrayList<>(); 
    List<Penjemputan> myTasks = new ArrayList<>();      
    List<Penjemputan> historyList = new ArrayList<>(); 
    
    double totalPendapatan = 0;
    double pendapatanBulanIni = 0;
    int totalSesi = 0;
    
    boolean hasActiveTask = false;
    double destLat = 0, destLng = 0;
    String destAddress = "";

    
    String fullName = (officer.getNama() != null) ? officer.getNama() : "Officer";
    String firstName = fullName;
    String lastName = "";
    if(fullName.contains(" ")){
        int idx = fullName.lastIndexOf(" ");
        firstName = fullName.substring(0, idx);
        lastName = fullName.substring(idx + 1);
    }

    for(Penjemputan p : allRequests) {
        if ("Pending".equalsIgnoreCase(p.getStatus())) {
            pendingList.add(p);
        } else if ("Proses".equalsIgnoreCase(p.getStatus())) {
            if (p.getOfficerId() == officer.getId()) { 
                myTasks.add(p);
                if (!hasActiveTask) {
                    hasActiveTask = true;
                    destLat = p.getLatitude();
                    destLng = p.getLongitude();
                    destAddress = (p.getAlamat() != null) ? p.getAlamat() : "";
                    if(destLat == 0) destLat = -7.2575;
                    if(destLng == 0) destLng = 112.7521;
                }
            }
        } else if ("Selesai".equalsIgnoreCase(p.getStatus())) {
            if (p.getOfficerId() == officer.getId()) {
                historyList.add(p);
                totalPendapatan += p.getEstimasiHarga();
                totalSesi++;
                if(p.getTanggal() != null && p.getTanggal().startsWith(currentMonth)) {
                    pendapatanBulanIni += p.getEstimasiHarga();
                }
            }
        }
    }
    
    int unreadNotif = pendingList.size(); 
%>

<!DOCTYPE html>
<html lang="<%= sessionLang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | SamPick Officer</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        
        :root { --primary: #00d25b; --primary-dark: #00b850; --bg-body: #f8f9fa; --bg-card: #ffffff; --text-main: #2d3436; --text-grey: #a4b0be; --shadow: 0 4px 20px rgba(0,0,0,0.05); --radius: 16px; --border-color: #eee; --sidebar-w: 260px; }
        
        body.dark-mode { --bg-body: #121212; --bg-card: #1e1e1e; --text-main: #ffffff; --text-grey: #b0b0b0; --shadow: 0 4px 20px rgba(0,0,0,0.3); --border-color: #333; }
        
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; transition: background 0.3s, color 0.3s; }
        a { text-decoration: none; color: inherit; }

        /* LAYOUT & SIDEBAR */
        .sidebar { width: var(--sidebar-w); background: var(--bg-card); padding: 25px; display: flex; flex-direction: column; justify-content: space-between; position: fixed; height: 100vh; border-right: 1px solid var(--border-color); z-index: 100; transition: background 0.3s; }
        .brand { font-size: 1.25rem; font-weight: 800; color: #111827; display: flex; align-items: center; gap: 12px; margin-bottom: 40px; } 
        body.dark-mode .brand { color: white; }
        .brand-icon { width: 36px; height: 36px; background: var(--primary); color: white; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .menu-list { list-style: none; }
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 12px 16px; color: var(--text-grey); font-weight: 600; border-radius: 10px; margin-bottom: 5px; cursor: pointer; transition: 0.2s; font-size: 0.95rem; }
        .menu-item:hover, .menu-item.active { background: #e6fcf0; color: var(--primary); }
        body.dark-mode .menu-item:hover, body.dark-mode .menu-item.active { background: rgba(0, 210, 91, 0.1); color: #66ff99; }
        .user-mini { display: flex; align-items: center; gap: 12px; padding-top: 20px; border-top: 1px solid var(--border-color); cursor:pointer; }
        .avatar-mini { width: 40px; height: 40px; background: #e6fcf0; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.1rem; }

        .main-content { margin-left: var(--sidebar-w); flex: 1; padding: 30px 40px; width: calc(100% - var(--sidebar-w)); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { font-size: 1.5rem; font-weight: 700; margin-bottom: 4px; }
        .header p { font-size: 0.9rem; color: var(--text-grey); }
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
        
        .btn-primary { background: var(--primary); color: white; padding: 12px 30px; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; font-size: 0.95rem; }
        .btn-primary:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0, 210, 91, 0.3); }
        .btn-sm { padding: 8px 15px; border-radius: 8px; font-size: 0.85rem; cursor: pointer; border: none; font-weight: 600; transition: 0.2s; }
        .btn-finish { background: #3498db; color: white; }
        
        .section-card { background: var(--bg-card); padding: 25px; border-radius: var(--radius); border: 1px solid var(--border-color); margin-bottom: 25px; }
        .view-section { display: none; animation: fadeIn 0.3s; }
        .view-section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }


        .income-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 25px; margin-bottom: 30px; }
        .inc-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; padding: 25px; position: relative; }
        .inc-head { font-size: 0.85rem; color: var(--text-grey); display: flex; justify-content: space-between; margin-bottom: 10px; }
        .inc-val { font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin-bottom: 5px; }
        .inc-trend { font-size: 0.8rem; font-weight: 600; color: var(--primary); display: flex; align-items: center; gap: 5px; }
        .inc-icon { width: 40px; height: 40px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        
        .chart-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; padding: 25px; margin-bottom: 30px; }
        .chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .chart-tabs { background: var(--bg-body); padding: 4px; border-radius: 8px; display: flex; gap: 4px; }
        .c-tab { padding: 6px 12px; font-size: 0.8rem; font-weight: 600; border-radius: 6px; cursor: pointer; border: none; background: transparent; color: var(--text-grey); }
        .c-tab.active { background: var(--bg-card); color: var(--text-main); box-shadow: 0 2px 5px rgba(0,0,0,0.05); }

        .btn-withdraw { background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; font-size: 0.9rem; font-weight: 700; border: none; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-withdraw:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0, 210, 91, 0.3); }


        .setting-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px; padding: 25px; margin-bottom: 25px; }
        .st-header { margin-bottom: 20px; }
        .st-header h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 5px; color: var(--text-main); }
        .st-header p { font-size: 0.85rem; color: var(--text-grey); margin: 0; }
        .st-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid var(--border); }
        .st-row:last-child { border-bottom: none; }
        .st-info h4 { font-size: 0.95rem; font-weight: 600; color: var(--text-main); margin-bottom: 4px; }
        .st-info p { font-size: 0.8rem; color: var(--text-grey); max-width: 90%; line-height: 1.4; }
        
        .switch { position: relative; display: inline-block; width: 48px; height: 28px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #e0e0e0; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 22px; width: 22px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        input:checked + .slider { background-color: #00d25b; }
        input:checked + .slider:before { transform: translateX(20px); }


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

        
        .danger-zone { border: 1px solid #ff4757; background: rgba(255, 71, 87, 0.05); border-radius: 16px; padding: 25px; margin-top: 30px; display: flex; justify-content: space-between; align-items: center; }
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

        
        table { width: 100%; border-collapse: collapse; } th, td { padding: 15px; text-align: left; border-bottom: 1px solid var(--border-color); color: var(--text-main); }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-green { background: #e6fcf0; color: #00d25b; } .badge-yellow { background: #fff7d1; color: #f1c40f; }
        .badge-success { background: #e6fcf0; color: var(--primary); padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
        
        .active-order-card { background: var(--bg-card); border-radius: var(--radius); padding: 25px; border:1px solid var(--border-color); margin-bottom: 20px; border-left: 5px solid #f1c40f; }
        .active-order-card.proses { border-left-color: var(--primary); }
        .tracking-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); margin-bottom: 30px; border-left: 5px solid var(--primary); }
        .track-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }

        
        .custom-map-icon {
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            color: white;
            font-size: 1.1rem;
            border: 3px solid white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        #trackingMap { height: 200px; width: 100%; border-radius: 12px; z-index: 1; border:1px solid #eee; margin-top:10px; }

        
        .profile-header-card { background: var(--bg-card); padding: 30px; border-radius: var(--radius); border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .ph-user { display: flex; align-items: center; gap: 20px; }
        .ph-avatar-box { position: relative; }
        .ph-avatar { width: 90px; height: 90px; background: #ddd; border-radius: 50%; background-image: url('https://ui-avatars.com/api/?name=<%= fullName.replace(" ", "+") %>&background=random&size=128'); background-size: cover; border: 4px solid white; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: background-image 0.3s; }
        .ph-edit-btn { position: absolute; bottom: 0; right: 0; background: var(--primary); color: white; width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; border: 2px solid white; cursor: pointer; }
        .ph-info h2 { margin-bottom: 2px; font-size: 1.4rem; color: var(--text-main); }
        .ph-info p { color: var(--text-grey); font-size: 0.9rem; margin-top: 0; }
        .ph-points { text-align: right; min-width: 200px; }
        .point-badge { background: #e6fcf0; color: #112413; padding: 10px 20px; border-radius: 12px; display: inline-block; margin-bottom: 10px; border: 1px solid #c3f0d4; }
        .point-val { font-size: 1.5rem; font-weight: 800; color: #112413; }
        .progress-bar { height: 6px; background: #eee; border-radius: 10px; overflow: hidden; margin-top: 5px; }
        .progress-fill { height: 100%; background: var(--primary); border-radius: 10px; width: 75%; } 
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: var(--text-main); }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 0.95rem; background: var(--bg-body); color: var(--text-main); transition: 0.3s; }
        .form-control:focus { border-color: var(--primary); outline: none; }
        .map-preview { height: 150px; background: #eee; border-radius: 10px; margin-top: 10px; display: flex; align-items: center; justify-content: center; background-image: url('https://static.maps.cimpress.io/v1.0.0/images/rd-map.png'); background-size: cover; background-position: center; position: relative; }
        .map-overlay { position: absolute; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.1); border-radius: 10px; }
        .btn-map-pin { background: white; padding: 8px 15px; border-radius: 20px; font-weight: 600; font-size: 0.8rem; box-shadow: 0 4px 10px rgba(0,0,0,0.2); z-index: 2; cursor: pointer; display: flex; align-items: center; gap: 5px; color: #333; }

        
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
        #routingMap, #viewMap { height: 300px; width: 100%; border-radius: 12px; z-index: 1; }

        @media (max-width: 992px) { .sidebar { display: none; } .main-content { margin-left: 0; width: 100%; padding: 20px; } .stats-grid { grid-template-columns: 1fr; } .income-grid { grid-template-columns: 1fr; } .profile-header-card { flex-direction: column; text-align: center; gap: 20px; } .ph-user { flex-direction: column; } .ph-points { text-align: center; width: 100%; } .form-grid { grid-template-columns: 1fr; } .danger-zone { flex-direction: column; align-items: flex-start; gap: 15px; } }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div>
            <div class="brand"><div class="brand-icon"><i class="fas fa-recycle"></i></div><div>Pickwaste<br><span style="font-size:0.75rem; color:var(--text-grey); font-weight:600;">SAMPICK PANEL</span></div></div>
            <ul class="menu-list">
                <li onclick="switchView('home')" class="menu-item active" id="menu-home"><i class="fas fa-th-large"></i> <%= t.get("menu_dash") %></li>
                <li onclick="switchView('tasks')" class="menu-item" id="menu-tasks"><i class="fas fa-tasks"></i> <%= t.get("menu_task") %> 
                <% if(!myTasks.isEmpty()) { %><span style="background:#ff4757; color:white; padding:2px 8px; border-radius:10px; font-size:0.7rem; margin-left:auto;"><%= myTasks.size() %></span><% } %></li>
                <li onclick="switchView('history')" class="menu-item" id="menu-history"><i class="fas fa-history"></i> <%= t.get("menu_hist") %></li>
                <li onclick="switchView('income')" class="menu-item" id="menu-income"><i class="fas fa-wallet"></i> <%= t.get("menu_inc") %></li>
                <li onclick="switchView('settings')" class="menu-item" id="menu-settings"><i class="fas fa-cog"></i> <%= t.get("menu_set") %></li>
            </ul>
        </div>
        
        <div class="user-mini" onclick="switchView('profile')" title="<%= t.get("prof_edit") %>">
            <div class="avatar-mini"><%= officer.getNama().substring(0,1) %></div>
            <div style="flex:1;">
                <div style="font-weight:700; font-size:0.9rem;"><%= officer.getNama() %></div>
                <div style="font-size:0.8rem; color:var(--text-grey);"><%= t.get("role_name") %></div>
            </div>
            <a href="LogoutServlet" style="color:#ff4757;"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="header">
            <div>
                <h1 style="display:flex; align-items:center; gap:10px;"><%= t.get("welcome") %>, <%= officer.getNama().split(" ")[0] %>! <span style="font-size:1.5rem;">👋</span></h1>
                <p style="color:var(--text-grey);"><%= t.get("sub_welcome") %></p>
            </div>
            <div class="header-controls">
                <div class="icon-btn" onclick="toggleNotifDropdown()">
                    <i class="far fa-bell"></i>
                    <% if(unreadNotif > 0) { %><div class="notif-dot"></div><% } %>
                </div>
            </div>
        </header>

        <div id="view-home" class="view-section active">
            <% if(hasActiveTask) { %>
            <div class="tracking-card">
                <div class="track-head">
                    <div style="display:flex; align-items:center; gap:15px;">
                        <div style="width:50px; height:50px; border-radius:12px; background:#e6fcf0; color:#00d25b; display:flex; justify-content:center; align-items:center; font-size:1.5rem;"><i class="fas fa-map-marked-alt"></i></div>
                        <div><h4 style="margin:0;"><%= t.get("active_route") %></h4><small style="color:var(--primary); font-weight:600;"><%= destAddress %></small></div>
                    </div>
                    <button class="btn-sm btn-finish" onclick="switchView('tasks')"><%= t.get("btn_finish") %></button>
                </div>
                <div id="routingMap"></div>
            </div>
            <% } %>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_avail") %></div>
                    <div class="stat-value"><%= pendingList.size() %></div>
                    <div class="stat-icon-bg"><i class="fas fa-box-open"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_prog") %></div>
                    <div class="stat-value"><%= myTasks.size() %></div>
                    <div class="stat-icon-bg"><i class="fas fa-running"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label"><%= t.get("card_total") %></div>
                    <div class="stat-value">Rp <%= String.format("%,.0f", totalPendapatan) %></div>
                    <div class="stat-icon-bg"><i class="fas fa-wallet"></i></div>
                </div>
            </div>

            <div class="section-card">
                <div style="display:flex; justify-content:space-between; margin-bottom:20px; align-items:center;">
                    <h3>🎯 <%= t.get("menu_dash") %></h3>
                    <button class="btn-sm" onclick="location.reload()" style="background:#f1f2f6; color:#666;"><i class="fas fa-sync-alt"></i> Refresh</button>
                </div>
                <table>
                    <thead><tr><th><%= t.get("tab_date") %></th><th><%= t.get("tab_loc") %></th><th><%= t.get("tab_dist") %></th><th><%= t.get("tab_price") %></th><th><%= t.get("tab_act") %></th></tr></thead>
                    <tbody>
                        <% if(pendingList.isEmpty()){ %><tr><td colspan="5" style="text-align:center; padding:30px; color:#888;"><%= t.get("stat_none") %></td></tr><% } else { 
                           for(Penjemputan p : pendingList) { 
                               String rawAddr = p.getAlamat();
                               String displayAddr = (rawAddr != null && rawAddr.contains("|")) ? rawAddr.split("\\|")[0] : (rawAddr != null ? rawAddr : "-");
                               double estimasiHarga = p.getEstimasiHarga();
                               if (estimasiHarga <= 0) estimasiHarga = 5000;
                        %>
                        <tr>
                            <td><%= p.getTanggal() %></td>
                            <td style="max-width:200px;"><div style="font-weight:600;"><%= displayAddr %></div><a href="#" onclick="showMapModal('<%= displayAddr %>')" style="font-size:0.8rem; color:#00d25b; font-weight:600;"><i class="fas fa-map-marker-alt"></i> <%= t.get("btn_map") %></a></td>
                            <td><span class="badge" style="background:#eee; color:#666;"><%= String.format("%.2f", p.getJarakKm()) %> km</span></td>
                            <td><strong style="color:var(--primary);">Rp <%= String.format("%,.0f", estimasiHarga) %></strong></td>
                            <td><form action="OfficerActionServlet" method="post" id="take-form-<%= p.getId() %>"><input type="hidden" name="action" value="ambil"><input type="hidden" name="id_penjemputan" value="<%= p.getId() %>"><button type="button" onclick="confirmTake(<%= p.getId() %>)" class="btn-sm btn-primary"><i class="fas fa-hand-paper"></i> <%= t.get("btn_take") %></button></form></td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-tasks" class="view-section">
            <h2 style="margin-bottom:20px;"><%= t.get("menu_task") %></h2>
            <div class="section-card" style="border-left: 5px solid #f1c40f;">
                <table>
                    <thead><tr><th>ID</th><th><%= t.get("tab_loc") %></th><th>Catatan</th><th><%= t.get("tab_act") %></th></tr></thead>
                    <tbody>
                        <% if(myTasks.isEmpty()){ %><tr><td colspan="4" style="text-align:center; padding:30px;"><%= t.get("stat_none") %></td></tr><% } else { 
                           for(Penjemputan p : myTasks) { 
                               String rawAddr = p.getAlamat();
                               String displayAddr = (rawAddr != null && rawAddr.contains("|")) ? rawAddr.split("\\|")[0] : (rawAddr != null ? rawAddr : "-");
                               String note = (rawAddr != null && rawAddr.contains("Note:")) ? rawAddr.split("Note:")[1] : "-"; 
                               
                               
                               String chatUserName = "User";
                               try {
                                   Pengguna u = pDao.getPenggunaById(p.getUserId());
                                   if(u != null) chatUserName = u.getNama();
                               } catch(Exception e){}
                        %>
                        <tr>
                            <td>#<%= p.getId() %></td>
                            <td><div style="font-weight:700;"><%= displayAddr %></div></td>
                            <td><%= note %></td>
                            <td style="display:flex; gap:5px;">
                                <button type="button" onclick="openChat(<%= p.getId() %>, <%= p.getUserId() %>, '<%= chatUserName %>')" class="btn-sm" style="background:#9b59b6; color:white;"><i class="fas fa-comments"></i> <%= t.get("btn_chat") %></button>
                                <button type="button" onclick="finishJob(<%= p.getId() %>)" class="btn-sm btn-finish" style="background:#3498db; color:white;"><i class="fas fa-check-circle"></i> <%= t.get("btn_finish") %></button>
                            </td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-history" class="view-section">
            <h2 style="margin-bottom:20px;"><%= t.get("menu_hist") %></h2>
            <div class="section-card">
                <table>
                    <thead><tr><th><%= t.get("tab_date") %></th><th><%= t.get("tab_loc") %></th><th><%= t.get("tab_weight") %></th><th><%= t.get("tab_earn") %></th><th><%= t.get("tab_status") %></th></tr></thead>
                    <tbody>
                        <% for(Penjemputan p : historyList) { 
                           String rawAddr = p.getAlamat();
                           String displayAddr = (rawAddr != null && rawAddr.contains("|")) ? rawAddr.split("\\|")[0] : (rawAddr != null ? rawAddr : "-");
                           
                          
                           String namaPelanggan = "Pelanggan";
                           try {
                               Pengguna m = pDao.getPenggunaById(p.getUserId()); 
                               if(m != null && m.getNama() != null) namaPelanggan = m.getNama();
                           } catch(Exception e) { namaPelanggan = "User " + p.getUserId(); }
                        %>
                        <tr>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><%= p.getTanggal() %></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><div style="font-weight:700;"><%= namaPelanggan %></div><div style="font-size:0.8rem; color:#888;"><%= displayAddr %></div></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9; font-weight:600;"><i class="fas fa-weight-hanging"></i> <%= p.getBerat() %> kg</td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9; color:#00d25b; font-weight:700;">+Rp <%= String.format("%,.0f", p.getEstimasiHarga()) %></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><span class="badge-success">Berhasil</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-income" class="view-section">
            <div class="header">
                <div><h1><%= t.get("inc_title") %></h1><p><%= t.get("inc_sub") %></p></div>
            </div>

            <div class="income-grid">
                <div class="inc-card">
                    <div class="inc-head"><span><%= t.get("inc_card_bal") %></span><div class="st-icon" style="background:#e6fcf0; color:var(--primary); width:35px; height:35px; font-size:1rem;"><i class="fas fa-wallet"></i></div></div>
                    <div class="inc-val">Rp <%= String.format("%,.0f", totalPendapatan) %></div>
                    <div class="inc-trend"><i class="fas fa-arrow-up"></i> +12% <%= t.get("inc_vs_last") %></div>
                </div>
                <div class="inc-card">
                    <div class="inc-head"><span><%= t.get("inc_card_month") %></span><div class="st-icon" style="background:#eff6ff; color:#2563eb; width:35px; height:35px; font-size:1rem;"><i class="fas fa-calendar-alt"></i></div></div>
                    <div class="inc-val">Rp <%= String.format("%,.0f", pendapatanBulanIni) %></div>
                    <div class="inc-trend" style="color:#2563eb;"><i class="fas fa-arrow-up"></i> +5% <%= t.get("inc_vs_last") %></div>
                </div>
                <div class="inc-card">
                    <div class="inc-head"><span><%= t.get("inc_card_sess") %></span><div class="st-icon" style="background:#fff7ed; color:#ea580c; width:35px; height:35px; font-size:1rem;"><i class="fas fa-truck"></i></div></div>
                    <div class="inc-val"><%= totalSesi %> Sesi</div>
                    <div class="inc-trend" style="color:#ea580c;"><i class="fas fa-arrow-up"></i> +8 sesi <%= t.get("inc_vs_last") %></div>
                </div>
            </div>

            <div class="chart-card">
                <div class="chart-header">
                    <div><h3 style="margin:0; font-size:1.1rem;"><%= t.get("inc_chart_title") %></h3></div>
                    <div class="chart-tabs">
                        <button class="c-tab active" onclick="updateChart('week')"><%= t.get("inc_tab_week") %></button>
                        <button class="c-tab" onclick="updateChart('month')"><%= t.get("inc_tab_month") %></button>
                        <button class="c-tab" onclick="updateChart('year')"><%= t.get("inc_tab_year") %></button>
                    </div>
                </div>
                <canvas id="incomeChart" height="90"></canvas>
            </div>

            <div class="section-card">
                <div style="display:flex; justify-content:space-between; margin-bottom:20px; align-items:center;">
                    <h3 style="margin:0;"><%= t.get("inc_hist_title") %></h3>
                    <a href="#" style="color:var(--primary); font-weight:600; font-size:0.85rem;"><%= t.get("inc_view_all") %></a>
                </div>
                <table style="width:100%; border-collapse:collapse;">
                    <thead><tr><th style="padding:15px; border-bottom:1px solid #eee; text-align:left;"><%= t.get("tab_date") %></th><th style="padding:15px; border-bottom:1px solid #eee; text-align:left;"><%= t.get("tab_cust") %></th><th style="padding:15px; border-bottom:1px solid #eee; text-align:left;"><%= t.get("tab_weight") %></th><th style="padding:15px; border-bottom:1px solid #eee; text-align:left;"><%= t.get("tab_earn") %></th><th style="padding:15px; border-bottom:1px solid #eee; text-align:left;"><%= t.get("tab_status") %></th></tr></thead>
                    <tbody>
                        <% for(Penjemputan p : historyList) { 
                           String rawAddr = p.getAlamat();
                           String displayAddr = (rawAddr != null && rawAddr.contains("|")) ? rawAddr.split("\\|")[0] : (rawAddr != null ? rawAddr : "-");
                           
                          
                           String namaPelanggan = "Pelanggan";
                           try {
                               Pengguna m = pDao.getPenggunaById(p.getUserId()); 
                               if(m != null && m.getNama() != null) namaPelanggan = m.getNama();
                           } catch(Exception e) { namaPelanggan = "User " + p.getUserId(); }
                        %>
                        <tr>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><%= p.getTanggal() %></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><div style="font-weight:700;"><%= namaPelanggan %></div><div style="font-size:0.8rem; color:#888;"><%= displayAddr %></div></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9; font-weight:600;"><i class="fas fa-weight-hanging"></i> <%= p.getBerat() %> kg</td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9; color:#00d25b; font-weight:700;">+Rp <%= String.format("%,.0f", p.getEstimasiHarga()) %></td>
                            <td style="padding:15px; border-bottom:1px solid #f9f9f9;"><span class="badge-success">Berhasil</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
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
                            <h2><%= officer.getNama() %></h2>
                            <p><i class="far fa-envelope"></i> <%= officer.getEmail() %></p>
                        </div>
                    </div>
                    <div class="ph-points">
                        <div class="point-badge">
                            <small style="display:block; font-size:0.7rem; color:#555; text-transform:uppercase;"><%= t.get("card_total") %></small>
                            <span class="point-val">Rp <%= String.format("%,.0f", totalPendapatan) %></span>
                        </div>
                        <div style="font-size:0.75rem; color:var(--text-grey);"><%= t.get("prof_role") %>: <%= t.get("role_name") %></div>
                        <div class="progress-bar"><div class="progress-fill"></div></div>
                    </div>
                </div>

                <div class="section-card">
                    <div style="display:flex; justify-content:space-between; margin-bottom:20px;">
                        <h3 style="font-size:1.1rem; font-weight:700;"><i class="fas fa-id-card" style="color:var(--primary); margin-right:8px;"></i> <%= t.get("prof_header_info") %></h3>
                    </div>

                    <div class="form-grid">
                        <div class="form-group"><label><%= t.get("prof_fname") %></label><input type="text" id="inputFname" value="<%= firstName %>" class="form-control"></div>
                        <div class="form-group"><label><%= t.get("prof_lname") %></label><input type="text" id="inputLname" value="<%= lastName %>" class="form-control"></div>
                    </div>
                    <div class="form-grid">
                        <div class="form-group"><label><%= t.get("prof_email") %></label><input type="email" name="email" value="<%= officer.getEmail() %>" class="form-control"></div>
                        <div class="form-group"><label><%= t.get("prof_phone") %></label><input type="text" name="no_hp" value="<%= (officer.getNoHp() != null) ? officer.getNoHp() : "" %>" class="form-control"></div>
                    </div>
                    <div class="form-group">
                        <label><%= t.get("prof_main_addr") %></label>
                        <textarea name="alamat" class="form-control" rows="2"><%= (officer.getAlamat() != null) ? officer.getAlamat() : "" %></textarea>
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
                        <div class="st-info"><h4><%= t.get("set_vis_title") %></h4><p><%= t.get("set_vis_desc") %></p></div>
                        <label class="switch"><input type="checkbox" name="visibilitas" checked><span class="slider"></span></label>
                    </div>
                    <div class="st-row">
                        <div class="st-info"><h4><%= t.get("set_ana_title") %></h4><p><%= t.get("set_ana_desc") %></p></div>
                        <label class="switch"><input type="checkbox" name="analitik"><span class="slider"></span></label>
                    </div>
                </div>

                <div class="setting-card">
                    <div class="st-header"><h3><%= t.get("set_app_title") %></h3></div>
                    <div style="margin-bottom:25px;">
                        <label style="display:block; font-weight:600; font-size:0.85rem; margin-bottom:8px; color:var(--text-main);"><%= t.get("set_lang") %></label>
                        <select class="form-control" style="background:var(--bg-body);" onchange="window.location.href='dashboardSampick.jsp?lang='+this.value">
                            <option value="id" <%= "id".equals(sessionLang) ? "selected" : "" %>>Bahasa Indonesia</option>
                            <option value="en" <%= "en".equals(sessionLang) ? "selected" : "" %>>English (US)</option>
                        </select>
                    </div>
                    <div>
                        <label style="display:block; font-weight:600; font-size:0.85rem; margin-bottom:8px; color:var(--text-main);"><%= t.get("set_theme") %></label>
                        <div class="theme-grid">
                            <div id="theme-light" class="theme-box active" onclick="toggleTheme('light')"><div class="t-preview t-light"></div><div class="t-name"><i class="fas fa-sun"></i> <%= t.get("theme_light") %></div></div>
                            <div id="theme-dark" class="theme-box" onclick="toggleTheme('dark')"><div class="t-preview t-dark"></div><div class="t-name"><i class="fas fa-moon"></i> <%= t.get("theme_dark") %></div></div>
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
                            <div class="form-group"><label><%= t.get("set_curr_pass") %></label><input type="password" name="passwordLama" class="form-control"></div>
                            <div class="form-group"><label><%= t.get("set_new_pass") %></label><input type="password" name="passwordBaru" class="form-control"></div>
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

    <div id="notifDropdown" class="dropdown"><div class="dropdown-header"><span><%= t.get("notif_title") %></span> <span style="font-size:0.75rem; color:var(--primary); cursor:pointer;"><%= t.get("notif_mark") %></span></div><% if(pendingList.isEmpty()){ %><div class="dropdown-item" style="color:#999; justify-content:center;"><%= t.get("notif_empty") %></div><% } else { for(Penjemputan p : pendingList) { String rawAddr = p.getAlamat(); String displayAddr = (rawAddr != null && rawAddr.contains("|")) ? rawAddr.split("\\|")[0] : (rawAddr != null ? rawAddr : "-"); %><div class="dropdown-item" onclick="switchView('home')"><div style="width:35px; height:35px; background:#e6fcf0; color:var(--primary); border-radius:50%; display:flex; align-items:center; justify-content:center;"><i class="fas fa-box-open"></i></div><div><div style="font-weight:600; font-size:0.9rem;">Order Baru #<%= p.getId() %></div><div style="font-size:0.8rem; color:#888;"><%= displayAddr %></div></div></div><% }} %></div>

    <div id="mapModal" class="modal-overlay">
        <div class="modal-box"><span class="close-btn" onclick="document.getElementById('mapModal').classList.remove('show')">&times;</span><h3><%= t.get("tab_loc") %></h3><div id="viewMap"></div><p id="addrText" style="margin-top:10px; color:#666; font-size:0.9rem;"></p></div>
    </div>

    <div id="chatModal" class="chat-modal">
        <div class="chat-header"><span id="chatOfficerName">Chat User</span><span style="cursor:pointer;" onclick="closeChat()">&times;</span></div>
        <div class="chat-body" id="chatContainer"><div style="text-align:center; margin-top:50px; color:#ccc;">...</div></div>
        <div class="chat-footer"><input type="text" id="chatInput" class="chat-input" placeholder="..." onkeydown="handleEnter(event)"><button onclick="sendMessage()" style="background:var(--primary); border:none; width:35px; height:35px; border-radius:50%; color:white; cursor:pointer;"><i class="fas fa-paper-plane"></i></button></div>
        <input type="hidden" id="chatJemputId"><input type="hidden" id="chatReceiverId"><input type="hidden" id="myUserId" value="<%= officer.getId() %>">
    </div>

    <form id="finishForm" action="OfficerActionServlet" method="post"><input type="hidden" name="action" value="selesai"><input type="hidden" name="id_penjemputan" id="finishId"><input type="hidden" name="berat" id="finishBerat"></form>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.js"></script>
    <script>
        var myChart;
        function switchView(viewName) {
            document.querySelectorAll('.view-section').forEach(e => e.classList.remove('active'));
            document.querySelectorAll('.menu-item').forEach(e => e.classList.remove('active'));
            document.getElementById('view-' + viewName).classList.add('active');
            var menu = document.getElementById('menu-' + viewName);
            if(menu) menu.classList.add('active');
            if(viewName === 'home' && typeof routingMap !== 'undefined') setTimeout(function(){ routingMap.invalidateSize(); }, 200);
            if(viewName === 'income') initChart(); 
        }
        
        function toggleNotifDropdown() { document.getElementById('notifDropdown').classList.toggle('show'); }
        function confirmTake(id) { Swal.fire({title: '<%= t.get("alert_confirm_take") %>', icon: 'question', showCancelButton: true, confirmButtonColor: '#00d25b', confirmButtonText: 'Ya'}).then((r) => { if (r.isConfirmed) document.getElementById('take-form-' + id).submit(); }); }
        function finishJob(id) { Swal.fire({title: '<%= t.get("alert_finish_title") %>', text: '<%= t.get("alert_finish_text") %>', input: 'number', inputAttributes: { min: 1, step: 0.1 }, showCancelButton: true, confirmButtonColor: '#00d25b'}).then((r) => { if (r.isConfirmed) { document.getElementById('finishId').value = id; document.getElementById('finishBerat').value = r.value; document.getElementById('finishForm').submit(); } }); }

       
        function initChart() {
            var ctx = document.getElementById('incomeChart').getContext('2d');
            if(myChart) myChart.destroy();
            
           
            var dataWeek = [15000, 20000, 10000, 50000, 30000, 25000, 40000];
            var labelsWeek = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

            myChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labelsWeek,
                    datasets: [{
                        label: 'Pendapatan (Rp)',
                        data: dataWeek,
                        borderColor: '#00d25b',
                        backgroundColor: 'rgba(0, 210, 91, 0.1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointBackgroundColor: '#00d25b'
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    },
                    plugins: { legend: { display: false } }
                }
            });
        }
        
        function updateChart(type) {
            document.querySelectorAll('.c-tab').forEach(el => el.classList.remove('active'));
            event.target.classList.add('active');
            
            var newData = type === 'week' ? [15000, 20000, 10000, 50000, 30000, 25000, 40000] : 
                          type === 'month' ? [150000, 200000, 180000, 220000] : 
                          [500000, 750000, 600000, 900000, 850000, 1000000];
            var newLabels = type === 'week' ? ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"] : 
                            type === 'month' ? ["Minggu 1", "Minggu 2", "Minggu 3", "Minggu 4"] : 
                            ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun"];
            
            myChart.data.labels = newLabels;
            myChart.data.datasets[0].data = newData;
            myChart.update();
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
        document.addEventListener("DOMContentLoaded", function() {
            var savedTheme = localStorage.getItem('theme');
            if(savedTheme === 'dark') toggleTheme('dark'); else toggleTheme('light');
        });

        
        function submitProfile() {
            var f = document.getElementById('inputFname').value;
            var l = document.getElementById('inputLname').value;
            document.getElementById('combinedName').value = f + (l ? " " + l : "");
            document.getElementById('profileForm').submit();
        }
        function changeAvatar() {
            var newName = prompt("Masukkan nama untuk avatar:");
            if(newName) { document.getElementById('avatarPreview').style.backgroundImage = "url('https://ui-avatars.com/api/?name=" + newName.replace(" ","+") + "&background=random&size=128')"; }
        }

     
        var map, routingMap;
        function showMapModal(addr) { document.getElementById('mapModal').classList.add('show'); document.getElementById('addrText').innerText=addr; if(!map){ map=L.map('viewMap').setView([-7.25, 112.75], 13); L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map); } setTimeout(function(){map.invalidateSize();},200); }
        
        <% if(hasActiveTask) { %>
        document.addEventListener("DOMContentLoaded", function() {
            if(document.getElementById('routingMap')) {
                
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

                var start = [<%= MY_LAT %>, <%= MY_LNG %>]; 
                var end = [<%= destLat %>, <%= destLng %>]; 
                
                routingMap = L.map('routingMap').setView(start, 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(routingMap);
                
                L.Routing.control({ 
                    waypoints: [L.latLng(start), L.latLng(end)], 
                    routeWhileDragging: false, 
                    show: false, 
                    addWaypoints: false, 
                    draggableWaypoints: false,
                    lineOptions: { styles: [{color: '#00d25b', opacity: 0.8, weight: 6}] },
                    createMarker: function(i, wp, nWps) {
                        if (i === 0) {
                            return L.marker(wp.latLng, { icon: officerIcon }); 
                        } else {
                            return L.marker(wp.latLng, { icon: userIcon }); 
                        }
                    }
                }).addTo(routingMap);
            }
        });
        <% } %>

     
        var chatInterval;
        function openChat(idJemput, userId, userName) {
            document.getElementById('chatJemputId').value = idJemput;
            document.getElementById('chatReceiverId').value = userId;
            document.getElementById('chatOfficerName').innerText = userName; 
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
                        var senderName = isMe ? 'Saya' : (msg.sender_name ? msg.sender_name : 'User');
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
            var msg = document.getElementById('chatInput').value;
            if(!msg) return;
            fetch('ChatServlet', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: 'id_penjemputan=' + idJemput + '&receiver_id=' + receiverId + '&message=' + encodeURIComponent(msg) }).then(res => { if(res.ok) { document.getElementById('chatInput').value = ''; loadMessages(); } });
        }
        function handleEnter(e) { if(e.key === 'Enter') sendMessage(); }
        
        function konfirmasiHapus() {
            Swal.fire({
                title: '<%= t.get("alert_del_confirm") %>',
                text: '<%= t.get("alert_del_text") %>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, Delete!',
                cancelButtonText: '<%= t.get("btn_cancel") %>'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'UpdateUserServlet?action=deleteAccount&id=<%= officer.getId() %>';
                }
            });
        }

        window.onclick = function(e) { if (!e.target.closest('.icon-btn') && !e.target.closest('.dropdown') && !e.target.closest('.modal-box') && !e.target.closest('.chat-modal') && !e.target.closest('.swal2-container')) { document.getElementById('notifDropdown').classList.remove('show'); document.getElementById('mapModal').classList.remove('show'); } }
    </script>
</body>
</html>