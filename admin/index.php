<?php include 'layout_top.php'; ?>

<div class="page-header">
    <h1 class="page-title">Dashboard Overview</h1>
    <div class="user-info">
        <span>Halo, <strong><?php echo htmlspecialchars($_SESSION['name']); ?></strong></span>
    </div>
</div>

<?php

$backupDir = __DIR__ . '/../storage/backups/';

if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

$files = glob($backupDir . '*.sql');

$needBackup = true;

if ($files) {

    usort($files, function ($a, $b) {
        return filemtime($b) - filemtime($a);
    });

    $lastBackup = filemtime($files[0]);

    if ((time() - $lastBackup) < 86400) {
        $needBackup = false;
    }
}

if ($needBackup) {

    $fileName = 'auto_backup_' . date('Y-m-d_H-i-s') . '.sql';

    $backupFile = $backupDir . $fileName;

    $mysqldump = "C:\\laragon\\bin\\mysql\\mysql-8.0.30-winx64\\bin\\mysqldump.exe";

    $command = "\"$mysqldump\" -u root sispus --result-file=\"$backupFile\"";

    exec($command);
}
?>

<?php
// Statistics queries
$stats = [
    'books' => $conn->query("SELECT SUM(quantity) as total FROM buku")->fetch_assoc()['total'] ?? 0,
    'members' => $conn->query("SELECT COUNT(*) as total FROM users WHERE role='user'")->fetch_assoc()['total'] ?? 0,
    'borrowed' => $conn->query("SELECT COUNT(*) as total FROM peminjaman WHERE status='borrowed'")->fetch_assoc()['total'] ?? 0,
    'total_trans' => $conn->query("SELECT COUNT(*) as total FROM peminjaman")->fetch_assoc()['total'] ?? 0
];
?>

<div class="dashboard-grid">
    <div class="glass-card stat-card">
        <div class="stat-icon blue">
            <i class="fas fa-book"></i>
        </div>
        <div class="stat-details">
            <h3><?php echo $stats['books']; ?></h3>
            <p>Total Buku</p>
        </div>
    </div>
    <div class="glass-card stat-card">
        <div class="stat-icon green">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-details">
            <h3><?php echo $stats['members']; ?></h3>
            <p>Anggota Aktif</p>
        </div>
    </div>
    <div class="glass-card stat-card">
        <div class="stat-icon orange">
            <i class="fas fa-hand-holding-hand"></i>
        </div>
        <div class="stat-details">
            <h3><?php echo $stats['borrowed']; ?></h3>
            <p>Buku Dipinjam</p>
        </div>
    </div>
    <div class="glass-card stat-card">
        <div class="stat-icon pink">
            <i class="fas fa-history"></i>
        </div>
        <div class="stat-details">
            <h3><?php echo $stats['total_trans']; ?></h3>
            <p>Total Transaksi</p>
        </div>
    </div>
</div>

<div class="glass-panel" style="padding: 20px;">
    <h3>Peminjaman Terbaru</h3>
    <div class="table-container" style="margin-top: 15px;">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Peminjam</th>
                    <th>Buku</th>
                    <th>Tgl Pinjam</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $recent = $conn->query("
                SELECT 
                    p.*,
                    u.name AS user_name,
                    GROUP_CONCAT(b.title SEPARATOR ', ') AS book_titles
                FROM peminjaman p
                JOIN users u ON p.user_id = u.id_user
                JOIN detail_pinjam d ON p.id_peminjaman = d.id_peminjaman
                JOIN buku b ON d.id_buku = b.id_buku
                GROUP BY
                    p.id_peminjaman,
                    p.user_id,
                    p.borrow_date,
                    p.return_date,
                    p.status,
                    p.created_at,
                    u.name
                ORDER BY p.created_at DESC
                LIMIT 5
            ");
                while ($row = $recent->fetch_assoc()):
                ?>
                <tr>
                    <td>#<?php echo $row['id_peminjaman']; ?></td>
                    <td><?php echo htmlspecialchars($row['user_name']); ?></td>
                    <td><?php echo htmlspecialchars($row['book_titles']); ?></td>
                    <td><?php echo date('d M Y', strtotime($row['borrow_date'])); ?></td>
                    <td>
                        <?php if($row['status'] == 'borrowed'): ?>
                            <span class="badge badge-warning">Dipinjam</span>
                        <?php else: ?>
                            <span class="badge badge-success">Dikembalikan</span>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endwhile; ?>
                <?php if($recent->num_rows == 0): ?>
                <tr><td colspan="5" style="text-align:center;">Belum ada transaksi</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php
$aktivitas = $conn->query("SELECT 'Peminjaman' as tipe, u.name as nama, p.created_at as tanggal
    FROM peminjaman p JOIN users u ON p.user_id = u.id_user UNION ALL SELECT 'User Baru', name, created_at
    FROM users ORDER BY tanggal DESC
    LIMIT 10
");
?>

<div class="glass-panel" style="padding: 20px; margin-top: 25px;">
    <h3>Aktivitas Terbaru</h3>
    <div class="table-container" style="margin-top: 15px;">
        <table>
        <thead>
        <tr>
            <th>Tipe</th>
            <th>Nama</th>
            <th>Tanggal</th>
        </tr>
        </thead>

        <tbody>
        <?php while($row = $aktivitas->fetch_assoc()): ?>
        <tr>
            <td><?= $row['tipe'] ?></td>
            <td><?= $row['nama'] ?></td>
            <td><?= date('d M Y', strtotime($row['tanggal'])) ?></td>
        </tr>
        <?php endwhile; ?>
        </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
