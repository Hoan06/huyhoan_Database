create database session06_bai1;

use session06_bai1;

create table customers(
	customer_id INT primary key,
    full_name varchar(255) not null,
    city varchar(255) not null
);

create table orders(
	order_id int primary key,
    customer_id int,
    order_date date not null,
    status enum('pending', 'completed', 'cancelled'),
    foreign key(customer_id) references customers(customer_id)
);

INSERT INTO customers (customer_id, full_name, city)
VALUES
(1, 'Nguyen Van A', 'Hanoi'),
(2, 'Tran Thi B', 'Ho Chi Minh'),
(3, 'Le Van C', 'Danang'),
(4, 'Pham Thi D', 'Haiphong'),
(5, 'Do Van E', 'Cantho');

INSERT INTO orders (order_id, customer_id, order_date, status)
VALUES
(101, 1, '2024-01-05', 'completed'),
(102, 1, '2024-01-10', 'pending'),
(103, 2, '2024-02-02', 'completed'),
(104, 2, '2024-02-15', 'cancelled'),
(105, 3, '2024-03-01', 'completed'),
(106, 3, '2024-03-20', 'pending'),
(107, 4, '2024-04-05', 'completed'),
(108, 4, '2024-04-22', 'completed'),
(109, 5, '2024-05-11', 'pending'),
(110, 5, '2024-05-18', 'cancelled');

select o.* , c.full_name
from orders o
join customers c on o.customer_id = c.customer_id;

SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;









