-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 03, 2026 at 01:47 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sispus`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapus_buku` (IN `bid` INT)   BEGIN
    DELETE FROM detail_pinjam 
    WHERE id_buku = bid;

    DELETE FROM buku 
    WHERE id_buku = bid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `kembalikan_buku` (IN `pid` INT)   BEGIN
    UPDATE peminjaman 
    SET status = 'returned', return_date = CURDATE()
    WHERE id_peminjaman = pid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lihat_members` ()   BEGIN
    SELECT 
        u.id_user,
        u.name,
        u.username,
        u.created_at,
        total_buku_dipinjam(u.id_user) as total
    FROM users u
    WHERE u.role = 'user'
    ORDER BY u.created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_peminjaman` (IN `uid` INT)   BEGIN
    INSERT INTO peminjaman(user_id, borrow_date, status)
    VALUES(uid, CURDATE(), 'borrowed');

    SELECT LAST_INSERT_ID() as id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `total_buku_dipinjam` (`uid` INT) RETURNS INT DETERMINISTIC RETURN (
    SELECT COUNT(*)
    FROM peminjaman p
    JOIN detail_pinjam d ON p.id_peminjaman = d.id_peminjaman
    WHERE p.user_id = uid
)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `publisher` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `year` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_kategori` int DEFAULT NULL,
  `locked_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `title`, `author`, `publisher`, `year`, `quantity`, `created_at`, `id_kategori`, `locked_by`) VALUES
