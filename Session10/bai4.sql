USE social_network_pro;


-- Truy vấn gốc
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND YEAR(created_at) = 2026;

EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND YEAR(created_at) = 2026;

-- -> Filter: (year(posts.created_at) = 2026)  (cost=4.7 rows=17) (actual time=0.0427..0.102 rows=8 loops=1)
 --    -> Index lookup on posts using posts_fk_users (user_id=1)  (cost=4.7 rows=17) (actual time=0.0381..0.0929 rows=17 loops=1)
 
-- Tạo chỉ mục phức hợp trên 2 cột: created_at và user_id
CREATE INDEX idx_created_at_user_id
ON posts(created_at, user_id);

-- Kiểm tra kế hoạch thực thi sau khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND YEAR(created_at) = 2026;

-- -> Filter: (year(posts.created_at) = 2026)  (cost=4.7 rows=17) (actual time=0.398..0.446 rows=8 loops=1)
  --   -> Index lookup on posts using posts_fk_users (user_id=1)  (cost=4.7 rows=17) (actual time=0.393..0.438 rows=17 loops=1)
 
-- Truy vấn gốc
SELECT user_id, username, email
FROM users
WHERE email = 'an@gmail.com';

-- Kiểm tra kế hoạch thực thi trước khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT user_id, username, email
FROM users
WHERE email = 'an@gmail.com';

-- -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=300e-6..400e-6 rows=1 loops=1)
 
 
 -- Tạo chỉ mục duy nhất trên cột email
CREATE UNIQUE INDEX idx_email
ON users(email);

-- Kiểm tra kế hoạch thực thi sau khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT user_id, username, email
FROM users
WHERE email = 'an@gmail.com';

 -- -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=200e-6..300e-6 rows=1 loops=1)
 
 
 
 
