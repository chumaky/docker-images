conn system/admin@xepdb1

create user test identified by test default tablespace users temporary tablespace temp quota unlimited on users;
grant connect to test;
grant create table to test;

-- next commands have to be executed under "test" user
conn test/test@//localhost:1521/xepdb1

create table users(id int, name varchar(10));
insert into users values (1, 'John');
insert into users values (2, 'Mary');
insert into users values (3, 'Peter');
alter table users add constraint users_pk primary key (id);