(1, 'Seporsi Mie Ayam Sebelum Mati', 'Ferdian Paleka', 'Sidu', 2024, 5, '2026-04-04 16:38:10', NULL, NULL),
(3, 'Parable', 'Brian Khrisna', 'MediaKita', 2021, 5, '2026-04-05 02:50:43', 2, NULL),
(4, 'Bagaimana jika tuhan bilang tidak', 'Tinaandrose', 'temanduduk', 2025, 5, '2026-04-05 11:22:12', 4, NULL),
(5, 'Ikbal', 'ikbalaaa', 'feny', 1200, 5, '2026-04-07 09:52:58', 1, NULL),
(6, 'Atomic Habits', 'James Clear', 'Gramedia', 2022, 4, '2026-06-03 13:01:07', 1, NULL),
(7, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 'Gramedia', 2021, 4, '2026-06-03 13:01:07', 1, NULL),
(8, 'Filosofi Teras', 'Henry Manampiring', 'Kompas', 2020, 4, '2026-06-03 13:01:07', 1, NULL),
(9, 'Bumi', 'Tere Liye', 'Gramedia', 2023, 4, '2026-06-03 13:01:07', 1, NULL),
(10, 'Laskar Pelangi', 'Andrea Hirata', 'Bentang', 2022, 5, '2026-06-03 13:01:07', 1, NULL),
(11, 'Negeri 5 Menara', 'Ahmad Fuadi', 'Gramedia', 2021, 5, '2026-06-03 13:01:07', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `detail_pinjam`
--

CREATE TABLE `detail_pinjam` (
  `id_detail` int NOT NULL,
  `id_peminjaman` int DEFAULT NULL,
  `id_buku` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `detail_pinjam`
--

INSERT INTO `detail_pinjam` (`id_detail`, `id_peminjaman`, `id_buku`) VALUES
(1, 1, 6),
(2, 2, 7),
(3, 3, 8),
(4, 4, 9),
(5, 6, 6),
(6, 7, 7),
(7, 8, 6),
(8, 9, 7);

--
-- Triggers `detail_pinjam`
--
DELIMITER $$
CREATE TRIGGER `trg_kurangi_stok` AFTER INSERT ON `detail_pinjam` FOR EACH ROW BEGIN
    UPDATE buku
    SET quantity = quantity - 1
    WHERE id_buku = NEW.id_buku;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int NOT NULL,
  `nama` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama`) VALUES
(1, 'Komik'),
(2, 'Teknologi'),
(3, 'Cerpen'),
(4, 'Novel');

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int NOT NULL,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `user_id`, `borrow_date`, `return_date`, `status`, `created_at`) VALUES
(1, 6, '2026-06-03', NULL, 'borrowed', '2026-06-03 13:31:35'),
(2, 6, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:31:35'),
(3, 5, '2026-06-03', NULL, 'borrowed', '2026-06-03 13:31:35'),
(4, 4, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:31:35'),
(6, 8, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:32:56'),
(7, 8, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:33:06'),
(8, 8, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:45:13'),
(9, 8, '2026-06-03', '2026-06-03', 'returned', '2026-06-03 13:45:20');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `trg_tambah_stok` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF OLD.status = 'borrowed'
       AND NEW.status = 'returned' THEN

        UPDATE buku b
        JOIN detail_pinjam d
            ON b.id_buku = d.id_buku
        SET b.quantity = b.quantity + 1
        WHERE d.id_peminjaman = NEW.id_peminjaman;

    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman_aktif`
--

CREATE TABLE `peminjaman_aktif` (
  `id_peminjaman` int NOT NULL,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peminjaman_aktif`
--

INSERT INTO `peminjaman_aktif` (`id_peminjaman`, `user_id`, `borrow_date`, `return_date`, `status`, `created_at`) VALUES
(15, 4, '2026-04-06', NULL, 'borrowed', '2026-04-06 07:39:15'),
(22, 4, '2026-04-06', NULL, 'borrowed', '2026-04-06 15:55:07'),
(24, 5, '2026-04-07', NULL, 'borrowed', '2026-04-07 06:06:35'),
(33, 6, '2026-04-07', NULL, 'borrowed', '2026-04-07 09:49:59'),
(34, 5, '2026-04-07', NULL, 'borrowed', '2026-04-07 09:50:18'),
(36, 5, '2026-04-07', NULL, 'borrowed', '2026-04-07 09:55:00'),
(37, 6, '2026-04-07', NULL, 'borrowed', '2026-04-07 09:55:53');

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman_selesai`
--

CREATE TABLE `peminjaman_selesai` (
  `id_peminjaman` int NOT NULL,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peminjaman_selesai`
--

INSERT INTO `peminjaman_selesai` (`id_peminjaman`, `user_id`, `borrow_date`, `return_date`, `status`, `created_at`) VALUES
(1, 2, '2026-04-04', '2026-04-04', 'returned', '2026-04-04 16:40:06'),
(2, 2, '2026-04-04', '2026-04-04', 'returned', '2026-04-04 16:42:19'),
(3, 3, '2026-04-04', '2026-04-04', 'returned', '2026-04-04 16:43:05'),
(4, 2, '2026-04-04', '2026-04-04', 'returned', '2026-04-04 16:43:54'),
(5, 4, '2026-04-05', '2026-04-05', 'returned', '2026-04-05 11:25:25'),
(6, 4, '2026-04-05', '2026-04-05', 'returned', '2026-04-05 11:43:11'),
(13, 4, '2026-04-05', '2026-04-05', 'returned', '2026-04-05 13:44:25'),
(14, 4, '2026-04-05', '2026-04-05', 'returned', '2026-04-05 13:44:28'),
(16, 4, '2026-04-06', '2026-04-07', 'returned', '2026-04-06 08:43:08'),
(17, 4, '2026-04-06', '2026-04-06', 'returned', '2026-04-06 08:45:00'),
(18, 4, '2026-04-06', '2026-04-06', 'returned', '2026-04-06 08:45:02'),
(19, 4, '2026-04-06', '2026-04-06', 'returned', '2026-04-06 08:45:40'),
(20, 5, '2026-04-06', '2026-04-06', 'returned', '2026-04-06 08:50:08'),
(21, 4, '2026-04-06', '2026-04-06', 'returned', '2026-04-06 15:54:22'),
(23, 4, '2026-04-06', '2026-04-07', 'returned', '2026-04-06 15:55:10'),
(25, 4, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 06:06:37'),
(26, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 06:12:52'),
(27, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 06:12:54'),
(28, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:18:04'),
(29, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:18:14'),
(30, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:28:13'),
(31, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:34:17'),
(32, 5, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:41:16'),
(35, 6, '2026-04-07', '2026-04-07', 'returned', '2026-04-07 09:50:29');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('admin','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `name`, `created_at`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Administrator', '2026-04-04 16:16:21'),
(2, 'user', '$2y$10$DcQg/LbtkycfLcCQbD0QY.p/uCZSdVN8.7iBjfyUEX6Mk6Lshd0vi', 'user', 'user', '2026-04-04 16:39:49'),
(3, 'tora', '$2y$10$2ZfAIUD.EeV7KfUwrl4bBuwC4LWN8vWIrTKnmDCwrCU5Cr9VY6k8C', 'user', 'tora', '2026-04-04 16:42:49'),
(4, 'jeki', '$2y$10$1xulAAl4Hq/MPGzvahnof.xfaFdfEmaHhqB/X9SzQpGS4Zy9bbCvG', 'user', 'jek', '2026-04-05 02:55:22'),
(5, 'zule', '$2y$10$JdVZO5CJdNymdZhbTL4ol.j3D0WAvCx0vCwuXWR6ibvs0hoPkf9aK', 'user', 'zul', '2026-04-05 11:50:46'),
(6, 'balfer', '$2y$10$QihR9CsphKFoyFlyujanQ.ZEcQyarQaJN7rODSdniB71fSRi.jLe2', 'user', 'ikbal', '2026-04-07 09:44:52'),
(8, 'ima', '$2y$10$b7mxZgWFg0cAVLfEZfWTpOosNYyiqLNIhaNkmVUyN1nNT3HO1OKs2', 'user', 'ima', '2026-05-29 12:53:29');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_peminjaman`
-- (See below for the actual view)
--
CREATE TABLE `view_peminjaman` (
`id_peminjaman` int
,`nama_peminjam` varchar(100)
,`judul_buku` varchar(255)
,`borrow_date` date
,`return_date` date
,`status` enum('borrowed','returned')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_peminjaman_aktif`
-- (See below for the actual view)
--
CREATE TABLE `view_peminjaman_aktif` (
`id_peminjaman` int
,`user_id` int
,`borrow_date` date
,`return_date` date
,`status` enum('borrowed','returned')
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_peminjaman_selesai`
-- (See below for the actual view)
--
CREATE TABLE `view_peminjaman_selesai` (
`id_peminjaman` int
,`user_id` int
,`borrow_date` date
,`return_date` date
,`status` enum('borrowed','returned')
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_union`
-- (See below for the actual view)
--
CREATE TABLE `view_union` (
`data_info` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `view_peminjaman`
--
DROP TABLE IF EXISTS `view_peminjaman`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_peminjaman`  AS SELECT `p`.`id_peminjaman` AS `id_peminjaman`, `u`.`name` AS `nama_peminjam`, `b`.`title` AS `judul_buku`, `p`.`borrow_date` AS `borrow_date`, `p`.`return_date` AS `return_date`, `p`.`status` AS `status` FROM (((`peminjaman` `p` join `users` `u` on((`p`.`user_id` = `u`.`id_user`))) join `detail_pinjam` `d` on((`p`.`id_peminjaman` = `d`.`id_peminjaman`))) join `buku` `b` on((`d`.`id_buku` = `b`.`id_buku`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `view_peminjaman_aktif`
--
DROP TABLE IF EXISTS `view_peminjaman_aktif`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_peminjaman_aktif`  AS SELECT `peminjaman`.`id_peminjaman` AS `id_peminjaman`, `peminjaman`.`user_id` AS `user_id`, `peminjaman`.`borrow_date` AS `borrow_date`, `peminjaman`.`return_date` AS `return_date`, `peminjaman`.`status` AS `status`, `peminjaman`.`created_at` AS `created_at` FROM `peminjaman` WHERE (`peminjaman`.`status` = 'borrowed')  ;

-- --------------------------------------------------------

--
-- Structure for view `view_peminjaman_selesai`
--
DROP TABLE IF EXISTS `view_peminjaman_selesai`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_peminjaman_selesai`  AS SELECT `peminjaman`.`id_peminjaman` AS `id_peminjaman`, `peminjaman`.`user_id` AS `user_id`, `peminjaman`.`borrow_date` AS `borrow_date`, `peminjaman`.`return_date` AS `return_date`, `peminjaman`.`status` AS `status`, `peminjaman`.`created_at` AS `created_at` FROM `peminjaman` WHERE (`peminjaman`.`status` = 'returned')  ;

-- --------------------------------------------------------

--
-- Structure for view `view_union`
--
DROP TABLE IF EXISTS `view_union`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_union`  AS SELECT `users`.`username` AS `data_info` FROM `users` union select `buku`.`title` AS `data_info` from `buku`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `detail_pinjam`
--
ALTER TABLE `detail_pinjam`
  ADD PRIMARY KEY (`id_detail`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `detail_pinjam`
--
ALTER TABLE `detail_pinjam`
  MODIFY `id_detail` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
