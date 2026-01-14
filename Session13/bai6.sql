use bai1;



create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    constraint fk_friendships_follower
        foreign key (follower_id)
        references users(user_id)
        on delete cascade,
    constraint fk_friendships_followee
        foreign key (followee_id)
        references users(user_id)
        on delete cascade
);



drop trigger if exists trg_after_insert_friendships;
drop trigger if exists trg_after_delete_friendships;

delimiter //

create trigger trg_after_insert_friendships
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end //

create trigger trg_after_delete_friendships
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end //

delimiter ;


drop procedure if exists follow_user;

delimiter //

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending', 'accepted')
)
begin
    -- không cho tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'Không thể tự follow chính mình';
    end if;

    -- tránh follow trùng
    if exists (
        select 1
        from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'Đã tồn tại quan hệ follow';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end //

delimiter ;


drop view if exists user_profile;

create view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes,
    group_concat(
        concat(p.post_id, ': ', left(p.content, 30))
        order by p.created_at desc
        separator ' | '
    ) as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;



-- follow hợp lệ
call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

-- follow pending
call follow_user(1, 2, 'pending');

-- kiểm tra follower_count
select user_id, username, follower_count
from users;

-- unfollow (xóa quan hệ)
delete from friendships
where follower_id = 2 and followee_id = 1;

-- kiểm tra lại
select user_id, username, follower_count
from users;

-- xem profile chi tiết
select * from user_profile;
