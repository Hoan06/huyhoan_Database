use social_network;

create table follows (
    follower_id int not null,
    followed_id int not null,

    primary key (follower_id, followed_id),

    constraint fk_follows_follower
        foreign key (follower_id) references users(user_id),

    constraint fk_follows_followed
        foreign key (followed_id) references users(user_id)
);

alter table users
add column following_count int default 0,
add column followers_count int default 0;

delimiter //
create procedure sp_follow_user(p_follower_id int , p_followed_id int)
begin 

	declare checkCount int;
	declare checkFollow int;
	start transaction;
    
    select count(*) into checkCount from users where user_id in(p_follower_id , p_followed_id);
    if (checkCount < 2) then
		rollback;
		signal sqlstate '45000' set message_text = 'Không tìm thấy user';
	end if;
    
    if p_follower_id = p_followed_id then
		rollback;
		signal sqlstate '45000' set message_text = 'Không được tự follow chính mình';
	end if;
    
    select count(*) into checkFollow from follows where follower_id = p_follower_id and followed_id = p_followed_id;
    
    if checkFollow > 0 then
		rollback;
		signal sqlstate '45000' set message_text = 'Đã follow trước đó rồi';
	end if;
    
    insert into follows(follower_id , followed_id) value 
    (p_follower_id , p_followed_id);
    
    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;
    
    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;
    
    commit;
end //

drop procedure sp_follow_user;

call sp_follow_user(1, 2);

call sp_follow_user(1, 2);

call sp_follow_user(2, 2);


