create database session03_bai3;

use session03_bai3;

create table subject(
	id_subject varchar(50) primary key,
    name_subject varchar(50) not null,
    credits int not null,
    check(credits > 0)
);

insert into subject(id_subject , name_subject , credits ) 
values ('sb01' , 'Toán' , 3),
 ('sb02' , 'Lý' , 4),
 ('sb03' , 'Hóa' , 5);
 
 select * from subject;
 
update subject
set credits = 6
where id_subject = 'sb01';

update subject
set name_subject = 'Anh'
where id_subject = 'sb01';


