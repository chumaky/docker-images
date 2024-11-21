conn system/admin@xepdb1

create user hr identified by hr default tablespace users temporary tablespace temp quota unlimited on users;
grant connect to hr;
grant create table to hr;

-- next commands have to be executed under "hr" user
conn hr/hr@//localhost:1521/xepdb1

create table users(id int, name varchar(10));
insert into users values (1, 'John');
insert into users values (2, 'Mary');
insert into users values (3, 'Peter');
alter table users add constraint users_pk primary key (id);

/*
select * from users order by id;
insert into users values (5, 'zxcv');
commit;
select * from users order by id;
*/