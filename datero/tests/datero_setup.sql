-- csv
DROP SCHEMA IF EXISTS csv CASCADE;
CREATE SCHEMA IF NOT EXISTS csv;

CREATE FOREIGN TABLE csv.departments
( id        int
, name      varchar
)
SERVER file_fdw_1
OPTIONS (filename '/home/data/departments.csv', format 'csv', header 'true')
;

-- mongo
-- create foreign tables. mongo_fdw doesn't support IMPORT FOREIGN SCHEMA
DROP SCHEMA IF EXISTS mongo CASCADE;
CREATE SCHEMA IF NOT EXISTS mongo;

CREATE FOREIGN TABLE mongo.orders
( _id          name
, id           int
, customer_id  int
, product_id   int
, employee_id  int
, quantity     int
)
SERVER mongo_fdw_1
OPTIONS (database 'sales', collection 'orders')
;



-- Final query that must work
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