use bai1;

create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    constraint fk_history_posts
        foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

delimiter //
create trigger trigger_before_update_posts
before update on posts
for each row
begin
		if old.content <> new.content then
			insert into post_history(post_id,old_content,new_content,changed_at,changed_by_user_id) value
            (old.post_id , old.content , new.content , now() , old.user_id);
		end if;
end //

delimiter //
create trigger trg_after_delete_posts
after delete on posts
for each row
begin

end //

update posts
set content = 'Hello world from Alice '
where post_id = 1;

update posts
set content = 'Bob first post - updated '
where post_id = 3;

select * from post_history;





