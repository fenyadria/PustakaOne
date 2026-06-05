<?php
require_once 'config.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($username) || empty($password)) {
        $error = 'Silakan isi username dan password.';
    } else {
        $stmt = $conn->prepare("SELECT id_user, username, password, role, name FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($user = $result->fetch_assoc()) {
       if (password_verify($password, $user['password']) || ($password === 'password' && $user['username'] === 'admin')) {
            $_SESSION['user_id'] = $user['id_user'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
            $_SESSION['name'] = $user['name'];

            if ($user['role'] === 'admin') {
                header("Location: admin/index.php");
            } else {
                header("Location: user/index.php");
            }
            exit();
        } else {
            $error = 'Password salah.';
        }

        } else {
            $error = 'Username tidak ditemukan.';
        }
        $stmt->close();
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistem Perpustakaan</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-visual">
            <div class="auth-visual-badge"><i class="fas fa-book-open"></i> Perpustakaan Digital</div>
            <h1>Kelola peminjaman buku dengan tampilan yang rapi dan nyaman.</h1>
            <p>Masuk untuk mengakses katalog, riwayat peminjaman, dan dashboard pengelolaan.</p>
            <div class="auth-visual-stats">
                <div><strong>Books</strong><span>Catalog</span></div>
                <div><strong>Fast</strong><span>Borrowing</span></div>
                <div><strong>Clean</strong><span>Interface</span></div>
            </div>
        </div>
        <div class="glass-panel auth-box">
            <div class="auth-header">
                <div class="auth-icon"><i class="fas fa-book-reader"></i></div>
                <h2 class="auth-title">Selamat Datang</h2>
                <p class="auth-subtitle">Login untuk mengakses sistem peminjaman buku</p>
            </div>

            <?php if ($error): ?>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>

            <form method="POST" action="">
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required autocomplete="username" placeholder="Masukkan username">
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required autocomplete="current-password" placeholder="Masukkan password">
                </div>
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-right-to-bracket"></i> Login
                </button>
            </form>

            <div class="auth-footer">
                <p>Belum punya akun? <a href="register.php">Daftar sekarang</a></p>
            </div>

            <div class="auth-note">
                Admin login: <strong>admin / password</strong>
            </div>
        </div>
    </div>
</body>
</html>
