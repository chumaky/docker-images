create database dev;
use dev;
create table users(id int, name varchar(10));
insert into users values (1, 'John'), (2, 'Mary'), (3, 'Peter');
alter table users add constraint primary key users_pk(id);
