USE social_network_pro;

drop view view_user_post;

create view view_user_post as
select p.user_id , count(p.post_id) as total_user_post from posts p
group by p.user_id;

select * from view_user_post;

select u.full_name , coalesce(v.total_user_post,0) as total_user_post from users u
join view_user_post v on v.user_id = u.user_id;
	
