create table products(id int, name text, price numeric);

insert
  into products
 values (1, 'apple', 1)
      , (2, 'banana', 2.3)
      , (3, 'orange', 3.5)
;

alter table products add constraint products_pk primary key (id);