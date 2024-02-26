create schema tds_fdw;
create extension tds_fdw schema tds_fdw;
create server mssql foreign data wrapper tds_fdw options (servername 'mssql', port '1433', database 'test');
create user mapping for postgres server mssql options (username 'sa', password 'mssql_2019');

create foreign table banner(version text)
server mssql
options (query 'select @@version as version')
;

create foreign table users(id int, name varchar)
server mssql
options (query 'select * from users')
;
