-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: sispus
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `buku`
--

DROP TABLE IF EXISTS `buku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buku` (
  `id_buku` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `publisher` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `year` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_kategori` int DEFAULT NULL,
  `locked_by` int DEFAULT NULL,
  PRIMARY KEY (`id_buku`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buku`
--

LOCK TABLES `buku` WRITE;
/*!40000 ALTER TABLE `buku` DISABLE KEYS */;
INSERT INTO `buku` VALUES (1,'Seporsi Mie Ayam Sebelum Mati','Ferdian Paleka','Sidu',2024,5,'2026-04-04 16:38:10',NULL,NULL),(3,'Parable','Brian Khrisna','MediaKita',2021,4,'2026-04-05 02:50:43',2,NULL),(4,'Bagaimana jika tuhan bilang tidak','Tinaandrose','temanduduk',2025,5,'2026-04-05 11:22:12',4,NULL),(5,'Ikbal','ikbalaaa','feny',1200,5,'2026-04-07 09:52:58',1,NULL),(6,'Atomic Habits','James Clear','Gramedia',2022,4,'2026-06-03 13:01:07',1,NULL),(7,'Rich Dad Poor Dad','Robert Kiyosaki','Gramedia',2021,4,'2026-06-03 13:01:07',1,NULL),(8,'Filosofi Teras','Henry Manampiring','Kompas',2020,4,'2026-06-03 13:01:07',1,NULL),(9,'Bumi','Tere Liye','Gramedia',2023,4,'2026-06-03 13:01:07',1,NULL),(10,'Laskar Pelangi','Andrea Hirata','Bentang',2022,5,'2026-06-03 13:01:07',1,NULL),(11,'Negeri 5 Menara','Ahmad Fuadi','Gramedia',2021,5,'2026-06-03 13:01:07',1,NULL);
/*!40000 ALTER TABLE `buku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detail_pinjam`
--

DROP TABLE IF EXISTS `detail_pinjam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_pinjam` (
  `id_detail` int NOT NULL AUTO_INCREMENT,
  `id_peminjaman` int DEFAULT NULL,
  `id_buku` int DEFAULT NULL,
  PRIMARY KEY (`id_detail`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_pinjam`
--

LOCK TABLES `detail_pinjam` WRITE;
/*!40000 ALTER TABLE `detail_pinjam` DISABLE KEYS */;
INSERT INTO `detail_pinjam` VALUES (1,1,6),(2,2,7),(3,3,8),(4,4,9),(5,6,6),(6,7,7),(7,8,6),(8,9,7),(9,10,3);
/*!40000 ALTER TABLE `detail_pinjam` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_kurangi_stok` AFTER INSERT ON `detail_pinjam` FOR EACH ROW BEGIN
    UPDATE buku
    SET quantity = quantity - 1
    WHERE id_buku = NEW.id_buku;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori` (
  `id_kategori` int NOT NULL,
  `nama` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori`
--

LOCK TABLES `kategori` WRITE;
/*!40000 ALTER TABLE `kategori` DISABLE KEYS */;
INSERT INTO `kategori` VALUES (1,'Komik'),(2,'Teknologi'),(3,'Cerpen'),(4,'Novel');
/*!40000 ALTER TABLE `kategori` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peminjaman`
--

DROP TABLE IF EXISTS `peminjaman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peminjaman` (
  `id_peminjaman` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_peminjaman`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peminjaman`
--

LOCK TABLES `peminjaman` WRITE;
/*!40000 ALTER TABLE `peminjaman` DISABLE KEYS */;
INSERT INTO `peminjaman` VALUES (1,6,'2026-06-03',NULL,'borrowed','2026-06-03 13:31:35'),(2,6,'2026-06-03','2026-06-03','returned','2026-06-03 13:31:35'),(3,5,'2026-06-03',NULL,'borrowed','2026-06-03 13:31:35'),(4,4,'2026-06-03','2026-06-03','returned','2026-06-03 13:31:35'),(6,8,'2026-06-03','2026-06-03','returned','2026-06-03 13:32:56'),(7,8,'2026-06-03','2026-06-03','returned','2026-06-03 13:33:06'),(8,8,'2026-06-03','2026-06-03','returned','2026-06-03 13:45:13'),(9,8,'2026-06-03','2026-06-03','returned','2026-06-03 13:45:20'),(10,9,'2026-06-04',NULL,'borrowed','2026-06-04 10:11:01');
/*!40000 ALTER TABLE `peminjaman` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_tambah_stok` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF OLD.status = 'borrowed'
       AND NEW.status = 'returned' THEN

        UPDATE buku b
        JOIN detail_pinjam d
            ON b.id_buku = d.id_buku
        SET b.quantity = b.quantity + 1
        WHERE d.id_peminjaman = NEW.id_peminjaman;

    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `peminjaman_aktif`
--

DROP TABLE IF EXISTS `peminjaman_aktif`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peminjaman_aktif` (
  `id_peminjaman` int NOT NULL,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peminjaman_aktif`
--

LOCK TABLES `peminjaman_aktif` WRITE;
/*!40000 ALTER TABLE `peminjaman_aktif` DISABLE KEYS */;
INSERT INTO `peminjaman_aktif` VALUES (15,4,'2026-04-06',NULL,'borrowed','2026-04-06 07:39:15'),(22,4,'2026-04-06',NULL,'borrowed','2026-04-06 15:55:07'),(24,5,'2026-04-07',NULL,'borrowed','2026-04-07 06:06:35'),(33,6,'2026-04-07',NULL,'borrowed','2026-04-07 09:49:59'),(34,5,'2026-04-07',NULL,'borrowed','2026-04-07 09:50:18'),(36,5,'2026-04-07',NULL,'borrowed','2026-04-07 09:55:00'),(37,6,'2026-04-07',NULL,'borrowed','2026-04-07 09:55:53');
/*!40000 ALTER TABLE `peminjaman_aktif` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peminjaman_selesai`
--

DROP TABLE IF EXISTS `peminjaman_selesai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peminjaman_selesai` (
  `id_peminjaman` int NOT NULL,
  `user_id` int NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'borrowed',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peminjaman_selesai`
--

LOCK TABLES `peminjaman_selesai` WRITE;
/*!40000 ALTER TABLE `peminjaman_selesai` DISABLE KEYS */;
INSERT INTO `peminjaman_selesai` VALUES (1,2,'2026-04-04','2026-04-04','returned','2026-04-04 16:40:06'),(2,2,'2026-04-04','2026-04-04','returned','2026-04-04 16:42:19'),(3,3,'2026-04-04','2026-04-04','returned','2026-04-04 16:43:05'),(4,2,'2026-04-04','2026-04-04','returned','2026-04-04 16:43:54'),(5,4,'2026-04-05','2026-04-05','returned','2026-04-05 11:25:25'),(6,4,'2026-04-05','2026-04-05','returned','2026-04-05 11:43:11'),(13,4,'2026-04-05','2026-04-05','returned','2026-04-05 13:44:25'),(14,4,'2026-04-05','2026-04-05','returned','2026-04-05 13:44:28'),(16,4,'2026-04-06','2026-04-07','returned','2026-04-06 08:43:08'),(17,4,'2026-04-06','2026-04-06','returned','2026-04-06 08:45:00'),(18,4,'2026-04-06','2026-04-06','returned','2026-04-06 08:45:02'),(19,4,'2026-04-06','2026-04-06','returned','2026-04-06 08:45:40'),(20,5,'2026-04-06','2026-04-06','returned','2026-04-06 08:50:08'),(21,4,'2026-04-06','2026-04-06','returned','2026-04-06 15:54:22'),(23,4,'2026-04-06','2026-04-07','returned','2026-04-06 15:55:10'),(25,4,'2026-04-07','2026-04-07','returned','2026-04-07 06:06:37'),(26,5,'2026-04-07','2026-04-07','returned','2026-04-07 06:12:52'),(27,5,'2026-04-07','2026-04-07','returned','2026-04-07 06:12:54'),(28,5,'2026-04-07','2026-04-07','returned','2026-04-07 09:18:04'),(29,5,'2026-04-07','2026-04-07','returned','2026-04-07 09:18:14'),(30,5,'2026-04-07','2026-04-07','returned','2026-04-07 09:28:13'),(31,5,'2026-04-07','2026-04-07','returned','2026-04-07 09:34:17'),(32,5,'2026-04-07','2026-04-07','returned','2026-04-07 09:41:16'),(35,6,'2026-04-07','2026-04-07','returned','2026-04-07 09:50:29');
/*!40000 ALTER TABLE `peminjaman_selesai` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('admin','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','admin','Administrator','2026-04-04 16:16:21'),(2,'user','$2y$10$DcQg/LbtkycfLcCQbD0QY.p/uCZSdVN8.7iBjfyUEX6Mk6Lshd0vi','user','user','2026-04-04 16:39:49'),(3,'tora','$2y$10$2ZfAIUD.EeV7KfUwrl4bBuwC4LWN8vWIrTKnmDCwrCU5Cr9VY6k8C','user','tora','2026-04-04 16:42:49'),(4,'jeki','$2y$10$1xulAAl4Hq/MPGzvahnof.xfaFdfEmaHhqB/X9SzQpGS4Zy9bbCvG','user','jek','2026-04-05 02:55:22'),(5,'zule','$2y$10$JdVZO5CJdNymdZhbTL4ol.j3D0WAvCx0vCwuXWR6ibvs0hoPkf9aK','user','zul','2026-04-05 11:50:46'),(6,'balfer','$2y$10$QihR9CsphKFoyFlyujanQ.ZEcQyarQaJN7rODSdniB71fSRi.jLe2','user','ikbal','2026-04-07 09:44:52'),(8,'ima','$2y$10$b7mxZgWFg0cAVLfEZfWTpOosNYyiqLNIhaNkmVUyN1nNT3HO1OKs2','user','ima','2026-05-29 12:53:29'),(9,'feny','$2y$10$Ki6luJyfYV9lomfNO/xFTueG2x0dLnMh9/wVzwxYfF1A9hC1CaPWK','user','fen','2026-06-04 10:10:38');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_peminjaman`
--

DROP TABLE IF EXISTS `view_peminjaman`;
/*!50001 DROP VIEW IF EXISTS `view_peminjaman`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_peminjaman` AS SELECT 
 1 AS `id_peminjaman`,
 1 AS `nama_peminjam`,
 1 AS `judul_buku`,
 1 AS `borrow_date`,
 1 AS `return_date`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_peminjaman_aktif`
--

DROP TABLE IF EXISTS `view_peminjaman_aktif`;
/*!50001 DROP VIEW IF EXISTS `view_peminjaman_aktif`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_peminjaman_aktif` AS SELECT 
 1 AS `id_peminjaman`,
 1 AS `user_id`,
 1 AS `borrow_date`,
 1 AS `return_date`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_peminjaman_selesai`
--

DROP TABLE IF EXISTS `view_peminjaman_selesai`;
/*!50001 DROP VIEW IF EXISTS `view_peminjaman_selesai`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_peminjaman_selesai` AS SELECT 
 1 AS `id_peminjaman`,
 1 AS `user_id`,
 1 AS `borrow_date`,
 1 AS `return_date`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_union`
--

DROP TABLE IF EXISTS `view_union`;
/*!50001 DROP VIEW IF EXISTS `view_union`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_union` AS SELECT 
 1 AS `data_info`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `view_peminjaman`
--

/*!50001 DROP VIEW IF EXISTS `view_peminjaman`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_peminjaman` AS select `p`.`id_peminjaman` AS `id_peminjaman`,`u`.`name` AS `nama_peminjam`,`b`.`title` AS `judul_buku`,`p`.`borrow_date` AS `borrow_date`,`p`.`return_date` AS `return_date`,`p`.`status` AS `status` from (((`peminjaman` `p` join `users` `u` on((`p`.`user_id` = `u`.`id_user`))) join `detail_pinjam` `d` on((`p`.`id_peminjaman` = `d`.`id_peminjaman`))) join `buku` `b` on((`d`.`id_buku` = `b`.`id_buku`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_peminjaman_aktif`
--

/*!50001 DROP VIEW IF EXISTS `view_peminjaman_aktif`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_peminjaman_aktif` AS select `peminjaman`.`id_peminjaman` AS `id_peminjaman`,`peminjaman`.`user_id` AS `user_id`,`peminjaman`.`borrow_date` AS `borrow_date`,`peminjaman`.`return_date` AS `return_date`,`peminjaman`.`status` AS `status`,`peminjaman`.`created_at` AS `created_at` from `peminjaman` where (`peminjaman`.`status` = 'borrowed') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_peminjaman_selesai`
--

/*!50001 DROP VIEW IF EXISTS `view_peminjaman_selesai`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_peminjaman_selesai` AS select `peminjaman`.`id_peminjaman` AS `id_peminjaman`,`peminjaman`.`user_id` AS `user_id`,`peminjaman`.`borrow_date` AS `borrow_date`,`peminjaman`.`return_date` AS `return_date`,`peminjaman`.`status` AS `status`,`peminjaman`.`created_at` AS `created_at` from `peminjaman` where (`peminjaman`.`status` = 'returned') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_union`
--

/*!50001 DROP VIEW IF EXISTS `view_union`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_union` AS select `users`.`username` AS `data_info` from `users` union select `buku`.`title` AS `data_info` from `buku` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-05 22:35:22
