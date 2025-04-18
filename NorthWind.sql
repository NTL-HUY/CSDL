use Northwind

	select tmp.*,prod.ProductName,(tmp.ThanhTien - tmp.TienGiamGia) as TienPhaiTra
	from Products prod
		inner join (
			select detail.*,
			(UnitPrice*Quantity) as ThanhTien, 
			(UnitPrice*Quantity)*Discount as TienGiamGia
			from [Order Details] detail
				inner join Orders ord
					on ord.OrderID = detail.OrderID
			where YEAR(ord.OrderDate) = 1997
		) tmp
			on tmp.ProductID = prod.ProductID
	order by tmp.OrderID

	select tmp.OrderID,prod.ProductName,
		odetail.UnitPrice,odetail.Quantity,
		odetail.Discount,tmp.ThanhTien,
		tmp.TienGiamGia,
		tmp.ThanhTien - tmp.TienGiamGia as TienPhaiTra
	from Products prod
		inner join(
			select detail.ProductID,detail.OrderID,
			(UnitPrice*Quantity) as ThanhTien, 
			(UnitPrice*Quantity)*Discount as TienGiamGia
			from [Order Details] detail
				inner join Orders ord
					on ord.OrderID = detail.OrderID
			where YEAR(ord.OrderDate) = 1997
		) tmp
			on tmp.ProductID = prod.ProductID
		inner join [Order Details] odetail
			on tmp.ProductID = odetail.ProductID
			and tmp.OrderID = odetail.OrderID
	order by odetail.OrderID

----20)
select tmp.*,prod.ProductName,(tmp.ThanhTien - tmp.TienGiamGia) as TienPhaiTra
from Products prod
	inner join (
		select detail.*,
		(UnitPrice*Quantity) as ThanhTien, 
		(UnitPrice*Quantity)*Discount as TienGiamGia
		from [Order Details] detail
			inner join Orders ord
				on ord.OrderID = detail.OrderID
		where YEAR(ord.OrderDate) = 1997
	) tmp
		on tmp.ProductID = prod.ProductID
where tmp.Discount > 0 and (tmp.ThanhTien - tmp.TienGiamGia) < 50
order by tmp.OrderID


---21)
select ProductID, ProductName,CompanyName,UnitPrice,UnitsInStock,(UnitPrice * UnitsInStock) as TriGia
from Products prod
	inner join Suppliers sup
		on sup.SupplierID = prod.SupplierID
where UnitsInStock > 0 and Discontinued = 1

---22)
select (TitleOfCourtesy + ' ' + FirstName + ' ' + LastName) as HoTen, HireDate, Title, BirthDate,HomePhone
from Employees em
where year(HireDate) < 1993

---23)
select 
	COUNT(*) SoSanPham,
	MAX(p.UnitPrice) as MaxDonGia,
	MAX(p.UnitPrice) as MaxDonGia,
	AVG(p.UnitPrice) as trungbinh
from Products p

---24)
select 
	COUNT(*) SoSanPham,
	MAX(p.UnitPrice) as MaxDonGia,
	MAX(p.UnitPrice) as MaxDonGia,
	AVG(p.UnitPrice) as trungbinh
from Products p
	inner join Categories cate
		on cate.CategoryID = p.CategoryID
group by
	cate.CategoryID

---25)
select count(*) soDH
from Orders o
where o.ShipCountry in ('Belgium','Canada','UK')

---26)
select ShipCountry, count(*) as SoDH
from Orders o
where o.ShipCountry in ('Belgium','Canada','UK')
group by ShipCountry

---27)
select cate.CategoryName,avg(UnitPrice) as Dgtb
from Categories cate
	inner join Products prod
		on prod.CategoryID = cate.CategoryID
group by cate.CategoryID,cate.CategoryName
having avg(UnitPrice) > 30
---28. Tính đơn giá trung bình của mỗi loại sản phẩm, chỉ thống kê trên các sản phẩm có đơn giá lớn hơn 30
select cate.CategoryID, cate.CategoryName, AVG(prod.UnitPrice) as DonGiaTB
from Categories cate
	inner join Products prod
		on cate.CategoryID = prod.CategoryID
where prod.UnitPrice > 30
group by cate.CategoryID, cate.CategoryName
---29. Tính doanh số của từng loại sản phẩm (Category) trong năm 1996. 
----Danh sách gồm 2 cột: CategoryName, DoanhSo; trong đó 
----DoanhSo là tổng tất cả tiền phải trả với TienPhaiTra = UnitPrice*Quantity*(1-Discount)


