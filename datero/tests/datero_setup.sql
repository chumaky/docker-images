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
create server sqlite foreign data wrapper sqlite_fdw options (database '/home/data/job_roles.db');

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
options (filename '/home/data/departments.csv', format 'csv', header 'true')
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

select *
  from redis.users;
