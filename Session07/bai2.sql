create database session07_bai2;

use session07_bai2;

create table products(
	product_id int primary key,
    name varchar(255) not null,
    price float not null
);

create table order_items(
	order_id int primary key,
    product_id int,
    quantity int not null,
    foreign key(product_id) references products(product_id)
);


INSERT INTO products (product_id, name, price) VALUES
(1, 'iPhone 13', 19000000),
(2, 'Samsung Galaxy S22', 18000000),
(3, 'Xiaomi Redmi Note 12', 5500000),
(4, 'MacBook Air M1', 23000000),
(5, 'Dell Inspiron 15', 15000000),
(6, 'Sony WH-1000XM4', 6500000),
(7, 'Logitech MX Master 3', 2500000);


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(102, 2, 2),
(103, 3, 3),
(104, 5, 1),
(105, 4, 1);


select product_id , name from products
where product_id in(select product_id from order_items);





