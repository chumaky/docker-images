-- sqlite
create schema sqlite_fdw;
create extension sqlite_fdw schema sqlite_fdw;
create server sqlite_server foreign data wrapper sqlite_fdw options (database '/home/data/job_roles.db');
create foreign table users(id int options (key 'true'), name varchar) server sqlite;

create schema sqlite;
import foreign schema public from server sqlite_server into sqlite;

-- csv
create schema file_fdw;
create extension file_fdw schema file_fdw;
create server file_server foreign data wrapper file_fdw;

create schema csv;
create foreign table csv.departments
( id        int
, name      varchar
)
server file_server
options (filename '/home/data/departments.csv', format 'csv', header 'true')
;

-- mongo
create schema mongo_fdw;
create extension mongo_fdw schema mongo_fdw;
create server mongo_server foreign data wrapper mongo_fdw options (address 'mongo', port '27017', authentication_database 'admin');
create user mapping for postgres server mongo_server options (username 'mongo', password 'mongo');

-- create foreign tables. mongo_fdw doesn't support import foreign schema
create schema mongo;
create foreign table mongo.orders
( _id          name
, id           int
, customer_id  int
, product_id   int
, employee_id  int
, quantity     int
)
server mongo_server
options (database 'sales', collection 'orders')
;


-- final query that must work
select c.name                          as customer_name
     , p.name                          as product
     , round(o.quantity * p.price, 2)  as total_amount
     , e.name                          as employee_name
     , j.name                          as employee_position
     , d.name                          as employee_department
  from mongo.orders      o
  join mysql.customers   c on c.id = o.customer_id
  join postgres.products p on p.id = o.product_id
  join mssql.employees   e on e.id = o.employee_id
  join sqlite.job_roles  j on j.id = e.job_id
  join csv.departments   d on d.id = j.department_id
;