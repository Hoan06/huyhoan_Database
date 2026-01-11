USE social_network_pro;

select * from users
where hometown = 'Hà Nội';

explain analyze
select * from users
where hometown = 'Hà Nội'; 
-- -> Filter: (users.hometown = 'Hà Nội')  (cost=2.75 rows=2.5) (actual time=0.0291..0.0538 rows=8 loops=1)
   --  -> Table scan on users  (cost=2.75 rows=25) (actual time=0.026..0.0468 rows=25 loops=1)
   
 

create index idx_hometown 
on users(hometown);

-- -> Index lookup on users using idx_hometown (hometown='Hà Nội')  (cost=1.43 rows=8) (actual time=0.0361..0.0478 rows=8 loops=1)
 
