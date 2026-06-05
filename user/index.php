<?php 
include 'layout_top.php'; 

$search = $_GET['search'] ?? '';
$query = "SELECT * FROM buku";
if ($search) {
    $search_esc = $conn->real_escape_string($search);
    $query .= " WHERE title LIKE '%$search_esc%' OR author LIKE '%$search_esc%'";
}
$query .= " ORDER BY created_at DESC";
$buku = $conn->query($query);
?>

<div class="page-header">
    <h1 class="page-title">Katalog Buku</h1>
</div>

<div class="glass-panel" style="padding: 20px; margin-bottom: 30px;">
    <form method="GET" class="search-box" style="margin: 0; max-width: 600px;">
        <input type="text" name="search" class="form-control" placeholder="Cari berdasarkan judul atau penulis..." value="<?php echo htmlspecialchars($search); ?>">
        <button type="submit" class="btn btn-primary" style="padding: 12px 24px;"><i class="fas fa-search"></i> Cari</button>
    </form>
</div>

<?php if(isset($_GET['msg']) && $_GET['msg'] == 'success'): ?>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> Berhasil meminjam buku. Silakan ambil buku di meja administrasi.
    </div>
<?php elseif(isset($_GET['msg']) && $_GET['msg'] == 'error'): ?>
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> Gagal meminjam buku. Stok mungkin habis atau terjadi kesalahan.
    </div>
<?php endif; ?>

<div class="book-grid">
    <?php while($row = $buku->fetch_assoc()): ?>
    <div class="glass-card book-card">
        <div class="book-card-content">
            <h3 class="book-title"><?php echo htmlspecialchars($row['title']); ?></h3>
            <p class="book-author"><i class="fas fa-pen-nib" style="width:20px;"></i> <?php echo htmlspecialchars($row['author']); ?></p>
            <p class="book-publisher"><i class="fas fa-building" style="width:20px;"></i> <?php echo htmlspecialchars($row['publisher']); ?> (<?php echo $row['year']; ?>)</p>
        </div>
        <div class="book-meta">
            <div>
                <?php if($row['quantity'] > 0): ?>
                    <span class="badge badge-success"><?php echo $row['quantity']; ?> Tersedia</span>
                <?php else: ?>
                    <span class="badge badge-danger">Tidak Tersedia</span>
                <?php endif; ?>
            </div>
            <div>
                <?php if($row['quantity'] > 0): ?>
                <form action="borrow.php" method="POST" style="display:inline;">
                    <input type="hidden" name="book_id" value="<?php echo $row['id_buku']; ?>">
                    <button type="submit" class="btn btn-primary" style="padding: 5px 12px; font-size: 0.8rem;" onclick="return confirm('Anda yakin ingin meminjam buku ini?');">Pinjam</button>
                </form>
                <?php else: ?>
                <button class="btn btn-secondary" style="padding: 5px 12px; font-size: 0.8rem; opacity: 0.5; cursor: not-allowed;" disabled>Pinjam</button>
                <?php endif; ?>
            </div>
        </div>
    </div>
    <?php endwhile; ?>
    <?php if($buku->num_rows == 0): ?>
    <div style="grid-column: 1 / -1; text-align:center; padding: 40px; color: #94a3b8;">
        <i class="fas fa-book-open" style="font-size: 3rem; margin-bottom: 20px; opacity: 0.5;"></i>
        <h3>Buku tidak ditemukan</h3>
        <p>Coba gunakan kata kunci pencarian yang lain.</p>
    </div>
    <?php endif; ?>
</div>

<?php include 'layout_bottom.php'; ?>
