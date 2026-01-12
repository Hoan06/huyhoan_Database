use social_network_pro;

DELIMITER $$

CREATE PROCEDURE sp_GetPostsByUser (
    IN p_user_id INT
)
BEGIN
    SELECT 
        post_id   AS PostID,
        content   AS NoiDung,
        created_at AS ThoiGianTao
    FROM posts
    WHERE user_id = p_user_id
    ORDER BY created_at DESC;
END$$

CALL sp_GetPostsByUser(1);
DROP PROCEDURE IF EXISTS sp_GetPostsByUser;

