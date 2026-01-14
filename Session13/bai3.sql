use bai1;

delimiter $$

-- trước khi insert like: không cho user like bài của chính mình
create trigger trg_before_insert_likes
before insert on likes	
for each row
begin
    declare post_owner int;

    select user_id into post_owner
    from posts
    where post_id = new.post_id;

    if new.user_id = post_owner then
        signal sqlstate '45000'
        set message_text = 'Không được like bài đăng của chính mình';
    end if;
end$$

-- trước khi update like (đổi post_id): cũng không cho like bài của chính mình
create trigger trg_before_update_likes
before update on likes
for each row
begin
    declare post_owner int;

    select user_id into post_owner
    from posts
    where post_id = new.post_id;

    if new.user_id = post_owner then
        signal sqlstate '45000'
        set message_text = 'Không được like bài đăng của chính mình';
    end if;
end$$



-- sau khi insert like
create trigger trg_after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$

-- sau khi delete like
create trigger trg_after_delete_likes
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$

-- sau khi update like (đổi post_id)
create trigger trg_after_update_likes
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id;

        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end$$

delimiter ;



-- 1. thử like bài của chính mình (PHẢI BÁO LỖI)
insert into likes (user_id, post_id)
values (1, 1);

-- 2. thêm like hợp lệ
insert into likes (user_id, post_id)
values (2, 1);

select * from posts where post_id = 1;

-- 3. update like sang post khác
update likes
set post_id = 2
where user_id = 2 and post_id = 1;

select * from posts where post_id in (1, 2);

-- 4. xóa like
delete from likes
where user_id = 2 and post_id = 2;

select * from posts where post_id = 2;


select * from posts;
select * from user_statistics;
