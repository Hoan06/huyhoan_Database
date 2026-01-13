create database session12_miniproject;

use session12_miniproject;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default current_timestamp
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

create table friends (
    user_id int not null,
    friend_id int not null,
    status varchar(20) not null,
    check (status in ('pending','accepted')),
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

create table likes (
    user_id int not null,
    post_id int not null,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id)
);


insert into users (username, password, email) values
('user1','pass1','user1@gmail.com'),
('user2','pass2','user2@gmail.com'),
('user3','pass3','user3@gmail.com'),
('user4','pass4','user4@gmail.com'),
('user5','pass5','user5@gmail.com'),
('user6','pass6','user6@gmail.com'),
('user7','pass7','user7@gmail.com'),
('user8','pass8','user8@gmail.com'),
('user9','pass9','user9@gmail.com'),
('user10','pass10','user10@gmail.com'),
('user11','pass11','user11@gmail.com'),
('user12','pass12','user12@gmail.com'),
('user13','pass13','user13@gmail.com'),
('user14','pass14','user14@gmail.com'),
('user15','pass15','user15@gmail.com'),
('user16','pass16','user16@gmail.com'),
('user17','pass17','user17@gmail.com'),
('user18','pass18','user18@gmail.com'),
('user19','pass19','user19@gmail.com'),
('user20','pass20','user20@gmail.com');

insert into posts (user_id, content) values
(1,'hello world'),
(2,'learning sql is fun'),
(3,'today is a good day'),
(4,'i like programming'),
(5,'mysql stored procedure'),
(6,'database design'),
(7,'foreign key example'),
(8,'simple post content'),
(9,'practice makes perfect'),
(10,'coding every day'),
(11,'backend development'),
(12,'frontend vs backend'),
(13,'sql join practice'),
(14,'case when example'),
(15,'trigger and procedure'),
(16,'web application'),
(17,'software engineering'),
(18,'system design'),
(19,'final exam practice'),
(20,'graduation project');


insert into comments (post_id, user_id, content) values
(1,2,'nice post'),
(2,3,'good job'),
(3,4,'interesting'),
(4,5,'i agree'),
(5,6,'very helpful'),
(6,7,'thanks'),
(7,8,'good explanation'),
(8,9,'cool'),
(9,10,'well done'),
(10,11,'keep it up'),
(11,12,'useful'),
(12,13,'great'),
(13,14,'nice idea'),
(14,15,'clear'),
(15,16,'awesome'),
(16,17,'helpful post'),
(17,18,'good example'),
(18,19,'thanks a lot'),
(19,20,'well written'),
(20,1,'excellent');


insert into friends (user_id, friend_id, status) values
(1,2,'accepted'),
(2,1,'accepted'),
(1,3,'accepted'),
(3,1,'accepted'),
(2,3,'accepted'),
(3,2,'accepted'),
(4,5,'accepted'),
(5,4,'accepted'),
(6,7,'accepted'),
(7,6,'accepted'),
(8,9,'accepted'),
(9,8,'accepted'),
(10,11,'accepted'),
(11,10,'accepted'),
(12,13,'accepted'),
(13,12,'accepted'),
(14,15,'accepted'),
(15,14,'accepted'),
(16,17,'accepted'),
(17,16,'accepted');


insert into likes (user_id, post_id) values
(2,1),
(3,1),
(4,2),
(5,2),
(6,3),
(7,3),
(8,4),
(9,4),
(10,5),
(11,5),
(12,6),
(13,6),
(14,7),
(15,7),
(16,8),
(17,8),
(18,9),
(19,9),
(20,10),
(1,10);

-- Bài 1
select * from users;

-- Bài 2
create view  vw_public_users 
as 
select user_id , username , created_at from users;

select user_id , username , created_at from vw_public_users;

-- Bài 3
explain analyze
select user_id , username from users
where username like('user19');
-- -> Filter: (users.username like 'user19')  (cost=0.46 rows=1) (actual time=0.315..0.316 rows=1 loops=1)
  --   -> Covering index range scan on users using username over (username = 'user19')  (cost=0.46 rows=1) (actual time=0.0464..0.0472 rows=1 loops=1)
 
create index idx_username
on users(username);
-- -> Filter: (users.username like 'user19')  (cost=0.46 rows=1) (actual time=0.0316..0.0324 rows=1 loops=1)
  --   -> Covering index range scan on users using username over (username = 'user19')  (cost=0.46 rows=1) (actual time=0.0289..0.0295 rows=1 loops=1)
 
