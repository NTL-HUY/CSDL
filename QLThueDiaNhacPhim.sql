if DB_ID('QLThueDiaNhacPhim') is not null drop database QLThueDiaNhacPhim;
go

create database QLThueDiaNhacPhim;
go

use QLThueDiaNhacPhim;
go

create table DIA(
	MaDia char(10) primary key,
	TenDia nvarchar(100),
	TheLoai nvarchar(200),
	NuocSX nvarchar(100),
	GiaMua money,
	GhiChu nvarchar(max),
);
go

create table KHACHHANG(
	MaKH char(10) primary key,
	TenKH nvarchar(200),
	DiaChi nvarchar(500),
	SDT char(20),
	LoaiYeuThich nvarchar(500),
	GhiChu nvarchar(max)
);
go

create table THUEDIA(
	MaKH char(10),
	MaDia char(10),
	NgayThue datetime,
	NgayTra datetime,
	primary key (MaKH,MaDia),
	constraint fk_thuedia_khachhang foreign key (makh) references khachhang(makh)
		on update cascade,
	constraint fk_thuedia_dia foreign key (MaDia) references dia(madia)
		on update cascade
);
go