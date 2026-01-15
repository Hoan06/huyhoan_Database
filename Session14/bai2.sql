use social_network;

create table likes (
    like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,

    constraint fk_likes_posts
        foreign key (post_id) references posts(post_id),

    constraint fk_likes_users
        foreign key (user_id) references users(user_id),

    constraint unique_like
        unique (post_id, user_id)
);

alter table posts
add column likes_count int default 0;

delimiter //
create procedure insert_like(p_user_id int , p_post_id int)
begin
	declare exit handler for sqlexception
    begin
		rollback;
	end;
	
	start transaction;
    
    insert into likes (post_id, user_id)
	values (p_post_id, p_user_id);

	update posts
	set likes_count = likes_count + 1
	where post_id = p_post_id;
    
    commit;
 end //

call insert_like(1,1);