-- Bài 4
delimiter //
create procedure  sp_create_post(p_user_id int, p_content text , out inform varchar(50))
begin	
	declare checkUser int default 0;
	select user_id into checkUser from users
    where user_id = p_user_id;
    
	if checkUser = 0 then
		set inform = 'User không tồn tại';
	else
		set inform = 'Success';
		insert into posts(user_id , content , created_at) value
        (p_user_id , p_content , now());
	end if;
end //

drop procedure sp_create_post;

call sp_create_post(1 , 'Con mèo con' , @inform);
select @inform;


-- Bài 5 
create view vw_recent_posts
as 
select post_id , content from posts
where created_at >= now() - interval 7 day;

select * from vw_recent_posts;


-- Bài 6
create index idx_post_user_id
on users(user_id , created_at);

select * from posts 
where user_id = 15
order by created_at desc;

-- Bài 7
delimiter //
create procedure sp_count_posts(p_user_id int , out p_total int)
begin
	select count(post_id) into p_total from posts
    where user_id = p_user_id;
end //

call sp_count_posts(1,@p_total);
select @p_total;

-- Bài 8 
create view vw_active_users 
as
select u.user_id , u.username , u.email from users u
join posts p on u.user_id = p.user_id
with check option;

select * from vw_active_users;

update vw_active_users
set email = 'newmail@gmail.com'
where user_id = 1;

update vw_active_users
set user_id = 999
where user_id = 1;

-- Bài 9
delimiter //
create procedure sp_add_friend(
	in p_user_id int,
	in p_friend_id int,
	out inform varchar(100)
)
begin
	declare countFriend int;
	if p_user_id = p_friend_id then
		set inform = 'Không thể tự kết bạn với chính mình';
	else
		select count(*) into countFriend
		from users
		where user_id = p_friend_id;

		if countFriend = 0 then
			set inform = 'Id user muốn kết bạn không tồn tại';
		else
			insert into friends(user_id, friend_id, status)
			values (p_user_id, p_friend_id, 'accepted');

			set inform = 'Success';
		end if;
	end if;
end //

drop procedure sp_add_friend;

call sp_add_friend(1,2,@inform);
select @inform;

-- Bài 10
delimiter //
create procedure sp_suggest_friends(p_user_id int , inout p_limit int)
begin 
	select u.user_id , u.username from users u
    where u.user_id <> p_user_id and u.user_id not in(select friend_id from friends where user_id = p_user_id)
    limit p_limit;
end //
set @limit = 5;
call sp_suggest_friends(1,@limit);


-- Bài 11
create index idx_post_id
on likes(post_id);

create view vw_top_posts as
select p.post_id, p.content, count(l.user_id) as like_count
from posts p
join likes l on p.post_id = l.post_id
group by p.post_id, p.content
order by like_count desc
limit 5;

select * from vw_top_posts;


-- Bài 12
delimiter //
create procedure sp_add_comment(p_user_id int , p_post_id int , p_content text , out inform varchar(100))
begin
	declare checkUser int default 0;
	declare checkPost int default 0;
    
    select user_id into checkUser from users where user_id = p_user_id;
    select post_id into checkPost from posts where post_id = p_post_id;
    
    if checkUser = 0 or checkPost = 0 then
		set inform = 'Không thể thêm bình luận';
	else
		insert into comments(post_id , user_id , content , created_at) value
        (p_post_id , p_user_id , p_content , now());
        set inform = 'Success';
	end if;
end //

drop procedure sp_add_comment;

call sp_add_comment(1,1,'Vãi đạn thiệt',@inform);
select @inform;


-- Bài 13
delimiter //

create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int,
    out inform varchar(100)
)
begin
    declare checkLike int default 0;

    -- kiểm tra đã like chưa
    select count(*) into checkLike
    from likes
    where user_id = p_user_id
      and post_id = p_post_id;

    if checkLike > 0 then
        set inform = 'User đã thích bài viết này rồi';
    else
        insert into likes(user_id, post_id)
        values (p_user_id, p_post_id);

        set inform = 'Like thành công';
    end if;
end //

call sp_like_post(1,1,@inform);
select @inform;

create view vw_post_likes as
select 
    post_id,
    count(*) as total_likes
from likes
group by post_id;

select * from vw_post_likes;


-- Bài 14
delimiter //

create procedure sp_search_social(
    in p_option int,
    in p_keyword varchar(100)
)
begin
    if p_option = 1 then
        -- tìm user theo username
        select user_id, username, email
        from users
        where username like concat('%', p_keyword, '%');

    elseif p_option = 2 then
        -- tìm post theo content
        select post_id, user_id, content, created_at
        from posts
        where content like concat('%', p_keyword, '%');

    else
        select 'Giá trị p_option không hợp lệ' as message;
    end if;
end //

call sp_search_social(1, 'an');
call sp_search_social(2, 'database');



 







