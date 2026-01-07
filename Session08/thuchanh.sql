create database session08_thuchanh;

use session08_thuchanh;


SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

SET FOREIGN_KEY_CHECKS = 1;

create table customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);

create table categories(
	category_id int primary key auto_increment,
    category_name varchar(255) not null unique
);

create table products(
	product_id int primary key auto_increment,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check(price > 0),
    category_id int not null,
    foreign key(category_id) references categories(category_id)
);

create table orders(
	order_id int primary key auto_increment,
    customer_id int not null,
    order_date datetime default(current_date()),
    status enum('Pending' , 'Completed' , 'Cancel') default('Pending'),
    foreign key(customer_id) references customers(customer_id)
);

create table order_items(
	order_item_id int primary key auto_increment,
    order_id int,
	product_id int,
    quantity int not null check(quantity > 0)
);

INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002'),
('Le Van C', 'c@gmail.com', '0900000003'),
('Pham Thi D', 'd@gmail.com', '0900000004'),
('Hoang Van E', 'e@gmail.com', '0900000005'),
('Vo Thi F', 'f@gmail.com', '0900000006');

INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Máy tính bảng'),
('Phụ kiện'),
('Đồng hồ thông minh');


INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 14', 22000000, 1),
('Samsung S23', 18000000, 1),
('MacBook Air M2', 30000000, 2),
('Dell XPS 13', 28000000, 2),
('iPad Pro 11', 25000000, 3),
('AirPods Pro 2', 5500000, 4),
('Apple Watch S8', 12000000, 5),
('Logitech Mouse', 800000, 4),         
('iPhone 15 Pro Max', 32000000, 1);     


INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-01-05 10:30:00', 'Completed'),
(2, '2025-01-06 14:20:00', 'Pending'),
(3, '2025-01-07 09:10:00', 'Completed'),
(4, '2025-01-08 16:45:00', 'Cancel'),
(5, '2025-01-09 11:00:00', 'Completed'),
(1, '2025-01-10 09:00:00', 'Completed'),
(1, '2025-01-12 08:30:00', 'Pending'),
(3, '2025-01-15 13:20:00', 'Completed'),
(6, '2025-01-15 15:30:00', 'Pending');


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 6, 2),
(2, 2, 1),
(3, 3, 1),
(3, 7, 1),
(4, 5, 1),
(5, 4, 1),
(6, 9, 1),
(6, 8, 2),
(7, 1, 1),
(8, 3, 1),
(9, 2, 1);



-- Phần A
select * from categories;

select * from orders where status = 'Completed';

select * from products order by price desc;

select * from products order by price desc limit 5 offset 2;

-- Phần B
select p.product_name 'Tên sản phẩm' , c.category_name 'Danh mục' from products p
join categories c on p.category_id = c.category_id;

select o.order_id , o.order_date , c.customer_name , o.status from orders o
join customers c on o.customer_id = c.customer_id;

select order_id , sum(quantity) 'Tổng số lượng' from order_items
group by order_id;

select customer_id 'Khách hàng' , count(order_id) 'Số đơn hàng' from orders
group by customer_id;

select customer_id 'Khách hàng' , count(order_id) 'Số đơn hàng' from orders
group by customer_id
having count(order_id) >= 2;

select c.category_id , c.category_name 'Tên danh mục' , avg(p.price) 'Giá trung bình' , min(p.price) 'Giá thấp nhất' , max(p.price) 'Giá cao nhất' from products p
join categories c on p.category_id = c.category_id
group by c.category_id;


-- Phần C
-- Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select p.product_name 'Tên sản phẩm' , format(p.price , 0 , 'vi_VN') 'Giá'  from products p
where p.price > 
(select avg(p.price) from products p); 

-- Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
select customer_name 'Tên khách hàng' from customers c
where c.customer_id 
in(select customer_id from orders
group by customer_id
having count(order_id) >= 1 );

-- Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.
SELECT order_id, total_qty
FROM (
    SELECT order_id, SUM(quantity) AS total_qty
    FROM order_items
    GROUP BY order_id
) AS t
WHERE total_qty = (
    SELECT MAX(total_qty)
    FROM (
        SELECT SUM(quantity) AS total_qty
        FROM order_items
        GROUP BY order_id
    ) AS x
);

-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM (
        SELECT category_id, AVG(price) AS avg_price
        FROM products
        GROUP BY category_id
        ORDER BY avg_price DESC
        LIMIT 1
    ) AS t
);

-- Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
SELECT customer_id, SUM(total_quantity) AS total_quantity_per_customer
FROM (
    SELECT o.customer_id, oi.order_id, SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id, oi.order_id
) AS t
GROUP BY customer_id;

-- Viết lại truy vấn lấy sản phẩm có giá cao nhất
SELECT *
FROM products
WHERE price = (
    SELECT MAX(price) 
    FROM products
);
















