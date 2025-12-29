
create database btth;

use btth;

create table students(
	id_student varchar(50) primary key ,
    name_student varchar(50) not null,
    birth_day date not null,
    email varchar(50) not null,
    class_name varchar(50) not null
);


create table subject(
	id_subject varchar(50) primary key,
    name_subject varchar(50) not null,
    credits int not null,
    check(credits > 0)
);

create table enrollment(
	id_student varchar(50),
    id_subject varchar(50),
    semester varchar(20),
    date_register date not null,
    primary key (id_student,id_subject),
    foreign key(id_student) references students(id_student) on delete cascade,
    foreign key(id_subject) references subject(id_subject) on delete cascade
);	

-- insert 
INSERT INTO students(id_student, name_student, birth_day, email, class_name) VALUES
 ('sv01', 'Nguyễn An', '2005-01-10', 'anan@gmail.com', 'K23'),
 ('sv02', 'Trần Bình', '2005-02-11', 'binh@gmail.com', 'K23'),
 ('sv03', 'Lê Cường', '2005-03-12', 'cuong@gmail.com', 'K24'),
 ('sv04', 'Phạm Dung', '2005-04-13', 'dung2@gmail.com', 'K24'),
 ('sv05', 'Vũ Hạnh', '2005-05-14', 'hanh@gmail.com', 'K25'),
 ('sv06', 'Đỗ Minh', '2005-06-15', 'minh@gmail.com', 'K25'),
 ('sv07', 'Bùi Nga', '2005-07-16', 'nga@gmail.com', 'K22'),
 ('sv08', 'Lý Phú', '2005-08-17', 'phu@gmail.com', 'K22'),
 ('sv09', 'Mai Quân', '2005-09-18', 'quan@gmail.com', 'K21'),
 ('sv10', 'Đặng Sơn', '2005-10-19', 'son@gmail.com', 'K21');

 
INSERT INTO subject(id_subject, name_subject, credits) VALUES
 ('mh01', 'Cơ sở dữ liệu', 3),
 ('mh02', 'Mạng máy tính', 4),
 ('mh03', 'Toán rời rạc', 3),
 ('mh04', 'Hệ điều hành', 4),
 ('mh05', 'Java', 3),
 ('mh06', 'Web cơ bản', 2),
 ('mh07', 'Python', 3),
 ('mh08', 'Phân tích thiết kế', 3),
 ('mh09', 'Thuật toán', 4),
 ('mh10', 'Lịch sử Đảng', 2);

  
INSERT INTO enrollment(id_student, id_subject, semester, date_register) VALUES
 ('sv01', 'mh01', 'HK1', '2025-10-01'),
 ('sv02', 'mh02', 'HK1', '2025-10-02'),
 ('sv03', 'mh03', 'HK2', '2025-10-03'),
 ('sv04', 'mh04', 'HK1', '2025-10-04'),
 ('sv05', 'mh05', 'HK2', '2025-10-05'),
 ('sv06', 'mh06', 'HK1', '2025-10-06'),
 ('sv07', 'mh07', 'HK2', '2025-10-07'),
 ('sv08', 'mh08', 'HK1', '2025-10-08'),
 ('sv09', 'mh09', 'HK2', '2025-10-09'),
 ('sv10', 'mh10', 'HK1', '2025-10-10');

-- select
SELECT id_student, name_student
FROM students;

SELECT name_subject, credits
FROM subject;

SELECT id_student , id_subject
FROM subject;

-- update

UPDATE students
SET email = 'newemail@gmail.com'
WHERE id_student = 'sv01';

UPDATE subject 
SET credits = 1
where id_subject = mb01;

UPDATE enrollment 
SET semester = 'HK3'
where id_student = 'sv01' and id_subject = 'mb01';

DELETE FROM enrollment 
where id_student = 'sv01' and id_subject = 'mb01';

DELETE FROM students 
where id_student = 'sv02';






