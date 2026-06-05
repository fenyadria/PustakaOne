<?php
require_once dirname(__DIR__) . '/config.php';
checkLogin();
if ($_SESSION['role'] === 'admin') {
    header("Location: /admin/index.php");
    exit();
}
$current_page = basename($_SERVER['PHP_SELF']);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Perpustakaan</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="fas fa-book-reader"></i> Perpus<span>Pro</span>
            </div>
            <div class="sidebar-user">
                <div class="sidebar-user-label">Member</div>
                <strong><?php echo htmlspecialchars($_SESSION['name']); ?></strong>
            </div>
            <ul class="sidebar-nav">
                <li class="nav-item"><a href="index.php" class="nav-link <?= $current_page=='index.php'?'active':'' ?>"><i class="fas fa-search"></i> Cari Buku</a></li>
                <li class="nav-item"><a href="history.php" class="nav-link <?= $current_page=='history.php'?'active':'' ?>"><i class="fas fa-history"></i> Riwayat Peminjaman</a></li>
                <li class="nav-item nav-logout">
                    <a href="../logout.php" class="nav-link danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </aside>
        <main class="main-content">
