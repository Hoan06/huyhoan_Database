create database session07_bai1;

use session07_bai1;

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
(3, 'Le Van C', 'c.le@example.com'),
(4, 'Pham Thi D', 'd.pham@example.com'),
(5, 'Hoang Van E', 'e.hoang@example.com'),
(6, 'Vo Thi F', 'f.vo@example.com'),
(7, 'Dang Van G', 'g.dang@example.com');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-01-05', 1500000),
(102, 2, '2025-01-07', 2750000),
(103, 3, '2025-01-10', 320000),
(104, 1, '2025-01-12', 450000),
(105, 5, '2025-01-15', 985000),
(106, 7, '2025-01-18', 2100000),
(107, 4, '2025-01-20', 750000);

select customer_id , name from customers
where customer_id in(select customer_id from orders);










