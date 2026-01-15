drop database if exists social_network;
create database social_network;
use social_network;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    constraint fk_posts_users
        foreign key (user_id) references users(user_id)
);

insert into users (username)
values
('an'),
('binh'),
('chi');

insert into posts (user_id, content)
values
(1, 'Bài viết đầu tiên của An'),
(2, 'Xin chào, tôi là Bình');

delimiter //
create procedure insert_post(p_user_id int , p_content text)
begin
	start transaction;
    if trim(p_content) = '' then
		signal sqlstate '45000' set message_text = 'Lỗi content không được để trống';
		rollback;
	end if;
    
    insert into posts (user_id , content , created_at) value
    (p_user_id , p_content , now());
    
    update users
    set posts_count = posts_count + 1
    where user_id = p_user_id;
    
    commit;
 end //

call insert_post(1,'');
call insert_post(1,'hello');





