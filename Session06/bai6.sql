create database session06_bai6;

use session06_bai6;

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
(106, 2, 4),
(107, 2, 3),
(108, 2, 3),
(109, 5, 5),
(110, 5, 4),
(111, 5, 3),
(112, 3, 2),
(113, 4, 1),
(114, 1, 1);



select p.product_name , sum(oi.quantity) 'Tổng số lượng bán' , sum(p.price * oi.quantity) 'Tổng doanh thu' ,  avg(p.price) 'Giá bán trung bình'
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id
having sum(oi.quantity) > 10
order by sum(p.price * oi.quantity) desc
limit 5;










