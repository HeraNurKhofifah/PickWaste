<%-- 
    Document   : index
    Description: Modern Landing Page for PickWaste (Versi Bahasa Indonesia)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Masyarakat" %>
<%@page session="true" %>

<%
    // Cek Status Login untuk mengatur tombol di Navbar
    Object userObj = session.getAttribute("user");
    boolean isLoggedIn = (userObj != null && userObj instanceof Masyarakat);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PickWaste | Ubah Sampah Jadi Rupiah</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* --- GLOBAL STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        html { scroll-behavior: smooth; }
        body { background-color: #f9fbfd; color: #2d3436; overflow-x: hidden; }
        a { text-decoration: none; color: inherit; transition: 0.3s; }
        ul { list-style: none; }

        /* --- VARIABLES --- */
        :root {
            --primary: #00d25b;
            --primary-dark: #00b850;
            --secondary: #112413;
            --text-dark: #2d3436;
            --text-light: #636e72;
            --white: #ffffff;
        }

        /* --- NAVBAR --- */
        .navbar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 20px 80px; background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px); position: fixed; width: 100%; top: 0; z-index: 1000;
            box-shadow: 0 2px 20px rgba(0,0,0,0.05);
        }
        .logo { font-size: 1.5rem; font-weight: 800; color: var(--secondary); display: flex; align-items: center; gap: 10px; }
        .logo i { color: var(--primary); font-size: 1.8rem; }
        
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { font-weight: 500; color: var(--text-dark); font-size: 0.95rem; }
        .nav-links a:hover { color: var(--primary); }

        .nav-auth { display: flex; gap: 15px; }
        .btn { padding: 10px 25px; border-radius: 50px; font-weight: 600; cursor: pointer; border: none; font-size: 0.9rem; transition: 0.3s; }
        .btn-outline { background: transparent; border: 2px solid var(--primary); color: var(--primary); }
        .btn-outline:hover { background: var(--primary); color: white; }
        .btn-fill { background: var(--primary); color: white; border: 2px solid var(--primary); box-shadow: 0 4px 15px rgba(0, 210, 91, 0.3); }
        .btn-fill:hover { background: var(--primary-dark); border-color: var(--primary-dark); transform: translateY(-2px); }

        /* --- HERO SECTION --- */
        .hero {
            height: 100vh;
            background: linear-gradient(rgba(17, 36, 19, 0.7), rgba(17, 36, 19, 0.7)), 
                        url('https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=1470&auto=format&fit=crop');
            background-size: cover; background-position: center;
            display: flex; align-items: center; justify-content: center;
            text-align: center; color: white; padding: 0 20px;
            margin-top: -80px; /* Offset navbar */
        }
        .hero-content { max-width: 800px; animation: fadeInUp 1s ease-out; }
        .hero h1 { font-size: 3.5rem; font-weight: 800; margin-bottom: 20px; line-height: 1.2; }
        .hero p { font-size: 1.1rem; margin-bottom: 30px; opacity: 0.9; font-weight: 300; }
        .hero-btns { display: flex; justify-content: center; gap: 20px; }

        /* --- STATS SECTION --- */
        .stats-section {
            padding: 60px 80px; background: white; margin-top: -50px;
            position: relative; z-index: 10; border-radius: 20px 20px 0 0;
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px;
            box-shadow: 0 -10px 30px rgba(0,0,0,0.03);
        }
        .stat-item { text-align: center; }
        .stat-num { font-size: 2.5rem; font-weight: 800; color: var(--primary); display: block; }
        .stat-label { color: var(--text-light); font-weight: 500; font-size: 0.9rem; }

        /* --- FEATURES SECTION --- */
        .features { padding: 80px 80px; text-align: center; }
        .section-title { font-size: 2.2rem; font-weight: 800; margin-bottom: 10px; color: var(--secondary); }
        .section-desc { color: var(--text-light); max-width: 600px; margin: 0 auto 50px; }
        
        .feature-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
        .feature-card {
            background: white; padding: 40px 30px; border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); transition: 0.3s;
            border: 1px solid #f0f0f0;
        }
        .feature-card:hover { transform: translateY(-10px); box-shadow: 0 15px 40px rgba(0, 210, 91, 0.15); border-color: var(--primary); }
        .f-icon {
            width: 70px; height: 70px; background: #e6fcf0; color: var(--primary);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin: 0 auto 20px;
        }
        .feature-card h3 { margin-bottom: 15px; font-weight: 700; }
        .feature-card p { color: var(--text-light); font-size: 0.9rem; line-height: 1.6; }

        /* --- HOW IT WORKS --- */
        .steps-section { background: var(--secondary); color: white; padding: 80px; text-align: center; }
        .steps-section .section-title { color: white; }
        .steps-section .section-desc { color: rgba(255,255,255,0.7); }
        .step-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 40px; margin-top: 50px; }
        .step-item { position: relative; }
        .step-num { 
            font-size: 4rem; font-weight: 900; color: rgba(255,255,255,0.1); 
            position: absolute; top: -20px; left: 50%; transform: translateX(-50%); z-index: 0;
        }
        .step-content { position: relative; z-index: 1; }
        .step-content h4 { font-size: 1.2rem; margin-bottom: 10px; font-weight: 700; }
        .step-content p { font-size: 0.9rem; opacity: 0.8; }

        /* --- FOOTER --- */
        footer { background: #0b180d; color: white; padding: 50px 80px 20px; }
        .footer-top { display: flex; justify-content: space-between; margin-bottom: 40px; }
        .f-brand h2 { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .f-links h4 { margin-bottom: 20px; color: var(--primary); }
        .f-links ul li { margin-bottom: 10px; }
        .f-links ul li a:hover { color: var(--primary); }
        .copyright { text-align: center; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; font-size: 0.8rem; opacity: 0.6; }

        /* --- ANIMATIONS --- */
        @keyframes fadeInUp { from { opacity:0; transform: translateY(30px); } to { opacity:1; transform: translateY(0); } }

        /* --- RESPONSIVE --- */
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; } /* Hide links on mobile for simplicity */
            .hero h1 { font-size: 2.2rem; }
            .stats-section, .feature-grid, .step-grid { grid-template-columns: 1fr; }
            .stats-section { padding: 40px 20px; }
            .features, .steps-section, footer { padding: 50px 20px; }
            .footer-top { flex-direction: column; gap: 30px; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo"><i class="fas fa-recycle"></i> PickWaste</div>
        <ul class="nav-links">
            <li><a href="#">Beranda</a></li>
            <li><a href="#features">Fitur</a></li>
            <li><a href="#how">Cara Kerja</a></li>
            <li><a href="#contact">Kontak</a></li>
        </ul>
        <div class="nav-auth">
            <% if (isLoggedIn) { %>
                <a href="dashboardUser.jsp" class="btn btn-fill">Dashboard <i class="fas fa-arrow-right"></i></a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-outline">Masuk</a>
                <a href="register.jsp" class="btn btn-fill">Daftar</a>
            <% } %>
        </div>
    </nav>

    <header class="hero">
        <div class="hero-content">
            <h1>Ubah Sampah Jadi <span style="color:#00d25b;">Cuan</span></h1>
            <p>Bergabunglah dengan revolusi hijau. Jadwalkan penjemputan, pantau dampak lingkunganmu, dan dapatkan poin untuk setiap kilogram sampah yang kamu daur ulang.</p>
            <div class="hero-btns">
                <% if (isLoggedIn) { %>
                    <a href="dashboardUser.jsp" class="btn btn-fill" style="padding:15px 40px; font-size:1.1rem;">Ke Dashboard</a>
                <% } else { %>
                    <a href="register.jsp" class="btn btn-fill" style="padding:15px 40px; font-size:1.1rem;">Mulai Sekarang</a>
                    <a href="#how" class="btn btn-outline" style="color:white; border-color:white;">Pelajari Lebih Lanjut</a>
                <% } %>
            </div>
        </div>
    </header>

    <section class="stats-section">
        <div class="stat-item">
            <span class="stat-num">10rb+</span>
            <span class="stat-label">Pengguna Aktif</span>
        </div>
        <div class="stat-item">
            <span class="stat-num">500 Ton</span>
            <span class="stat-label">Sampah Didaur Ulang</span>
        </div>
        <div class="stat-item">
            <span class="stat-num">Rp 2M+</span>
            <span class="stat-label">Reward Dibagikan</span>
        </div>
    </section>

    <section class="features" id="features">
        <h2 class="section-title">Kenapa Pilih PickWaste?</h2>
        <p class="section-desc">Kami menyediakan cara termudah untuk mengelola sampah rumah tangga sambil mendapatkan keuntungan.</p>
        
        <div class="feature-grid">
            <div class="feature-card">
                <div class="f-icon"><i class="fas fa-truck"></i></div>
                <h3>Penjemputan Mudah</h3>
                <p>Jadwalkan penjemputan sesuai kenyamananmu. Petugas kami akan datang tepat waktu untuk mengambil sampah daur ulangmu.</p>
            </div>
            <div class="feature-card">
                <div class="f-icon"><i class="fas fa-coins"></i></div>
                <h3>Dapatkan Poin</h3>
                <p>Dibayar untuk sampahmu! Tukarkan sampah menjadi poin yang bisa diredeem menjadi voucher belanja, pulsa, atau saldo e-wallet.</p>
            </div>
            <div class="feature-card">
                <div class="f-icon"><i class="fas fa-map-marked-alt"></i></div>
                <h3>Pelacakan Langsung</h3>
                <p>Lacak petugas penjemputan secara real-time layaknya aplikasi ojek online favoritmu.</p>
            </div>
        </div>
    </section>

    <section class="steps-section" id="how">
        <h2 class="section-title">Cara Kerja</h2>
        <p class="section-desc">Daur ulang jadi simpel hanya dalam 3 langkah mudah.</p>
        
        <div class="step-grid">
            <div class="step-item">
                <div class="step-num">01</div>
                <div class="step-content">
                    <h4>Pilah Sampah</h4>
                    <p>Pisahkan sampah organik, anorganik, dan bahan daur ulang di rumah.</p>
                </div>
            </div>
            <div class="step-item">
                <div class="step-num">02</div>
                <div class="step-content">
                    <h4>Request Jemput</h4>
                    <p>Gunakan aplikasi untuk mengatur lokasi dan waktu penjemputan. Kami yang urus sisanya.</p>
                </div>
            </div>
            <div class="step-item">
                <div class="step-num">03</div>
                <div class="step-content">
                    <h4>Dapat Hadiah</h4>
                    <p>Terima poin instan setelah penimbangan. Tukarkan dengan berbagai hadiah menarik!</p>
                </div>
            </div>
        </div>
    </section>

    <footer id="contact">
        <div class="footer-top">
            <div class="f-brand">
                <h2><i class="fas fa-recycle" style="color:#00d25b;"></i> PickWaste</h2>
                <p style="opacity:0.7; max-width:300px;">Membuat dunia lebih bersih, satu jemputan dalam satu waktu. Bergabunglah dalam misi kami menciptakan masa depan yang berkelanjutan.</p>
            </div>
            <div class="f-links">
                <h4>Tautan Cepat</h4>
                <ul>
                    <li><a href="#">Tentang Kami</a></li>
                    <li><a href="#">Layanan</a></li>
                    <li><a href="#">Kebijakan Privasi</a></li>
                </ul>
            </div>
            <div class="f-links">
                <h4>Kontak</h4>
                <ul>
                    <li><i class="fas fa-envelope"></i> hello@pickwaste.com</li>
                    <li><i class="fas fa-phone"></i> +62 812 3456 7890</li>
                    <li><i class="fas fa-map-marker-alt"></i> Surabaya, Indonesia</li>
                </ul>
            </div>
        </div>
        <div class="copyright">
            &copy; 2025 PickWaste Inc. Hak Cipta Dilindungi.
        </div>
    </footer>

</body>
</html>