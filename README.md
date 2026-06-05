# 📚 PustakaOne (Proyek UAP)
PustakaOne merupakan sistem informasi perpustakaan berbasis web yang dibangun menggunakan PHP dan MySQL. Sistem ini digunakan untuk mengelola data buku, anggota, peminjaman, pengembalian, dan laporan perpustakaan. Pada proyek ini juga diimplementasikan beberapa materi basis data seperti stored procedure, trigger, fragmentasi database, backup database, dan task scheduler.
<img src="img/dashboard.png">
## 🗃️ Backup Database
Untuk menjaga keamanan dan ketersediaan data, sistem dilengkapi fitur backup database menggunakan `mysqldump`.

Backup disimpan pada direktori:
`storage/backups/` sehingga data tetap aman meskipun admin tidak sedang login ke sistem, selain itu akan ditampilkan pada `backup_list.php`
Nama file backup menggunakan _timestamp_ sehingga mudah dilacak. Selain itu keseluruhan backup hanya dapat dilakukan oleh **admin**.

## Backup Manual
Backup dilakukan melalui file `backup.php` dengan menu:
<img width="985" height="223" alt="image" src="https://github.com/user-attachments/assets/4926149d-d23a-455f-bd1d-f50ef5889562" />

## Backup Otomatis 
Menyediakan dua backup otomatis:
#### 1. Backup otomatis menggunakan Windows Task Scheduler 
Dengan mengeksekusi script: `auto_backup.php` yang dapat dijalankan menggunakan Windows Task Scheduler setiap 1 hari sekali tanpa perlu membuka aplikasi.
#### 2. Backup Otomatis Saat Admin Login
Ketika admin berhasil login, sistem akan memeriksa waktu backup terakhir. Jika sudah lebih dari 24 jam sejak backup terakhir dibuat, maka sistem akan secara otomatis membuat backup database baru.
