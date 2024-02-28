create schema oracle_fdw;
create extension oracle_fdw schema oracle_fdw;
create server oracle foreign data wrapper oracle_fdw options (dbserver '//oracle:1521/xepdb1');
create user mapping for postgres server oracle options (user 'test', password 'test');
create foreign table users (id int options (key 'true'), name varchar) server oracle options (schema 'TEST', table 'USERS');
