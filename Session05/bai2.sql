create database session05_bai2;

use session05_bai2;

create table customers(
	customer_id int primary key,
    full_name varchar(255) not null,
    email varchar(255) not null,
    city varchar(255) not null,
    status enum('active','inactive')
);

INSERT INTO customers (customer_id, full_name, email, city, status) VALUES
(1, 'Nguyễn Văn An', 'an.nguyen@example.com', 'Hà Nội', 'active'),
(2, 'Trần Thị Bình', 'binh.tran@example.com', 'TP.HCM', 'active'),
(3, 'Lê Hoàng Phúc', 'phuc.le@example.com', 'Đà Nẵng', 'inactive'),
(4, 'Phạm Minh Khang', 'khang.pham@example.com', 'Hà Nội', 'inactive'),
(5, 'Võ Thảo My', 'my.vo@example.com', 'TP.HCM', 'active');


select * from customers;

select * from customers 
where city = 'TP.HCM';

select * from customers 
where status = 'active' and city = 'Hà Nội';

select * from customers 
order by full_name;



