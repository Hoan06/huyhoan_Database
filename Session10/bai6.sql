USE social_network_pro;

-- Tạo view thống kê số lượng bài viết của từng user
CREATE OR REPLACE VIEW view_users_summary AS
SELECT 
    u.user_id,
    u.username,
    COUNT(p.post_id) AS total_posts
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username;

SELECT *
FROM view_users_summary
WHERE total_posts > 5;
