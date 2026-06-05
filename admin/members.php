<?php 
include 'layout_top.php'; 

// Fetch members
$members = $conn->query("CALL lihat_members()");
?>

<div class="page-header">
    <h1 class="page-title">Data Anggota</h1>
</div>

<div class="glass-panel" style="padding: 20px;">
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama</th>
                    <th>Username</th>
                    <th>Tanggal Bergabung</th>
                    <th>Total Pinjam</th>
                </tr>
            </thead>
            <tbody>
                <?php while($row = $members->fetch_assoc()): 
                ?>
                <tr>
                    <td><?php echo $row['id_user']; ?></td>
                    <td><strong><?php echo htmlspecialchars($row['name']); ?></strong></td>
                    <td><?php echo htmlspecialchars($row['username']); ?></td>
                    <td><?php echo date('d M Y', strtotime($row['created_at'])); ?></td>
                    <td><?= $row['total']; ?> Kali</td>
                </tr>
                <?php endwhile; ?>
                <?php if($members->num_rows == 0): ?>
                <tr><td colspan="5" style="text-align:center;">Belum ada anggota</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php include 'layout_bottom.php'; ?>
