create database session06_bai5;

use session06_bai5;

create table customers(
	customer_id int primary key,
    full_name varchar(255) not null,
    city varchar(255) not null
);

create table orders(
	order_id int primary key,
    customer_id int,
    order_date date not null,
    status enum('pending', 'completed', 'cancelled'),
    foreign key(customer_id) references customers(customer_id),
    total_amount decimal(10,2) not null
);

INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Nguyen Van A', 'Hanoi'),
(2, 'Tran Thi B', 'Ho Chi Minh'),
(3, 'Le Van C', 'Da Nang'),
(4, 'Pham Thi D', 'Hai Phong'),
(5, 'Hoang Van E', 'Can Tho');

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) VALUES
(101, 1, '2024-12-01', 'completed', 1500000.00),
(102, 2, '2024-12-05', 'pending', 2500000.00),
(103, 3, '2024-12-10', 'cancelled', 1200000.00),
(104, 1, '2024-12-15', 'completed', 3200000.00),
(105, 5, '2024-12-18', 'pending', 800000.00),
(106, 1, '2024-12-20', 'completed', 4000000.00),
(107, 1, '2024-12-22', 'completed', 3500000.00);


select c.full_name , count(o.order_id) 'Tổng số đơn hàng' , sum(total_amount) 'Tổng tiền đã chi' , avg(total_amount) 'Giá trị đơn hàng trung bình'
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id , c.full_name
having count(o.order_id) > 3 and sum(total_amount) > 10000000
order by sum(total_amount) desc; 























