
create database session03_bai4;

use session03_bai4;

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

insert into students(id_student , name_student , birth_day , email , class_name)
values ('sv01' , 'Hoàn' , '2006-03-13' , 'Hoan@gmail.com' , 'CNTT2'),
 ('sv02' , 'Huy' , '2006-02-14' , 'Huy@gmail.com' , 'CNTT3');
 
insert into subject(id_subject , name_subject , credits ) 
values ('sb01' , 'Toán' , 3),
 ('sb02' , 'Lý' , 4),
 ('sb03' , 'Hóa' , 5);
 
 insert into enrollment(id_student , id_subject , semester , date_register)
 values ('sv01' , 'sb02' , 'HK1' , '2025-12-29'),
  ('sv02' , 'sb03' , 'HK2' , '2025-12-26');


select * from enrollment;

select * from enrollment where id_student = 'sv01';



