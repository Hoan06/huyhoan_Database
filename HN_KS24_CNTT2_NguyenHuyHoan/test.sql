create database test;

use test;

create table Student(
	student_id varchar(10) primary key,
    student_name varchar(50) not null,
    email varchar(50) not null unique,
    phone varchar(15) not null
);

create table Course(
	course_id varchar(10) primary key,
    course_name varchar(50) not null,
    credits int not null,
    check( credits > 0)
);

create table Enrollment(
	student_id varchar(10),
    course_id varchar(10),
    grade decimal(4,2) default 0,
    primary key(student_id , course_id),
    foreign key(student_id) references Student(student_id) on delete cascade,
    foreign key(course_id) references Course(course_id) on delete cascade
);


insert into Student(student_id , student_name , email , phone) 
values ('SV01' , 'Nguyễn Huy Hoàn' , 'huyhoan13032006@gmail.com' , '0345146806'),
 ('SV02' , 'Nguyễn Huy Hoàn' , 'hoanhuy@gmail.com' , '0345146807'),
 ('SV03' , 'Nguyễn Tiến Đạt' , 'dattien@gmail.com' , '0345146808'),
 ('SV04' , 'Nguyễn Văn Phú' , 'vanphu@gmail.com' , '0345146809'),
 ('SV05' , 'Nguyễn Dũng Hái' , 'haidung@gmail.com' , '0345146805');

insert into Course(course_id , course_name , credits)
values ('C01' , 'Cơ sở dữ liệu' , 2),
 ('C02' , 'Lập trình C' , 3),
 ('C03' , 'Lập trình C++' , 4),
 ('C04' , 'lập trình python' , 1),
 ('C05' , 'Toán cao cấp' , 5);
 
 insert into Enrollment(student_id , course_id , grade)
 values ('SV01' , 'C02' , 9.00),
  ('SV02' , 'C03' , 8.00),
  ('SV03' , 'C01' , 7.00),
  ('SV04' , 'C04' , 6.50),
  ('SV05' , 'C05' , 8.80);
  
  
  -- Cập nhật
  update Enrollment 
  set grade = 9.00
  where student_id = 'SV02' and course_id = 'C03';
  
  -- Lấy danh sách
  select student_name `Họ tên` , email , phone `Số điện thoại` from Student;

-- Xóa
delete from Course
where course_id = 'C01';

-- Xóa thành công bởi vì đã có on delete cascade ở bảng Enrollment
-- và nếu không có dòng này nó sẽ báo không xóa được vì nó có sự ràng buộc giữa 2 bảng Course và Enrollment







