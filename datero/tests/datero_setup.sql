-- mysql
create schema mysql_fdw;
create extension mysql_fdw schema mysql_fdw;
create server mysql_server foreign data wrapper mysql_fdw options (host 'mysql', port '3306');
create user mapping for postgres server mysql_server options (username 'mysql', password 'mysql');

create schema mysql;
import foreign schema finance from server mysql_server into mysql;

-- postgres
create schema postgres_fdw;
create extension postgres_fdw schema postgres_fdw;
create server postgres_server foreign data wrapper postgres_fdw options (host 'postgres', port '5432', dbname 'factory');
create user mapping for postgres server postgres_server options (user 'postgres', password 'postgres');

create schema postgres;
import foreign schema public from server postgres_server into postgres;

-- mssql
create schema tds_fdw;
create extension tds_fdw schema tds_fdw;
create server mssql_server foreign data wrapper tds_fdw options (servername 'mssql', port '1433', database 'hr');
create user mapping for postgres server mssql_server options (username 'sa', password 'Mssql_2019');

create schema mssql;
import foreign schema dbo from server mssql_server into mssql;

-- sqlite
create schema sqlite_fdw;
create extension sqlite_fdw schema sqlite_fdw;
create server sqlite_server foreign data wrapper sqlite_fdw options (database '/home/data/job_roles.db');

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
