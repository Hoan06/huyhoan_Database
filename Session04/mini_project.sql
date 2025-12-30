create database session04;

use session04;

create table Students(
	student_id varchar(10) primary key,
    student_name varchar(50) not null,
    birth_day date not null,
    email varchar(50) not null unique
);

create table Teacher(
	teacher_id varchar(10) primary key,
    teacher_name varchar(50) not null,
    email varchar(50) not null unique
);

create table Course(
	course_id varchar(10) primary key,
    course_name varchar(50) not null,
    description varchar(100) default 'Khóa học cơ bản',
    number_learn int not null,
    teacher_id varchar(10),
    foreign key(teacher_id) references Teacher(teacher_id)
);

create table Enrollment(
	student_id varchar(10),
    course_id varchar(10),
    date_register date not null,
    primary key(student_id , course_id),
    foreign key(student_id) references Students(student_id) on delete cascade,
    foreign key(course_id) references Course(course_id) on delete cascade
);

create table Score(
	student_id varchar(10),
    course_id varchar(10),
    mid_term decimal(4,2),
    final_term decimal(4,2),
    primary key(student_id , course_id),
    check(mid_term between 0 and 10),
    check(final_term between 0 and 10),
    foreign key(student_id) references Students(student_id) on delete cascade,
    foreign key(course_id) references Course(course_id) on delete cascade
);

-- Phần thêm mới

insert into Students(student_id, student_name, birth_day, email) values
('SV01', 'Nguyen Van A', '2004-03-15', 'a.nguyen@example.com'),
('SV02', 'Tran Thi B', '2003-07-22', 'b.tran@example.com'),
('SV03', 'Le Hoang C', '2005-01-09', 'c.le@example.com'),
('SV04', 'Pham Minh D', '2004-11-02', 'd.pham@example.com'),
('SV05', 'Do Thi E', '2003-05-25', 'e.do@example.com');

insert into Teacher(teacher_id, teacher_name, email) values
('TC01', 'Nguyen Thanh Long', 'long.nguyen@example.com'),
('TC02', 'Pham Quoc Hung', 'hung.pham@example.com'),
('TC03', 'Tran Ba Khoa', 'khoa.tran@example.com'),
('TC04', 'Le Thi Mai', 'mai.le@example.com'),
('TC05', 'Vo Minh Tuan', 'tuan.vo@example.com');

insert into Course(course_id, course_name, description, number_learn, teacher_id) values
('C001', 'Lập trình C cơ bản', 'Giới thiệu lập trình C', 12, 'TC01'),
('C002', 'Cơ sở dữ liệu', 'Học SQL và thiết kế CSDL', 15, 'TC02'),
('C003', 'Lập trình Java', 'Java OOP và ứng dụng', 18, 'TC03'),
('C004', 'Mạng máy tính', 'Nguyên lý mạng căn bản', 10, 'TC04'),
('C005', 'Thiết kế web', 'HTML CSS JavaScript cơ bản', 20, 'TC05');

insert into Enrollment(student_id, course_id, date_register) values
('SV01', 'C001', '2025-01-10'),
('SV01', 'C002', '2025-01-12'),
('SV02', 'C003', '2025-01-15'),
('SV03', 'C001', '2025-01-20'),
('SV04', 'C005', '2025-01-22');

insert into Score(student_id, course_id, mid_term, final_term) values
('SV01', 'C001', 8.50, 9.00),
('SV01', 'C002', 7.00, 8.25),
('SV02', 'C003', 6.75, 7.50),
('SV03', 'C001', 9.00, 9.25),
('SV04', 'C005', 8.00, 8.80);

-- Phần cập nhật

update Students
set email = 'test@gmail.com'
where student_id = 'SV01';

update Course 
set description = 'Khóa học vip pro max'
where course_id = 'C001';

update Score
set final_term = 10.00
where student_id = 'SV01';

-- Phần xóa

delete from Score
where student_id = 'SV01' and course_id = 'C002';

delete from Enrollment
where student_id = 'SV01' and course_id = 'C002';

-- Phần lấy dữ liệu

select * from Students;
select * from Teacher;
select * from Course;
select * from Enrollment;
select * from Score;









