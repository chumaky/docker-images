create extension oracle_fdw;
create server oracle foreign data wrapper oracle_fdw options (dbserver '//oracle:1521/xepdb1');
create user mapping for postgres server oracle options (user 'hr', password 'hr');
create foreign table users (id int options (key 'true'), name varchar) server oracle options (schema 'HR', table 'USERS');


/*
select 'before' as op, users.* from users order by id;
insert into users (id, name) values (4, 'asdf');
update users set name = 'qwer' where id = 2;
delete from users where id = 1;
select 'after' as op, users.* from users order by id;
*/