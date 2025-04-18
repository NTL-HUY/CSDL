if DB_ID('QLThueSach') is not null drop database QLThueSach;
go

create database QLThueSach;
go

use QLThueSach;
go

create table LOAISACH(
	MaLoai char(10) primary key,
	TenLoai nvarchar(100),
	MieuTa nvarchar(max)
);
go

create table SACH(
	MaSach char(10) primary key,
	TenSach nvarchar(100),
	TacGia nvarchar(100),
	NXB nvarchar(100),
	GiaMuaVao money,
	GhiChu nvarchar(max),
	MaLoaiSach char(10),
	constraint fk_sach_loaisach foreign key(MaLoaiSach) references LOAISACH(MaLoai)
);
go

create table KHACHHANG(
	MaKH char(10) primary key,
	TenKH nvarchar(500),
	DiaChi nvarchar(500),
	SDT char(20),
	LoaiYeuThich nvarchar(500),
	GhiChu nvarchar(max),
);
go

create table THUESACH(
	MaKH char(10),
	MaSach char(10),
	NgayMuon datetime,
	NgayTra datetime,
	TienThue money,
	GhiChu nvarchar(max),
	primary key(MaKH, MaSach),
	constraint fk_thuesach_sach foreign key(MaSach) references SACH(MaSach)
		on update cascade,
	constraint fk_thuesach_khachhang foreign key(MaKH) references KHACHHANG(MaKH)
		on update cascade
);
go
