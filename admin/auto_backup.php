<?php

date_default_timezone_set('Asia/Jakarta');

$backupDir = dirname(__DIR__) . '/storage/backups/';

if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

$fileName = 'auto_backup_' . date('Y-m-d_H-i-s') . '.sql';

$backupFile = $backupDir . $fileName;

$mysqldump = "C:\\laragon\\bin\\mysql\\mysql-8.0.30-winx64\\bin\\mysqldump.exe";

$dbUser = "root";
$dbPass = "";
$dbName = "sispus";

$command = "\"$mysqldump\" -u $dbUser " .
           ($dbPass ? "-p$dbPass " : "") .
           "$dbName --result-file=\"$backupFile\"";

exec($command);