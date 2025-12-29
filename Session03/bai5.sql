

create database session03_bai5;

use session03_bai5;

create table score (
    student_id varchar(50),
    subject_id varchar(50),
    mid_score decimal(4,2) check(mid_score >= 0 and mid_score <= 10),
    final_score decimal(4,2) check(final_score >= 0 and final_score <= 10),
    primary key(student_id, subject_id)
);

insert into score(student_id, subject_id, mid_score, final_score)
values
    ('sv01', 'sb01', 7.5, 8.0),
    ('sv02', 'sb03', 6.0, 7.5);

update score
set final_score = 9.0
where student_id = 'sv01' and subject_id = 'sb01';


select * from score;

select *
from score
where final_score >= 8;

