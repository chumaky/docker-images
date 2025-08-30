create schema datero_fdw;

-- mysql
create extension mysql_fdw schema datero_fdw;
create server mysql foreign data wrapper mysql_fdw options (host 'mysql', port '3306');
create user mapping for postgres server mysql options (username 'mysql', password 'mysql');

create schema mysql;
import foreign schema finance from server mysql into mysql;

-- postgres
create extension postgres_fdw schema datero_fdw;
create server postgres foreign data wrapper postgres_fdw options (host 'postgres', port '5432', dbname 'factory');
create user mapping for postgres server postgres options (user 'postgres', password 'postgres');

create schema postgres;
import foreign schema public from server postgres into postgres;

-- mssql
create extension tds_fdw schema datero_fdw;
create server mssql foreign data wrapper tds_fdw options (servername 'mssql', port '1433', database 'hr');
create user mapping for postgres server mssql options (username 'sa', password 'Mssql_2019');

create schema mssql;
import foreign schema dbo from server mssql into mssql;

-- sqlite
create extension sqlite_fdw schema datero_fdw;
create server sqlite foreign data wrapper sqlite_fdw options (database '/data/sqlite/job_roles.db');

create schema sqlite;
import foreign schema public from server sqlite into sqlite;

-- csv
create extension file_fdw schema datero_fdw;
create server files foreign data wrapper file_fdw;

create schema csv;
create foreign table csv.departments
( id        int
, name      varchar
)
server files
options (filename '/data/departments.csv', format 'csv', header 'true')
;

-- mongo
create extension mongo_fdw schema datero_fdw;
create server mongo foreign data wrapper mongo_fdw options (address 'mongo', port '27017', authentication_database 'admin');
create user mapping for postgres server mongo options (username 'mongo', password 'mongo');

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
server mongo
options (database 'sales', collection 'orders')
;

-- redis
create extension redis_fdw schema datero_fdw;
create server redis foreign data wrapper redis_fdw options (address 'redis', port '6379');
create user mapping for postgres server redis /*options (password '')*/;

create schema redis;
create foreign table redis.users(key text, val text[])
server redis
options (database '0', tabletype 'hash', tablekeyprefix 'users:')
;

-- duckdb
create extension duckdb_fdw schema datero_fdw;
create server duckdb foreign data wrapper duckdb_fdw options (database '/home/data/json_files.duckdb');

create schema duckdb;
import foreign schema public from server duckdb into duckdb;

-- oracle
create extension oracle_fdw schema datero_fdw;
create server oracle foreign data wrapper oracle_fdw options (dbserver '//oracle:1521/xepdb1');
create user mapping for postgres server oracle options (user 'oracle', password 'oracle');

create schema oracle;

create foreign table oracle.customer_profiles
( id          int options (key 'true')
, customer_id int
, category    varchar
)
server oracle
options (schema 'ORACLE', table 'CUSTOMER_PROFILES')
;


-- final queries that must work
select c.name                          as customer_name
     , cp.category                     as customer_category
     , p.name                          as product
     , round(o.quantity * p.price, 2)  as total_amount
     , e.name                          as employee_name
     , j.name                          as employee_position
     , d.name                          as employee_department
  from mongo.orders             o
  join mysql.customers          c  on c.id = o.customer_id
  join oracle.customer_profiles cp on c.id = cp.customer_id
  join postgres.products        p  on p.id = o.product_id
  join mssql.employees          e  on e.id = o.employee_id
  join sqlite.job_roles         j  on j.id = e.job_id
  join csv.departments          d  on d.id = j.department_id
;

/*
 customer_name | customer_category | product | total_amount | employee_name | employee_position | employee_department 
---------------+-------------------+---------+--------------+---------------+-------------------+---------------------
 Tom           | Bronze            | apple   |        10.00 | John          | owner             | management
 Tom           | Bronze            | banana  |         4.60 | Bob           | manager           | finance
 Tom           | Bronze            | orange  |        17.50 | Lisa          | salesman          | sales
 Kate          | Silver            | orange  |        10.50 | Bob           | manager           | finance
 Kate          | Silver            | apple   |         5.00 | Lisa          | salesman          | sales
 John          | Gold              | apple   |         8.00 | Lisa          | salesman          | sales
(6 rows)
*/

select *
  from redis.users;

select *
  from duckdb.json_files_v;

-- DML tests
-- delete the last row from the orders table
-- John          | Gold              | apple   |         8.00 | Lisa          | salesman          | sales
--
-- also update one of the row and insert a new one

-- Mysql
insert into mysql.customers values (4, 'Peter');
update mysql.customers set name = 'Ms. Kate' where name = 'Kate';
delete from mysql.customers where name = 'John';

-- Postgres
insert into postgres.products values (4, 'pear', 1.5);
delete from postgres.products where name = 'pear';
insert into postgres.products values (4, 'pear', 15);
update postgres.products set price = 100 where name = 'banana';

-- MSSQL
-- tds_fdw doesn't support DML operations

-- SQLite
insert into sqlite.job_roles values (4, 'developer', 1);
delete from sqlite.job_roles where name = 'developer';
insert into sqlite.job_roles values (4, 'developer', 3);
update sqlite.job_roles set name = 'CEO' where name = 'owner';

-- CSV
-- file_fdw doesn't support DML operations

-- Mongo
-- insert into mongo.orders (id, customer_id, product_id, employee_id, quantity) values (7, 3, 3, 2, 4);
-- delete from mongo.orders where _id = '67519d3bce358833416a05d2';
-- update mongo.orders set quantity = 44 where id = 7;

-- Redis
-- insert into redis.users values ('users:4', '{id,4,name,asdf}');
-- delete from redis.users where key = 'users:4';
-- update redis.users set val = '{id,2,name,Blahsss}' where key = 'users:2';

-- Oracle
insert into oracle.customer_profiles values (4, 4, 'Platinum');
update oracle.customer_profiles set category = 'Silver 925' where category = 'Silver';
delete from oracle.customer_profiles where category = 'Gold';

-- DuckDB
-- duckdb.json_file_v is a view, so we can't perform DML operations on it



-- run the query again to see the changes
select c.name                          as customer_name
     , cp.category                     as customer_category
     , p.name                          as product
     , round(o.quantity * p.price, 2)  as total_amount
     , e.name                          as employee_name
     , j.name                          as employee_position
     , d.name                          as employee_department
  from mongo.orders             o
  join mysql.customers          c  on c.id = o.customer_id
  join oracle.customer_profiles cp on c.id = cp.customer_id
  join postgres.products        p  on p.id = o.product_id
  join mssql.employees          e  on e.id = o.employee_id
  join sqlite.job_roles         j  on j.id = e.job_id
  join csv.departments          d  on d.id = j.department_id
;
