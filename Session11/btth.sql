create database sociallab;
use sociallab;

create table posts (
    post_id int auto_increment primary key,
    content text,
    author varchar(100),
    likes_count int default 0
);

delimiter //

create procedure sp_createpost(
    in content_in text,
    in author_in varchar(100),
    out post_id_out int
)
begin
    insert into posts(content, author)
    values (content_in, author_in);

    set post_id_out = last_insert_id();
end //


delimiter //

create procedure sp_searchpost(
    in keyword_in varchar(100)
)
begin
    select *
    from posts
    where content like concat('%', keyword_in, '%');
end //


delimiter //

create procedure sp_increaselike(
    in post_id_in int,
    inout like_inout int
)
begin
    update posts
    set likes_count = likes_count + 1
    where post_id = post_id_in;

    select likes_count
    into like_inout
    from posts
    where post_id = post_id_in;
end //

delimiter //

create procedure sp_deletepost(
    in post_id_in int
)
begin
    delete from posts
    where post_id = post_id_in;
end //

-- Tạo 2 bài viết và lấy ID trả về
set @id1 = 0;
call sp_createpost('hello world from mysql', 'hoan', @id1);
select @id1 as post_id_1;

set @id2 = 0;
call sp_createpost('this is another hello post', 'an', @id2);
select @id2 as post_id_2;

-- Tìm bài viết có chữ "hello"
call sp_searchpost('hello');

-- Tăng like cho bài viết (dùng INOUT)
select likes_count into @like from posts where post_id = @id1;
call sp_increaselike(@id1, @like);
select @like as new_like_count;

-- Xóa một bài viết
call sp_deletepost(@id2);

-- Kiểm tra lại bảng
select * from posts;

-- Xóa bỏ (Drop) tất cả các thủ tục đã tạo sau khi hoàn thành.
drop procedure if exists sp_createpost;
drop procedure if exists sp_searchpost;
drop procedure if exists sp_increaselike;
drop procedure if exists sp_deletepost;