select cate.CategoryName,cate.CategoryID, sum(tmp.TienPhaiTra) as DoanhSo
from Categories cate
	inner join (
		select prod.ProductID,prod.CategoryID, (detail.UnitPrice*Quantity*(1-Discount)) as TienPhaiTra 
		from Products prod
			inner join [Order Details] detail
				on detail.ProductID = prod.ProductID
			inner join Orders o
				on o.OrderID = detail.OrderID
		where year(o.OrderDate) = 1996
	) tmp
		on cate.CategoryID = tmp.CategoryID
group by cate.CategoryName,cate.CategoryID


---30. Thiết kế query tính tỉ lệ % tiền cước so với tiền mua hàng của từng công ty khách hàng trong năm 1997
----. Danh sách gồm các cột: CompanyName (của KH), TongTienCuoc (Freight), 
----TongTienHang với TienHang = UnitPrice * Quantity*(1-Discount), TiLeCuoc= TongTienCuoc/TongTienHang

select 
	tmp.CompanyName,
	FORMAT(tmp.TongTienCuoc,'N') as TongTienCuoc,
	FORMAT(tmp.TongTienHang,'N') as TongTienHang,
	FORMAT(tmp.TongTienCuoc/tmp.TongTienHang,'P') as TiLeCuoc,
	tmp.OrderDate
from (
	select
		cus.CustomerID,
		cus.CompanyName,
		sum(distinct o.Freight) as TongTienCuoc,
		sum(UnitPrice * Quantity*(1-Discount)) as TongTienHang,
		o.OrderDate
	from Customers cus
		join Orders o
			on cus.CustomerID = o.CustomerID
		join [Order Details] detail
			on detail.OrderID = o.OrderID
	where year(o.OrderDate) = 1997
	group by
		cus.CustomerID,
		cus.CompanyName,
		o.OrderDate
) as tmp
order by CompanyName


---31. Lập danh sách lấy 39 sản phẩm có đơn giá niêm yết cao nhất. DS gồm các cột: ProductID, ProductName, UnitPrice.
select top 39 * 
from Products
order by UnitPrice desc
---32. Lập danh sách lấy 50% số sản phẩm có đơn giá niêm yết cao nhất. DS gồm các cột: ProductID, ProductName, UnitPrice.
select top 50 percent *
from Products
order by UnitPrice desc
---33. Lập danh sách lấy 10 khách hàng mua nhiều đơn hàng nhất. DS gồm các cột: CustomerID, CompanyName, SoLuong DonHang
select top 10 cus.CustomerID,cus.CompanyName,count(*) as SoLuongDonHang
from Customers cus
	join Orders o
		on o.CustomerID = cus.CustomerID
group by cus.CustomerID,cus.CompanyName
order by SoLuongDonHang desc

---34. Lập danh sách lấy các khách hàng đã từng mua ít nhất một đơn hàng. DS gồm tất cả các cột bảng Customers.
select cus.CustomerID,cus.CompanyName,count(*) as SoLuongDonHang
from Customers cus
	join Orders o
		on o.CustomerID = cus.CustomerID
group by cus.CustomerID,cus.CompanyName
order by SoLuongDonHang asc

select *
from Customers cus
where cus.CustomerID in
(
	select distinct Orders.CustomerID 
	from Orders
)

---35. Lập danh sách lấy các khách hàng chưa mua đơn hàng nào. DS gồm tất cả các cột bảng Customers.
select *
from Customers
where Customers.CustomerID not in (
	select cus.CustomerID
	from Customers cus
		join Orders o
			on o.CustomerID = cus.CustomerID
	group by cus.CustomerID
)

select *
from Customers
where Customers.CustomerID not in
(
	select distinct Orders.CustomerID
	from Orders
)

---36. 36-- Tạo bảng Cutstomers1 là copy của bảng Customers
drop table if exists Customers1
select Customers.*
into Customers1
from Customers
---37. 37--Thêm nhiều hàng vào bảng Customer1 (20 hàng là các KH ở nước USA và UK)
---38. 38-- Xóa các KH nước USA:
---39. 39--Thêm 1 hàng vào bảng Customerl
---40. 40-- Sửa số ĐT thành "0111222333", tên thành "Lê Thanh Bình", thành phố thành "Hà Nội" cho KH mã KH001:
---41. 41-- Sửa tên Country 'UK' thành 'Anh':
---42. 42-- Xóa tất cả các hàng của bang Customers1:
---43. 43-- Xóa bảng customersl