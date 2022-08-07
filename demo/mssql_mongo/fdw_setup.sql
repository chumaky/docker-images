-- install extensions
CREATE SCHEMA mongo_fdw;
CREATE EXTENSION mongo_fdw SCHEMA mongo_fdw;

CREATE SCHEMA tds_fdw;
CREATE EXTENSION tds_fdw SCHEMA tds_fdw;

-- create foreign servers
CREATE SERVER mongo FOREIGN DATA WRAPPER mongo_fdw OPTIONS (address 'mongo', port '27017', authentication_database 'admin');
CREATE USER MAPPING FOR postgres SERVER mongo OPTIONS (username 'root', password 'root');
CREATE SCHEMA mongo;

CREATE SERVER mssql FOREIGN DATA WRAPPER tds_fdw OPTIONS (servername 'mssql', port '1433', database 'test');
CREATE USER MAPPING FOR postgres SERVER mssql OPTIONS (username 'sa', password 'mssql_2019');
CREATE SCHEMA mssql;

-- create foregin tables
CREATE FOREIGN TABLE mssql.banner(version text)
SERVER MSSQL
OPTIONS (query 'select @@version as version')
;

CREATE FOREIGN TABLE mssql.users(id int, name varchar)
SERVER mssql
OPTIONS (query 'select * from users')
;

CREATE FOREIGN TABLE mongo.regions
( _id    name
, id     int
, name   text
) SERVER mongo;
