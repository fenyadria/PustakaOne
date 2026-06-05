<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

session_start();

require_once __DIR__ . '/../config.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header('Location: ../login.php');
    exit;
}

date_default_timezone_set('Asia/Jakarta');

$backupDir = __DIR__ . '/../storage/backups/';

if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

$fileName = 'backup_' . date('Y-m-d_H-i-s') . '.sql';
$backupFile = $backupDir . $fileName;

$mysqldump = "C:\\laragon\\bin\\mysql\\mysql-8.0.30-winx64\\bin\\mysqldump.exe";

$dbUser = "root";
$dbPass = "";
$dbName = "sispus";

$command = "\"$mysqldump\" -u $dbUser " .
           ($dbPass ? "-p$dbPass " : "") .
           "$dbName --result-file=\"$backupFile\" 2>&1";

exec($command, $output, $returnCode);

if ($returnCode === 0 && file_exists($backupFile)) {

    header("Location: backup_list.php?status=success");
    exit;

} else {

    header("Location: backup_list.php?status=failed");
    exit;
}