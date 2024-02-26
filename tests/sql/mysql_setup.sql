create database dev;
use dev;
create table t(id int);
insert into t values (1), (2), (3);
alter table t add constraint primary key t_pk(id);
