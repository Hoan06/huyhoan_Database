create database session03_bai6;

use session03_bai6;

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

create table score (
    student_id varchar(50),
    subject_id varchar(50),
    mid_score decimal(4,2) check(mid_score >= 0 and mid_score <= 10),
    final_score decimal(4,2) check(final_score >= 0 and final_score <= 10),
    primary key(student_id, subject_id),
    foreign key(student_id) references students(id_student) on delete cascade,
    foreign key(subject_id) references subject(id_subject) on delete cascade
);

insert into students(id_student , name_student , birth_day , email , class_name)
values ('sv03' , 'An' , '2006-05-20' , 'an@gmail.com' , 'CNTT1');

insert into subject(id_subject , name_subject , credits ) 
values 
('sb01' , 'Toán' , 3),
('sb02' , 'Lý' , 4),
('sb03' , 'Hóa' , 5);


insert into enrollment(id_student , id_subject , semester , date_register)
values 
('sv03', 'sb01', 'HK1', '2025-01-10'),
('sv03', 'sb02', 'HK1', '2025-01-10');

insert into score(student_id, subject_id, mid_score, final_score)
values
('sv03', 'sb01', 7.0, 8.0),
('sv03', 'sb02', 6.5, 7.0);

update score
set final_score = 9.0
where student_id = 'sv03' and subject_id = 'sb01';

delete from enrollment
where id_student = 'sv03' and id_subject = 'sb02';

select 
    score.student_id,
    students.name_student,
    subject.name_subject,
    score.mid_score,
    score.final_score
from score
join students 
    on score.student_id = students.id_student
join subject 
    on score.subject_id = subject.id_subject;






