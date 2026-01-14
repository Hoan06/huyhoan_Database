use bai1;

-- tạo bảng likes
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    constraint fk_likes_users
        foreign key (user_id)
        references users(user_id)
        on delete cascade,
    constraint fk_likes_posts
        foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

-- thêm dữ liệu mẫu vào likes
insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- trigger tăng like_count khi thêm like
delimiter $$

create trigger trg_after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$

-- trigger giảm like_count khi xóa like
create trigger trg_after_delete_likes
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$

delimiter ;

-- tạo view thống kê người dùng
create view user_statistics as
select 
    u.user_id,
    u.username,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

-- thêm một lượt thích và kiểm chứng
insert into likes (user_id, post_id, liked_at)
values (2, 4, now());

select * from posts where post_id = 4;
select * from user_statistics;

-- xóa một lượt thích (ví dụ like_id = 1) và kiểm chứng lại
delete from likes where like_id = 1;

select * from posts;
select * from user_statistics;
