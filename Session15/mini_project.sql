create database mini_project_social_network;

use mini_project_social_network;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default current_timestamp
);

create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table comments (
    comment_id int auto_increment primary key,
    post_id int,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table likes (
    user_id int,
    post_id int,
    created_at datetime default current_timestamp,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

create table friends (
    user_id int,
    friend_id int,
    status varchar(20) default 'pending',
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    check (status in ('pending', 'accepted')),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (friend_id) references users(user_id) on delete cascade
);

create table user_log (
    log_id int auto_increment primary key,
    user_id int,
    action varchar(255),
    log_time datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);

insert into comments (post_id, user_id, content, created_at) values
(1, 2, 'Bài viết hay quá 👍', now()),
(1, 3, 'Mình cũng thấy rất hữu ích', now());


-- Bài 1
delimiter //
create procedure sp_register_user(p_username varchar(50), p_password varchar(255), p_email varchar(100))
begin
	if exists (select 1 from users where username = p_username) then
		signal sqlstate '45000' set message_text = 'Lỗi trùng username';
    end if;
    
    if exists (select 1 from users where email = p_email) then
		signal sqlstate '45000' set message_text = 'Lỗi trùng email';
    end if;
    
    insert into users(username,password,email,created_at) value
    (p_username , p_password , p_email , now());
    
end //

drop procedure sp_register_user;

delimiter //
create trigger trigger_insert_user
after insert on users
for each row
begin 
	insert into user_log (user_id , action , log_time) value
    (new.user_id , 'Đăng ký tài khoản mới' , now());
end //

-- Test Bài 1
-- Insert thành công
call sp_register_user('an',   '123456', 'an@gmail.com');
call sp_register_user('binh', '123456', 'binh@gmail.com');
call sp_register_user('chi',  '123456', 'chi@gmail.com');
call sp_register_user('duy',  '123456', 'duy@gmail.com');

-- Check trùng
call sp_register_user('an', 'abcdef', 'an2@gmail.com');
call sp_register_user('an_new', 'abcdef', 'an@gmail.com');

-- Bài 2
create table post_log (
    log_id int auto_increment primary key,
    user_id int,
    post_id int,
    action varchar(255),
    log_time datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);


delimiter //
create procedure  sp_create_post(p_user_id int , p_content text)
begin
	if length(trim(p_content)) = 0 then
		signal sqlstate '45000' set message_text = 'Nội dung không được để trống';
    end if;
    
    insert into posts(user_id , content , created_at) value 
    (p_user_id , p_content , now());
end //

delimiter //
create trigger trigger_insert_post
after insert on posts
for each row
begin 
	insert into post_log (user_id , post_id , action , log_time) value
    (new.user_id , new.post_id , 'Đăng bài viết mới' , now());
end //

-- User 1 đăng bài
call sp_create_post(1, 'Bài viết số 1 của user 1');
call sp_create_post(1, 'Bài viết số 2 của user 1');

-- User 2 đăng bài
call sp_create_post(2, 'Xin chào, đây là bài viết của user 2');
call sp_create_post(2, 'Hôm nay học MySQL Transaction');

-- User 3 đăng bài
call sp_create_post(3, 'Trigger và Stored Procedure');
call sp_create_post(3, 'Mini project social network');

-- check content rỗng
call sp_create_post(1, '');

-- Bài 3

alter table posts
add column  like_count INT DEFAULT 0;

delimiter //
create procedure  sp_like(p_user_id int , p_post_id int)
begin
	declare checkUser int;
	declare checkPost int;
	select count(*) into checkUser from users where user_id = p_user_id;
	select count(*) into checkPost from posts where post_id = p_post_id;
    
	if checkUser < 1 or checkPost < 1 then
		signal sqlstate '45000' set message_text = 'Không tìm thấy user or post';
    end if;
    
    insert into likes(user_id , post_id , created_at) value 
    (p_user_id , p_post_id , now());
end //

delimiter //
create procedure  sp_unlike(p_user_id int , p_post_id int)
begin
	declare checkUser int;
	declare checkPost int;
	select count(*) into checkUser from users where user_id = p_user_id;
	select count(*) into checkPost from posts where post_id = p_post_id;
    
	if checkUser < 1 or checkPost < 1 then
		signal sqlstate '45000' set message_text = 'Không tìm thấy user or post';
    end if;
    
    delete from likes where user_id = p_user_id and post_id = p_post_id;
end //

-- trigger like
delimiter //
create trigger trigger_like_post
after insert on likes
for each row
begin 
	update posts
    set like_count = like_count + 1
    where post_id = new.post_id;

	insert into user_log (user_id , action , log_time) value
    (new.user_id , 'Đã thích bài viết' , now());
end //

-- trigger unlike
delimiter //
create trigger trigger_unlike_post
after delete on likes
for each row
begin 
	update posts
    set like_count = like_count - 1
    where post_id = old.post_id;

	insert into user_log (user_id , action , log_time) value
    (old.user_id , 'Đã hủy bỏ thích bài viết' , now());
end //

-- Drop trigger
drop trigger if exists trigger_like_post;
drop trigger if exists trigger_unlike_post;

-- Drop procedure
drop procedure if exists sp_like;
drop procedure if exists sp_unlike;

-- like
call sp_like(2, 1);   -- user 2 like post 1
call sp_like(3, 1);   -- user 3 like post 1
call sp_like(1, 3);   -- user 1 like post 3

-- trùng
call sp_like(2, 1);

-- Bài 4
delimiter //
create procedure sp_send_friend_request(p_sender_id int , p_receiver_id int)
begin

	if p_sender_id = p_receiver_id then
		signal sqlstate '45000' set message_text = 'Không thể tự kết bạn chính mình';
    end if;
    
    insert into friends(user_id , friend_id , status , created_at) value 
    (p_sender_id , p_receiver_id , 'pending' , now());
end //

delimiter //
create trigger trigger_send_request_friend
after insert on friends
for each row
begin 
	insert into user_log (user_id , action , log_time) value
    (new.user_id , 'Đã gửi lời mời kết bạn' , now());
end //

-- test hợp lệ
call sp_send_friend_request(1, 2);  -- u1 → u2
call sp_send_friend_request(1, 3);  -- u1 → u3

-- test không hợp lệ
call sp_send_friend_request(1, 1);


-- Bài 5
delimiter //
create procedure sp_accepted_friend(p_sender_id int , p_receiver_id int)
begin

	declare checkRequest int;
    select count(*) into checkRequest from friends where user_id = p_sender_id and friend_id = p_receiver_id and status = 'pending';
    
    if checkRequest < 1 then
		signal sqlstate '45000' set message_text = 'Không tìm thấy lời mời';
    end if;
    
    update friends
    set status = 'accepted'
    where user_id = p_sender_id and friend_id = p_receiver_id;
    
    insert into friends(user_id , friend_id , status , created_at) value 
    (p_receiver_id , p_sender_id , 'accepted' , now());
end //

call sp_accepted_friend(1, 2);


-- Bài 6
drop procedure update_delete_friend;

delimiter //
create procedure update_delete_friend(p_sender_id int , p_receiver_id int)
begin
    declare checkFriend int;
    start transaction;
    select count(*) into checkFriend from friends where user_id = p_sender_id and friend_id = p_receiver_id and status = 'accepted';
    
    if checkFriend < 1 then
		rollback;
		signal sqlstate '45000' set message_text = 'Không tìm thấy mối quan hệ';
    end if;
    
     delete from friends
        where (user_id = p_sender_id and friend_id = p_receiver_id)
           or (user_id = p_receiver_id and friend_id = p_sender_id);
	commit;
end //

delimiter //
create trigger trigger_cancel_friend
after delete on friends
for each row
begin 
	insert into user_log (user_id , action , log_time) value
    (old.user_id , 'Đã hủy kết bạn' , now());
end //

-- test hợp lệ
call update_delete_friend(1,2);

-- test ko hợp lệ
call update_delete_friend(1,5);


-- Bài 7
delimiter //
create procedure  sp_delete_post(p_post_id int , p_user_id int)
begin
    declare checkPost int;
    start transaction;
    select count(*) into checkPost from posts where user_id = p_user_id and post_id = p_post_id;
    
    if checkPost < 1 then
		rollback;
		signal sqlstate '45000' set message_text = 'Không tìm thấy bài viết';
    end if;
    
     delete from posts where post_id = p_post_id and user_id = p_user_id;
	commit;
end //

delimiter //
create trigger trigger_delete_post
after delete on posts
for each row
begin 
	insert into user_log(user_id, action, log_time)
    values (old.user_id, 'Đã xóa bài viết', now());
end //

call sp_delete_post(1,1);


-- Bài 8
delimiter //
create procedure sp_delete_user(p_user_id int)
begin
    declare checkUser int;

    start transaction;

    -- kiểm tra user tồn tại
    select count(*) into checkUser
    from users
    where user_id = p_user_id;

    if checkUser < 1 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Không tìm thấy user';
    end if;

    -- xóa user (cascade toàn bộ dữ liệu liên quan)
    delete from users
    where user_id = p_user_id;

    commit;
end //
delimiter ;














delimiter //

create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
    if old.Score <> new.Score then
        insert into GradeLog(StudentID, OldScore, NewScore, ChangeDate)
        values (old.StudentID, old.Score, new.Score, now());
    end if;
end //

delimiter ;


delimiter //

create procedure sp_PayTuition()
begin
    declare v_TotalDebt decimal(10,2);

    start transaction;

    update Students
    set TotalDebt = TotalDebt - 2000000
    where StudentID = 'SV01';

    select TotalDebt into v_TotalDebt
    from Students
    where StudentID = 'SV01';

    if v_TotalDebt < 0 then
        rollback;
    else
        commit;
    end if;
end //

delimiter ;


delimiter //

create trigger tg_PreventPassUpdate
before update on Grades
for each row
begin
    if old.Score >= 4.0 then
        signal sqlstate '45000'
        set message_text = 'Sinh viên đã qua môn, không được phép sửa điểm';
    end if;
end //

delimiter ;


delimiter //

create procedure sp_DeleteStudentGrade(
    in p_StudentID char(5),
    in p_SubjectID char(5)
)
begin
    declare v_OldScore decimal(4,2);

    start transaction;

    select Score into v_OldScore
    from Grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    insert into GradeLog(StudentID, OldScore, NewScore, ChangeDate)
    values (p_StudentID, v_OldScore, null, now());

    delete from Grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end //

delimiter ;




