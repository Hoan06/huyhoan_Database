create database session07_bai6;

use session07_bai6;

create table customers(
	customer_id int primary key,
    name varchar(255) not null,
    email varchar(255) not null
);

create table orders(
	order_id int primary key,
    customer_id int,
    order_date date not null,
    total_amount float not null,
    foreign key(customer_id) references customers(customer_id)
);


INSERT INTO customers (customer_id, name, email) VALUES
(1, 'Nguyen Van A', 'a.nguyen@example.com'),
(2, 'Tran Thi B', 'b.tran@example.com'),
(3, 'Le Thi C', 'c.le@example.com'),
(4, 'Pham Van D', 'd.pham@example.com'),
(5, 'Hoang Thi E', 'e.hoang@example.com');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-01-05', 1500000),
(102, 1, '2025-01-07', 2200000),
(103, 1, '2025-01-10', 1750000),
(104, 1, '2025-01-12', 980000),
(105, 2, '2025-01-15', 2500000),
(106, 3, '2025-01-17', 450000),
(107, 4, '2025-01-20', 3200000),
(108, 5, '2025-01-22', 1350000);


SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    ) AS t
);






