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
