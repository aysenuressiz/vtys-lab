/*veri tabanı*/
create database foy3;
go
use foy3;

/*TABLO OLUŞTURMA*/

/*çalışanlar tablosu*/
create table calisanlar(
calisan_id int primary key,
ad char(25)NULL,
soyad char(25) NULL,
maas int NULL,
katılmaTarihi datetime NULL,
calisan_birim_id int NOT NULL);

/*birimler tablosu*/
create table birimler(
birim_id int primary key,
birim_ad char(25) NOT NULL);

/*ikramiye tablosu*/
create table ikramiye(
ikramiye_calisan_id int NOT NULL,
ikramiye_ucret int NULL,
ikramiye_tarih datetime NULL);

/*unvan tablosu*/
create table unvan(
unvan_calisan_id int NOT NULL,
unvan_calisan char(25) NULL,
unvan_tarih datetime NULL);


/*VERİ EKLEME VE GÖRÜNTÜLEME*/

/*birimler tablosu*/
insert into birimler (birim_id, birim_ad) values
(1, 'Yazılım'),
(2, 'Donanım'),
(3, 'Güvenlik');

select * from birimler;

/*çalışanlar tablosu*/
insert into  calisanlar values
(1, 'İsmail', 'İşeri', 100000, '2014-02-20', 1),
(2, 'Hami', 'Satılmış', 80000, '2014-06-11', 1),
(3, 'Durmuş', 'Şahin', 300000, '2014-02-20', 2),
(4, 'Kağan', 'Yazar', 500000, '2014-02-20', 3),
(5, 'Meryem', 'Soysaldı', 500000, '2014-06-11', 3),
(6, 'Duygu', 'Akşehir', 200000, '2014-06-11', 2),
(7, 'Kübra', 'Seyhan', 75000, '2014-01-20', 1),
(8, 'Gülcan', 'Yıldız', 90000, '2014-04-11', 3);

select * from calisanlar;

/*ikramiye tablosu*/
insert into ikramiye values
(1, 5000, '2016-02-20'),
(2, 3000, '2016-06-11'),
(3, 4000, '2016-02-20'),
(1, 4500, '2016-02-20'),
(2, 3500, '2016-06-11');

select * from ikramiye;

/*unvan tablosu*/
insert into unvan values
(1, 'Yönetici', '2016-02-20'),
(2, 'Personel', '2016-06-11'),
(8, 'Personel', '2016-06-11'),
(5, 'Müdür', '2016-06-11'),
(4, 'Yönetici Yardımcısı', '2016-06-11'),
(7, 'Personel', '2016-06-11'),
(6, 'Takım Lideri', '2016-06-11'),
(3, 'Takım Lideri', '2016-06-11');

select * from unvan


/*SORGULAR*/

/*“Yazılım” veya “Donanım” birimlerinde çalışanların ad, soyad ve maaş bilgilerini listeleyen SQL sorgusu*/
SELECT c.ad, c.soyad, c.maas 
FROM calisanlar c
JOIN birimler b ON c.calisan_birim_id = b.birim_id
WHERE b.birim_ad IN ('Yazılım', 'Donanım');

/*Maaşı en yüksek olan çalışanların ad, soyad ve maaş bilgilerini listeleyen SQL sorgusu*/
SELECT ad, soyad, maas 
FROM calisanlar 
WHERE maas = (SELECT MAX(maas) FROM calisanlar);

/*Birimlerin her birinde kaç adet çalışan olduğunu ve birimlerin isimlerini listeleyen sorgu*/
SELECT b.birim_ad, COUNT(c.calisan_id) AS calisan_sayisi
FROM birimler b
LEFT JOIN calisanlar c ON b.birim_id = c.calisan_birim_id
GROUP BY b.birim_ad;

/*Birden fazla çalışana ait olan unvanların isimlerini ve o unvan altında çalışanların sayısını listeleyen sorgu*/
SELECT u.unvan_calisan, COUNT(u.unvan_calisan_id) AS calisan_sayisi
FROM unvan u
GROUP BY u.unvan_calisan
HAVING COUNT(u.unvan_calisan_id) > 1;

/*Maaşları “50000” ve “100000” arasında değişen çalışanların ad, soyad ve maaş bilgilerini listeleyen sorgu*/
SELECT ad, soyad, maas 
FROM calisanlar 
WHERE maas BETWEEN 50000 AND 100000;

/*İkramiye hakkına sahip çalışanlara ait ad, soyad, birim, unvan ve ikramiye ücreti bilgilerini listeleyen sorgu*/
SELECT c.ad, c.soyad, u.unvan_calisan, i.ikramiye_ucret 
FROM calisanlar c
JOIN ikramiye i ON c.calisan_id = i.ikramiye_calisan_id
JOIN unvan u ON c.calisan_id = u.unvan_calisan_id;

/*Ünvanı “Yönetici” ve “Müdür” olan çalışanların ad, soyad ve ünvanlarını listeleyen sorgu*/
SELECT c.ad, c.soyad, u.unvan_calisan 
FROM calisanlar c
JOIN unvan u ON c.calisan_id = u.unvan_calisan_id
WHERE u.unvan_calisan IN ('Yönetici', 'Müdür');

/*Her bir birimde en yüksek maaş alan çalışanların ad, soyad ve maaş bilgilerini listeleyen sorgu*/
SELECT c.ad, c.soyad, c.maas, b.birim_ad
FROM calisanlar c
JOIN birimler b ON c.calisan_birim_id = b.birim_id
WHERE c.maas = (
    SELECT MAX(c2.maas)
    FROM calisanlar c2
    WHERE c2.calisan_birim_id = c.calisan_birim_id
);
