<?php
require_once 'config.php';

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirm_password = $_POST['confirm_password'] ?? '';

    if (empty($name) || empty($username) || empty($password)) {
        $error = 'Silakan isi semua field.';
    } elseif ($password !== $confirm_password) {
        $error = 'Password dan konfirmasi password tidak cocok.';
    } else {
        $stmt_check = $conn->prepare("SELECT id_user FROM users WHERE username = ?");
        $stmt_check->bind_param("s", $username);
        $stmt_check->execute();
        $res = $stmt_check->get_result();

        if ($res->num_rows > 0) {
            $error = 'Username sudah terdaftar, silakan pilih yang lain.';
        } else {
            $hashed = password_hash($password, PASSWORD_DEFAULT);
            $role = 'user';

            $stmt = $conn->prepare("INSERT INTO users (username, password, role, name) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("ssss", $username, $hashed, $role, $name);

            if ($stmt->execute()) {
                $success = 'Pendaftaran berhasil! Silakan login.';
            } else {
                $error = 'Terjadi kesalahan sistem.';
            }
            $stmt->close();
        }
        $stmt_check->close();
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi - Sistem Perpustakaan</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-visual">
            <div class="auth-visual-badge"><i class="fas fa-user-plus"></i> Gabung Sekarang</div>
            <h1>Buat akun untuk mulai meminjam buku favoritmu.</h1>
            <p>Registrasi yang sederhana, tampilan yang cerah, dan pengalaman yang lebih nyaman.</p>
            <div class="auth-visual-stats">
                <div><strong>Easy</strong><span>Sign Up</span></div>
                <div><strong>Safe</strong><span>Password</span></div>
                <div><strong>Quick</strong><span>Access</span></div>
            </div>
        </div>
        <div class="glass-panel auth-box">
            <div class="auth-header">
                <div class="auth-icon"><i class="fas fa-book-open-reader"></i></div>
                <h2 class="auth-title">Daftar Anggota</h2>
                <p class="auth-subtitle">Buat akun untuk mulai meminjam buku</p>
            </div>

            <?php if ($error): ?>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>

            <?php if ($success): ?>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <?php echo htmlspecialchars($success); ?>
                </div>
                <div style="text-align:center; margin-bottom: 20px;">
                    <a href="login.php" class="btn btn-primary btn-block">Ke Halaman Login</a>
                </div>
            <?php else: ?>
            <form method="POST" action="">
                <div class="form-group">
                    <label class="form-label" for="name">Nama Lengkap</label>
                    <input type="text" id="name" name="name" class="form-control" required placeholder="Masukkan nama lengkap">
                </div>
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required autocomplete="username" placeholder="Buat username">
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required autocomplete="new-password" placeholder="Buat password">
                </div>
                <div class="form-group">
                    <label class="form-label" for="confirm_password">Konfirmasi Password</label>
                    <input type="password" id="confirm_password" name="confirm_password" class="form-control" required autocomplete="new-password" placeholder="Ulangi password">
                </div>
                <button type="submit" class="btn btn-secondary btn-block">
                    <i class="fas fa-user-plus"></i> Daftar
                </button>
            </form>
            <?php endif; ?>

            <div class="auth-footer">
                <p>Sudah punya akun? <a href="login.php">Login di sini</a></p>
            </div>
        </div>
    </div>
</body>
</html>
