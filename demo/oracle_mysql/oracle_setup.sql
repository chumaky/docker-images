create user test identified by test default tablespace users temporary tablespace temp quota unlimited on users;
grant connect to test;
grant create table to test;

-- next commands have to be executed under "test" user
conn test/test@//localhost:1521/orclpdb1.localdomain
create table t as select rownum id from dual connect by level <= 3;
alter table t add constraint t_pk primary key (id);
