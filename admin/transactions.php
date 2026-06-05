<?php 
include 'layout_top.php'; 

$msg = '';
$msg_type = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['return_book'])) {
    $id_peminjaman = (int)$_POST['id_peminjaman'];
    
    $conn->begin_transaction();
    try {
        $conn->query("CALL kembalikan_buku($id_peminjaman)");
        $conn->commit();
        $msg = "Buku berhasil dikembalikan.";
        $msg_type = "success";
    } catch (Exception $e) {
        $conn->rollback();
        $msg = "Terjadi kesalahan saat memproses pengembalian.";
        $msg_type = "error";
    }
}

$status_filter = $_GET['status'] ?? 'all';
$query = "SELECT 
            p.id_peminjaman,
            u.name as user_name,
            GROUP_CONCAT(b.title SEPARATOR ', ') as book_titles,
            p.borrow_date,
            p.return_date,
            p.status
        FROM peminjaman p
        JOIN users u ON p.user_id = u.id_user
        JOIN detail_pinjam d ON p.id_peminjaman = d.id_peminjaman
        JOIN buku b ON d.id_buku = b.id_buku
        ";

if ($status_filter === 'borrowed') {
    $query .= " WHERE p.status = 'borrowed'";
} elseif ($status_filter === 'returned') {
    $query .= " WHERE p.status = 'returned'";
}

$query .= "
GROUP BY
    p.id_peminjaman,
    p.user_id,
    u.name,
    p.borrow_date,
    p.return_date,
    p.status,
    p.created_at
ORDER BY p.created_at DESC";

$peminjaman = $conn->query($query);

if (!$peminjaman) {
    die("SQL Error: " . $conn->error);
}
?>

<div class="page-header">
    <h1 class="page-title">Transaksi Peminjaman</h1>
</div>

<?php if ($msg): ?>
    <div class="alert alert-<?php echo $msg_type; ?>">
        <?php echo $msg; ?>
    </div>
<?php endif; ?>

<div class="glass-panel" style="padding: 20px;">
    <div style="margin-bottom: 20px;">
        <a href="transactions.php" class="btn <?php echo $status_filter=='all'?'btn-primary':'btn-outline'; ?>">Semua</a>
        <a href="transactions.php?status=borrowed" class="btn <?php echo $status_filter=='borrowed'?'btn-warning':'btn-outline'; ?>">Dipinjam</a>
        <a href="transactions.php?status=returned" class="btn <?php echo $status_filter=='returned'?'btn-success':'btn-outline'; ?>">Dikembalikan</a>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Peminjam</th>
                    <th>Buku</th>
                    <th>Tgl Pinjam</th>
                    <th>Tgl Kembali</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php while($row = $peminjaman->fetch_assoc()): ?>
                <tr>
                    <td>#<?php echo $row['id_peminjaman']; ?></td>
                    <td><?php echo htmlspecialchars($row['user_name']); ?></td>
                    <td><strong><?php echo htmlspecialchars($row['book_titles']); ?></strong></td>
                    <td><?php echo date('d M Y', strtotime($row['borrow_date'])); ?></td>
                    <td><?php echo $row['return_date'] ? date('d M Y', strtotime($row['return_date'])) : '-'; ?></td>
                    <td>
                        <?php if($row['status'] == 'borrowed'): ?>
                            <span class="badge badge-warning">Dipinjam</span>
                        <?php else: ?>
                            <span class="badge badge-success">Dikembalikan</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if($row['status'] == 'borrowed'): ?>
                        <form method="POST" onsubmit="return confirm('Proses pengembalian buku?');">
                            <input type="hidden" name="id_peminjaman" value="<?php echo $row['id_peminjaman']; ?>">
                            <button type="submit" name="return_book" class="btn btn-success" style="padding: 4px 10px; font-size: 0.8rem;">
                                <i class="fas fa-check"></i> Kembalikan
                            </button>
                        </form>
                        <?php else: ?>
                            <span style="color:#94a3b8; font-size:0.8rem;"><i class="fas fa-check-double"></i> Selesai</span>
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endwhile; ?>
                <?php if($peminjaman->num_rows == 0): ?>
                <tr><td colspan="7" style="text-align:center;">Tidak ada transaksi</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
