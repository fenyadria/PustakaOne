<?php 
include 'layout_top.php'; 

// Handle CRUD operations
$msg = '';
$msg_type = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['add_book'])) {
        $title = trim($_POST['title']);
        $author = trim($_POST['author']);
        $publisher = trim($_POST['publisher']);
        $year = (int)$_POST['year'];
        $quantity = (int)$_POST['quantity'];
        $id_kategori = (int)$_POST['id_kategori'];
        
        $stmt = $conn->prepare("INSERT INTO buku (title, author, publisher, year, quantity, id_kategori) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("sssiii", $title, $author, $publisher, $year, $quantity, $id_kategori);
        if ($stmt->execute()) {
            $msg = "Buku berhasil ditambahkan.";
            $msg_type = "success";
        }
    } elseif (isset($_POST['edit_book'])) {
        $id = (int)$_POST['id'];
        $title = trim($_POST['title']);
        $author = trim($_POST['author']);
        $publisher = trim($_POST['publisher']);
        $year = (int)$_POST['year'];
        $quantity = (int)$_POST['quantity'];
        $id_kategori = (int)$_POST['id_kategori'];
        
        $stmt = $conn->prepare("UPDATE buku SET title=?, author=?, publisher=?, year=?, quantity=?, id_kategori=? WHERE id_buku=?");
        $stmt->bind_param("sssiiii", $title, $author, $publisher, $year, $quantity, $id_kategori, $id);
        if ($stmt->execute()) {
            $msg = "Buku berhasil diperbarui.";
            $msg_type = "success";
        }
        } elseif (isset($_POST['delete_book'])) {
        $id = (int)$_POST['id'];

        if ($conn->query("CALL hapus_buku($id)")) {
            $msg = "Buku berhasil dihapus.";
            $msg_type = "success";
        } else {
            $msg = "Gagal menghapus buku.";
            $msg_type = "error";
        }
    }
}

// Fetch all books
$search = $_GET['search'] ?? '';
$query = "SELECT b.*, k.nama as kategori_nama
            FROM buku b LEFT JOIN kategori k ON b.id_kategori = k.id_kategori";
if ($search) {
    $search_esc = $conn->real_escape_string($search);
    $query .= " WHERE title LIKE '%$search_esc%' OR author LIKE '%$search_esc%'";
}
$query .= " ORDER BY created_at DESC";
$buku = $conn->query($query);
$kategori = $conn->query("SELECT * FROM kategori");

// Logic info for edit
$edit_id = $_GET['edit'] ?? null;
$book_edit = null;
if ($edit_id) {
    $stmt = $conn->prepare("SELECT * FROM buku WHERE id_buku=?");
    $stmt->bind_param("i", $edit_id);
    $stmt->execute();
    $book_edit = $stmt->get_result()->fetch_assoc();
}
?>

<div class="page-header">
    <h1 class="page-title">Kelola Data Buku</h1>
</div>

<?php if ($msg): ?>
    <div class="alert alert-<?php echo $msg_type; ?>">
        <?php echo $msg; ?>
    </div>
<?php endif; ?>

