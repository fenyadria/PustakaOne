<?php
$host = 'localhost';
$db   = 'sispus';
$user = 'root'; 
$pass = '';     

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
try {
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset("utf8mb4");
} catch (\mysqli_sql_exception $e) {
    if ($e->getCode() == 1049) { 
        $temp_conn = new mysqli($host, $user, $pass);
        $temp_conn->query("CREATE DATABASE IF NOT EXISTS `$db`");
        $temp_conn->close();

        $conn = new mysqli($host, $user, $pass, $db);
        
        $sql_file = __DIR__ . '/database.sql';
        if (file_exists($sql_file)) {
            $sql = file_get_contents($sql_file);

            if ($conn->multi_query($sql)) {
                do {

                    if ($result = $conn->store_result()) {
                        $result->free();
                    }
                } while ($conn->more_results() && $conn->next_result());
            }
        }
    } else {
        die("Database connection failed: " . $e->getMessage());
    }
}
session_start();

function getBaseUrl() {
    $script_name = $_SERVER['SCRIPT_NAME'];
    $base_dir = dirname($script_name);

    if (basename($base_dir) == 'admin' || basename($base_dir) == 'user') {
        $base_dir = dirname($base_dir);
    }

    if ($base_dir == DIRECTORY_SEPARATOR || $base_dir == '/' || $base_dir == '\\') {
        $base_dir = '';
    }
    return rtrim($base_dir, '/\\');
}

function checkLogin() {
    if (!isset($_SESSION['user_id'])) {
        header("Location: " . getBaseUrl() . "/login.php");
        exit();
    }
}

function checkAdmin() {
    checkLogin();
    if ($_SESSION['role'] !== 'admin') {
        header("Location: " . getBaseUrl() . "/user/index.php");
        exit();
    }
}
?>