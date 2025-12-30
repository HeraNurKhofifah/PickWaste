<%-- 
    Document   : register
    Description: Modern Registration Page with Role Dropdown (Versi Bahasa Indonesia)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buat Akun | PickWaste</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        
        body {
            height: 100vh;
            width: 100%;
            display: flex;
            overflow: hidden; /* Mencegah scroll */
        }

        /* --- LEFT SIDE (IMAGE & TEXT) --- */
        .left-section {
            width: 45%;
            background: url('https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?q=80&w=1000&auto=format&fit=crop') no-repeat center center/cover;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            padding: 40px;
            text-align: center;
        }

        /* Overlay Hijau Gelap agar tulisan terbaca */
        .left-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(17, 36, 19, 0.8), rgba(9, 26, 12, 0.95));
            z-index: 1;
        }

        .left-content {
            position: relative;
            z-index: 2;
            max-width: 400px;
        }

        .brand-icon-lg {
            font-size: 3rem;
            color: #00d25b;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }

        .left-content h1 {
            font-size: 2.5rem;
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 15px;
        }

        .left-content p {
            font-size: 1rem;
            color: rgba(255,255,255,0.8);
            margin-bottom: 30px;
            font-weight: 300;
        }

        /* Avatar Social Proof */
        .social-proof {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: rgba(255,255,255,0.1);
            padding: 10px 20px;
            border-radius: 50px;
            backdrop-filter: blur(5px);
        }
        .avatars { display: flex; padding-left: 10px; }
        .avatars img {
            width: 35px; height: 35px; border-radius: 50%;
            border: 2px solid #1a2e1c;
            margin-left: -10px;
        }
        .proof-text { font-size: 0.85rem; font-weight: 500; }

        @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-10px); } 100% { transform: translateY(0px); } }

        /* --- RIGHT SIDE (LOGIN FORM) --- */
        .right-section {
            width: 55%;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 0 100px; /* Padding besar kiri kanan */
        }

        .form-container {
            max-width: 450px;
            width: 100%;
            margin: 0 auto;
        }

        .form-header { margin-bottom: 30px; }
        .form-header h2 { font-size: 2rem; font-weight: 800; color: #1a1a1a; margin-bottom: 10px; }
        .form-header p { color: #888; font-size: 0.95rem; }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-weight: 600; font-size: 0.9rem; color: #333; margin-bottom: 8px; }
        
        .input-wrapper { position: relative; }
        .form-control {
            width: 100%;
            padding: 14px 15px;
            padding-right: 40px; /* Space for icon */
            border: 1px solid #e1e1e1;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: 0.3s;
            background: #fcfcfc;
        }
        .form-control:focus {
            border-color: #00d25b;
            background: #fff;
            outline: none;
            box-shadow: 0 0 0 4px rgba(0, 210, 91, 0.1);
        }
        
        .input-icon {
            position: absolute; right: 15px; top: 50%;
            transform: translateY(-50%);
            color: #aaa; cursor: pointer;
        }

        .btn-register {
            width: 100%; padding: 15px; background: #00d25b; color: white;
            border: none; border-radius: 10px; font-size: 1rem; font-weight: 700;
            cursor: pointer; transition: 0.3s; box-shadow: 0 4px 15px rgba(0, 210, 91, 0.3);
        }
        .btn-register:hover { background: #00b850; transform: translateY(-2px); }

        .bottom-text { text-align: center; margin-top: 25px; font-size: 0.9rem; color: #666; }
        .bottom-text a { color: #00d25b; font-weight: 700; text-decoration: none; }
        
        .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; background: #ffebeb; color: #e74c3c; border: 1px solid #ffcdcd; display:flex; align-items:center; gap:10px; }

        @media (max-width: 900px) { .left-section { display: none; } .right-section { width: 100%; padding: 30px; } .grid-row { grid-template-columns: 1fr; } }
    
        /* Alert Error */
        .alert-error {
            background: #ffebeb; color: #e74c3c; padding: 12px;
            border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem;
            border: 1px solid #ffcdcd; display: flex; align-items: center; gap: 10px;
        }

        /* Responsif untuk HP */
        @media (max-width: 768px) {
            .left-section { display: none; } /* Sembunyikan gambar di HP */
            .right-section { width: 100%; padding: 40px; }
        }
    </style>
</head>
<body>

    <div class="left-section">
        <div class="left-overlay"></div>
        <div class="left-content">
            <div class="brand-icon-lg"><i class="fas fa-recycle"></i></div>
            <h1>Bergabung dengan Revolusi Hijau</h1>
            <p>Terhubung dengan SamPick lokal, jadwalkan penjemputan dengan mudah, dan dapatkan hadiah untuk setiap kontribusi bagi bumi yang lebih bersih.</p>
            
            <div class="social-proof">
                <div class="avatars">
                    <img src="https://i.pravatar.cc/100?img=1" alt="User">
                    <img src="https://i.pravatar.cc/100?img=5" alt="User">
                    <img src="https://i.pravatar.cc/100?img=8" alt="User">
                </div>
                <span class="proof-text">Bergabung dengan 10rb+ pejuang lingkungan</span>
            </div>
        </div>
    </div>

    <div class="right-section">
        <div class="form-container">
            <div class="form-header">
                <h2>Buat Akun</h2>
                <p>Mulailah perjalanan Anda menuju masa depan yang berkelanjutan hari ini.</p>
            </div>

            <% String err = (String) request.getAttribute("errorMessage"); if (err != null) { %>
                <div class="alert"><i class="fas fa-exclamation-triangle"></i> <%= err %></div>
            <% } %>

            <form action="RegisterServlet" method="post">
                
                <div class="form-group">
                    <label class="form-label">Nama Lengkap</label>
                    <div class="input-wrapper">
                        <input type="text" name="nama" class="form-control" placeholder="Masukkan nama lengkap Anda" required>
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Alamat Email</label>
                    <div class="input-wrapper">
                        <input type="email" name="email" class="form-control" placeholder="nama@email.com" required>
                        <i class="fas fa-envelope input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Kata Sandi</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" class="form-control" placeholder="Buat kata sandi yang kuat" required>
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Saya bergabung sebagai:</label>
                    <div class="input-wrapper">
                        <select name="role" class="form-control" required style="cursor: pointer;">
                            <option value="" disabled selected>-- Pilih Peran --</option>
                            <option value="user">Masyarakat / Pengguna</option> 
                            <option value="sampick">Petugas SamPick</option>
                        </select>
                        <i class="fas fa-chevron-down input-icon" style="font-size:0.8rem;"></i>
                    </div>
                </div>

                <input type="hidden" name="no_hp" value="-">
                <input type="hidden" name="alamat" value="-">

                <button type="submit" class="btn-register">Buat Akun</button>
            </form>

            <div class="bottom-text">
                Sudah punya akun? <a href="login.jsp">Masuk</a>
            </div>
            
            <div style="text-align:center; margin-top:30px; font-size:0.8rem; color:#ccc;">
                <i class="fas fa-lock"></i> Data Anda terenkripsi dan aman
            </div>
        </div>
    </div>

</body>
</html>