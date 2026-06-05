<?php
require_once dirname(__DIR__) . '/config.php';
checkAdmin();
$current_page = basename($_SERVER['PHP_SELF']);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Sistem Perpustakaan</title>
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
                <div class="sidebar-user-label">Administrator</div>
                <strong><?php echo htmlspecialchars($_SESSION['name']); ?></strong>
            </div>
            <ul class="sidebar-nav">
                <li class="nav-item"><a href="index.php" class="nav-link <?= $current_page=='index.php'?'active':'' ?>"><i class="fas fa-home"></i> Dashboard</a></li>
                <li class="nav-item"><a href="books.php" class="nav-link <?= $current_page=='books.php'?'active':'' ?>"><i class="fas fa-book"></i> Kelola Buku</a></li>
                <li class="nav-item"><a href="members.php" class="nav-link <?= $current_page=='members.php'?'active':'' ?>"><i class="fas fa-users"></i> Anggota</a></li>
                <li class="nav-item"><a href="transactions.php" class="nav-link <?= $current_page=='transactions.php'?'active':'' ?>"><i class="fas fa-exchange-alt"></i> Peminjaman</a></li>
                <li class="nav-item"><a href="reports.php" class="nav-link <?= $current_page=='reports.php'?'active':'' ?>"><i class="fas fa-chart-line"></i> Laporan</a></li>
                <li class="nav-item"><a href="backup_list.php" class="nav-link <?= $current_page=='backup_list.php'?'active':'' ?>"><i class="fas fa-database"></i> Database</a></li>
                <li class="nav-item nav-logout">
                    <a href="../logout.php" class="nav-link danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </aside>
        <main class="main-content">
