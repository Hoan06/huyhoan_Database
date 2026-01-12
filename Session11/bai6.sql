use social_network_pro;

DELIMITER //

CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_full_name VARCHAR(100);

    -- Lấy tên đầy đủ người đăng
    SELECT full_name
    INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    -- Thêm bài viết mới
    INSERT INTO posts (user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    -- Gửi thông báo cho bạn bè (chiều user_id -> friend_id)
    INSERT INTO notifications (user_id, type, content, created_at)
    SELECT 
        f.friend_id,
        'new_post',
        CONCAT(v_full_name, ' đã đăng một bài viết mới'),
        NOW()
    FROM friends f
    WHERE f.user_id = p_user_id
      AND f.status = 'accepted'
      AND f.friend_id <> p_user_id;

    -- Gửi thông báo cho bạn bè (chiều friend_id -> user_id)
    INSERT INTO notifications (user_id, type, content, created_at)
    SELECT 
        f.user_id,
        'new_post',
        CONCAT(v_full_name, ' đã đăng một bài viết mới'),
        NOW()
    FROM friends f
    WHERE f.friend_id = p_user_id
      AND f.status = 'accepted'
      AND f.user_id <> p_user_id;

END //

CALL NotifyFriendsOnNewPost(1, 'Hôm nay tôi vừa học xong Stored Procedure 😄');

SELECT n.notification_id,
       n.user_id,
       n.type,
       n.content,
       n.created_at
FROM notifications n
WHERE n.type = 'new_post'
ORDER BY n.created_at DESC;
