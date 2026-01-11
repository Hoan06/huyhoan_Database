USE social_network_pro;

-- Truy vấn gốc
SELECT u.user_id, u.username, u.full_name, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- EXPLAIN ANALYZE trước khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT u.user_id, u.username, u.full_name, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- -> Limit: 10 row(s)  (cost=34.6 rows=10) (actual time=0.119..0.139 rows=10 loops=1)
  --   -> Nested loop inner join  (cost=34.6 rows=94.7) (actual time=0.118..0.138 rows=10 loops=1)
     --    -> Sort: u.username DESC  (cost=1.43 rows=8) (actual time=0.0991.....

-- Tạo chỉ mục cho cột hometown
CREATE INDEX idx_hometown
ON users(hometown);


-- EXPLAIN ANALYZE sau khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT u.user_id, u.username, u.full_name, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- -> Limit: 10 row(s)  (cost=34.6 rows=10) (actual time=0.169..0.207 rows=10 loops=1)
   --  -> Nested loop inner join  (cost=34.6 rows=94.7) (actual time=0.168..0.204 rows=10 loops=1)
   --      -> Sort: u.username DESC  (cost=1.43 rows=8) (actual time=0.14..0....
