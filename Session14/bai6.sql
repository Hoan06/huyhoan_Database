use social_network;

create table if not exists friend_requests (
    request_id int auto_increment primary key,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id)
);

create table if not exists friends (
    user_id int not null,
    friend_id int not null,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

alter table users
add column friends_count int default 0;

delimiter //

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;
    declare v_status varchar(20);

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    set transaction isolation level repeatable read;
    start transaction;

    -- kiểm tra request tồn tại, đúng người nhận và đang pending
    select from_user_id, status
    into v_from_user_id, v_status
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
    for update;

    if v_from_user_id is null or v_status <> 'pending' then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Friend request không hợp lệ';
    end if;

    -- kiểm tra đã là bạn trước đó chưa
    if exists (
        select 1 from friends
        where user_id = p_to_user_id
          and friend_id = v_from_user_id
    ) then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Hai user đã là bạn';
    end if;

    -- insert quan hệ bạn bè 2 chiều
    insert into friends(user_id, friend_id)
    values
    (p_to_user_id, v_from_user_id),
    (v_from_user_id, p_to_user_id);

    -- cập nhật friends_count
    update users
    set friends_count = friends_count + 1
    where user_id in (p_to_user_id, v_from_user_id);

    -- cập nhật trạng thái request
    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;

    commit;
end //

delimiter ;


-- request hợp lệ
call sp_accept_friend_request(1, 2);

-- request không hợp lệ (đã accepted)
call sp_accept_friend_request(1, 2);
