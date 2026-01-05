create database session06_bai4;

use session06_bai4;

create table products(
	product_id int primary key,
    product_name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items(
	order_id int primary key,
    product_id int,
    quantity int not null,
    foreign key(product_id) references products(product_id)
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop Dell Inspiron', 15000000.00),
(2, 'Chuột Logitech M331', 350000.00),
(3, 'Bàn phím cơ Keychron K2', 1900000.00),
(4, 'Màn hình Samsung 24 inch', 3200000.00),
(5, 'Tai nghe Sony WH-CH510', 1200000.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(102, 2, 2),
(103, 3, 1),
(104, 4, 1),
(105, 5, 3);



select p.product_id 'Mã sản phẩm' , oi.quantity 'Số lượng đã bán'
from products p
left join order_items oi on p.product_id = oi.product_id;

select p.product_id 'Mã sản phẩm' , sum(oi.quantity * p.price) as profit
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id;

select p.product_id 'Mã sản phẩm' , sum(oi.quantity * p.price) as profit
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id
having sum(oi.quantity * p.price) > 3000000;







