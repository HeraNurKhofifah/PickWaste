<%-- 
    Document   : dashboardSampick
    Description: OFFICER DASHBOARD - EXACT USER UI STYLE (Fixed Settings & Profile)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Pengguna" %> 
<%@page import="model.Penjemputan" %>
<%@page import="dao.PenjemputanDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page session="true" %>

<%
    // --- 1. CEK SESI & ROLE ---
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

    // --- 2. LOGIKA BAHASA ---
    String lang = request.getParameter("lang");
    String sessionLang = (String) session.getAttribute("appLang");
    if (lang != null) { session.setAttribute("appLang", lang); sessionLang = lang; } 
    else if (sessionLang == null) { sessionLang = "id"; }

    Map<String, String> t = new HashMap<>();
    boolean isEn = "en".equals(sessionLang);
    
    if (isEn) {
        t.put("menu_dash", "Dashboard"); 
        t.put("menu_task", "My Tasks"); t.put("menu_hist", "History");
        t.put("menu_set", "Settings"); t.put("menu_prof", "Profile");
        t.put("header_hi", "Hello"); t.put("header_sub", "Ready to clean the city today?");
        t.put("card_avail", "Available Orders"); t.put("card_prog", "In Progress"); t.put("card_total", "Total Weight");
        t.put("tab_date", "Date"); t.put("tab_loc", "Location"); t.put("tab_dist", "Dist."); t.put("tab_price", "Fee"); t.put("tab_act", "Action");
        t.put("btn_map", "Map"); t.put("btn_take", "Take Job"); t.put("btn_finish", "Finish"); t.put("btn_chat", "Chat");
        t.put("set_gen", "General Settings"); t.put("set_lang", "Language"); t.put("set_sec", "Account Security");
        t.put("set_pass", "Change Password"); t.put("set_curr_pass", "Current Password"); t.put("set_new_pass", "New Password"); t.put("set_conf", "Update Password");
        t.put("prof_title", "Edit Profile"); t.put("lbl_name", "Full Name"); t.put("lbl_email", "Email");
        t.put("lbl_hp", "Phone Number"); t.put("lbl_addr", "Basecamp Address"); t.put("btn_save", "Save Changes");
        t.put("role_name", "Field Officer");
    } else {
        t.put("menu_dash", "Dashboard"); 
        t.put("menu_task", "Tugas Saya"); t.put("menu_hist", "Riwayat");
        t.put("menu_set", "Pengaturan"); t.put("menu_prof", "Profil");
        t.put("header_hi", "Halo"); t.put("header_sub", "Siap membersihkan kota hari ini?");
        t.put("card_avail", "Order Tersedia"); t.put("card_prog", "Sedang Proses"); t.put("card_total", "Total Angkut");
        t.put("tab_date", "Waktu"); t.put("tab_loc", "Lokasi"); t.put("tab_dist", "Jarak"); t.put("tab_price", "Ongkir"); t.put("tab_act", "Aksi");
        t.put("btn_map", "Peta"); t.put("btn_take", "Ambil"); t.put("btn_finish", "Selesai"); t.put("btn_chat", "Chat");
        t.put("set_gen", "Pengaturan Umum"); t.put("set_lang", "Bahasa Aplikasi"); t.put("set_sec", "Keamanan Akun");
        t.put("set_pass", "Ganti Password"); t.put("set_curr_pass", "Password Saat Ini"); t.put("set_new_pass", "Password Baru"); t.put("set_conf", "Simpan Password");
        t.put("prof_title", "Edit Profil"); t.put("lbl_name", "Nama Lengkap"); t.put("lbl_email", "Email");
        t.put("lbl_hp", "No Handphone"); t.put("lbl_addr", "Alamat Basecamp"); t.put("btn_save", "Simpan Perubahan");
        t.put("role_name", "Petugas Lapangan");
    }

    // --- 3. CONFIG ---
    final double MY_LAT = -7.2650; 
    final double MY_LNG = 112.7600;

    // --- 4. LOAD DATA ---
    PenjemputanDAO dao = new PenjemputanDAO();
    List<Penjemputan> allRequests = dao.getAllPenjemputan();
    List<Penjemputan> pendingList = new ArrayList<>(); 
    List<Penjemputan> myTasks = new ArrayList<>();     
    List<Penjemputan> historyList = new ArrayList<>(); 
    
    double totalAngkut = 0;
    
    boolean hasActiveTask = false;
    double destLat = 0, destLng = 0;
    String destAddress = "";

    for(Penjemputan p : allRequests) {
        if ("Pending".equalsIgnoreCase(p.getStatus())) {
            pendingList.add(p);
        } else if ("Proses".equalsIgnoreCase(p.getStatus())) {
            if (p.getOfficerId() == officer.getId()) { 
                myTasks.add(p);
                
                // Set active task untuk Map
                if (!hasActiveTask) {
                    hasActiveTask = true;
                    destLat = p.getLatitude();
                    destLng = p.getLongitude();
                    destAddress = p.getAlamat();
                    if(destLat == 0) destLat = -7.2575;
                    if(destLng == 0) destLng = 112.7521;
                }
            }
        } 
        
        // KASUS 3: Selesai (Riwayat)
        // [PERBAIKAN LOGIKA] Hanya hitung pendapatan & riwayat petugas yang login
        else if ("Selesai".equalsIgnoreCase(p.getStatus())) {
            if (p.getOfficerId() == officer.getId()) {
                historyList.add(p);
                totalAngkut +=  p.getEstimasiHarga();
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        /* --- STYLE DARI DASHBOARD USER (PERSIS) --- */
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
        .header-controls { display: flex; align-items: center; gap: 20px; }
        .icon-btn { width: 40px; height: 40px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #666; box-shadow: var(--shadow); cursor: pointer; transition: 0.2s; position: relative; }
        .icon-btn:hover { color: var(--primary); transform: translateY(-2px); }
        .notif-dot { position: absolute; top: 8px; right: 8px; width: 8px; height: 8px; background: #ff4757; border-radius: 50%; border: 2px solid white; }

        /* CARDS & TABLES */
        .cards-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 25px; border-radius: var(--radius); box-shadow: var(--shadow); display: flex; align-items: center; gap: 20px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        .table-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); }
        .sec-header { display: flex; justify-content: space-between; margin-bottom: 20px; align-items: center; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; color: #888; font-weight: 500; font-size: 0.85rem; border-bottom: 1px solid #eee; }
        td { padding: 15px; font-size: 0.95rem; border-bottom: 1px solid #f9f9f9; }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-green { background: #e6fcf0; color: #00d25b; }
        
        /* BUTTONS & FORMS */
        .btn-sm { padding: 8px 15px; border-radius: 8px; border: none; font-weight: 600; font-size: 0.85rem; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 5px; }
        .btn-take { background: var(--primary); color: white; box-shadow: 0 4px 10px rgba(0, 210, 91, 0.3); } 
        .btn-finish { background: #3498db; color: white; box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3); } 
        .btn-primary { background: var(--primary); color: white; padding: 10px 25px; border-radius: 30px; font-weight: 600; border: none; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 15px rgba(0, 210, 91, 0.3); display: flex; align-items: center; gap: 8px; }
        
        .form-section { background: white; padding: 30px; border-radius: var(--radius); box-shadow: var(--shadow); max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #eee; border-radius: 10px; font-family: inherit; background: #fcfcfc; }
        .row-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .settings-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #f5f5f5; }
        
        /* SWITCH & SLIDER */
        .switch { position: relative; display: inline-block; width: 50px; height: 26px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
        .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 4px; bottom: 4px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(24px); }

        /* MAP & CHAT */
        .tracking-card { background: white; border-radius: var(--radius); padding: 25px; box-shadow: var(--shadow); margin-bottom: 30px; border-left: 5px solid var(--primary); }
        .track-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        #routingMap, #viewMap { height: 300px; width: 100%; border-radius: 12px; z-index: 1; }
        
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
        .leaflet-routing-machine-container { display: none !important; }

        /* NOTIF & MODAL */
        .dropdown { position: absolute; top: 70px; right: 80px; width: 320px; background: white; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); z-index: 2000; display: none; padding: 10px 0; max-height: 400px; overflow-y: auto; }
        .dropdown.show { display: block; animation: fadeIn 0.2s; }
        .dropdown-header { padding: 10px 20px; font-weight: 700; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between; }
        .dropdown-item { padding: 15px 20px; border-bottom: 1px solid #f9f9f9; cursor: pointer; display: flex; gap: 12px; }
        .dropdown-item:hover { background: #f9f9f9; }
        
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 3000; display: none; justify-content: center; align-items: center; backdrop-filter: blur(3px); }
        .modal-overlay.show { display: flex; animation: fadeIn 0.3s; }
        .modal-box { background: white; width: 600px; padding: 30px; border-radius: 20px; position: relative; max-height: 80vh; display: flex; flex-direction: column; }
        .close-btn { position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem; color: #888; }

        @media (max-width: 992px) { .sidebar { display: none; } .main-content { margin-left: 0; width: 100%; padding: 20px; } .cards-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div>
            <div class="brand"><i class="fas fa-recycle"></i> Sampick<span style="font-size:0.7rem; background:#eee; padding:2px 6px; border-radius:4px; margin-left:5px;">Officer</span></div>
            <ul class="menu-list">
                <li onclick="switchView('home')" class="menu-item active" id="menu-home"><i class="fas fa-th-large"></i> <%= t.get("menu_dash") %></li>
                <li onclick="switchView('tasks')" class="menu-item" id="menu-tasks"><i class="fas fa-tasks"></i> <%= t.get("menu_task") %> 
                <% if(!myTasks.isEmpty()) { %><span style="background:#ff4757; color:white; padding:2px 8px; border-radius:10px; font-size:0.7rem; margin-left:auto;"><%= myTasks.size() %></span><% } %></li>
                <li onclick="switchView('history')" class="menu-item" id="menu-history"><i class="fas fa-history"></i> <%= t.get("menu_hist") %></li>
                <li onclick="switchView('settings')" class="menu-item" id="menu-settings"><i class="fas fa-cog"></i> <%= t.get("menu_set") %></li>
            </ul>
        </div>
        
        <div class="user-mini" onclick="switchView('profile')" title="Edit Profil">
            <div class="avatar-mini"><%= officer.getNama().substring(0,1) %></div>
            <div style="flex:1;">
                <div style="font-weight:700; font-size:0.9rem;"><%= officer.getNama() %></div>
                <div style="font-size:0.8rem; color:#888;"><%= t.get("role_name") %></div>
            </div>
            <a href="LogoutServlet" style="color:#ff4757;"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="header">
            <div>
                <h1><%= t.get("header_hi") %>, <%= officer.getNama() %>!</h1>
                <p><%= t.get("header_sub") %></p>
            </div>
            <div class="header-controls">
                <div class="icon-btn" onclick="toggleNotifDropdown()">
                    <i class="far fa-bell"></i>
                    <% if(unreadNotif > 0) { %>
                        <div class="notif-dot"></div>
                    <% } %>
                </div>
                <div class="icon-btn" onclick="toggleHelpModal()"><i class="far fa-question-circle"></i></div>
                </div>
        </header>

        <div id="view-home" class="view-section active">
            <% if(hasActiveTask) { %>
            <div class="tracking-card">
                <div class="track-head">
                    <div style="display:flex; align-items:center; gap:15px;">
                        <div style="width:50px; height:50px; border-radius:12px; background:#e6fcf0; color:#00d25b; display:flex; justify-content:center; align-items:center; font-size:1.5rem;"><i class="fas fa-map-marked-alt"></i></div>
                        <div><h4 style="margin:0;">Rute Aktif</h4><small style="color:var(--primary); font-weight:600;"><%= destAddress %></small></div>
                    </div>
                    <button class="btn-sm btn-finish" onclick="switchView('tasks')"><%= t.get("btn_finish") %></button>
                </div>
                <div id="routingMap"></div>
            </div>
            <% } %>

            <div class="cards-grid">
                <div class="card"><div class="card-icon" style="background:#e3f2fd; color:#45aaf2;"><i class="fas fa-box-open"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_avail") %></div><div style="font-size:1.5rem; font-weight:700;"><%= pendingList.size() %></div></div></div>
                <div class="card"><div class="card-icon" style="background:#fff7d1; color:#f1c40f;"><i class="fas fa-running"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_prog") %></div><div style="font-size:1.5rem; font-weight:700;"><%= myTasks.size() %></div></div></div>
                <div class="card"><div class="card-icon" style="background:#e6fcf0; color:#00d25b;"><i class="fas fa-weight-hanging"></i></div><div><div style="font-size:0.85rem; color:#888;"><%= t.get("card_total") %></div><div style="font-size:1.5rem; font-weight:700;"><%= (int)totalAngkut %> kg</div></div></div>
            </div>

            <div class="table-card">
                <div class="sec-header"><h3>🎯 <%= t.get("menu_dash") %></h3><button class="btn-sm" onclick="location.reload()" style="background:#f1f2f6; color:#666;"><i class="fas fa-sync-alt"></i> Refresh</button></div>
                <table>
                    <thead><tr><th><%= t.get("tab_date") %></th><th><%= t.get("tab_loc") %></th><th><%= t.get("tab_dist") %></th><th><%= t.get("tab_price") %></th><th><%= t.get("tab_act") %></th></tr></thead>
                    <tbody>
                        <% if(pendingList.isEmpty()){ %><tr><td colspan="5" style="text-align:center; padding:30px; color:#888;">Tidak ada data.</td></tr><% } else { 
                           for(Penjemputan p : pendingList) { 
                               String displayAddr = p.getAlamat().split("\\|")[0];
                               double estimasiHarga = p.getEstimasiHarga();
                               if (estimasiHarga <= 0) estimasiHarga = 5000;
                        %>
                        <tr>
                            <td><%= p.getTanggal() %></td>
                            <td style="max-width:200px;"><div style="font-weight:600;"><%= displayAddr %></div><a href="#" onclick="showMapModal('<%= displayAddr %>')" style="font-size:0.8rem; color:#00d25b; font-weight:600;"><i class="fas fa-map-marker-alt"></i> <%= t.get("btn_map") %></a></td>
                            <td><span class="badge" style="background:#eee; color:#666;"><%= String.format("%.2f", p.getJarakKm()) %> km</span></td>
                            <td><strong style="color:var(--primary);">Rp <%= String.format("%,.0f", estimasiHarga) %></strong></td>
                            <td><form action="OfficerActionServlet" method="post" id="take-form-<%= p.getId() %>"><input type="hidden" name="action" value="ambil"><input type="hidden" name="id_penjemputan" value="<%= p.getId() %>"><button type="button" onclick="confirmTake(<%= p.getId() %>)" class="btn-sm btn-take"><i class="fas fa-hand-paper"></i> <%= t.get("btn_take") %></button></form></td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-tasks" class="view-section">
            <h2 style="margin-bottom:20px;"><%= t.get("menu_task") %></h2>
            <div class="table-card" style="border-left: 5px solid #f1c40f;">
                <table>
                    <thead><tr><th>ID</th><th><%= t.get("tab_loc") %></th><th>Catatan</th><th><%= t.get("tab_act") %></th></tr></thead>
                    <tbody>
                        <% if(myTasks.isEmpty()){ %><tr><td colspan="4" style="text-align:center; padding:30px;">Kosong.</td></tr><% } else { 
                           for(Penjemputan p : myTasks) { String displayAddr = p.getAlamat().split("\\|")[0]; String note = p.getAlamat().contains("Note:") ? p.getAlamat().split("Note:")[1] : "-"; %>
                        <tr>
                            <td>#<%= p.getId() %></td>
                            <td><div style="font-weight:700;"><%= displayAddr %></div></td>
                            <td><%= note %></td>
                            <td style="display:flex; gap:5px;">
                                <button type="button" onclick="openChat(<%= p.getId() %>, <%= p.getUserId() %>, 'User')" class="btn-sm" style="background:#9b59b6; color:white;"><i class="fas fa-comments"></i> <%= t.get("btn_chat") %></button>
                                <button type="button" onclick="finishJob(<%= p.getId() %>)" class="btn-sm btn-finish"><i class="fas fa-check-circle"></i> <%= t.get("btn_finish") %></button>
                            </td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-history" class="view-section">
            <h2 style="margin-bottom:20px;"><%= t.get("menu_hist") %></h2>
            <div class="table-card">
                <table>
                    <thead><tr><th><%= t.get("tab_date") %></th><th><%= t.get("tab_loc") %></th><th>Berat</th><th>Pendapatan</th><th>Status</th></tr></thead>
                    <tbody>
                        <% for(Penjemputan p : historyList) { 
                           String displayAddr = p.getAlamat().split("\\|")[0]; %>
                        <tr>
                            <td><%= p.getTanggal() %></td>
                            <td><%= displayAddr %></td>
                            <td><strong><%= p.getBerat() %> kg</strong></td>
                            <td style="color:var(--primary); font-weight:700;">Rp <%= String.format("%,.0f", p.getEstimasiHarga()) %></td>
                            <td><span class="badge badge-green">Selesai</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="view-settings" class="view-section">
            <div class="form-section" style="margin-bottom:30px;">
                <div class="settings-header" style="font-weight:700; margin-bottom:15px; display:flex; align-items:center; gap:10px;">
                    <i class="fas fa-sliders-h" style="color:#3498db;"></i> <%= t.get("set_gen") %>
                </div>
                <div class="settings-row">
                    <div><%= t.get("set_lang") %></div>
                    <select class="form-control" style="width:150px;" onchange="window.location.href='dashboardSampick.jsp?lang='+this.value">
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
                    <div>Mode Penyamaran</div>
                    <label class="switch"><input type="checkbox"><span class="slider"></span></label>
                </div>
                
                <div style="margin-top:20px; padding-top:20px; border-top:1px solid #f5f5f5;">
                    <h4 style="margin-bottom:15px;"><%= t.get("set_pass") %></h4>
                    
                    <form action="UpdateUserServlet" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="row-grid">
                            <div class="form-group">
                                <label class="form-label"><%= t.get("set_curr_pass") %></label>
                                <input type="password" name="passwordLama" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><%= t.get("set_new_pass") %></label>
                                <input type="password" name="passwordBaru" class="form-control" required>
                            </div>
                        </div>
                        <button class="btn-primary" style="background:#333;"><%= t.get("set_conf") %></button>
                    </form>
                </div>
            </div>
        </div>

        <div id="view-profile" class="view-section">
            <div class="form-section">
                <h2><%= t.get("prof_title") %></h2><hr style="margin:20px 0; border:0; border-top:1px solid #eee;">
                
                <form action="UpdateUserServlet" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="row-grid">
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_name") %></label><input type="text" name="nama" value="<%= officer.getNama() %>" class="form-control"></div>
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_email") %></label><input type="email" name="email" value="<%= officer.getEmail() %>" class="form-control"></div>
                    </div>
                    <div class="row-grid">
                        <div class="form-group"><label class="form-label"><%= t.get("lbl_hp") %></label><input type="text" name="no_hp" value="<%= officer.getNoHp() == null ? "-" : officer.getNoHp() %>" class="form-control"></div>
                        <div class="form-group"><label class="form-label">Role</label><input type="text" value="<%= t.get("role_name") %>" class="form-control" readonly style="background:#eee;"></div>
                    </div>
                    <div class="form-group"><label class="form-label"><%= t.get("lbl_addr") %></label><textarea name="alamat" class="form-control" rows="3"><%= officer.getAlamat() == null ? "-" : officer.getAlamat() %></textarea></div>
                    <button class="btn-primary"><%= t.get("btn_save") %></button>
                </form>
            </div>
        </div>
    </main>

    <div id="notifDropdown" class="dropdown"><div class="dropdown-header"><span>Notifikasi</span> <span style="font-size:0.75rem; color:var(--primary); cursor:pointer;">Tandai baca</span></div><% if(pendingList.isEmpty()){ %><div class="dropdown-item" style="color:#999; justify-content:center;">Tidak ada notifikasi baru</div><% } else { for(Penjemputan p : pendingList) { %><div class="dropdown-item" onclick="switchView('home')"><div style="width:35px; height:35px; background:#e6fcf0; color:var(--primary); border-radius:50%; display:flex; align-items:center; justify-content:center;"><i class="fas fa-box-open"></i></div><div><div style="font-weight:600; font-size:0.9rem;">Order Baru #<%= p.getId() %></div><div style="font-size:0.8rem; color:#888;"><%= p.getAlamat().split("\\|")[0] %></div></div></div><% }} %></div>

    <div id="helpModalOverlay" class="modal-overlay">
        <div class="modal-box"><span class="close-btn" onclick="toggleHelpModal()">&times;</span><h2 style="margin-bottom:20px;">Bantuan</h2><input type="text" id="helpSearch" class="help-search-input" placeholder="Cari masalah..."><div class="help-scroll-area"><div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)">Cara ambil order? <i class="fas fa-chevron-right"></i></div><div class="faq-answer">Buka menu Dashboard dan klik 'Ambil'.</div></div></div><a href="https://wa.me/6281234567890" target="_blank" class="btn-cs-wa"><i class="fab fa-whatsapp" style="font-size:1.2rem;"></i> Hubungi Admin</a></div>
    </div>

    <div id="mapModal" class="modal-overlay">
        <div class="modal-box"><span class="close-btn" onclick="document.getElementById('mapModal').classList.remove('show')">&times;</span><h3>Lokasi Penjemputan</h3><div id="viewMap"></div><p id="addrText" style="margin-top:10px; color:#666; font-size:0.9rem;"></p></div>
    </div>

    <div id="chatModal" class="chat-modal">
        <div class="chat-header"><span id="chatOfficerName">Chat User</span><span style="cursor:pointer;" onclick="closeChat()">&times;</span></div>
        <div class="chat-body" id="chatContainer"><div style="text-align:center; margin-top:50px; color:#ccc;">Memuat pesan...</div></div>
        <div class="chat-footer"><input type="text" id="chatInput" class="chat-input" placeholder="Tulis pesan..." onkeypress="handleEnter(event)"><button onclick="sendMessage()" style="background:var(--primary); border:none; width:35px; height:35px; border-radius:50%; color:white; cursor:pointer;"><i class="fas fa-paper-plane"></i></button></div>
        <input type="hidden" id="chatJemputId"><input type="hidden" id="chatReceiverId"><input type="hidden" id="myUserId" value="<%= officer.getId() %>">
    </div>

    <form id="finishForm" action="OfficerActionServlet" method="post"><input type="hidden" name="action" value="selesai"><input type="hidden" name="id_penjemputan" id="finishId"><input type="hidden" name="berat" id="finishBerat"></form>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.js"></script>
    <script>
        function switchView(viewName) {
            document.querySelectorAll('.view-section').forEach(e => e.classList.remove('active'));
            document.querySelectorAll('.menu-item').forEach(e => e.classList.remove('active'));
            document.getElementById('view-' + viewName).classList.add('active');
            var menu = document.getElementById('menu-' + viewName);
            if(menu) menu.classList.add('active');
            if(viewName === 'home' && typeof routingMap !== 'undefined') setTimeout(function(){ routingMap.invalidateSize(); }, 200);
        }
        
        function toggleNotifDropdown() { var el = document.getElementById('notifDropdown'); el.classList.toggle('show'); document.getElementById('helpModalOverlay').classList.remove('show'); }
        function toggleHelpModal() { document.getElementById('helpModalOverlay').classList.toggle('show'); document.getElementById('notifDropdown').classList.remove('show'); }
        function toggleFaq(el) { el.parentElement.classList.toggle('active'); }

        function confirmTake(id) { Swal.fire({title: '<%= t.get("btn_take") %>?', icon: 'question', showCancelButton: true, confirmButtonColor: '#00d25b', confirmButtonText: 'Ya'}).then((r) => { if (r.isConfirmed) document.getElementById('take-form-' + id).submit(); }); }
        function finishJob(id) { Swal.fire({title: '<%= t.get("btn_finish") %>', text: "Berat (kg):", input: 'number', inputAttributes: { min: 1, step: 0.1 }, showCancelButton: true, confirmButtonColor: '#00d25b'}).then((r) => { if (r.isConfirmed) { document.getElementById('finishId').value = id; document.getElementById('finishBerat').value = r.value; document.getElementById('finishForm').submit(); } }); }

        var map, routingMap;
        function showMapModal(addr) { document.getElementById('mapModal').classList.add('show'); document.getElementById('addrText').innerText=addr; if(!map){ map=L.map('viewMap').setView([-7.25, 112.75], 13); L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map); } setTimeout(function(){map.invalidateSize();},200); }
        
        <% if(hasActiveTask) { %>
        document.addEventListener("DOMContentLoaded", function() {
            if(document.getElementById('routingMap')) {
                var start = [<%= MY_LAT %>, <%= MY_LNG %>]; var end = [<%= destLat %>, <%= destLng %>];
                routingMap = L.map('routingMap').setView(start, 13);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(routingMap);
                L.Routing.control({ waypoints: [L.latLng(start), L.latLng(end)], routeWhileDragging: false, show: false, addWaypoints: false, lineOptions: { styles: [{color: '#00d25b', opacity: 0.8, weight: 6}] } }).addTo(routingMap);
            }
        });
        <% } %>

        // CHAT LOGIC
        var chatInterval;
        function openChat(idJemput, userId, userName) {
            document.getElementById('chatJemputId').value = idJemput;
            document.getElementById('chatReceiverId').value = userId;
            document.getElementById('chatOfficerName').innerText = "Chat " + userName;
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
                if(data.length === 0) { html = '<div style="text-align:center; color:#ddd; font-size:0.8rem; margin-top:20px;">Belum ada pesan.</div>'; } else {
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

        window.onclick = function(e) { if (!e.target.closest('.icon-btn') && !e.target.closest('.dropdown') && !e.target.closest('.modal-box') && !e.target.closest('.swal2-container')) { document.getElementById('notifDropdown').classList.remove('show'); if(e.target.classList.contains('modal-overlay')) document.getElementById('helpModalOverlay').classList.remove('show'); } }

        // ALERTS (Succes & Failed)
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        if (status === 'profileUpdated') { Swal.fire('Berhasil!', 'Profil diperbarui.', 'success').then(() => window.history.replaceState(null, null, window.location.pathname)); }
        else if (status === 'passUpdated') { Swal.fire('Berhasil!', 'Password diganti.', 'success').then(() => window.history.replaceState(null, null, window.location.pathname)); }
        else if (status === 'wrongOldPass') { Swal.fire('Gagal!', 'Password lama salah.', 'error').then(() => window.history.replaceState(null, null, window.location.pathname)); }
    </script>
</body>
</html>