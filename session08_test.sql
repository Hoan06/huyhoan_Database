CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày


-- Phần I
-- Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name 'Khách hàng' , phone 'Số điện thoại' from guests;  

-- Liệt kê các loại phòng khác nhau trong khách sạn
select distinct room_type 'Loại phòng' from rooms;

-- Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select room_type 'Loại phòng' , price_per_day 'Giá thuê' from rooms;

-- Hiển thị các phòng có giá thuê lớn hơn 1.000.000
select room_type 'Loại phòng' , price_per_day 'Giá thuê' from rooms where price_per_day > 1000000;

-- Liệt kê các lần đặt phòng diễn ra trong năm 2024
select booking_id 'Id đặt phòng' , check_in 'Ngày đặt' from bookings where check_in between '2024-01-01' and '2024-12-30';

-- Cho biết số lượng phòng của từng loại phòng
select room_type 'Loại phòng' , count(room_type) 'Số lượng phòng' from rooms
group by room_type;


-- Phần II
-- Liệt kê danh sách các lần đặt phòng 
select b.booking_id 'Id đặt phòng' , g.guest_name 'Tên khách hàng' , r.room_type 'Loại phòng' , b.check_in 'Ngày nhận phòng'  from bookings b
join guests g on b.guest_id = g.guest_id
join rooms r on b.room_id = r.room_id;

-- Đếm số lượng phòng khách đã đặt
select g.guest_name 'Tên khách hàng' , count(g.guest_id) 'Số lần đặt phòng' from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_id; 

-- Tính doanh thu của mỗi phòng
select r.room_id 'Id phòng' , sum(DATEDIFF(check_out, check_in) * r.price_per_day) 'Doanh thu' from bookings b
join rooms r on r.room_id = b.room_id
group by r.room_id , r.room_type;

-- Tổng doanh thu của từng loại phòng
select r.room_type 'Loại phòng' , sum(DATEDIFF(check_out, check_in) * r.price_per_day) 'Doanh thu' from rooms r
join bookings b on r.room_id = b.room_id
group by r.room_type;

-- Những khách đã đặt phòng từ 2 lần trở lên
select g.guest_name 'Tên khách hàng' , count(g.guest_id) 'Số lần đặt'  from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_id
having count(g.guest_id) >= 2;

-- Tìm loại phòng có số lượt đặt phòng nhiều nhất
select r.room_type 'Loại phòng' , count(r.room_type) 'Số lần được đặt' from rooms r
join bookings b on r.room_id = b.room_id
group by r.room_type 
order by count(r.room_type) desc
limit 1;


-- Phần III
-- Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả các phòng
select room_id 'id phòng', room_type 'loại phòng', price_per_day 'giá thuê'
from rooms
where price_per_day > (select avg(price_per_day) from rooms);

-- Hiển thị những khách chưa từng đặt phòng
select guest_id 'id khách', guest_name 'tên khách', phone 'số điện thoại'
from guests
where guest_id not in (select distinct guest_id from bookings);


-- Tìm phòng được đặt nhiều lần nhất
select room_id, room_type, booking_count
from (
    select r.room_id, r.room_type, count(b.booking_id) as booking_count
    from rooms r
    join bookings b on r.room_id = b.room_id
    group by r.room_id, r.room_type
) as temp
where booking_count = (
    select max(count_per_room)
    from (
        select count(b.booking_id) as count_per_room
        from rooms r
        join bookings b on r.room_id = b.room_id
        group by r.room_id
    ) as sub
);








