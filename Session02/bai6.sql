create database bai6;
use bai6;

create table Student (
	id int primary key auto_increment,
    full_name nvarchar(50) not null
);
create table Subjects (
	id int primary key auto_increment,
    subject_name nvarchar(50) not null,
    credits int not null,

    constraint chb_01 check(credits > 0)
);
create table Enrollment (
	student_id int,
    subject_id int,
    date_enrollment date,

    constraint fk_student foreign key(student_id) references Student(id),
    constraint fk_subject foreign key(subject_id) references Subjects(id)
);
create table Teacher (
	id int primary key auto_increment,
	full_name nvarchar(50) not null,
    email nvarchar(50) not null
);

alter table Subjects
add column teacher_id int,
add constraint fk_teacher foreign key(teacher_id) references Teacher(id);

create table Score (
	id int primary key auto_increment,
    student_id int,
    subject_id int,
    progress_grade int not null,
    final_grade int not null,

    constraint chb_progress check(progress_grade >= 0 and progress_grade <= 10),
    constraint chb_final check(final_grade >= 0 and final_grade <= 10),
    constraint fk_student foreign key(student_id) references Student(id),
    constraint fk_subject foreign key(subject_id) references Subjects(id)
);