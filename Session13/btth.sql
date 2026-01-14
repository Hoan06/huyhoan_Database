drop database if exists socialnetworkdb;
create database socialnetworkdb;
use socialnetworkdb;

create table users (
    user_id int auto_increment primary key,
    username varchar(50),
    total_posts int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    foreign key (user_id) references users(user_id)
);

create table post_audits (
    audit_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime
);

-- Task 1
delimiter //
create trigger tg_checkpostcontent
before insert on posts
for each row
begin
    if new.content is null or trim(new.content) = '' then
        signal sqlstate '45000'
        set message_text = 'noi dung bai viet khong duoc de trong';
    end if;
end //

-- Task 2
delimiter //
create trigger tg_updatepostcountafterinsert
after insert on posts
for each row
begin
    update users
    set total_posts = total_posts + 1
    where user_id = new.user_id;
end //

-- Task 3
delimiter //
create trigger tg_logpostchanges
after update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_audits(post_id, old_content, new_content, changed_at)
        values (old.post_id, old.content, new.content, now());
    end if;
end //

-- Task 4
delimiter //
create trigger tg_updatepostcountafterdelete
after delete on posts
for each row
begin
    update users
    set total_posts = total_posts - 1
    where user_id = old.user_id;
end //


insert into users(username) values ('hoanhuy');

insert into posts(user_id, content, created_at)
values (1, 'bai viet dau tien', now());

update posts
set content = 'noi dung da chinh sua'
where post_id = 1;

delete from posts where post_id = 1;

select * from users;
select * from post_audits;


