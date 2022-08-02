create table users(id int, name text);
insert
  into users
values (1, 'John')
     , (2, 'Mary')
     , (3, 'Paul')
;
alter table users add constraint primary key u_pk(id);
