use social_network;

create table if not exists delete_log (
    log_id int auto_increment primary key,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
);

delimiter //

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_owner_id int;

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- kiểm tra bài viết tồn tại và đúng chủ sở hữu
    select user_id into v_owner_id
    from posts
    where post_id = p_post_id;

    if v_owner_id is null or v_owner_id <> p_user_id then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Không tồn tại bài viết hoặc không có quyền xóa';
    end if;

    -- xóa likes
    delete from likes
    where post_id = p_post_id;

    -- xóa comments
    delete from comments
    where post_id = p_post_id;

    -- xóa bài viết
    delete from posts
    where post_id = p_post_id;

    -- cập nhật posts_count
    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id;

    -- ghi log xóa thành công
    insert into delete_log(post_id, deleted_by)
    values (p_post_id, p_user_id);

    commit;
end //

delimiter ;

-- trường hợp hợp lệ (chủ bài viết)
call sp_delete_post(1, 1);

-- trường hợp không hợp lệ (không phải chủ bài viết)
call sp_delete_post(2, 1);
