IF DB_ID('QLSV') IS NOT NULL DROP DATABASE QLSV;
go

create database QLSV;
go

use QLSV;
go

create table KHOA(
	MaKhoa nvarchar(100) primary key,
	TenKhoa nvarchar(500),
	GhiChuKhoa nvarchar(MAX)
);
go

create table LOP(
	MaLop nvarchar(100) primary key,
	TenLop nvarchar(500),
	KhoaHoc nvarchar(100),
	GhiChuLop nvarchar(MAX),
	MaKhoa nvarchar(100),
	constraint fk_lop_khoa foreign key(MaKhoa) references KHOA(MaKhoa)
		on update cascade
		on delete set null
);
go


create table SINHVIEN(
	MaSV nvarchar(100) primary key,
	HoLotSV nvarchar(200),
	TenSV nvarchar(100),
	NgaySinhSV datetime,
	GioiTinhSV nvarchar(10),
	DiaChiSV nvarchar(500),
	QueQuanSV nvarchar(200),
	EmailSV nvarchar(200),
	GhiChuSV nvarchar(max),
	MaLop nvarchar(100),
	constraint fk_sinhvien_lop foreign key(MaLop) references LOP(MaLop)
		on update cascade
		on delete set null
);
go

create table HOSOSINHVIEN(
	MaSV nvarchar(100) primary key,
	TenGoiKhacSV nvarchar(500),
	NoiSinhSV nvarchar(200),
	QuocTichSV nvarchar(200),
	ChieuCaoSV float,
	CanNangSV float,
	HoTenChaSV nvarchar(500),
	HoTenMeSV nvarchar(500),
	GhiChuHoSoSV nvarchar(MAX)
);
go

create table GIANGVIEN(
	MaGV nvarchar(100) primary key,
	HoLotGV nvarchar(200),
	TenGiangVien nvarchar(100),
	GhiChuGiangVien nvarchar(max),
	MaKhoaGiangVienCongTac nvarchar(100),
	constraint fk_giangvien_khoa foreign key(MaKhoaGiangVienCongTac) references KHOA(MaKhoa)
	on update cascade
	on delete set null
);
go

create table MONHOC(
	MaMonHoc nvarchar(100) primary key,
	TenMonHoc nvarchar(500),
	SoTinChi float,
	GhiChuMonHoc nvarchar(max),
	MaKhoaPhuTrachMonHoc nvarchar(100),
	constraint fk_monhoc_khoa foreign key(MaKhoaPhuTrachMonHoc) references KHOA(MaKhoa)
		on update cascade
		on delete set null
);
go

create table HOC(
	MaHoc nvarchar(100) primary key,
	MaSV nvarchar(100),
	MaMonHoc nvarchar(100),
	MaGiangVienGiangDay nvarchar(100),
	NhomDangKy nvarchar(100),
	HocKyDangKyMonHoc nvarchar(500),
	DiemGiuaKy nvarchar(10),
	DiemCuoiKy nvarchar(10),
	DiemTongKet nvarchar(10),
	constraint uq_hoc unique(MaSV, MaMonHoc,MaGiangVienGiangDay,NhomDangKy,HocKyDangKyMonHoc),
	--primary key(MaSV, MaMonHoc,MaGiangVienGiangDay,NhomDangKy,HocKyDangKyMonHoc),
	constraint fk_hoc_sinhvien foreign key(MaSV) references SINHVIEN(MaSV),
	constraint fk_hoc_monhoc foreign key(MaMonHoc) references MONHOC(MaMonHoc),
	constraint fk_hoc_giangvien foreign key(MaGiangVienGiangDay) references GIANGVIEN(MaGV)
	
);
go

---alter table HOSOSINHVIEN
---add constraint fk_hososinhvien_sinhvien foreign key(MaSV) references SINHVIEN(MaSV)
---
---drop table HOC
---
---alter table hoc
---drop constraint if exists fk_hoc_monhoc
---
---alter table HOC
---add constraint fk_hoc_monhoc foreign key(MaMonHoc) references MONHOC(MaMonHoc)
---		on update cascade
---		on delete no action
---
---alter table hoc
---drop constraint if exists fk_hoc_sinhvien
---
---alter table HOC
---add  constraint fk_hoc_sinhvien foreign key(MaSV) references SINHVIEN(MaSV)
---		on update cascade
---		on delete no action
---
---alter table hoc
---drop constraint if exists fk_hoc_giangvien
---
---alter table HOC
---add constraint fk_hoc_giangvien foreign key(MaGiangVienGiangDay) references GIANGVIEN(MaGV)
---		on update cascade
---		on delete no action
---
---alter table HOSOSINHVIEN
---add constraint fk_hososinhvien_sinhvien foreign key(MaSV) references SINHVIEN(MaSV)
---
---drop table HOC