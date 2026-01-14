use bai1;

delimiter //

create trigger trg_before_insert_users
before insert on users
for each row
begin
    -- kiểm tra email phải chứa @ và .
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'Email không hợp lệ';
    end if;

    -- kiểm tra username chỉ gồm chữ, số, underscore
    if new.username not regexp '^[A-Za-z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'Username chứa ký tự không hợp lệ';
    end if;
end //



delimiter //

create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users(username, email, created_at)
    values (p_username, p_email, p_created_at);
end //



-- 1. dữ liệu hợp lệ (THÀNH CÔNG)
call add_user('user_test1', 'user1@test.com', '2025-02-01');

-- 2. email không hợp lệ (BÁO LỖI)
call add_user('user_test2', 'user2test.com', '2025-02-02');

-- 3. username có ký tự đặc biệt (BÁO LỖI)
call add_user('user@test', 'user3@test.com', '2025-02-03');


select * from users;