<?php
require_once dirname(__DIR__) . '/config.php';
checkLogin();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['book_id'])) {

    $book_id = (int)$_POST['book_id'];
    $user_id = (int)$_SESSION['user_id'];
    $borrow_date = date('Y-m-d');

    $conn->begin_transaction();

    try {
        $stmt = $conn->prepare("SELECT quantity FROM buku WHERE id_buku = ? FOR UPDATE");
        $stmt->bind_param("i", $book_id);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($res->num_rows > 0) {
            $book = $res->fetch_assoc();

            $lock_check = $conn->query("SELECT locked_by FROM buku WHERE id_buku = $book_id FOR UPDATE");
            $lock = $lock_check->fetch_assoc();

            if ($lock['locked_by'] !== null && $lock['locked_by'] != $user_id) {
                throw new Exception("Deadlock: buku sedang dipakai user lain");
            }

            $conn->query("UPDATE buku SET locked_by = $user_id WHERE id_buku = $book_id");

            sleep(2);

            if ($book['quantity'] > 0) {
                $result = $conn->query("CALL tambah_peminjaman($user_id)");
                $row = $result->fetch_assoc();
                $id_peminjaman = $row['id'];
                $conn->next_result();
                
                $stmt_detail = $conn->prepare("
                    INSERT INTO detail_pinjam (id_peminjaman, id_buku) 
                    VALUES (?, ?)
                ");
                $stmt_detail->bind_param("ii", $id_peminjaman, $book_id);
                $stmt_detail->execute();

                $conn->query("UPDATE buku SET locked_by = NULL WHERE id_buku = $book_id");

                $conn->commit();
                header("Location: index.php?msg=success");
                exit();
            }
             else {
                throw new Exception("Stok buku habis");
            }
        }
        $conn->rollback();
        $conn->query("UPDATE buku SET locked_by = NULL WHERE id_buku = $book_id");
        header("Location: index.php?msg=error");
        exit();

    } catch (Exception $e) {

        $conn->rollback();
        $conn->query("UPDATE buku SET locked_by = NULL WHERE id_buku = $book_id");

        die("ERROR: " . $e->getMessage());
    }

} else {
    header("Location: index.php");
}
?>