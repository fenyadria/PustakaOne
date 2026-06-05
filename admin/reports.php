<?php 
include 'layout_top.php'; 

// Basic report summary
$total_borrowed = $conn->query("SELECT COUNT(*) as total FROM peminjaman")->fetch_assoc()['total'];
$total_returned = $conn->query("SELECT COUNT(*) as total FROM peminjaman WHERE status='returned'")->fetch_assoc()['total'];

// Most borrowed books
$report = $conn->query("SELECT * FROM view_peminjaman");

$popular_books = $conn->query("
    SELECT
        b.id_buku,
        b.title,
        COUNT(d.id_buku) as borrow_count
    FROM buku b
    LEFT JOIN detail_pinjam d ON b.id_buku = d.id_buku
    LEFT JOIN peminjaman p ON d.id_peminjaman = p.id_peminjaman
    GROUP BY b.id_buku, b.title
    ORDER BY borrow_count DESC
    LIMIT 5
");
?>

<div class="page-header">
    <h1 class="page-title">Laporan Peminjaman</h1>
    <button onclick="window.print()" class="btn btn-primary"><i class="fas fa-print"></i> Cetak Laporan</button>
</div>

<div class="glass-panel report-panel">
    <table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Nama</th>
        <th>Buku</th>
        <th>Tanggal</th>
        <th>Status</th>
    </tr>
    </thead>

    <tbody>
    <?php while($row = $report->fetch_assoc()): ?>
    <tr>
        <td>#<?= $row['id_peminjaman'] ?></td>
        <td><?= $row['nama_peminjam'] ?></td>
        <td><?= $row['judul_buku'] ?></td>
        <td><?= $row['borrow_date'] ?></td>
        <td><?= $row['status'] ?></td>
    </tr>
    <?php endwhile; ?>
    </tbody>
    </table>
</div>

<div class="dashboard-grid">
    <div class="glass-card stat-card report-stat-card">
        <h3><?php echo $total_borrowed; ?></h3>
        <p>Total Transaksi Peminjaman</p>
    </div>
    <div class="glass-card stat-card report-stat-card">
        <h3><?php echo $total_returned; ?></h3>
        <p>Buku Telah Dikembalikan</p>
    </div>
    <div class="glass-card stat-card report-stat-card">
        <h3><?php echo $total_borrowed - $total_returned; ?></h3>
        <p>Buku Masih Dipinjam</p>
    </div>
</div>

<div class="glass-panel popular-books-panel">
    <h3>Buku Paling Sering Dipinjam</h3>
    <div class="table-container popular-books-table">
        <table>
            <thead>
                <tr>
                    <th>Judul Buku</th>
                    <th>Jumlah Peminjaman</th>
                </tr>
            </thead>
            <tbody>
                <?php while($row = $popular_books->fetch_assoc()): ?>
                <tr>
                    <td><strong><?php echo htmlspecialchars($row['title']); ?></strong></td>
                    <td><?php echo $row['borrow_count']; ?> Kali</td>
                </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
