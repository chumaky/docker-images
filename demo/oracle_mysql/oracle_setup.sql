conn sys/admin@//localhost:1521/xepdb1 as sysdba
create user test identified by test default tablespace users temporary tablespace temp quota unlimited on users;
grant connect to test;
grant create table to test;

-- next commands have to be executed under "test" user
conn test/test@//localhost:1521/xepdb1
create table profiles(user_id int, role varchar(10));
alter table profiles add constraint p_pk primary key (user_id);

insert into profiles values (1, 'Worker');
insert into profiles values (2, 'Manager');
insert into profiles values (3, 'Owner');
