<?php 
include 'layout_top.php'; 

$user_id = (int)$_SESSION['user_id'];
$query = "
    SELECT p.id_peminjaman, b.title as book_title, b.author, p.borrow_date, p.return_date, p.status 
    FROM peminjaman p
    JOIN detail_pinjam d ON p.id_peminjaman = d.id_peminjaman
    JOIN buku b ON d.id_buku = b.id_buku
    WHERE p.user_id = $user_id
    ORDER BY p.created_at DESC
";
$history = $conn->query($query);
?>

<div class="page-header">
    <h1 class="page-title">Riwayat Peminjaman</h1>
</div>

<div class="glass-panel" style="padding: 20px;">
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Judul Buku</th>
                    <th>Penulis</th>
                    <th>Tanggal Pinjam</th>
                    <th>Tanggal Kembali</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php while($row = $history->fetch_assoc()): ?>
                <tr>
                    <td><strong><?php echo htmlspecialchars($row['book_title']); ?></strong></td>
                    <td><?php echo htmlspecialchars($row['author']); ?></td>
                    <td><?php echo date('d M Y', strtotime($row['borrow_date'])); ?></td>
                    <td><?php echo $row['return_date'] ? date('d M Y', strtotime($row['return_date'])) : '-'; ?></td>
                    <td>
                        <?php if($row['status'] == 'borrowed'): ?>
                            <span class="badge badge-warning">Sedang Dipinjam</span>
                        <?php else: ?>
                            <span class="badge badge-success">Selesai</span>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endwhile; ?>
                <?php if($history->num_rows == 0): ?>
                <tr><td colspan="5" style="text-align:center;">Belum ada riwayat peminjaman</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
