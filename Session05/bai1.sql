create database session05_bai1;

use session05_bai1;

create table products(
	product_id int primary key,
    product_name varchar(255) not null,
    price decimal(10,2) not null,
    stock int not null,
    status enum('active','inactive')
);

insert into products (product_id, product_name, price, stock, status) values
(1, 'Laptop Dell Inspiron 3505', 15000.00, 20, 'active'),
(2, 'Chuột Logitech M331', 350.00, 100, 'active'),
(3, 'Bàn phím cơ AKKO 3068', 1200.00, 50, 'inactive'),
(4, 'Tai nghe Sony WH-CH510', 900.00, 35, 'active'),
(5, 'Màn hình Samsung 24inch', 2800.00, 15, 'inactive');

select * from products;

select * from products 
where status = 'active';

select * from products 
where price > 1000000;

select * from products 
where status = 'active'
order by price;



