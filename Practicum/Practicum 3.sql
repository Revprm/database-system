-- 1
SELECT mb.`Nama`, mb.`Alamat`, pd.`Nama`
FROM member mb
INNER JOIN customer cs ON mb.`IDMember` = cs.`Member_IDMember`
INNER JOIN transaksi ts ON cs.`IDCust` = ts.`Customer_IDCust`
INNER JOIN detailtransaksi dt ON ts.`IDTransaksi` = dt.`Transaksi_IDTransaksi`
INNER JOIN produk pd ON dt.`Produk_IDProduk` = pd.`IDProduk`
WHERE mb.`Alamat` LIKE '%Tanah Abang%'

-- 2
SELECT ts.`Tanggal`, mb.`Nama`, pd.`Nama`
FROM member mb
INNER JOIN customer cs ON mb.`IDMember` = cs.`Member_IDMember`
INNER JOIN transaksi ts ON cs.`IDCust` = ts.`Customer_IDCust`
INNER JOIN detailtransaksi dt ON ts.`IDTransaksi` = dt.`Transaksi_IDTransaksi`
INNER JOIN produk pd ON dt.`Produk_IDProduk` = pd.`IDProduk`
WHERE DAY(ts.`Tanggal`) = 15 AND MONTH(ts.`Tanggal`) = 06 AND YEAR(ts.`Tanggal`) = 2023

-- 3
SELECT pd.`Nama`, SUM(dt.`Jumlah`) AS Jumlah
FROM detailtransaksi dt
INNER JOIN produk pd ON dt.`Produk_IDProduk` = pd.`IDProduk`
GROUP BY pd.`Nama`
ORDER BY Jumlah DESC LIMIT 3

-- 4
SELECT st.`Nama`, SUM(ts.`TotalHarga`) AS Total_transaksi
FROM staff st
INNER JOIN transaksi ts ON st.`IDStaff` = ts.`Staff_IDStaff`
GROUP BY st.`Nama`
HAVING Total_transaksi > 500000
ORDER BY Total_transaksi DESC

-- 5
SELECT *
FROM staff st
WHERE st.`IDStaff` NOT IN(
    SELECT ts.`Staff_IDStaff`
    FROM transaksi ts
)

-- 6
SELECT COUNT(mb.nama) AS `Jumlah`
FROM member mb
INNER JOIN customer cs ON mb.`IDMember` = cs.`Member_IDMember`
INNER JOIN transaksi ts ON cs.`IDCust` = ts.`Customer_IDCust`
INNER JOIN detailtransaksi dt ON ts.`IDTransaksi` = dt.`Transaksi_IDTransaksi`
INNER JOIN produk pd ON dt.`Produk_IDProduk` = pd.`IDProduk`
WHERE pd.`Nama` LIKE 'Scarlett Whitening Facial Wash'

-- 7
SELECT Ranking
FROM(
    SELECT bd.`Nama`, RANK() OVER (ORDER BY SUM(dt.`Jumlah`) DESC) AS Ranking
    FROM detailtransaksi dt
    INNER JOIN produk pd ON dt.`Produk_IDProduk` = pd.`IDProduk`
    INNER JOIN brand bd ON pd.`Brand_IDBrand` = bd.`IDBrand`
    GROUP BY bd.`Nama`
    ORDER BY Ranking ASC
) AS Ranking_brand
WHERE Nama = 'EMINA'

-- 8
SELECT (umur_member - umur_staff) AS Selisih_umur
FROM(
    SELECT TIMESTAMPDIFF(YEAR, mb.`TanggalLahir`, CURDATE()) AS Umur_member
    FROM member mb
    WHERE mb.`Alamat` LIKE '%Grogol%'
    ORDER BY Umur_member ASC LIMIT 1
) AS Umur_member,
(
    SELECT TIMESTAMPDIFF(YEAR, st.`TanggalLahir`, CURDATE()) AS Umur_Staff
    FROM staff st
    WHERE st.`Alamat` LIKE '%DKI Jakarta%'
    ORDER BY Umur_Staff DESC LIMIT 1
) AS Umur_Staff


-- 9
SELECT ts.`IDTransaksi`, SUM(ts.`TotalHarga`) AS Total_transaksi
FROM transaksi ts
GROUP BY ts.`IDTransaksi`
HAVING Total_transaksi > (
    SELECT AVG(tl_transaksi)
    FROM(
        SELECT tr.`IDTransaksi` ,SUM(tr.`TotalHarga`) AS tl_transaksi
        FROM transaksi tr
        GROUP BY tr.`IDTransaksi`
    ) AS Jumlah_transaksi
)

-- 10
SELECT ts.`Tanggal`, SUM(ts.`TotalHarga`) AS Total_transaksi
FROM transaksi ts
GROUP BY ts.`Tanggal`
ORDER BY Total_transaksi DESC LIMIT 5