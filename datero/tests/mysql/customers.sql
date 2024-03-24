create table customers(id int, name text);

insert
  into customers
values (1, 'Tom')
     , (2, 'Kate')
     , (3, 'John')
;

alter table customers add constraint primary key customers_pk(id);
