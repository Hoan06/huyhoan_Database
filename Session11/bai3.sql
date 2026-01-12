use social_network_pro;

delimiter //
create procedure CalculateBonusPoints(p_user_id int , inout p_bonus_points int)
begin 
	declare checkPoints int;
	SELECT COUNT(*)
	INTO checkPoints
	FROM posts
	WHERE user_id = p_user_id;

    if checkPoints >= 20 then
		set p_bonus_points = p_bonus_points + 100;
	elseif checkPoints >= 10 then
		set p_bonus_points = p_bonus_points + 50;
	end if;
end //

drop procedure CalculateBonusPoints;

set @p_bonus_points = 20;
call CalculateBonusPoints(1,@p_bonus_points);
select @p_bonus_points;