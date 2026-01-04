 DROP DATABASE IF EXISTS product_db;
CREATE DATABASE product_db;
USE product_db;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT,
    status VARCHAR(20) -- ACTIVE, INACTIVE
);

INSERT INTO products (product_name, category, price, stock, status) VALUES
('Laptop', 'Electronics', 1500, 10, 'ACTIVE'),
('Mouse', 'Accessories', 20, 100, 'ACTIVE'),
('Keyboard', 'Accessories', 50, 50, 'ACTIVE'),
('Monitor', 'Electronics', 300, 20, 'ACTIVE'),
('Printer', 'Electronics', 200, 0, 'INACTIVE'),
('USB Cable', 'Accessories', 10, 200, 'ACTIVE'),
('Webcam', 'Electronics', 80, 15, 'ACTIVE'),
('Headphone', 'Accessories', 120, 0, 'INACTIVE'),
('Tablet', 'Electronics', 600, 8, 'ACTIVE'),
('Speaker', 'Accessories', 150, 12, 'ACTIVE');

-- select với case when

select price ,
			case  
				when price < 300
					then 'Rẻ'
				when price < 600
					then 'Bình thường'
				else 'Đắt'
			end 'Phân loại'
from products ;

select stock ,
			case  
				when stock = 0
					then 'Hết hàng'
				when stock <= 100
					then 'Sắp hết hàng'
				else 'Hàng còn nhiều'
			end 'Tình trạng'
from products ;

-- select với where

select * from products 
where price between 300 and 600;

select * from products
where product_name like '%P%'; -- dấu _ đại diện cho 1 kí tự , dấu % đại diện cho 1 sâu kí tự

select * from products
where product_name like '_a%';

-- Lọc theo tập hợp

select * from products
where price in(300,600,1200);

-- Sắp xếp bằng Order By

select * from products 
order by price asc; -- asc : tăng , desc : giảm 

select * from products
order by stock desc ,
		price asc;
        
-- Limit offset

select * from products
limit 3 offset 6;
-- Phân trang cần phải biết : Số trang ( page_number ) , số phần tử trên trang ( size ) 
-- Mối liên hệ :
-- + limit = size 
-- + offset = size * page_number 

select * from products
limit 3 offset 6;

select * from products
limit 3 ;


-- Thực hành
-- Lấy tất cả sp 
select * from products;

-- Lấy ds sp đang bán products
select product_name `Tên sản phẩm` , status `Trạng thái` from products
where status = 'ACTIVE';

-- Lấy name và price của sp có price > 100
select product_name `Tên sản phẩm` , price `Giá` from products 
where price > 100;

-- Lấy sp có giá trong khoảng 50-300
select price `Giá` from products 
where price between 50 and 300;

-- Lấy sp thuộc nhóm Electronis
select category `Danh mục` from products 
where category = 'Electronics';

-- Lấy các sp có tồn kho = 0
select product_name `Tên sản phẩm` , stock `Tồn kho` from products 
where stock = 0;

-- Lấy sp có tên chứa chữ 'o'
select product_name `Tên sản phẩm` from products 
where product_name like '%o%';

-- Sx tăng dần
select product_name `Tên sản phẩm` , price `Giá tăng dần` from products 
order by price;

-- Sx tồn kho giảm dần
select product_name `Tên sản phẩm` , price `Giá giảm dần` from products 
order by stock desc;

-- Hiển thị 5 sp đầu 
select * from products 
limit 5;