<div class="glass-panel" style="padding: 20px; margin-bottom: 30px;">
    <h3><?php echo $book_edit ? 'Edit Buku' : 'Tambah Buku Baru'; ?></h3>
    <form method="POST" action="books.php" style="margin-top: 15px; display: flex; flex-wrap: wrap; gap: 15px;">
        <?php if ($book_edit): ?>
            <input type="hidden" name="id" value="<?php echo $book_edit['id_buku']; ?>">
        <?php endif; ?>
        
        <div class="form-group" style="flex: 1; min-width: 250px; margin-bottom: 0;">
            <label class="form-label">Judul Buku</label>
            <input type="text" name="title" class="form-control" required value="<?php echo $book_edit['title'] ?? ''; ?>">
        </div>
        <div class="form-group" style="flex: 1; min-width: 200px; margin-bottom: 0;">
            <label class="form-label">Penulis</label>
            <input type="text" name="author" class="form-control" required value="<?php echo $book_edit['author'] ?? ''; ?>">
        </div>
        <div class="form-group" style="flex: 1; min-width: 150px; margin-bottom: 0;">
            <label class="form-label">Penerbit</label>
            <input type="text" name="publisher" class="form-control" required value="<?php echo $book_edit['publisher'] ?? ''; ?>">
        </div>
        <div class="form-group" style="flex: 1; min-width: 200px; margin-bottom: 0;">
            <label class="form-label">Kategori</label>
            <select name="id_kategori" class="form-control" required>
                <option value="">Pilih Kategori</option>
                <?php while($k = $kategori->fetch_assoc()): ?>
                    <option value="<?= $k['id_kategori']; ?>">
                        <?= $k['nama']; ?>
                    </option>
                <?php endwhile; ?>
            </select>
        </div>
        <div class="form-group" style="width: 100px; margin-bottom: 0;">
            <label class="form-label">Tahun</label>
            <input type="number" name="year" class="form-control" required value="<?php echo $book_edit['year'] ?? ''; ?>">
        </div>
        <div class="form-group" style="width: 100px; margin-bottom: 0;">
            <label class="form-label">Jumlah</label>
            <input type="number" name="quantity" class="form-control" required value="<?php echo $book_edit['quantity'] ?? '1'; ?>" min="1">
        </div>
        <div class="form-group" style="display: flex; align-items: flex-end; margin-bottom: 0;">
            <?php if ($book_edit): ?>
                <button type="submit" name="edit_book" class="btn btn-warning" style="margin-right: 10px;">Update</button>
                <a href="books.php" class="btn btn-outline">Batal</a>
            <?php else: ?>
                <button type="submit" name="add_book" class="btn btn-primary"><i class="fas fa-plus"></i> Tambah</button>
            <?php endif; ?>
        </div>
    </form>
</div>

<div class="glass-panel" style="padding: 20px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h3>Daftar Buku</h3>
        <form method="GET" class="search-box" style="margin: 0; width: 300px;">
            <input type="text" name="search" class="form-control" placeholder="Cari buku..." value="<?php echo htmlspecialchars($search); ?>">
            <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
        </form>
    </div>
    
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Judul</th>
                    <th>Penulis</th>
                    <th>Penerbit</th>
                    <th>Kategori</th>
                    <th>Tahun</th>
                    <th>Stok</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php while($row = $buku->fetch_assoc()): ?>
                <tr>
                    <td><strong><?php echo htmlspecialchars($row['title']); ?></strong></td>
                    <td><?php echo htmlspecialchars($row['author']); ?></td>
                    <td><?php echo htmlspecialchars($row['publisher']); ?></td>
                    <td><?php echo $row['kategori_nama']; ?></td>
                    <td><?php echo htmlspecialchars($row['year']); ?></td>
                    <td>
                        <?php if($row['quantity'] > 0): ?>
                            <span class="badge badge-success"><?php echo $row['quantity']; ?></span>
                        <?php else: ?>
                            <span class="badge badge-danger">Habis</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <a href="books.php?edit=<?php echo $row['id_buku']; ?>" class="btn btn-outline" style="padding: 4px 8px; font-size: 0.8rem;"><i class="fas fa-edit"></i></a>
                        <form method="POST" style="display:inline;" onsubmit="return confirm('Hapus buku ini?');">
                            <input type="hidden" name="id" value="<?php echo $row['id_buku']; ?>">
                            <button type="submit" name="delete_book" class="btn btn-danger" style="padding: 4px 8px; font-size: 0.8rem;"><i class="fas fa-trash"></i></button>
                        </form>
                    </td>
                </tr>
                <?php endwhile; ?>
                <?php if($buku->num_rows == 0): ?>
                <tr><td colspan="7" style="text-align:center;">Tidak ada data buku</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
