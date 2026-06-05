<?php
include 'layout_top.php';

$backup_dir = dirname(__DIR__) . '/storage/backups/';

if (!is_dir($backup_dir)) {
    mkdir($backup_dir, 0755, true);
}

$files = glob($backup_dir . '*.sql');

usort($files, function ($a, $b) {
    return filemtime($b) - filemtime($a);
});

$totalBackup = count($files);

$totalSize = 0;

foreach ($files as $file) {
    $totalSize += filesize($file);
}

$totalSizeMB = round($totalSize / 1024 / 1024, 2);

$lastBackup = '-';
if (!empty($files)) {
    $latestTime = 0;
    foreach ($files as $file) {
        $fileTime = filemtime($file);
        if ($fileTime > $latestTime) {
            $latestTime = $fileTime;
        }
    }
    $lastBackup = date('d M Y H:i:s', $latestTime);
}
?>

<div class="page-header">

    <h1 class="page-title">
        Backup Database
    </h1>

    <a href="backup.php" class="btn btn-primary">
        <i class="fas fa-database"></i>
        Backup Sekarang
    </a>

</div>

<?php if(isset($_GET['status']) && $_GET['status'] == 'success'): ?>
    <div class="alert alert-success">
        Backup database berhasil dibuat.
    </div>
<?php endif; ?>

<?php if(isset($_GET['status']) && $_GET['status'] == 'fail'): ?>
    <div class="alert alert-error">
        Backup database gagal dibuat.
    </div>
<?php endif; ?>

<div class="dashboard-grid">

    <div class="glass-card stat-card">

        <div class="stat-icon blue">
            <i class="fas fa-database"></i>
        </div>

        <div class="stat-details">
            <h3><?= $totalBackup ?></h3>
            <p>Total Backup</p>
        </div>

    </div>

    <div class="glass-card stat-card">

        <div class="stat-icon green">
            <i class="fas fa-hdd"></i>
        </div>

        <div class="stat-details">
            <h3><?= $totalSizeMB ?> MB</h3>
            <p>Total Ukuran</p>
        </div>

    </div>

    <div class="glass-card stat-card">

        <div class="stat-icon orange">
            <i class="fas fa-clock"></i>
        </div>

        <div class="stat-details">
            <h3 style="font-size:1rem;">
                <?= $lastBackup ?>
            </h3>
            <p>Backup Terakhir</p>
        </div>

    </div>

</div>

<div class="glass-panel">

    <div class="table-container">

        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Nama File</th>
                    <th>Ukuran</th>
                    <th>Tanggal Backup</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>

            <tbody>

            <?php if(count($files) > 0): ?>

                <?php $no = 1; ?>

                <?php foreach($files as $file): ?>

                <tr>

                    <td><?= $no++; ?></td>

                    <td>
                        <strong><?= basename($file); ?></strong>
                    </td>

                    <td>
                        <?= round(filesize($file) / 1024, 2); ?> KB
                    </td>

                    <td>
                        <?= date('d M Y H:i:s', filemtime($file)); ?>
                    </td>

                    <td>
                        <span class="badge badge-success">
                            Berhasil
                        </span>
                    </td>
                    <td>
                        <a href="../storage/backups/<?= urlencode(basename($file)); ?>" class="btn btn-secondary" download>
                            <i class="fas fa-download"></i>
                            Download
                        </a>
                    </td>
                </tr>
                <?php endforeach; ?>
            <?php else: ?>

                <tr>
                    <td colspan="6" style="text-align:center; padding:30px;">
                        Belum ada file backup.
                    </td>
                </tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
<?php include 'layout_bottom.php'; ?>