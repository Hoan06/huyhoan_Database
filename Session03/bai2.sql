create database session03_bai2;

use session03_bai2;

create table students(
	id_student varchar(50) primary key ,
    name_student varchar(50) not null,
    birth_day date not null,
    email varchar(50) not null unique
);

insert into students(id_student , name_student , birth_day , email ) 
values ( 'sv01' , 'Hoàn' , '2006-03-13' , 'hoan@gmail.com' ),
 ( 'sv02' , 'Dũng' , '2006-03-14' , 'dung@gmail.com' ),
 ( 'sv03' , 'Huy' , '2006-03-15' , 'huy@gmail.com' );
 
 update students
 set email = 'huyFix@gmail.com'
 where id_student = 'sv03';
 
  update students
 set birth_day = '2006-03-16'
 where id_student = 'sv02';
 
 delete from students 
 where id_student = 'sv01';
 
  select * from students;
 

