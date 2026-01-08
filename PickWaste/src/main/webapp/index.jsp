<%-- 
    Document    : index
    Description :  Landing Page PickWaste 
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Masyarakat" %>
<%@page session="true" %>

<%
   
    Object userObj = session.getAttribute("user");
    boolean isLoggedIn = (userObj != null && userObj instanceof Masyarakat);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PickWaste | Revolusi Daur Ulang Digital</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
           
            --primary: #14532d;       
            --primary-light: #166534; 
            --accent: #22c55e;        
            
           
            --dark: #0f172a;          
            --grey: #64748b;          
            --light-grey: #f8fafc;   
            --white: #ffffff;
            --border: #e2e8f0;
            
           
            --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
            --radius: 24px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        html { scroll-behavior: smooth; }
        body { background-color: var(--white); color: var(--dark); line-height: 1.6; overflow-x: hidden; }
        a { text-decoration: none; color: inherit; transition: all 0.3s ease; }
        ul { list-style: none; }
        img { max-width: 100%; height: auto; }

       
        .navbar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 5%; position: fixed; width: 100%; top: 0; z-index: 1000;
            background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            transition: all 0.3s ease;
        }
        .logo { 
            font-size: 1.5rem; font-weight: 800; color: var(--primary); 
            display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; 
        }
        .logo span { color: var(--dark); }
        
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { 
            font-weight: 600; color: var(--grey); font-size: 0.95rem; 
            position: relative; padding: 5px 0;
        }
        .nav-links a:hover { color: var(--primary); }
        .nav-links a::after {
            content: ''; position: absolute; width: 0; height: 2px; bottom: 0; left: 0;
            background-color: var(--primary); transition: width 0.3s;
        }
        .nav-links a:hover::after { width: 100%; }

        .nav-auth { display: flex; gap: 10px; }
        .btn { 
            padding: 10px 24px; border-radius: 50px; font-weight: 600; font-size: 0.9rem; 
            cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-primary { 
            background: var(--primary); color: var(--white); border: none; 
            box-shadow: 0 4px 6px rgba(20, 83, 45, 0.2);
        }
        .btn-primary:hover { background: var(--primary-light); transform: translateY(-2px); box-shadow: 0 8px 15px rgba(20, 83, 45, 0.3); }
        
        .btn-outline { 
            background: transparent; color: var(--primary); border: 1.5px solid var(--border); 
        }
        .btn-outline:hover { border-color: var(--primary); color: var(--primary); background: #f0fdf4; }

        
        .hero {
            padding: 160px 5% 100px;
            display: grid; grid-template-columns: 1.2fr 1fr; gap: 60px; align-items: center;
            background: radial-gradient(circle at 10% 20%, rgba(220, 252, 231, 0.4) 0%, transparent 40%);
            position: relative;
        }
        .hero-tag {
            display: inline-block; background: #dcfce7; color: var(--primary);
            padding: 6px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;
            margin-bottom: 20px; border: 1px solid #bbf7d0;
        }
        .hero h1 { 
            font-size: 4rem; font-weight: 800; line-height: 1.1; margin-bottom: 20px; 
            color: var(--dark); letter-spacing: -1.5px; 
        }
        .hero h1 span { 
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero p { font-size: 1.15rem; color: var(--grey); margin-bottom: 40px; max-width: 90%; }
        
        .hero-btns { display: flex; gap: 15px; }
        .btn-lg { padding: 14px 32px; font-size: 1rem; }

        .hero-stats {
            display: flex; gap: 30px; margin-top: 50px; padding-top: 30px;
            border-top: 1px solid var(--border);
        }
        .hs-item h4 { font-size: 1.5rem; font-weight: 800; color: var(--dark); margin: 0; }
        .hs-item p { font-size: 0.85rem; color: var(--grey); margin: 0; }

        .hero-img-box { position: relative; }
        .hero-main-img { 
            border-radius: 30px; box-shadow: var(--shadow-lg); 
            transform: rotate(2deg); transition: transform 0.5s; 
            border: 8px solid var(--white);
        }
        .hero-img-box:hover .hero-main-img { transform: rotate(0deg); }
        
        .float-card {
            position: absolute; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px);
            padding: 20px; border-radius: 20px; box-shadow: var(--shadow-lg);
            display: flex; align-items: center; gap: 15px; animation: float 6s ease-in-out infinite;
            border: 1px solid rgba(255,255,255,0.5);
            max-width: 250px;
        }
        .fc-1 { top: 40px; left: -30px; }
        .fc-2 { bottom: 40px; right: -30px; animation-delay: 2s; }
        .fc-icon { 
            width: 50px; height: 50px; background: #dcfce7; color: var(--primary); 
            border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; 
        }
        @keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-15px); } }


        .features { padding: 100px 5%; background: var(--light-grey); }
        .sec-header { text-align: center; max-width: 700px; margin: 0 auto 60px; }
        .sec-title { font-size: 2.5rem; font-weight: 800; color: var(--dark); margin-bottom: 15px; }
        .sec-desc { color: var(--grey); font-size: 1.1rem; }

        .bento-grid {
            display: grid; grid-template-columns: repeat(3, 1fr); grid-template-rows: repeat(2, auto);
            gap: 24px;
        }
        .bento-card {
            background: var(--white); border-radius: 24px; padding: 35px;
            border: 1px solid var(--border); transition: 0.3s;
            display: flex; flex-direction: column; justify-content: space-between;
            position: relative; overflow: hidden;
        }
        .bento-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-lg); border-color: var(--primary); }
        
        .bento-large { grid-column: span 2; display: flex; align-items: center; }
        .bento-content { flex: 1; z-index: 2; }
        
        .bento-icon-box { 
            width: 60px; height: 60px; border-radius: 16px; 
            display: flex; align-items: center; justify-content: center; 
            font-size: 1.5rem; margin-bottom: 20px; 
        }
        .bento-card h3 { font-size: 1.3rem; font-weight: 700; margin-bottom: 10px; color: var(--dark); }
        .bento-card p { color: var(--grey); font-size: 0.95rem; line-height: 1.6; margin: 0; }
        
        .bento-decor-icon {
            font-size: 8rem; color: var(--primary); opacity: 0.08;
            position: absolute; bottom: -20px; right: -10px;
            transform: rotate(-10deg); transition: 0.3s;
        }
        .bento-card:hover .bento-decor-icon { transform: rotate(0deg) scale(1.1); opacity: 0.15; }


        .steps { padding: 100px 5%; background: var(--primary); color: var(--white); position: relative; overflow: hidden; }
        .steps::after { content:''; position:absolute; top:0; right:0; width:400px; height:400px; background:radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%); }
        
        .step-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px; margin-top: 60px; }
        .step-box { position: relative; }
        .step-num { 
            font-size: 4rem; font-weight: 900; color: rgba(255,255,255,0.1); 
            position: absolute; top: -30px; left: 0; z-index: 0;
        }
        .step-content { position: relative; z-index: 1; padding-top: 20px; }
        .step-content h4 { font-size: 1.2rem; font-weight: 700; margin-bottom: 10px; color: #86efac; }
        .step-content p { color: #dcfce7; font-size: 0.9rem; line-height: 1.6; }
        .step-line { height: 2px; background: rgba(255,255,255,0.2); width: 100%; margin-bottom: 20px; }

   
        .testimonials { padding: 100px 5%; background: var(--white); }
        .testi-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
        .testi-card { 
            background: var(--light-grey); padding: 40px; border-radius: 24px; 
            border: 1px solid var(--border); transition: all 0.3s ease;
        }
        .testi-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-md); border-color: var(--primary); background: var(--white); }
        .quote-icon { font-size: 2rem; color: var(--primary); margin-bottom: 20px; opacity: 0.3; }
        .testi-text { font-size: 1.05rem; color: var(--dark); margin-bottom: 30px; font-style: italic; line-height: 1.6; }
        .testi-user { display: flex; align-items: center; gap: 15px; }
        .testi-user img { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; }
        .tu-info h5 { font-size: 1rem; font-weight: 700; margin: 0; color: var(--dark); }
        .tu-info span { font-size: 0.85rem; color: var(--grey); }


        .cta { padding: 100px 5%; }
        .cta-inner {
            background: #064e3b; border-radius: 30px; padding: 80px 40px;
            text-align: center; color: var(--white); position: relative; overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(6, 78, 59, 0.4);
        }
        .cta-inner::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png'); opacity: 0.1;
        }
        .cta-text { position: relative; z-index: 2; max-width: 600px; margin: 0 auto; }
        .cta-text h2 { font-size: 3rem; font-weight: 800; margin-bottom: 20px; }
        .cta-text p { font-size: 1.1rem; color: #dcfce7; margin-bottom: 40px; }
        
        .btn-white { background: var(--white); color: var(--primary); }
        .btn-white:hover { background: #f0fdf4; transform: translateY(-2px); }

    
        footer { padding: 80px 5% 30px; background: var(--white); border-top: 1px solid var(--border); }
        .footer-content { display: grid; grid-template-columns: 1.5fr 1fr 1fr 1fr; gap: 50px; margin-bottom: 60px; }
        .f-logo { font-size: 1.5rem; font-weight: 800; color: var(--primary); margin-bottom: 20px; display: block; }
        .f-desc { color: var(--grey); font-size: 0.9rem; max-width: 300px; }
        .f-head { font-size: 1rem; font-weight: 700; color: var(--dark); margin-bottom: 20px; }
        .f-links li { margin-bottom: 12px; }
        .f-links a { color: var(--grey); font-size: 0.9rem; font-weight: 500; }
        .f-links a:hover { color: var(--primary); padding-left: 5px; }
        .f-bottom { border-top: 1px solid var(--border); padding-top: 30px; display: flex; justify-content: space-between; color: var(--grey); font-size: 0.85rem; }


        @media (max-width: 992px) {
            .hero { grid-template-columns: 1fr; text-align: center; padding-top: 120px; }
            .hero-btns, .hero-stats { justify-content: center; }
            .hero-img-box { margin-top: 50px; }
            .float-card { display: none; }
            .bento-grid { grid-template-columns: 1fr; }
            .bento-large { grid-column: span 1; }
            .step-container, .testi-grid, .footer-content { grid-template-columns: 1fr; gap: 40px; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo"><i class="fas fa-recycle"></i> <span>PickWaste</span></div>
        <% if(isLoggedIn) { %>
            <div class="nav-auth">
                <a href="dashboardUser.jsp" class="btn btn-primary">Ke Dashboard <i class="fas fa-arrow-right"></i></a>
            </div>
        <% } else { %>
            <ul class="nav-links">
                <li><a href="#">Beranda</a></li>
                <li><a href="#features">Fitur</a></li>
                <li><a href="#how">Cara Kerja</a></li>
                <li><a href="#testimonials">Testimoni</a></li>
            </ul>
            <div class="nav-auth">
                <a href="login.jsp" class="btn btn-outline" style="border:none;">Masuk</a>
                <a href="register.jsp" class="btn btn-primary">Daftar</a>
            </div>
        <% } %>
    </nav>

    <header class="hero">
        <div class="hero-text">
            <span class="hero-tag">🌱 Platform Daur Ulang #1</span>
            <h1>Kelola Sampah, <br><span>Raih Cuan.</span></h1>
            <p>Ubah sampah rumah tangga menjadi poin berharga. Jadwalkan penjemputan instan, pantau dampak lingkungan, dan tukar poin jadi saldo e-wallet.</p>
            
            <div class="hero-btns">
                <% if(isLoggedIn) { %>
                    <a href="dashboardUser.jsp" class="btn btn-primary btn-lg">Buka Dashboard</a>
                <% } else { %>
                    <a href="register.jsp" class="btn btn-primary btn-lg">Mulai Gratis</a>
                    <a href="#how" class="btn btn-outline btn-lg">Pelajari Dulu</a>
                <% } %>
            </div>

            <div class="hero-stats">
                <div class="hs-item">
                    <h4>10rb+</h4>
                    <p>Pengguna</p>
                </div>
                <div class="hs-item">
                    <h4>500 Ton</h4>
                    <p>Sampah Terolah</p>
                </div>
                <div class="hs-item">
                    <h4>Rp 2M+</h4>
                    <p>Reward Cair</p>
                </div>
            </div>
        </div>

        <div class="hero-img-box">
            <img src="https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=1613&auto=format&fit=crop" class="hero-main-img" alt="Recycling">
            
            <div class="float-card fc-1">
                <div class="fc-icon"><i class="fas fa-check"></i></div>
                <div>
                    <div style="font-size:0.75rem; color:#888; font-weight:700;">STATUS HARI INI</div>
                    <div style="font-weight:700;">120 Kg Terjemput</div>
                </div>
            </div>

            <div class="float-card fc-2">
                <div class="fc-icon" style="background:#dbeafe; color:#2563eb;"><i class="fas fa-wallet"></i></div>
                <div>
                    <div style="font-size:0.75rem; color:#888; font-weight:700;">TOTAL POIN</div>
                    <div style="font-weight:700;">Rp 450.000</div>
                </div>
            </div>
        </div>
    </header>

    <section class="features" id="features">
        <div class="sec-header">
            <h2 class="sec-title">Kenapa Harus PickWaste?</h2>
            <p class="sec-desc">Teknologi modern untuk pengalaman daur ulang yang mulus dan menguntungkan.</p>
        </div>

        <div class="bento-grid">
            <div class="bento-card bento-large">
                <div class="bento-content">
                    <div class="bento-icon-box" style="background:#dcfce7; color:var(--primary);">
                        <i class="fas fa-truck-fast"></i>
                    </div>
                    <h3>Jemputan Kilat</h3>
                    <p>Tidak perlu menunggu lama. Jadwalkan penjemputan dan petugas kami akan tiba di depan pintu Anda sesuai waktu yang ditentukan.</p>
                </div>
                <i class="fas fa-truck bento-decor-icon"></i>
            </div>

            <div class="bento-card">
                <div class="bento-icon-box" style="background:var(--primary); color:white;">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div>
                    <h3>Laporan Dampak</h3>
                    <p>Pantau jejak karbon yang berhasil Anda kurangi setiap bulannya.</p>
                </div>
            </div>

            <div class="bento-card">
                <div class="bento-icon-box" style="background:#eab308; color:white;">
                    <i class="fas fa-coins"></i>
                </div>
                <div>
                    <h3>Tukar Poin</h3>
                    <p>Kumpulkan poin dari sampah plastik & kertas, tukar jadi saldo DANA.</p>
                </div>
            </div>

            <div class="bento-card bento-large">
                <div class="bento-content">
                    <div class="bento-icon-box" style="background:#2563eb; color:white;">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Transparan & Aman</h3>
                    <p>Setiap penimbangan dilakukan secara digital dan tercatat otomatis di aplikasi. Tidak ada kecurangan, semua data transparan untuk Anda.</p>
                </div>
                <i class="fas fa-file-contract bento-decor-icon" style="color:#2563eb;"></i>
            </div>
        </div>
    </section>

    <section class="steps" id="how">
        <div class="sec-header" style="color:white; margin-bottom:40px;">
            <h2 class="sec-title" style="color:white;">Cara Kerja Simpel</h2>
            <p class="sec-desc" style="color:#a7f3d0;">4 langkah mudah mengubah sampah jadi berkah.</p>
        </div>
        
        <div class="step-container">
            <div class="step-box">
                <div class="step-num">1</div>
                <div class="step-line"></div>
                <div class="step-content">
                    <h4>Buat Akun</h4>
                    <p>Daftar gratis di platform kami hanya dalam 1 menit.</p>
                </div>
            </div>
            <div class="step-box">
                <div class="step-num">2</div>
                <div class="step-line"></div>
                <div class="step-content">
                    <h4>Pilah Sampah</h4>
                    <p>Pisahkan sampah organik dan anorganik di rumah.</p>
                </div>
            </div>
            <div class="step-box">
                <div class="step-num">3</div>
                <div class="step-line"></div>
                <div class="step-content">
                    <h4>Request Jemput</h4>
                    <p>Tentukan lokasi & waktu. Petugas segera meluncur.</p>
                </div>
            </div>
            <div class="step-box">
                <div class="step-num">4</div>
                <div class="step-line"></div>
                <div class="step-content">
                    <h4>Terima Cuan</h4>
                    <p>Sampah ditimbang, poin masuk ke saldo Anda.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="testimonials" id="testimonials">
        <div class="sec-header">
            <h2 class="sec-title">Kata Mereka</h2>
            <p class="sec-desc">Pengalaman nyata dari ribuan pengguna yang telah bergabung.</p>
        </div>
        
        <div class="testi-grid">
            <div class="testi-card">
                <div class="quote-icon"><i class="fas fa-quote-left"></i></div>
                <p class="testi-text">"Sangat terbantu! Dulu bingung buang sampah elektronik, sekarang tinggal request jemput. Dapat cuan pula!"</p>
                <div class="testi-user">
                    <img src="https://i.pravatar.cc/100?img=5" alt="User">
                    <div class="tu-info"><h5>Sarah Wijaya</h5><span>Ibu Rumah Tangga</span></div>
                </div>
            </div>
            
            <div class="testi-card">
                <div class="quote-icon"><i class="fas fa-quote-left"></i></div>
                <p class="testi-text">"Aplikasi smooth, petugas ramah. Transparansi timbangannya itu lho yang bikin percaya. Top banget!"</p>
                <div class="testi-user">
                    <img src="https://i.pravatar.cc/100?img=11" alt="User">
                    <div class="tu-info"><h5>Budi Santoso</h5><span>Mahasiswa</span></div>
                </div>
            </div>

            <div class="testi-card">
                <div class="quote-icon"><i class="fas fa-quote-left"></i></div>
                <p class="testi-text">"Udah tukar poin 3x buat token listrik. Lumayan banget buat penghematan bulanan sambil jaga bumi."</p>
                <div class="testi-user">
                    <img src="https://i.pravatar.cc/100?img=9" alt="User">
                    <div class="tu-info"><h5>Ani Pratama</h5><span>Wiraswasta</span></div>
                </div>
            </div>
        </div>
    </section>

    <section class="cta">
        <div class="cta-inner">
            <div class="cta-text">
                <h2>Siap Menjadi Pahlawan Lingkungan?</h2>
                <p>Bergabunglah dengan ribuan orang lainnya yang telah membuat dampak nyata.</p>
                <div class="cta-btns">
                    <% if(isLoggedIn) { %>
                        <a href="dashboardUser.jsp" class="btn btn-white">Masuk Dashboard</a>
                    <% } else { %>
                        <a href="register.jsp" class="btn btn-white">Daftar Sekarang</a>
                    <% } %>
                </div>
            </div>
        </div>
    </section>

    <footer id="contact">
        <div class="footer-content">
            <div>
                <a href="#" class="f-logo"><i class="fas fa-recycle"></i> PickWaste</a>
                <p class="f-desc">Platform manajemen sampah digital modern untuk masa depan Indonesia yang lebih bersih.</p>
            </div>
            <div>
                <div class="f-head">Perusahaan</div>
                <ul class="f-links">
                    <li><a href="#">Tentang Kami</a></li>
                    <li><a href="#">Karir</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </div>
            <div>
                <div class="f-head">Layanan</div>
                <ul class="f-links">
                    <li><a href="#">Rumah Tangga</a></li>
                    <li><a href="#">Bisnis</a></li>
                    <li><a href="#">Mitra</a></li>
                </ul>
            </div>
            <div>
                <div class="f-head">Hubungi Kami</div>
                <ul class="f-links">
                    <li><a href="#">Bantuan</a></li>
                    <li><a href="#">hello@pickwaste.com</a></li>
                    <li><a href="#">Surabaya, ID</a></li>
                </ul>
            </div>
        </div>
        <div class="f-bottom">
            <div>&copy; 2025 PickWaste Indonesia.</div>
            <div style="display:flex; gap:20px;">
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
            </div>
        </div>
    </footer>

</body>
</html>