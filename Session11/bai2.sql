use social_network_pro;

delimiter //
create procedure CalculatePostLikes(p_post_id int , out total_likes int)
begin
	select count(l.user_id) into total_likes from posts p 
    join likes l on p.post_id = l.post_id
    group by p.post_id
    having p.post_id = p_post_id;
end //

drop procedure CalculatePostLikes;

call CalculatePostLikes(101,@total_likes);
select @total_likes;